// Implementation file for parser generated by fsyacc
module CalculatorParser
#nowarn "64";; // turn off warnings that type variables used in production annotations are instantiated to concrete type
open Microsoft.FSharp.Text.Lexing
open Microsoft.FSharp.Text.Parsing.ParseHelpers
# 2 "CalculatorParser.fsp"

open CalculatorTypesAST

# 10 "CalculatorParser.fs"
// This type is the type of tokens accepted by the parser
type token = 
  | TIMES
  | DIV
  | PLUS
  | MINUS
  | POW
  | LPAR
  | RPAR
  | EOF
  | CON
  | SCON
  | DIS
  | SDIS
  | NEG
  | EQ
  | NEQ
  | LGT
  | LGET
  | RGT
  | RGET
  | TRUE
  | FALSE
  | ASSIGN
  | IF
  | FI
  | OD
  | DO
  | SKIP
  | WHILE
  | OR
  | SEP
  | SQRT
  | VAR of (string)
  | NUM of (float)
// This type is used to give symbolic names to token indexes, useful for error messages
type tokenId = 
    | TOKEN_TIMES
    | TOKEN_DIV
    | TOKEN_PLUS
    | TOKEN_MINUS
    | TOKEN_POW
    | TOKEN_LPAR
    | TOKEN_RPAR
    | TOKEN_EOF
    | TOKEN_CON
    | TOKEN_SCON
    | TOKEN_DIS
    | TOKEN_SDIS
    | TOKEN_NEG
    | TOKEN_EQ
    | TOKEN_NEQ
    | TOKEN_LGT
    | TOKEN_LGET
    | TOKEN_RGT
    | TOKEN_RGET
    | TOKEN_TRUE
    | TOKEN_FALSE
    | TOKEN_ASSIGN
    | TOKEN_IF
    | TOKEN_FI
    | TOKEN_OD
    | TOKEN_DO
    | TOKEN_SKIP
    | TOKEN_WHILE
    | TOKEN_OR
    | TOKEN_SEP
    | TOKEN_SQRT
    | TOKEN_VAR
    | TOKEN_NUM
    | TOKEN_end_of_input
    | TOKEN_error
// This type is used to give symbolic names to token indexes, useful for error messages
type nonTerminalId = 
    | NONTERM__startstart
    | NONTERM_start
    | NONTERM_Aexpression
    | NONTERM_Bexpression
    | NONTERM_Cexpression
    | NONTERM_GCexpression

// This function maps tokens to integer indexes
let tagOfToken (t:token) = 
  match t with
  | TIMES  -> 0 
  | DIV  -> 1 
  | PLUS  -> 2 
  | MINUS  -> 3 
  | POW  -> 4 
  | LPAR  -> 5 
  | RPAR  -> 6 
  | EOF  -> 7 
  | CON  -> 8 
  | SCON  -> 9 
  | DIS  -> 10 
  | SDIS  -> 11 
  | NEG  -> 12 
  | EQ  -> 13 
  | NEQ  -> 14 
  | LGT  -> 15 
  | LGET  -> 16 
  | RGT  -> 17 
  | RGET  -> 18 
  | TRUE  -> 19 
  | FALSE  -> 20 
  | ASSIGN  -> 21 
  | IF  -> 22 
  | FI  -> 23 
  | OD  -> 24 
  | DO  -> 25 
  | SKIP  -> 26 
  | WHILE  -> 27 
  | OR  -> 28 
  | SEP  -> 29 
  | SQRT  -> 30 
  | VAR _ -> 31 
  | NUM _ -> 32 

