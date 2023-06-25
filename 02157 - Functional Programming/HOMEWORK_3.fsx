//HOMEWORK 3 
//# Anton Ruby Larsen s174356 # Mads Esben Hansen s17443 # Mathias Jarl Jarby Søndergaard s174426 


type Title = string
type Document = Title * Element list
and  Element  = Par of string | Sec of Document


let s1   = ("Background", [Par "Bla"])
let s21  = ("Expressions", [Sec("Arithmetical Expressions", [Par "Bla"]);Sec("Boolean Expressions", [Par "Bla"])])
let s222 = ("Switch statements", [Par "Bla"])
let s223 = ("Repeat statements", [Par "Bla"])
let s22  = ("Statements",[Sec("Basics", [Par "Bla"]) ; Sec s222; Sec s223])
let s23  = ("Programs", [Par "Bla"])
let s2   = ("The Programming Language", [Sec s21; Sec s22; Sec s23])
let s3   = ("Tasks", [Sec("Frontend", [Par "Bla"]);Sec("Backend", [Par "Bla"])])
let doc  = ("Compiler project", [Par "Bla"; Sec s1; Sec s2; Sec s3])

//1
//noOfSecs: Document -> int 
let rec noOfSecs = function
    | (_,e1::rest) -> auxNOS1 e1 + auxNOS2 rest
    | _ -> 0
and auxNOS1 = function
    | Sec (_,E::rest) -> 1 + auxNOS1 E + auxNOS2 rest
    | _ -> 0
and auxNOS2 = function
    | [] -> 0
    | e::rest -> auxNOS1 e + auxNOS2 rest

noOfSecs doc;;


//2
// sizeOfDoc: Document -> int
let rec sizeOfDoc = function
    | (T,e1::rest) -> String.length T + auxSOD1 e1 + auxSOD2 rest
    | _ -> 0
and auxSOD1 = function
    | Sec (T,E::rest) -> String.length T + auxSOD1 E + auxSOD2 rest
    | Par p -> String.length p
    | _ -> 0
and auxSOD2 = function
    | [] -> 0
    | e::rest -> auxSOD1 e + auxSOD2 rest

sizeOfDoc doc;;

//Double check if it holds:
let allStrings="Background"+"Bla"+"Expressions"+"Arithmetical Expressions"+"Bla"+"Boolean Expressions"+"Bla"+"Switch statements"+"Bla"+"Repeat statements"+"Bla"+"Statements"+"Basics"+"Bla"+"Programs"+"Bla"+"The Programming Language"+"Tasks"+"Frontend"+ "Bla"+"Backend"+"Bla"+"Compiler project"+"Bla"

String.length allStrings = sizeOfDoc doc //True, so the function works with the "doc" example.

//3
// titlesInDoc: Documnet -> Title list
let rec titlesInDoc = function
    | (_,e1::rest) -> auxTID1 e1 @ auxTID2 rest
    | _ -> []
and auxTID1 = function
    | Sec (T,E::rest) -> T::(auxTID1 E @ auxTID2 rest)
    | _ -> []
and auxTID2 = function
    | [] -> []
    | e::rest -> auxTID1 e @ auxTID2 rest

titlesInDoc doc;;


type Prefix = int list;;
type ToC = (Prefix * Title) list


//4
//toc: Document -> ToC
let rec toc = function
    | (t,e) -> [([],t)] @ List.map (fun (ps,T) -> (List.rev(ps),T)) (auxTOC1 ([0],e))
and auxTOC1 = function
    | (_,[]) -> []
    | (p::ps, Sec (T,es)::tail) -> (p+1::ps,T)::auxTOC2 (0::p+1::ps,es) @ auxTOC2 (p+1::ps,tail)
    | (ps, _::tail) -> auxTOC1 (ps,tail)
and auxTOC2 = function
    | (_,[]) -> []
    | (p::ps, Sec (T,es)::tail) -> auxTOC1 (p::ps,[Sec (T,es)]) @ auxTOC2 (p+1::ps,tail)
    | (p,_::tail) -> auxTOC2 (p,tail)

toc doc;;