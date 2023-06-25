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

// Graph generator starts here ##################3
let rec Aeval e =
  match e with
    | Num(x) -> string(x)
    | Var(x) -> x
    | TimesExpr(x,y)-> (Aeval x) + "*" + (Aeval y)
    | DivExpr(x,y)  -> (Aeval x) + "/" + (Aeval y)
    | PlusExpr(x,y) -> (Aeval x)+ "+"+ (Aeval y)
    | MinusExpr(x,y)-> (Aeval x)+ "-"+ (Aeval y)
    | PowExpr(x,y)  -> (Aeval x)+ "^"+ (Aeval y)
    | SqrtExpr(x)-> "sqrt("+ Aeval x + ")"
    | UPlusExpr(x)  -> (Aeval x)
    | UMinusExpr(x) -> "-"+ (Aeval x)

let rec Beval e = 
   match e with 
    | ConExpr(x,y) -> (Beval x) + "&" + (Beval y)
    | SconExpr(x,y) -> (Beval x) + "&" + (Beval y)
    | DisExpr(x,y) -> (Beval x) + "V" + (Beval y)
    | SdisExpr(x,y) -> (Beval x) + "V" + (Beval y)
    | NegExpr(x) -> "!"+(Beval x)
    | EqExpr(x,y) -> (Aeval x) + "=" + (Aeval y)
    | NeqExpr(x,y) -> (Aeval x) + "<>" + (Aeval y)
    | LgtExpr(x,y) -> (Aeval x) + ">" + (Aeval y)
    | LgetExpr(x,y) -> (Aeval x) + ">=" + (Aeval y)
    | RgtExpr(x,y) -> (Aeval x) + "<" + (Aeval y)
    | RgetExpr(x,y) -> (Aeval x) + "<=" + (Aeval y)
    | _ -> string(e) 


let mutable fresh = 0


let rec edges (q1,q2) C = 
    match C with
    | AssignExpr(n,v) -> [(q1, n+":="+Aeval v,q2)]
    | SkipExpr -> [(q1,"skip",q2)]
    | SepExpr(c1,c2) -> let q = fresh <- fresh+1 ; fresh 
                        (edges (q1,q) c1)  @ (edges (q,q2) c2)
    | IfExpr gc -> edgesGC (q1,q2) gc
    | DoExpr gc -> edgesGC (q1,q1) gc @ [(q1,Done gc,q2)]
and edgesGC (q1,q2) GC =
    match GC with
    | WhileExpr(b,c) -> let q = fresh <- fresh+1; fresh
                        let b = (q1,Beval b,q)
                        let E = edges (q,q2) c
                        b::E
    | OrExpr(gc1,gc2) -> edgesGC (q1,q2) gc1 @ edgesGC (q1,q2) gc2
and Done gc =
    match gc with
    | WhileExpr(b,c) -> "!("+Beval b+")"
    | OrExpr(gc1,gc2) -> Done gc1 + "&" + Done gc2


let mutable endstate = -1

let rec toString = function
    | (f,s,t)::[] -> endstate <- (t+fresh) ; ";q" + string(f) + " -> q" + string(t+fresh) + " [label = \"" + s + "\" ];"
    | (f,s,t)::ls -> ";q" + string(f) + " -> q" + string(t) + " [label = \"" + s + "\" ]" + toString ls
    | [] -> ""

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
        printf "Write your commands: "
        try
        // We parse the input string
        let e = parse (Console.ReadLine())
        // and print the result of evaluating it
        let result = "digraph program_graph {rankdir=LR; \nnode [shape = circle]; q_start; \nnode [shape = doublecircle]; q_end; \nnode [shape = circle] \n" + (toString (edges (0,1) e)).Replace("q0","q_start").Replace("q"+string(endstate),"q_end") + "}"
        printfn "%s" result
        
        compute n
        printfn "OK"
        with err -> 
            printfn "KO"
            compute (n-1)


// Start interacting with the user
compute 3