// This function maps integer indexes to symbolic token ids
let tokenTagToTokenId (tokenIdx:int) = 
  match tokenIdx with
  | 0 -> TOKEN_TIMES 
  | 1 -> TOKEN_DIV 
  | 2 -> TOKEN_PLUS 
  | 3 -> TOKEN_MINUS 
  | 4 -> TOKEN_POW 
  | 5 -> TOKEN_LPAR 
  | 6 -> TOKEN_RPAR 
  | 7 -> TOKEN_EOF 
  | 8 -> TOKEN_CON 
  | 9 -> TOKEN_SCON 
  | 10 -> TOKEN_DIS 
  | 11 -> TOKEN_SDIS 
  | 12 -> TOKEN_NEG 
  | 13 -> TOKEN_EQ 
  | 14 -> TOKEN_NEQ 
  | 15 -> TOKEN_LGT 
  | 16 -> TOKEN_LGET 
  | 17 -> TOKEN_RGT 
  | 18 -> TOKEN_RGET 
  | 19 -> TOKEN_TRUE 
  | 20 -> TOKEN_FALSE 
  | 21 -> TOKEN_ASSIGN 
  | 22 -> TOKEN_IF 
  | 23 -> TOKEN_FI 
  | 24 -> TOKEN_OD 
  | 25 -> TOKEN_DO 
  | 26 -> TOKEN_SKIP 
  | 27 -> TOKEN_WHILE 
  | 28 -> TOKEN_OR 
  | 29 -> TOKEN_SEP 
  | 30 -> TOKEN_SQRT 
  | 31 -> TOKEN_VAR 
  | 32 -> TOKEN_NUM 
  | 35 -> TOKEN_end_of_input
  | 33 -> TOKEN_error
  | _ -> failwith "tokenTagToTokenId: bad token"

/// This function maps production indexes returned in syntax errors to strings representing the non terminal that would be produced by that production
let prodIdxToNonTerminal (prodIdx:int) = 
  match prodIdx with
    | 0 -> NONTERM__startstart 
    | 1 -> NONTERM_start 
    | 2 -> NONTERM_Aexpression 
    | 3 -> NONTERM_Aexpression 
    | 4 -> NONTERM_Aexpression 
    | 5 -> NONTERM_Aexpression 
    | 6 -> NONTERM_Aexpression 
    | 7 -> NONTERM_Aexpression 
    | 8 -> NONTERM_Aexpression 
    | 9 -> NONTERM_Aexpression 
    | 10 -> NONTERM_Aexpression 
    | 11 -> NONTERM_Aexpression 
    | 12 -> NONTERM_Aexpression 
    | 13 -> NONTERM_Bexpression 
    | 14 -> NONTERM_Bexpression 
    | 15 -> NONTERM_Bexpression 
    | 16 -> NONTERM_Bexpression 
    | 17 -> NONTERM_Bexpression 
    | 18 -> NONTERM_Bexpression 
    | 19 -> NONTERM_Bexpression 
    | 20 -> NONTERM_Bexpression 
    | 21 -> NONTERM_Bexpression 
    | 22 -> NONTERM_Bexpression 
    | 23 -> NONTERM_Bexpression 
    | 24 -> NONTERM_Bexpression 
    | 25 -> NONTERM_Bexpression 
    | 26 -> NONTERM_Bexpression 
    | 27 -> NONTERM_Cexpression 
    | 28 -> NONTERM_Cexpression 
    | 29 -> NONTERM_Cexpression 
    | 30 -> NONTERM_Cexpression 
    | 31 -> NONTERM_Cexpression 
    | 32 -> NONTERM_GCexpression 
    | 33 -> NONTERM_GCexpression 
    | _ -> failwith "prodIdxToNonTerminal: bad production index"

let _fsyacc_endOfInputTag = 35 
let _fsyacc_tagOfErrorTerminal = 33

// This function gets the name of a token as a string
let token_to_string (t:token) = 
  match t with 
  | TIMES  -> "TIMES" 
  | DIV  -> "DIV" 
  | PLUS  -> "PLUS" 
  | MINUS  -> "MINUS" 
  | POW  -> "POW" 
  | LPAR  -> "LPAR" 
  | RPAR  -> "RPAR" 
  | EOF  -> "EOF" 
  | CON  -> "CON" 
  | SCON  -> "SCON" 
  | DIS  -> "DIS" 
  | SDIS  -> "SDIS" 
  | NEG  -> "NEG" 
  | EQ  -> "EQ" 
  | NEQ  -> "NEQ" 
  | LGT  -> "LGT" 
  | LGET  -> "LGET" 
  | RGT  -> "RGT" 
  | RGET  -> "RGET" 
  | TRUE  -> "TRUE" 
  | FALSE  -> "FALSE" 
  | ASSIGN  -> "ASSIGN" 
  | IF  -> "IF" 
  | FI  -> "FI" 
  | OD  -> "OD" 
  | DO  -> "DO" 
  | SKIP  -> "SKIP" 
  | WHILE  -> "WHILE" 
  | OR  -> "OR" 
  | SEP  -> "SEP" 
  | SQRT  -> "SQRT" 
  | VAR _ -> "VAR" 
  | NUM _ -> "NUM" 

