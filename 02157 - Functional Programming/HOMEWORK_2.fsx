//HOMEWORK 2 
//# Anton Ruby Larsen s174356 # Mads Esben Hansen s17443 # Mathias Jarl Jarby Søndergaard s174426 


type Term = | V of string | C of int | F of string * Term list


//Exercise 2.1-----------
//Auxiliary function, ListOfV: term -> term list 
let rec ListOfV = function
    | F (_,[]) -> []
    | F (s,e::es) -> (auxListOfV e) @ (ListOfV (F (s, es)))
and auxListOfV = function
    | V r -> [r]
    | C _ -> []
    | F (s,l) -> ListOfV (F (s,l))

//isGround function Term -> bool
let isGround = function
    | e -> ListOfV e= List.empty


let t1 = F("f3",[F("f2",[C 2]); F("f1",[C 5]); F("f0",[])]);;
let t6 = F("f3",[F("f2",[C 1; C 2]); F("f1",[V "x"]); F("f0",[])]);;


//Check if there is no variable in t1 and t6 
isGround t1  //true
isGround t6  //false



//Exercise 2.2-----------
//toString: Term -> string
let rec toString = function
    | F (f,[]) -> f + "()"
    | F (f,e::es) -> f + "(" + ListToString [e] + (if not(es=[]) then "," else "") + ListToString es + ")"
and ListToString = function
    | F (f,list)::tail -> (toString (F (f,list))) + (if not(tail=[]) then "," else "") + ListToString tail
    | e::tail -> ElementToString e + (if not(tail=[]) then "," else "") + ListToString tail
    | [] -> ""
and ElementToString = function
    | V x -> x
    | C r -> string r 


//t6 as string: f3(f2(1,2),f1(x),f0())
toString t6



//Exercise 2.3-----------
//subst: Term -> Term -> Term list -> Term list
let rec subst x tp t = 
    match t with
    | F (f,list) -> F (f,auxsebst x tp list)
and auxsebst x tp list =
    match list with
    | [] -> []
    | F (f,list)::tail -> [subst x tp (F (f,list))] @ auxsebst x tp tail
    | C r::tail -> [C r] @ auxsebst x tp tail 
    | V r::tail when r=x -> [V tp] @ auxsebst x tp tail

//[y/x] in t6
subst "x" "y" t6
//Easily seen here:
toString (subst "x" "y" t6)



//Exercise 2.4-----------
//Auxiliary function, extract Map: Term -> (string * int) list
let rec extractList = function
    | F (f,list) -> [(f, List.length(list))] @ auxExtractList list
and auxExtractList = function
    | [] -> []
    | F (f,list)::tail -> extractList (F (f,list)) @ auxExtractList tail
    | _::tail -> auxExtractList tail

//Auxiliary function, isOk: (string * int) list -> bool
let rec isOk = function
    | [] -> true
    | (f,n)::tail -> List.forall (fun (fp,np) -> if f=fp then n=np else true) tail && isOk tail

//extractArities, Term -> Map<string,int> option
let extractArities t = if isOk(extractList t) then Some (Map.ofList (extractList t)) else None



//note f3 occours twice
let t2 = F("f3",[F("f2",[C 1; C 2]); F("f3",[V "x"]); F("f0",[])]);;

//Outputs as described in the assignment 
extractArities t6

//Outputs None
extractArities t2