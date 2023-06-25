// This script implements our interactive calculator

// We need to import a couple of modules, including the generated lexer and parser
#r "FsLexYacc.runtime/7.0.6/lib/portable-net45+netcore45+wpa81+wp8+MonoAndroid10+MonoTouch10/FsLexYacc.Runtime.dll"
open Microsoft.FSharp.Text.Lexing
open System
#load "CalculatorTypesAST.fs"
open CalculatorTypesAST
#load "CalculatorParser.fs"
open CalculatorParser
#load "CalculatorLexer.fs"
open CalculatorLexer

//starts here ##################3
let mutable fresh = 0
let mutable endstate = 1000
type op = Assign of string*Aexpr | Boolean of Bexpr | Or of op*op | Skip
type grafMap = Map<int,(op*int)list>

let rec Aeval map e =
  match e with
    | Num(x) -> x
    | Var(s) -> Map.find s map
    | TimesExpr(x,y)-> (Aeval map x)*(Aeval map y)
    | DivExpr(x,y)  -> (Aeval map x)/(Aeval map y)
    | PlusExpr(x,y) -> (Aeval map x)+(Aeval map y)
    | MinusExpr(x,y)-> (Aeval map x)-(Aeval map y)
    | PowExpr(x,y)  -> (Aeval map x)**(Aeval map y)
    | SqrtExpr(x)-> sqrt(Aeval map x)
    | UPlusExpr(x)  -> (Aeval map x)
    | UMinusExpr(x) -> -(Aeval map x)

let rec Beval map e = 
   match e with 
    | ConExpr(x,y) -> (Beval map x) && (Beval map y)
    | SconExpr(x,y) -> (Beval map x) && (Beval map y)
    | DisExpr(x,y) -> (Beval map x) || (Beval map y)
    | SdisExpr(x,y) -> (Beval map x) || (Beval map y)
    | NegExpr(x) -> not(Beval map x)
    | EqExpr(x,y) -> (Aeval map x) = (Aeval map y)
    | NeqExpr(x,y) -> not((Aeval map x) = (Aeval map y))
    | LgtExpr(x,y) -> (Aeval map x) > (Aeval map y)
    | LgetExpr(x,y) -> (Aeval map x) >= (Aeval map y)
    | RgtExpr(x,y) -> (Aeval map x) < (Aeval map y)
    | RgetExpr(x,y) -> (Aeval map x) <= (Aeval map y)

let rec edges (q1,q2) C = 
    match C with
    | AssignExpr(n,v) -> [(q1, Assign(n,v),q2)]
    | SkipExpr -> [(q1,Skip,q2)]
    | SepExpr(c1,c2) -> let q = fresh <- fresh+1 ; fresh 
                        (edges (q1,q) c1)  @ (edges (q,q2) c2)
    | IfExpr gc -> edgesGC (q1,q2) gc
    | DoExpr gc -> edgesGC (q1,q1) gc @ [(q1,Done gc,q2)]
and edgesGC (q1,q2) GC =
    match GC with
    | WhileExpr(b,c) -> let q = fresh <- fresh+1; fresh
                        let b = (q1,Boolean b,q)
                        let E = edges (q,q2) c
                        b::E
    | OrExpr(gc1,gc2) -> edgesGC (q1,q2) gc1 @ edgesGC (q1,q2) gc2
and Done gc =
    match gc with
    | WhileExpr(b,c) -> Boolean (NegExpr b)
    | OrExpr(gc1,gc2) -> Or((Done gc1, Done gc2))

let rec assign c = Map.ofList (assignAux c)
and assignAux = function
    | AssignExpr(n,Num(v)) -> [(n, v)]
    | SepExpr(c1,c2) -> (assignAux c1) @ (assignAux c2) 
    | _ -> failwith""

let rec toMap GC =
    toMapAux Map.empty (edges (0,1) GC)
and toMapAux map = function
    | [] -> Map.empty
    | (from,Op,To)::[] when (Map.containsKey from map) -> endstate <- To;
                                                          (Map.add from ((Map.find from map)@[(Op,To)]) map)
    | (from,Op,To)::[] -> endstate <- To; 
                          (Map.add from [(Op,To)] map)
    | (from,Op,To)::ls when (Map.containsKey from map) ->  toMapAux (Map.add from ((Map.find from map)@[(Op,To)]) map) ls 
    | (from,Op,To)::ls -> toMapAux (Map.add from [(Op,To)] map) ls


let rec run (graf:grafMap) (state:int) map=
    if state = endstate then map else
        let op = (Map.find state graf)
        match op with
        | (Assign(s,a),t)::_ when (Map.containsKey s map) -> run graf t (Map.add s (Aeval map a) map) 
        | (Assign(_,_),_)::_ -> failwith""
        | (Boolean(b1),t1)::[(Boolean(_),t2)] -> if (Beval map b1) then (run graf t1 map) else (run graf t2 map)
        | (Skip,t)::_ -> run graf t map
        | e -> runAux graf map e
and runAux graf map = function
        | (Or(Boolean(b1),Or(b2,b3)),t)::ls -> if (Beval map b1) then (runAux graf map ((Or(b2,b3),t)::ls)) else
                                                                                                     let list = (runAux3 graf map ls):int list
                                                                                                     let ran = Random()
                                                                                                     (runAux2 graf map list (ran.Next() % (list.Length)) 0)
        | (Or(Boolean(b1),Boolean(b2)),t)::ls -> if ((Beval map b1) && (Beval map b2)) then (run graf t map) else 
                                                                                                    let list = (runAux3 graf map ls):int list
                                                                                                    let ran = Random()
                                                                                                    (runAux2 graf map list (ran.Next() % (list.Length)) 0)
        | _ -> failwith ""
and runAux2 graf map ls r acc = 
    match ls with
    | e::ls when acc=r -> run graf e map
    | _::ls -> runAux2 graf map ls r (acc+1)
    | [] -> failwith ""
and runAux3 graf map = function
    | [] -> []
    | (Boolean(b1),t)::ls -> if Beval map b1 then (t::(runAux3 graf map ls)) else runAux3 graf map ls 
    | _ -> failwith ""
and runAux4 = function
    | [] -> 0
    | _::ls -> 1+(runAux4 ls)

let rec mapToString (map:Map<String,float>):String = auxMapToString (Map.toList map)
and auxMapToString = function
    | [] -> ""
    | (k,v)::ls -> k + "="+ string(v) + "\n" + (auxMapToString ls)

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
        printfn "Define your variables (given as eg. \"x:=1;y:=8\" etc): "
        try
            let j = parse (Console.ReadLine())
            printfn "Now write your commands: "
            let map = assign j
            try
               let e = parse (Console.ReadLine())
               let mapRes = run ((toMap e):grafMap) (0:int) map
               let result = "\n" + (mapToString mapRes)
               printfn "%s" result
               compute n
            with err -> 
               failwith""
        with err -> 
            printfn "KO"
            compute (n-1)


compute 3