// This function gets the data carried by a token as an object
let _fsyacc_dataOfToken (t:token) = 
  match t with 
  | TIMES  -> (null : System.Object) 
  | DIV  -> (null : System.Object) 
  | PLUS  -> (null : System.Object) 
  | MINUS  -> (null : System.Object) 
  | POW  -> (null : System.Object) 
  | LPAR  -> (null : System.Object) 
  | RPAR  -> (null : System.Object) 
  | EOF  -> (null : System.Object) 
  | CON  -> (null : System.Object) 
  | SCON  -> (null : System.Object) 
  | DIS  -> (null : System.Object) 
  | SDIS  -> (null : System.Object) 
  | NEG  -> (null : System.Object) 
  | EQ  -> (null : System.Object) 
  | NEQ  -> (null : System.Object) 
  | LGT  -> (null : System.Object) 
  | LGET  -> (null : System.Object) 
  | RGT  -> (null : System.Object) 
  | RGET  -> (null : System.Object) 
  | TRUE  -> (null : System.Object) 
  | FALSE  -> (null : System.Object) 
  | ASSIGN  -> (null : System.Object) 
  | IF  -> (null : System.Object) 
  | FI  -> (null : System.Object) 
  | OD  -> (null : System.Object) 
  | DO  -> (null : System.Object) 
  | SKIP  -> (null : System.Object) 
  | WHILE  -> (null : System.Object) 
  | OR  -> (null : System.Object) 
  | SEP  -> (null : System.Object) 
  | SQRT  -> (null : System.Object) 
  | VAR _fsyacc_x -> Microsoft.FSharp.Core.Operators.box _fsyacc_x 
  | NUM _fsyacc_x -> Microsoft.FSharp.Core.Operators.box _fsyacc_x 
