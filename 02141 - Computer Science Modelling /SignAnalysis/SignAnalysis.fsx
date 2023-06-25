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

type sign = Plus | Minus | Zero | TT | FF
type op = Addition | Subtraction | Multipication | Division | Power

let getSign = function
    | x when x>0.0 -> Plus
    | x when x<0.0 -> Minus
    | _ -> Zero

let getSignPlus x y =
    match x with
    | Plus -> match y with
              | Plus -> [Plus]
              | Minus -> [Plus;Minus;Zero]
              | Zero -> [Plus]
    | Minus -> match y with
               | Plus -> [Plus;Minus;Zero]
               | Minus -> [Minus]
               | Zero -> [Minus]
    | Zero -> match y with
               | Plus -> [Plus;Minus;Zero]
               | Minus -> [Minus]
               | Zero -> [Zero]
         
let getSignMinus x y =
    match x with
    | Plus -> match y with
              | Plus -> [Plus;Minus;Zero]
              | Minus -> [Plus]
              | Zero -> [Plus]
    | Minus -> match y with
               | Plus -> [Minus]
               | Minus -> [Plus;Minus;Zero]
               | Zero -> [Minus]
    | Zero -> match y with
               | Plus -> [Plus;Minus;Zero]
               | Minus -> [Plus]
               | Zero -> [Zero]

let getSignTimes x y =
    match x with
    | Plus -> match y with
              | Plus -> [Plus]
              | Minus -> [Minus]
              | Zero -> [Zero]
    | Minus -> match y with
               | Plus -> [Minus]
               | Minus -> [Plus]
               | Zero -> [Zero]
    | Zero -> [Zero]

let getSignDiv x y =
    match y with
    | Plus -> match x with
              | Plus -> [Plus]
              | Minus -> [Minus]
              | Zero -> [Zero]
    | Minus -> match x with
               | Plus -> [Minus]
               | Minus -> [Plus]
               | Zero -> [Zero]
    | Zero -> []


let getSignPow x y =
    match x with
    | Plus -> match y with
              | Plus -> [Plus]
              | Minus -> [Plus]
              | Zero -> [Plus]
    | Minus -> match y with
               | Plus -> [Minus; Plus]
               | Minus -> [Plus; Minus]
               | Zero -> [Plus]
    | Zero -> match y with
              | Plus -> [Zero]
              | Minus -> [Zero]
              | Zero -> [Plus]
          
let rec getSignUMinus = function
    | [] -> []
    | Plus::ls -> Minus::getSignUMinus ls
    | Minus::ls -> Plus::getSignUMinus ls
    | Zero::ls -> Zero::getSignUMinus ls

let rec iterrate f pairs =
    match pairs with
    | [] -> Set.empty:Set<sign>
    | (x,y)::ls -> Set.union (Set.ofList (f x y)) (iterrate f ls)


// We define the evaluation function recursively, by induction on the structure
// of arithmetic expressions (AST of type expr)
let rec Aeval e env =
  match e with
    | Num(x) -> [getSign x]
    | Var(x) -> Set.toList (Map.find x env)
    | TimesExpr(x,y)-> Set.toList (iterrate (getSignTimes) (List.allPairs (Aeval x env) (Aeval y env)))
    | DivExpr(x,y)  -> Set.toList (iterrate (getSignDiv) (List.allPairs (Aeval x env) (Aeval y env)))
    | PlusExpr(x,y) -> Set.toList (iterrate (getSignPlus) (List.allPairs (Aeval x env) (Aeval y env)))
    | MinusExpr(x,y)-> Set.toList (iterrate (getSignMinus) (List.allPairs (Aeval x env) (Aeval y env)))
    | PowExpr(x,y)  -> Set.toList (iterrate (getSignPow) (List.allPairs (Aeval x env) (Aeval y env)))
    | UPlusExpr(x)  -> (Aeval x env)
    | UMinusExpr(x) -> getSignUMinus (Aeval x env)


let getSignEq x y =
    match x with
    | Plus -> match y with
              | Plus -> [TT;FF]
              | Minus -> [FF]
              | Zero -> [FF]
    | Minus -> match y with
               | Plus -> [FF]
               | Minus -> [TT;FF]
               | Zero -> [FF]
    | Zero -> match y with
              | Plus -> [FF]
              | Minus -> [FF]
              | Zero -> [TT]

let getSignNeq x y =
    match x with
    | Plus -> match y with
              | Plus -> [TT;FF]
              | Minus -> [TT]
              | Zero -> [TT]
    | Minus -> match y with
               | Plus -> [TT]
               | Minus -> [TT;FF]
               | Zero -> [TT]
    | Zero -> match y with
              | Plus -> [TT]
              | Minus -> [TT]
              | Zero -> [FF]

let getSignLgt x y =
    match x with
    | Plus -> match y with
              | Plus -> [TT;FF]
              | Minus -> [TT]
              | Zero -> [TT]
    | Minus -> match y with
               | Plus -> [FF]
               | Minus -> [TT;FF]
               | Zero -> [FF]
    | Zero -> match y with
              | Plus -> [FF]
              | Minus -> [TT]
              | Zero -> [FF]

let getSignLget x y =
    match x with
    | Plus -> match y with
              | Plus -> [TT;FF]
              | Minus -> [TT]
              | Zero -> [TT]
    | Minus -> match y with
               | Plus -> [FF]
               | Minus -> [TT;FF]
               | Zero -> [FF]
    | Zero -> match y with
              | Plus -> [FF]
              | Minus -> [TT]
              | Zero -> [TT]

