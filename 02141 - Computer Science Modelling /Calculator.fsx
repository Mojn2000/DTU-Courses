// This script implements our interactive calculator

// We need to import a couple of modules, including the generated lexer and parser
#r "FsLexYacc.runtime.7.0.6/lib/portable-net45+netcore45+wpa81+wp8+MonoAndroid10+MonoTouch10/FsLexYacc.Runtime.dll"
open Microsoft.FSharp.Text.Lexing
open System
#load "CalculatorTypesAST.fs"
open CalculatorTypesAST
#load "CalculatorParser.fs"
open CalculatorParser
#load "CalculatorLexer.fs"
open CalculatorLexer

// Graph generator starts here ###################
let rec Aeval e =
  match e with
    | Num(x) -> Set.empty
    | Var(x) -> Set.ofList [x]
    | TimesExpr(x,y)-> Set.union (Aeval x) (Aeval y)
    | DivExpr(x,y)  -> Set.union (Aeval x) (Aeval y)
    | PlusExpr(x,y) -> Set.union (Aeval x) (Aeval y)
    | MinusExpr(x,y)-> Set.union (Aeval x) (Aeval y)
    | PowExpr(x,y)  -> Set.union (Aeval x) (Aeval y)
    | SqrtExpr(x)-> Aeval x
    | UPlusExpr(x)  -> (Aeval x)
    | UMinusExpr(x) -> (Aeval x)

let rec Beval e = 
   match e with 
    | ConExpr(x,y) -> Set.union (Beval x) (Beval y)
    | SconExpr(x,y) -> Set.union (Beval x) (Beval y)
    | DisExpr(x,y) -> Set.union (Beval x) (Beval y)
    | SdisExpr(x,y) -> Set.union (Beval x) (Beval y)
    | NegExpr(x) -> Beval x
    | EqExpr(x,y) ->  Set.union (Aeval x) (Aeval y)
    | NeqExpr(x,y) ->  Set.union (Aeval x) (Aeval y)
    | LgtExpr(x,y) ->  Set.union (Aeval x) (Aeval y)
    | LgetExpr(x,y) ->  Set.union (Aeval x) (Aeval y)
    | RgtExpr(x,y) ->  Set.union (Aeval x) (Aeval y)
    | RgetExpr(x,y) ->  Set.union (Aeval x) (Aeval y)
    | _ -> Set.empty

let rec join envList envMap = 
    match envList with
    | [] -> envMap
    | (s,set)::slist -> if Map.containsKey s envMap then join slist (Map.add s (Set.union (Map.find s envMap) (set)) envMap) else join slist (Map.add s set envMap)


let rec impJoin listStr envList = 
    match listStr with
    | []-> envList
    | s::lStr -> impJoin lStr (aux s envList)
and aux s envList =
    match envList with
    | [] -> []
    | (key,set)::eList -> (key, Set.add s set)::aux s eList

let mutable impli = Set.empty<String>

let rec edges C env:Map<String,Set<String>> = 
    match C with
    | AssignExpr(n,v) -> if Map.containsKey n env then Map.add n (Set.union (Map.find n env) (Aeval v)) env else Map.add n (Aeval v) env
    | SkipExpr -> env
    | SepExpr(c1,c2) -> join (Map.toList (edges c1 env)) (edges c2 env)               
    | IfExpr gc -> impli <- Set.empty<String>; edgesGC gc env
    | DoExpr gc -> impli <- Set.empty<String>; if (edgesGC gc env) = env then env else edgesGC gc env
and edgesGC GC env =
    match GC with
    | WhileExpr(b,c) -> impli <- Set.union (Beval b) impli
                        let E = edges c env
                        let imp = impli
                        Map.ofList (impJoin (Set.toList imp) (Map.toList E))
    | OrExpr(gc1,gc2) -> join (Map.toList (edgesGC gc1 env)) (edgesGC gc2 (env))
/////////////////////////////////////////////////////////////////////////////////////////////////////

let rec parseBrugerInput (s:String)  = auxBruger (List.ofArray ((s.Replace (" ", "")).Split ',')) Map.empty 1
and auxBruger list e acc = 
    match list with
    | [] -> e
    | h::ls -> auxBruger ls (Map.add h acc e) (acc+1)

let joinMap (p:Map<'a,'b>) (q:Map<'a,'b>) = 
    Map(Seq.concat [ (Map.toSeq p) ; (Map.toSeq q) ])

let rec defVar (s:String) clearenceEnv = auxVar (List.ofArray ((s.Replace (" ", "")).Split ',')) Map.empty clearenceEnv
and auxVar listVar env clearenceEnv = 
    match listVar with
    | [] -> env
    | s::ls -> joinMap (auxVar2 (List.ofArray (s.Split '=')) clearenceEnv env) (auxVar ls env clearenceEnv)
and auxVar2 list clearenceEnv env = 
    match list with
    | [var;clear] -> Map.add var (Map.find clear clearenceEnv) env
    | _ -> failwith "Wrong input, read instructions"
               


let rec checkViolation envVar flowList = 
    match flowList with
    | [] -> true
    | (var, set)::ls -> auxCheck (Map.find var envVar) (Set.toList set) envVar && checkViolation envVar ls
and auxCheck clearence varList envVar =
    match varList with
    | [] -> true
    | v::ls -> ((Map.find v envVar) <= clearence) && auxCheck clearence ls envVar


// We
let parse input =
    // translate string into a buffer of characters
    let lexbuf = LexBuffer<char>.FromString input
    // translate the buffer into a stream of tokens and parse them
    let res = CalculatorParser.start CalculatorLexer.tokenize lexbuf
    // return the result of parsing (i.e. value of type "expr")
    res

// We implement here the function that interacts with the user
let rec compute n =
    if n = 0 then
        printfn "Bye bye"
    else
        try
            impli <- Set.empty<String>
            printfn "Give your clearencies as eg \"public, private\"."
            let clearEnv = parseBrugerInput (Console.ReadLine())
            Async.Sleep(200) |> Async.RunSynchronously

            printfn "Assign clearency to variables as eg \"a=public, b=private\"."
            let varEnv = defVar (Console.ReadLine()) clearEnv
            Async.Sleep(200) |> Async.RunSynchronously

            printfn "Write your commands: "
            // We parse the input string
            let e = parse (Console.ReadLine())
            Async.Sleep(200) |> Async.RunSynchronously

            // and print the result of evaluating it
            let flowList = Map.toList (edges e Map.empty)
            Async.Sleep(200) |> Async.RunSynchronously

            printf "%s" "Actual flows: "
            printfn "%A" (List.toArray flowList)
            
            printf "%s" "Is the programme secure: "
            let secure = checkViolation varEnv flowList 
            let respond = if secure then "Yes" else "No" 
            printfn "%s" respond

            compute n
        with _ -> 
            printfn "KO"
            compute (n-1)



//let p1 = "y:=1; do x>0 -> y:=x*y; x:=x-1 od"
let p2 = "if x<0 -> y:=(-1*z)*z [] x == 0 -> y:=0 [] x>0 -> y:=z*z fi"
let p3 = "if x >= y -> z:=x [] y>x -> z:=y fi"
parseBrugerInput "public, private"
defVar ("x=private, z=public, y=public") (parseBrugerInput "public, private")

checkViolation (defVar ("x=public, z=public, y=private") (parseBrugerInput "public, private")) (Map.toList (edges (parse p2) Map.empty))
// Start interacting with the user

compute 3