let _fsyacc_gotos = [| 0us; 65535us; 1us; 65535us; 0us; 1us; 25us; 65535us; 22us; 4us; 23us; 5us; 24us; 6us; 25us; 7us; 26us; 8us; 27us; 9us; 28us; 10us; 29us; 11us; 31us; 12us; 32us; 13us; 42us; 14us; 43us; 14us; 44us; 14us; 45us; 14us; 46us; 14us; 47us; 15us; 48us; 16us; 49us; 17us; 50us; 18us; 51us; 19us; 52us; 20us; 57us; 21us; 62us; 14us; 65us; 14us; 70us; 14us; 9us; 65535us; 32us; 40us; 42us; 35us; 43us; 36us; 44us; 37us; 45us; 38us; 46us; 39us; 62us; 41us; 65us; 41us; 70us; 41us; 3us; 65535us; 0us; 2us; 61us; 59us; 68us; 60us; 3us; 65535us; 62us; 63us; 65us; 66us; 70us; 69us; |]
let _fsyacc_sparseGotoTableRowOffsets = [|0us; 1us; 3us; 29us; 39us; 43us; |]
let _fsyacc_stateToProdIdxsTableElements = [| 1us; 0us; 1us; 0us; 2us; 1us; 29us; 1us; 1us; 6us; 2us; 2us; 3us; 5us; 6us; 7us; 6us; 2us; 3us; 3us; 5us; 6us; 7us; 6us; 2us; 3us; 4us; 5us; 6us; 7us; 6us; 2us; 3us; 5us; 5us; 6us; 7us; 6us; 2us; 3us; 5us; 6us; 6us; 7us; 6us; 2us; 3us; 5us; 6us; 7us; 7us; 6us; 2us; 3us; 5us; 6us; 7us; 8us; 6us; 2us; 3us; 5us; 6us; 7us; 9us; 6us; 2us; 3us; 5us; 6us; 7us; 11us; 12us; 2us; 3us; 5us; 6us; 7us; 11us; 18us; 19us; 20us; 21us; 22us; 23us; 11us; 2us; 3us; 5us; 6us; 7us; 18us; 19us; 20us; 21us; 22us; 23us; 6us; 2us; 3us; 5us; 6us; 7us; 18us; 6us; 2us; 3us; 5us; 6us; 7us; 19us; 6us; 2us; 3us; 5us; 6us; 7us; 20us; 6us; 2us; 3us; 5us; 6us; 7us; 21us; 6us; 2us; 3us; 5us; 6us; 7us; 22us; 6us; 2us; 3us; 5us; 6us; 7us; 23us; 6us; 2us; 3us; 5us; 6us; 7us; 27us; 1us; 2us; 1us; 3us; 1us; 4us; 1us; 5us; 1us; 6us; 1us; 7us; 1us; 8us; 1us; 9us; 1us; 10us; 1us; 11us; 2us; 11us; 26us; 1us; 11us; 1us; 12us; 5us; 13us; 13us; 14us; 15us; 16us; 5us; 13us; 14us; 14us; 15us; 16us; 5us; 13us; 14us; 15us; 15us; 16us; 5us; 13us; 14us; 15us; 16us; 16us; 5us; 13us; 14us; 15us; 16us; 17us; 5us; 13us; 14us; 15us; 16us; 26us; 5us; 13us; 14us; 15us; 16us; 32us; 1us; 13us; 1us; 14us; 1us; 15us; 1us; 16us; 1us; 17us; 1us; 18us; 1us; 19us; 1us; 20us; 1us; 21us; 1us; 22us; 1us; 23us; 1us; 24us; 1us; 25us; 1us; 26us; 1us; 27us; 1us; 27us; 1us; 28us; 2us; 29us; 29us; 2us; 29us; 32us; 1us; 29us; 1us; 30us; 2us; 30us; 33us; 1us; 30us; 1us; 31us; 2us; 31us; 33us; 1us; 31us; 1us; 32us; 2us; 33us; 33us; 1us; 33us; |]
let _fsyacc_stateToProdIdxsTableRowOffsets = [|0us; 2us; 4us; 7us; 9us; 16us; 23us; 30us; 37us; 44us; 51us; 58us; 65us; 72us; 85us; 97us; 104us; 111us; 118us; 125us; 132us; 139us; 146us; 148us; 150us; 152us; 154us; 156us; 158us; 160us; 162us; 164us; 166us; 169us; 171us; 173us; 179us; 185us; 191us; 197us; 203us; 209us; 215us; 217us; 219us; 221us; 223us; 225us; 227us; 229us; 231us; 233us; 235us; 237us; 239us; 241us; 243us; 245us; 247us; 249us; 252us; 255us; 257us; 259us; 262us; 264us; 266us; 269us; 271us; 273us; 276us; |]
let _fsyacc_action_rows = 71
let _fsyacc_actionTableElements = [|4us; 32768us; 22us; 62us; 25us; 65us; 26us; 58us; 31us; 56us; 0us; 49152us; 2us; 32768us; 7us; 3us; 29us; 61us; 0us; 16385us; 1us; 16386us; 4us; 27us; 1us; 16387us; 4us; 27us; 1us; 16388us; 4us; 27us; 3us; 16389us; 0us; 22us; 1us; 23us; 4us; 27us; 3us; 16390us; 0us; 22us; 1us; 23us; 4us; 27us; 1us; 16391us; 4us; 27us; 3us; 16392us; 0us; 22us; 1us; 23us; 4us; 27us; 3us; 16393us; 0us; 22us; 1us; 23us; 4us; 27us; 6us; 32768us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 6us; 33us; 12us; 32768us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 6us; 33us; 13us; 47us; 14us; 48us; 15us; 49us; 16us; 50us; 17us; 51us; 18us; 52us; 11us; 32768us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 13us; 47us; 14us; 48us; 15us; 49us; 16us; 50us; 17us; 51us; 18us; 52us; 5us; 16402us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 5us; 16403us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 5us; 16404us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 5us; 16405us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 5us; 16406us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 5us; 16407us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 5us; 16411us; 0us; 22us; 1us; 23us; 2us; 25us; 3us; 26us; 4us; 27us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 0us; 16394us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 0us; 16395us; 0us; 16396us; 0us; 16397us; 0us; 16398us; 0us; 16399us; 0us; 16400us; 0us; 16401us; 5us; 32768us; 6us; 55us; 8us; 42us; 9us; 43us; 10us; 44us; 11us; 45us; 5us; 32768us; 8us; 42us; 9us; 43us; 10us; 44us; 11us; 45us; 27us; 68us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 0us; 16408us; 0us; 16409us; 0us; 16410us; 1us; 32768us; 21us; 57us; 6us; 32768us; 2us; 28us; 3us; 29us; 5us; 31us; 30us; 24us; 31us; 34us; 32us; 30us; 0us; 16412us; 1us; 16413us; 29us; 61us; 1us; 16416us; 29us; 61us; 4us; 32768us; 22us; 62us; 25us; 65us; 26us; 58us; 31us; 56us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 2us; 32768us; 23us; 64us; 28us; 70us; 0us; 16414us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; 2us; 32768us; 24us; 67us; 28us; 70us; 0us; 16415us; 4us; 32768us; 22us; 62us; 25us; 65us; 26us; 58us; 31us; 56us; 1us; 16417us; 28us; 70us; 9us; 32768us; 2us; 28us; 3us; 29us; 5us; 32us; 12us; 46us; 19us; 54us; 20us; 53us; 30us; 24us; 31us; 34us; 32us; 30us; |]
let _fsyacc_actionTableRowOffsets = [|0us; 5us; 6us; 9us; 10us; 12us; 14us; 16us; 20us; 24us; 26us; 30us; 34us; 41us; 54us; 66us; 72us; 78us; 84us; 90us; 96us; 102us; 108us; 115us; 122us; 129us; 136us; 143us; 150us; 157us; 164us; 165us; 172us; 182us; 183us; 184us; 185us; 186us; 187us; 188us; 189us; 195us; 201us; 211us; 221us; 231us; 241us; 251us; 258us; 265us; 272us; 279us; 286us; 293us; 294us; 295us; 296us; 298us; 305us; 306us; 308us; 310us; 315us; 325us; 328us; 329us; 339us; 342us; 343us; 348us; 350us; |]
let _fsyacc_reductionSymbolCounts = [|1us; 2us; 3us; 3us; 2us; 3us; 3us; 3us; 2us; 2us; 1us; 3us; 1us; 3us; 3us; 3us; 3us; 2us; 3us; 3us; 3us; 3us; 3us; 3us; 1us; 1us; 3us; 3us; 1us; 3us; 3us; 3us; 3us; 3us; |]
let _fsyacc_productionToNonTerminalTable = [|0us; 1us; 2us; 2us; 2us; 2us; 2us; 2us; 2us; 2us; 2us; 2us; 2us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 3us; 4us; 4us; 4us; 4us; 4us; 5us; 5us; |]
let _fsyacc_immediateActions = [|65535us; 49152us; 65535us; 16385us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 16394us; 65535us; 65535us; 16395us; 16396us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 65535us; 16408us; 16409us; 16410us; 65535us; 65535us; 16412us; 65535us; 65535us; 65535us; 65535us; 65535us; 16414us; 65535us; 65535us; 16415us; 65535us; 65535us; 65535us; |]
let _fsyacc_reductions ()  =    [| 
# 295 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Cexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
                      raise (Microsoft.FSharp.Text.Parsing.Accept(Microsoft.FSharp.Core.Operators.box _1))
                   )
                 : '_startstart));