let getSignRgt x y =
    match y with
    | Plus -> match x with
              | Plus -> [TT;FF]
              | Minus -> [TT]
              | Zero -> [TT]
    | Minus -> match x with
               | Plus -> [FF]
               | Minus -> [TT;FF]
               | Zero -> [FF]
    | Zero -> match x with
              | Plus -> [FF]
              | Minus -> [TT]
              | Zero -> [FF]

let getSignRget x y =
    match y with
    | Plus -> match x with
              | Plus -> [TT;FF]
              | Minus -> [TT]
              | Zero -> [TT]
    | Minus -> match x with
               | Plus -> [FF]
               | Minus -> [TT;FF]
               | Zero -> [FF]
    | Zero -> match x with
              | Plus -> [FF]
              | Minus -> [TT]
              | Zero -> [TT] 

let getSignCon x y = 
    match x with
        | TT -> match y with
                | FF -> [FF]
                | TT -> [TT]
        | FF -> match y with
                | FF -> [FF]
                | TT -> [FF]

let getSignScon x y = 
    match x with
        | TT -> match y with
                | FF -> [FF]
                | TT -> [TT]
        | FF -> [FF]
    
let getSignDis x y = 
    match x with
        | TT -> match y with
                | FF -> [TT]
                | TT -> [TT]
        | FF -> match y with
                | FF -> [FF]
                | TT -> [TT]
      
let getSignSdis x y = 
    match x with
        | TT -> [TT]
        | FF -> match y with
                | FF -> [FF]
                | TT -> [TT]

let rec getSignNeg ls = 
    match ls with
    | [] -> []
    | TT::ls -> FF::getSignNeg ls
    | FF::ls -> TT::getSignNeg ls

let rec Beval e env = 
   match e with 
    | ConExpr(x,y) -> Set.toList (iterrate (getSignCon) (List.allPairs (Beval x env) (Beval y env)))
    | SconExpr(x,y) -> Set.toList (iterrate (getSignScon) (List.allPairs (Beval x env) (Beval y env)))
    | DisExpr(x,y) -> Set.toList (iterrate (getSignDis) (List.allPairs (Beval x env) (Beval y env)))
    | SdisExpr(x,y) -> Set.toList (iterrate (getSignSdis) (List.allPairs (Beval x env) (Beval y env)))
    | NegExpr(x) -> getSignNeg (Beval x env)
    | EqExpr(x,y) -> Set.toList (iterrate (getSignEq) (List.allPairs (Aeval x env) (Aeval y env)))
    | NeqExpr(x,y) -> Set.toList (iterrate (getSignNeq) (List.allPairs (Aeval x env) (Aeval y env)))
    | LgtExpr(x,y) -> Set.toList (iterrate (getSignLgt) (List.allPairs (Aeval x env) (Aeval y env)))
    | LgetExpr(x,y) -> Set.toList (iterrate (getSignLget) (List.allPairs (Aeval x env) (Aeval y env)))
    | RgtExpr(x,y) -> Set.toList (iterrate (getSignRgt) (List.allPairs (Aeval x env) (Aeval y env)))
    | RgetExpr(y,x) -> Set.toList (iterrate (getSignRget) (List.allPairs (Aeval x env) (Aeval y env)))
    | FalseExpr -> [FF]
    | TrueExpr -> [TT]

let rec join map1 = function
    | [] -> map1
    | (k,v)::ls when Map.containsKey k map1 -> join (Map.add k (Set.union (Map.find k map1) v) map1) ls 
    | (k,v)::ls -> join (Map.add k v map1) ls



let rec Ceval e env =
    match e with
    | AssignExpr(x,y) -> Map.add x (Set.ofList (Aeval y env)) env
    | SepExpr(x,y) -> Ceval y (Ceval x env)
    | IfExpr(x) -> IfGCeval x env
    | SkipExpr -> env
    | DoExpr(x) -> DoGCeval x env
and DoGCeval e env = 
    match e with
    | OrExpr(x,y) -> join (DoGCeval x env) (Map.toList (DoGCeval y env))
    | WhileExpr(x,y) when List.contains TT (Beval x env) -> IfGCeval (WhileExpr(x,y)) env
    | WhileExpr(x,y) -> env
and IfGCeval e env =
    match e with
    | OrExpr(x,y) -> join (IfGCeval x env) (Map.toList (IfGCeval y env))
    | WhileExpr(x,y) -> if List.contains TT (Beval x env) then Ceval y env else env


let rec printres = function
  | [] -> ""
  | (x,s)::ls -> x+" = {"+ (printresAux (Set.toList s)) + "} \n" + printres ls
and printresAux = function
  | [] -> ""
  | Plus::ls -> " + " + printresAux ls
  | Minus::ls -> " - " + printresAux ls
  | Zero::ls -> " 0 " + printresAux ls


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
          let res = Ceval e (Map.empty<string,Set<sign>>)
          let res = printres (Map.toList res)
          printfn "%s" res
          compute n
        with err -> printfn "ko"
                    compute (n-1)

let tester input = 
  let res = printres (Map.toList (Ceval (parse input) (Map.empty<string,Set<sign>>)))
  printfn "%s" res


let test1 = "x:=89;y:=21;x:=x-y;z:=x*y"
let test2 = "x:=42;y:=1; do x>5 -> y:=x*y; x:=x-1 od"
let test3 = "x:=42;y:=70; z:=9; if x>=y -> z:=x [] y>x -> z:=y fi"

tester test1 //works like formal methods
tester test2 //works like formal methods
tester test3 //works like formal methods
