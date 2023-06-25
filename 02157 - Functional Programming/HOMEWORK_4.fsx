//HOMEWORK 4 
//# Anton Ruby Larsen s174356 # Mads Esben Hansen s17443 # Mathias Jarl Jarby Søndergaard s174426 


//SCOREBOARD #####
type Name = string
type Event = string
type Point = int
type Score = Name * Event * Point
type Scoreboard = Score list
let sb = [("Joe", "June Fishing", 35); ("Peter", "May Fishing", 30);("Joe", "May Fishing", 28); ("Paul", "June Fishing", 28)];;

//1.1
//inv: Scoreboard -> bool
let rec inv = function
    | (_,_,s0)::es -> invaux s0 es
    | _ -> false
and invaux s0 = function
    | [] -> true
    | (_,_,sn)::es when s0>=sn -> invaux sn es
    | _ -> false

inv sb


//1.2
//insert: Score -> Scoreboard -> Scoreboard
let rec insert (n,k,s) = function
    | (n1,k1,s1)::es when s>=s1 -> (n,k,s)::(n1,k1,s1)::es
    | (n1,k1,s1)::es -> (n1,k1,s1)::insert (n,k,s) es
    | [] -> [n,k,s]


insert ("Egon","Skak",40) sb


//1.3
//get: (Event * Scoreboard) -> int
let get (name,sb) = List.map (fun (_,ev,score) -> (ev,score)) (List.filter (fun (name1,_,_) -> name=name1) sb)

get ("Joe", sb)


//1.4
//top: int -> Scoreboard -> Scoreboard option
let rec top k sb = if k<0 || (List.length sb)<k then None else auxtop k sb []
and auxtop k sb state =
    match sb with
    | p::sb -> if (List.length state)<k then auxtop k sb (state @ [p]) else Some state
    | [] -> Some state

//Alternative solution
let top k sb = if k<0 || (List.length sb)<k then None else Some (List.foldBack (fun p state -> if (List.length state)<k then p::state else state) sb [])

top 4 sb




//PATH IN TREES  ###

type T<'a> = N of 'a * T<'a> list;;

let td = N("g", []);;
let tc = N("c", [N("d",[]); N("e",[td])]);;
let tb = N("b", [N("c",[])]);;
let ta = N("a", [tb; tc; N("f",[])])


//1
//toList: T<'a> -> 'a list
let rec toList (N (s,list)) = s::(auxList list)
and auxList = function
    | N (s,list)::tail -> s::(auxList list @ auxList tail)
    | [] -> []

toList ta



//2
//map: ('a -> 'b) -> T<'a> -> T<'b>
let rec map f (N (s,list)) = N(f s,auxMap f list)
and auxMap f = function
    | N (s,list)::tail -> N (f s,auxMap f list) :: (auxMap f tail)
    | [] -> []

map (fun s -> s + "K") ta


type Path = int list


//3
//path: int list -> T<'a> -> bool
let rec isPath is (N (_,list)) = auxPath 0 (is,list)
and auxPath n = function
    | (i::is,N (_,list)::_) when n=i -> auxPath 0 (is,list)
    | (i::is,N (_,_)::tail) -> auxPath (n+1) (i::is,tail)
    | ([],_) -> true
    | (_,[]) -> false

isPath [0] ta


//4
//get: int list -> T<'a> -> T<'a>
let rec get is (N (s,list)) = auxGet1 (N (s,list)) 0 (is,list)
and auxGet1 tn n = function
    | (i::is,N (s,list)::_) when n=i -> auxGet1 (N (s,list)) 0 (is,list)
    | (i::is,N (s,list)::tail) -> auxGet1 (N (s,list)) (n+1) (i::is,tail)
    | ([],_) -> tn
    | (_,[]) -> failwith "Path does not exist in tree"

get [1;1;0] ta



//5
//tryFindPathto: ’a -> T<’a> -> Path option
let rec tryFindPathto v = function
    | N(s,_) when s=v -> Some []
    | N(s,list) -> if List.contains v (toList (N (s,list))) then Some (List.rev (auxTFP1 v (list,[0]))) else None
and auxTFP1 v = function
    | (N (s,_)::_,ns) when s=v -> ns
    | (N (s,list)::tail,n::ns) -> if (List.contains v (toList (N (s,list)))) then (auxTFP1 v (list,(0::(n::ns)))) else (auxTFP1 v (tail,((n+1)::ns)))
    | ([],_) -> failwith "This shouldn't have happened, something went wrong"
    | (_,[]) -> failwith "This shouldn't have happened, something went wrong"

tryFindPathto "c" ta