# 304 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Cexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 39 "CalculatorParser.fsp"
                                                          _1 
                   )
# 39 "CalculatorParser.fsp"
                 : Cexpr));
# 315 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 49 "CalculatorParser.fsp"
                                                         TimesExpr(_1,_3) 
                   )
# 49 "CalculatorParser.fsp"
                 : Aexpr));
# 327 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 50 "CalculatorParser.fsp"
                                                        DivExpr(_1,_3) 
                   )
# 50 "CalculatorParser.fsp"
                 : Aexpr));
# 339 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 51 "CalculatorParser.fsp"
                                               SqrtExpr(_2)
                   )
# 51 "CalculatorParser.fsp"
                 : Aexpr));
# 350 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 52 "CalculatorParser.fsp"
                                                        PlusExpr(_1,_3) 
                   )
# 52 "CalculatorParser.fsp"
                 : Aexpr));
# 362 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 53 "CalculatorParser.fsp"
                                                         MinusExpr(_1,_3) 
                   )
# 53 "CalculatorParser.fsp"
                 : Aexpr));
# 374 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 54 "CalculatorParser.fsp"
                                                        PowExpr(_1,_3) 
                   )
# 54 "CalculatorParser.fsp"
                 : Aexpr));
# 386 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 55 "CalculatorParser.fsp"
                                               UPlusExpr(_2) 
                   )
