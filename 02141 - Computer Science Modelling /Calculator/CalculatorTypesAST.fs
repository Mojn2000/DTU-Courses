// This file implements a module where we define a data type "expr"
// to store represent arithmetic expressions
module CalculatorTypesAST

type Aexpr =
  | Num of float
  | Var of string
  | TimesExpr of (Aexpr * Aexpr)
  | DivExpr of (Aexpr * Aexpr)
  | PlusExpr of (Aexpr * Aexpr)
  | MinusExpr of (Aexpr * Aexpr)
  | PowExpr of (Aexpr * Aexpr)
  | UPlusExpr of (Aexpr)
  | UMinusExpr of (Aexpr)
  | SqrtExpr of (Aexpr)

type Bexpr = 
    | ConExpr of (Bexpr * Bexpr)
    | SconExpr of (Bexpr * Bexpr)
    | DisExpr of (Bexpr * Bexpr)
    | SdisExpr of (Bexpr * Bexpr)
    | NegExpr of (Bexpr)
    | EqExpr of (Aexpr * Aexpr)
    | NeqExpr of (Aexpr * Aexpr)
    | LgtExpr of (Aexpr * Aexpr)
    | LgetExpr of (Aexpr * Aexpr)
    | RgtExpr of (Aexpr * Aexpr)
    | RgetExpr of (Aexpr * Aexpr)
    | FalseExpr
    | TrueExpr

type Cexpr = 
    | AssignExpr of (string * Aexpr)
    | IfExpr of (GCexpr)
    | DoExpr of (GCexpr)
    | SepExpr of (Cexpr * Cexpr)
    | SkipExpr
and GCexpr = 
    | WhileExpr of (Bexpr * Cexpr)
    | OrExpr of (GCexpr * GCexpr)
