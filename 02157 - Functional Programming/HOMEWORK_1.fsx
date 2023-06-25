//HOMEWORK 1 - Mads Esben Hansen s174434 - Anton Ruby Larsen s174356 - Mathias Jarl Jarby Søndergaard s174426

//TASK 2 -------------------------------------------------------
type Species     = string
type Location    = string
type Time        = int
type Observation = Species * Location * Time
let os = [("Owl","L1",3); ("Sparrow","L2",4); ("Eagle","L3",5); ("Falcon","L2",7); ("Sparrow","L1",9);  ("Eagle","L1",14)]

//1
let rec locationsOf s os = 
    match os with
    | [] -> []
    | (sn,ln,_tn)::tail when sn=s ->  ln::locationsOf s tail
    | _::tail -> locationsOf s tail;;

//white-box test of locationsOf
locationsOf "a" [];; // expects type error
locationsOf "" os;; // expects []
locationsOf "Owl" os;; // expects ["L1"]
locationsOf "Eagle" os;; // expects ["L3"; "L1"]


//2
let rec insert a occ =
    match occ with
    | [] -> [(a,1)]
    | (an,cn)::tail when an=a -> (a,cn+1)::tail 
    | h::tail -> h::insert a tail;;

//white-box test of insert
insert "Owl" [("Eagle", 2); ("Sparrow", 2); ("Falcon", 1); ("Owl", 1)];; // expects [("Eagle", 2); ("Sparrow", 2); ("Falcon", 1); ("Owl", 2)]
insert "" [];; // expects [("", 1)]
insert (2,4) [(4,3)];; // expects type error
insert os;; // expects a declaration of the function

//3
let rec toCount os =
    match os with
    | [] -> []
    | (sn,_,_)::tail -> insert sn (toCount tail);;

//test of toCount
toCount os;; // expects  [("Eagle", 2); ("Sparrow", 2); ("Falcon", 1); ("Owl", 1)]


//4
let rec select f intv os  =
    match (os,intv) with
    | ([],_) -> []
    | ((sn,ln,tn)::tail,(t1,t2)) when t1<=tn && tn<=t2 -> [f (sn,ln)] @ select f (t1,t2) tail
    | (_::tail,(t1,t2)) -> select f (t1,t2) tail;;

//test of select
select (fun (x,y) -> (x,y)) (4,9) os;;  //returns value = [("Sparrow", "L2"); ("Eagle", "L3"); ("Falcon", "L2"); ("Sparrow", "L1")]



//5
select (fun (x,y) -> (x,y)) (4,9) os;;   //returns value = [("Sparrow", "L2"); ("Eagle", "L3"); ("Falcon", "L2"); ("Sparrow", "L1")]




//TASK 3 -------------------------------------------------------
//1                    
//Auxiliary function "unzip" [(a,b,c);(d,e,f);(g,h,i)] -> ([a;d;g];[b,e;h];[c,f;i])
let unzip os = List.foldBack (fun (x,y,z) (xs,ys,zs) -> (x::xs,y::ys,z::zs)) os ([],[],[]);;
      
let locationsOf s os = 
    let unos = unzip (List.filter (fun (sn,ln,tn) -> (sn,ln,tn)=(s,ln,tn)) os)
    match unos with
    | (_,ls,_) -> ls;;

//test of locationsOf
locationsOf "Eagle" os;; // expects ["L3"; "L1"]

   
//2
let toCount os =List.foldBack (fun (x,y,z) xs -> x::xs) os [] |>List.countBy id;;

//test of toCount
toCount os;; // expects  [("Owl", 1); ("Sparrow", 2); ("Eagle", 2); ("Falcon", 1)]