# 55 "CalculatorParser.fsp"
                 : Aexpr));
# 397 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 56 "CalculatorParser.fsp"
                                                UMinusExpr(_2) 
                   )
# 56 "CalculatorParser.fsp"
                 : Aexpr));
# 408 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : float)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 57 "CalculatorParser.fsp"
                                      Num(_1) 
                   )
# 57 "CalculatorParser.fsp"
                 : Aexpr));
# 419 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 58 "CalculatorParser.fsp"
                                                   _2 
                   )
# 58 "CalculatorParser.fsp"
                 : Aexpr));
# 430 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : string)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 59 "CalculatorParser.fsp"
                                      Var(_1) 
                   )
# 59 "CalculatorParser.fsp"
                 : Aexpr));
# 441 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 62 "CalculatorParser.fsp"
                                                        ConExpr(_1,_3) 
                   )
# 62 "CalculatorParser.fsp"
                 : Bexpr));
# 453 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 63 "CalculatorParser.fsp"
                                                        SconExpr(_1,_3) 
                   )
# 63 "CalculatorParser.fsp"
                 : Bexpr));
# 465 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 64 "CalculatorParser.fsp"
                                                        DisExpr(_1,_3) 
                   )
# 64 "CalculatorParser.fsp"
                 : Bexpr));
# 477 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 65 "CalculatorParser.fsp"
                                                        SdisExpr(_1,_3) 
                   )
# 65 "CalculatorParser.fsp"
                 : Bexpr));
# 489 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 66 "CalculatorParser.fsp"
                                               NegExpr(_2) 
                   )
# 66 "CalculatorParser.fsp"
                 : Bexpr));
# 500 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 67 "CalculatorParser.fsp"
                                                       EqExpr(_1,_3) 
                   )
# 67 "CalculatorParser.fsp"
                 : Bexpr));
# 512 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 68 "CalculatorParser.fsp"
                                                        NeqExpr(_1,_3) 
                   )
# 68 "CalculatorParser.fsp"
                 : Bexpr));
# 524 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 69 "CalculatorParser.fsp"
                                                        LgtExpr(_1,_3) 
                   )
# 69 "CalculatorParser.fsp"
                 : Bexpr));
# 536 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 70 "CalculatorParser.fsp"
                                                        LgetExpr(_1,_3) 
                   )
# 70 "CalculatorParser.fsp"
                 : Bexpr));
# 548 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 71 "CalculatorParser.fsp"
                                                        RgtExpr(_1,_3) 
                   )
# 71 "CalculatorParser.fsp"
                 : Bexpr));
# 560 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 72 "CalculatorParser.fsp"
                                                        RgetExpr(_1,_3) 
                   )
# 72 "CalculatorParser.fsp"
                 : Bexpr));
