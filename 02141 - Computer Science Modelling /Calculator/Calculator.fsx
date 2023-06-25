// This script implements our interactive calculator

// We need to import a couple of modules, including the generated lexer and parser
#r "FsLexYacc.Runtime.7.0.6/lib/portable-net45+netcore45+wpa81+wp8+MonoAndroid10+MonoTouch10/FsLexYacc.Runtime.dll"
open Microsoft.FSharp.Text.Lexing
open System
#load "CalculatorTypesAST.fs"
open CalculatorTypesAST
#load "CalculatorParser.fs"
open CalculatorParser
#load "CalculatorLexer.fs"
open CalculatorLexer

// We define the evaluation function recursively, by induction on the structure
// of arithmetic expressions (AST of type expr)
let rec Aeval e env =
  match e with
    | Num(x) -> x
    | Var(x) -> Map.find x env
    | TimesExpr(x,y)-> (Aeval x env) * (Aeval y env)
    | DivExpr(x,y)  -> (Aeval x env) / (Aeval y env)
    | PlusExpr(x,y) -> (Aeval x env) + (Aeval y env)
    | MinusExpr(x,y)-> (Aeval x env) - (Aeval y env)
    | PowExpr(x,y)  -> (Aeval x env) ** (Aeval y env)
    | SqrtExpr(x)-> sqrt(Aeval x env)
    | UPlusExpr(x)  -> (Aeval x env)
    | UMinusExpr(x) -> - (Aeval x env)

let rec Beval e env = 
   match e with 
    | ConExpr(x,y) -> (Beval x env) && (Beval y env)
    | SconExpr(x,y) -> (Beval x env) && (Beval y env)
    | DisExpr(x,y) -> (Beval x env) || (Beval y env)
    | SdisExpr(x,y) -> (Beval x env) || (Beval y env)
    | NegExpr(x) -> not((Beval x env))
    | EqExpr(x,y) -> (Aeval x env) = (Aeval y env)
    | NeqExpr(x,y) -> (Aeval x env) =  (Aeval y env)
    | LgtExpr(x,y) -> (Aeval x env) >  (Aeval y env)
    | LgetExpr(x,y) -> (Aeval x env) >=  (Aeval y env)
    | RgtExpr(x,y) -> (Aeval x env) <  (Aeval y env)
    | RgetExpr(x,y) -> (Aeval x env) <=  (Aeval y env)
    | FalseExpr -> false
    | TrueExpr -> true

let join (p:Map<'a,'b>) (q:Map<'a,'b>) = 
    Map(Seq.concat [ (Map.toSeq p) ; (Map.toSeq q) ])




let rec Ceval e env =
    match e with
    | AssignExpr(x,y) -> Map.add x (Aeval y env) env
    | SepExpr(x,y) -> Ceval y (Ceval x env)
    | IfExpr(x) -> IfGCeval x env
    | SkipExpr -> env
    | DoExpr(x) -> DoGCeval x env
and DoGCeval e env = 
    match e with
    | OrExpr(x,y) -> join (DoGCeval x env) (DoGCeval y env)
    | WhileExpr(x,y) when (Beval x env) -> Ceval (DoExpr(WhileExpr(x,y))) (Ceval y env)
    | WhileExpr(x,y) -> env
and IfGCeval e env =
    match e with
    | OrExpr(x,y) -> join (IfGCeval x env) (IfGCeval y env)
    | WhileExpr(x,y) -> if Beval x env then Ceval y env else env

                            




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
        printf "Enter a GC expression: "
        try
        // We parse the input string
        let e = parse (Console.ReadLine())
        // and print the result of evaluating it
        //printfn "Result: %f" (evalA(e))
        printfn "ok" 
      //  let res = Ceval e (Map.empty<string,float>)
      //  printfn "%A" (Map.toList res)
        compute n
        
        with err -> printfn "ko"

// Start interacting with the user
compute 3