# 572 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 73 "CalculatorParser.fsp"
                                       FalseExpr 
                   )
# 73 "CalculatorParser.fsp"
                 : Bexpr));
# 582 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 74 "CalculatorParser.fsp"
                                      TrueExpr 
                   )
# 74 "CalculatorParser.fsp"
                 : Bexpr));
# 592 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 75 "CalculatorParser.fsp"
                                                   _2 
                   )
# 75 "CalculatorParser.fsp"
                 : Bexpr));
# 603 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : string)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Aexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 78 "CalculatorParser.fsp"
                                                    AssignExpr(_1,_3) 
                   )
# 78 "CalculatorParser.fsp"
                 : Cexpr));
# 615 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 79 "CalculatorParser.fsp"
                                      SkipExpr 
                   )
# 79 "CalculatorParser.fsp"
                 : Cexpr));
# 625 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Cexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Cexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 80 "CalculatorParser.fsp"
                                                        SepExpr(_1,_3) 
                   )
# 80 "CalculatorParser.fsp"
                 : Cexpr));
# 637 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : GCexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 81 "CalculatorParser.fsp"
                                                 IfExpr(_2) 
                   )
# 81 "CalculatorParser.fsp"
                 : Cexpr));
# 648 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _2 = (let data = parseState.GetInput(2) in (Microsoft.FSharp.Core.Operators.unbox data : GCexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 82 "CalculatorParser.fsp"
                                                 DoExpr(_2) 
                   )
# 82 "CalculatorParser.fsp"
                 : Cexpr));
# 659 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : Bexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : Cexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 85 "CalculatorParser.fsp"
                                                         WhileExpr(_1,_3) 
                   )
# 85 "CalculatorParser.fsp"
                 : GCexpr));
# 671 "CalculatorParser.fs"
        (fun (parseState : Microsoft.FSharp.Text.Parsing.IParseState) ->
            let _1 = (let data = parseState.GetInput(1) in (Microsoft.FSharp.Core.Operators.unbox data : GCexpr)) in
            let _3 = (let data = parseState.GetInput(3) in (Microsoft.FSharp.Core.Operators.unbox data : GCexpr)) in
            Microsoft.FSharp.Core.Operators.box
                (
                   (
# 86 "CalculatorParser.fsp"
                                                        OrExpr(_1,_3) 
                   )
# 86 "CalculatorParser.fsp"
                 : GCexpr));
|]
# 684 "CalculatorParser.fs"
let tables () : Microsoft.FSharp.Text.Parsing.Tables<_> = 
  { reductions= _fsyacc_reductions ();
    endOfInputTag = _fsyacc_endOfInputTag;
    tagOfToken = tagOfToken;
    dataOfToken = _fsyacc_dataOfToken; 
    actionTableElements = _fsyacc_actionTableElements;
    actionTableRowOffsets = _fsyacc_actionTableRowOffsets;
    stateToProdIdxsTableElements = _fsyacc_stateToProdIdxsTableElements;
    stateToProdIdxsTableRowOffsets = _fsyacc_stateToProdIdxsTableRowOffsets;
    reductionSymbolCounts = _fsyacc_reductionSymbolCounts;
    immediateActions = _fsyacc_immediateActions;
    gotos = _fsyacc_gotos;
    sparseGotoTableRowOffsets = _fsyacc_sparseGotoTableRowOffsets;
    tagOfErrorTerminal = _fsyacc_tagOfErrorTerminal;
    parseError = (fun (ctxt:Microsoft.FSharp.Text.Parsing.ParseErrorContext<_>) -> 
                              match parse_error_rich with 
                              | Some f -> f ctxt
                              | None -> parse_error ctxt.Message);
    numTerminals = 36;
    productionToNonTerminalTable = _fsyacc_productionToNonTerminalTable  }
let engine lexer lexbuf startState = (tables ()).Interpret(lexer, lexbuf, startState)
let start lexer lexbuf : Cexpr =
    Microsoft.FSharp.Core.Operators.unbox ((tables ()).Interpret(lexer, lexbuf, 0))
