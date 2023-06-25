{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module Symbolic where
import Data.Maybe
import Data.List
import Constants
import IntsOnly
import Decomposition
import MsgTree
import Remola
import qualified Data.Map as Map


isIntruder :: Msg -> Bool
isIntruder m = (m == atom_i) || (m == UnOp opAgent atom_i)

type Step = Int

data Fact = M Step Msg Msg Msg Msg Msg
	  | W Step Msg Msg Msg Msg Msg
	  | Secret Msg Msg 
	  | Give Msg Msg
	  | Request Msg Msg Msg Msg Bool
	  | Witness Msg Msg Msg Msg  
	  | BinOpF Msg Msg Msg --- the first one is the operator name, 
		              --- the other two the arguments.
	  deriving Eq

type RT = Bool  -- True: Std

type Rule = ([Fact],[Fact],[Inequality],[Fact],RT)
--- LHS Negative-Facts Inequalities RHS

show_users :: Msg ->   Msg ->          Msg ->   Msg ->  String
show_users real_sender official_sender receiver session =
  if isIntruder real_sender
  then
    (if isIntruder official_sender
     then "i" 
     else "(I,"++(show official_sender)++")")
    ++" -> ("++(show receiver)++","++(show session)++"): "
  else
    "("++(show real_sender)++","++(show session)++") -> "++
    (if isIntruder receiver
     then "i"
     else "(I,"++(show receiver)++")")++": "

--- must be decided later...
show_users2 :: Msg ->   Msg ->          Msg ->   Msg ->  String
show_users2 real_sender official_sender receiver session =
  if isIntruder real_sender
  then
    (if isIntruder official_sender
     then "i" 
     else "(i,"++(show official_sender)++")")
    ++" -> ("++(show receiver)++","++(show session)++"): "
  else
    "("++(show real_sender)++","++(show session)++") -> "++
    (if isIntruder receiver
     then "i"
     else "(i,"++(show receiver)++")")++": "

instance Show Fact where
  showsPrec p e = 
    case e of
    (M 0 o s r m c) 
     -> showString ((show_users2 o s r c)++(show m))
    (M i o s r m c) 
     -> showString ((show i)++". "++(show_users o s r c)++(show m))
    (W i s r (Atom _ "dummy") l c) 
     -> showString "" 
    (W i s r st l c) 
     -> showString ("state_"++(show st)++"(" --- ++(show i)++","
                    ++(show s)++","++(show r)++(showDvO l)++(showDvO c)++")")
    (Secret (BinOp op atom1 atom2) session)
     -> showString ("secret("++(show atom1)++","++(show atom2)++","++(show session)++")")
    (Secret atom session)
     -> showString ("secret("++(show atom)++","++(show session)++")")
    (Give atom session)
     -> showString ( "give("++(show atom)++","++(show session)++")")
    (Request a b c d bool) 
     -> showString ((if bool then "request" else "wrequest")
                    ++"("++(show a)++","++(show b)++","++(show c)++","
                    ++(show d)++")")
    (Witness a b c d) 
     -> showString ("witness("++(show a)++","++(show b)++","++(show c)++","++(show d)++")")
    (BinOpF  (Atom 12 "request") (BinOp _ m1
			(BinOp _ m2 (BinOp _ m3 m4))) m5)
     -> showString ("request("++(showlist [m1,m2,m3,m4,m5])++")") 
    (BinOpF  (Atom 11 "witness") (BinOp _ m1
			(BinOp _ m2 (BinOp _ m3 m4))) _)
     -> showString ("witness("++(showlist [m1,m2,m3,m4])++")") 
    (BinOpF a b c ) 
     -> showString ((show a)++"("++(show b)++","++(show c)++")")
    
showDvO m@(BinOp op m1 m2) = 
  if op==opNAPair then ","++(show m1)++(showDvO m2) else 
  if m==atom_dummy then "" else ","++(show m)
showDvO m = if m==atom_dummy then "" else ","++(show m)

show_factlist :: [Fact] -> Bool -> String
show_factlist [] _ = ""
show_factlist (x:xs) b = (if b then "% " else "") ++ (show x)++"\n"++
			 (show_factlist xs b)

mapfact :: (Msg -> Msg) -> Fact -> Fact
mapfact f (M s m1 m2 m3 m4 m5) = M s (f m1) (f m2) (f m3) (f m4) (f m5)
mapfact f (W s m1 m2 m3 m4 m5) = W s (f m1) (f m2) (f m3) (f m4) (f m5)
mapfact f (Secret m1 m2)       = Secret (f m1) (f m2)
mapfact f (Give   m1 m2)       = Give   (f m1) (f m2)
mapfact f (Request m1 m2 m3 m4 b) = Request (f m1) (f m2) (f m3) (f m4) b
mapfact f (Witness m1 m2 m3 m4) = Witness (f m1) (f m2) (f m3) (f m4)
mapfact f (BinOpF m1 m2 m3)    = BinOpF (f m1) (f m2) (f m3)

substitute_fact :: Substitution -> Fact -> Fact
substitute_fact sub fact = mapfact (substitute sub) fact

var_fact :: Fact -> [Int]
var_fact (M s m1 m2 m3 m4 m5) = concatMap msg_vars [m1,m2,m3,m4,m5]
var_fact (W s m1 m2 m3 m4 m5) = concatMap msg_vars [m1,m2,m3,m4,m5]
var_fact (Secret m1 m2) = concatMap msg_vars [m1,m2]
var_fact (Give m1 m2) = concatMap msg_vars [m1,m2]
var_fact (Request m1 m2 m3 m4 b) = concatMap msg_vars [m1,m2,m3,m4]
var_fact (Witness m1 m2 m3 m4) = concatMap msg_vars [m1,m2,m3,m4]
var_fact (BinOpF m1 m2 m3) = concatMap msg_vars [m1,m2,m3]

var_rule :: Rule -> [Var]
var_rule (l,n,c,r,_) = nub ((concatMap var_fact l)++
			    (concatMap var_fact r)++
			    (concatMap var_fact n)++
			    (concatMap var_ineq c))

var_ineq (Negsub var eq) = 
  var ++ (concatMap (\ (s,t) -> (msg_vars s)++(msg_vars t)) eq)
var_ineq _ = []

isWTerm (W _ _ _ _ _ _) = True
isWTerm _ = False

isMTerm (M _ _ _ _ _ _) = True
isMTerm _ = False

isSecret (Secret _ _) = True
isSecret _ = False

isGTerm (Give _ _) = True
isGTerm _ = False

isWitness (Witness _ _ _ _) = True
isWitness _ = False

isRequest (Request _ _ _ _ _) = True
isRequest _ = False

type Time = Int

data State = State{ porflag :: Bool,
		    time    :: Time,
		    facts   :: [Fact],
		    ik	    :: IKstate,
		    popo    :: [Fact],
		    cs	    :: Constraints,
		    history :: [Fact] }
		    deriving (Eq,Show)

var_state :: State -> [Var]
var_state = concatMap var_fact . facts

new_var_rename :: State -> Rule -> Rule
new_var_rename s r =
  let offset = 100*(1+(time s)) 
  in add_var_rule offset r

add_var_rule offset (lhs,neg,cond,rhs,rtype) = 
  (map (add_var_fact offset) lhs,
   map (add_var_fact offset) neg,
   map (add_var_ineq offset) cond,
   map (add_var_fact offset) rhs, rtype)

add_var_fact offset fact =
  case fact of
  M i m1 m2 m3 m4 m5    -> M i     (f m1) (f m2) (f m3) (f m4) (f m5)
  W i m1 m2 m3 m4 m5    -> W i     (f m1) (f m2) (f m3) (f m4) (f m5)
  Secret m1 m2          -> Secret  (f m1) (f m2)
  Give m1 m2            -> Give    (f m1) (f m2)
  Witness m1 m2 m3 m4   -> Witness (f m1) (f m2) (f m3) (f m4)
  Request m1 m2 m3 m4 b -> Request (f m1) (f m2) (f m3) (f m4) b
  BinOpF m1 m2 m3       -> BinOpF  (f m1) (f m2) (f m3)
 where f = add_var_msg offset

add_var_msg offset msg =
  case msg of
  Var x          -> Var (x+offset)
  UnOp op m      -> UnOp  op (add_var_msg offset m)
  BinOp op m1 m2 -> BinOp op (add_var_msg offset m1) 
			     (add_var_msg offset m2)
  _              -> msg

add_var_ineq offset (Negsub var eq) = 
  Negsub 
  (map (+offset) var) 
  (map (\ (s,t) -> (add_var_msg offset s, add_var_msg offset t)) eq)
add_var_ineq _ ineq = ineq


showState :: State -> String
showState s =
  (if porflag s then "*" else "")++
  (concatMap (\f -> (show f)++"\n") (history s))

showState2 :: State -> String
showState2  s =
  (if porflag s then "*PORflag\n" else "")++
  "state:\n"++
  (concatMap (\f -> (show f)++"\n") (facts s))++"\n"++
  "postponed:\n"++
  (concatMap (\f -> (show f)++"\n") (popo s))++"\n"++
  "ik state:\n"++
  (showIKstate (ik s))++"\n"

showState3 :: State -> String
showState3 s =
  (showState2 s)++"\n"++
  "Constraints:\n"++
  (show_constraints (cs s))++"\n"

init_init :: AlgTheo -> State -> State
init_init theo s =
  s {ik = init_ana theo (getMsgs (ik s))} 

getMsgs (ik,nik,b) = mtToList (fst (catIK ik nik))

type InterState = (State,Rule)

showInterState :: InterState -> String
showInterState (s,(lhs,neg,cond,rhs,_)) =
 (showState3 s)++"\nRule: "++
 (show (lhs,neg))++" where "++
 (concatMap show_inequality cond)++"=> "++(show rhs)

substitute_state :: FECTheo -> Substitution -> State -> State
substitute_state fecTheo sub s = 
  s { facts = map (substitute_fact sub) (facts s),
      ik    = substituteIKstate sub (ik s),
      popo  = map (substitute_fact sub) (popo s),
      cs    = substitute_constraints fecTheo sub (cs s),
      history=  map (substitute_fact sub) (history s) }

substitute_interstate :: FECTheo -> Substitution -> InterState -> InterState
substitute_interstate fecTheo sub (state,(lhs,neg,cond,rhs,rtype)) =
  (substitute_state fecTheo sub state, 
   (map (substitute_fact sub) lhs, 
    map (substitute_fact sub) neg, 
    substineqs fecTheo sub cond, 
    map (substitute_fact sub) rhs,rtype))

{- Step 1: LHS w term -}


freeAlg :: FECTheo
freeAlg = (\ x -> error "you're not supposed to call this", \x -> [])


match_lhs_waiting_term :: FECTheo -> Bool -> InterState -> [InterState]
match_lhs_waiting_term fecTheo por (state,(lhs,neg,cond,rhs,rtype)) =
  let lhswterms = filter isWTerm lhs 
      otherterms = filter (\ x -> (not (isWTerm x)) && (not (isMTerm x))) lhs
  in
   case lhswterms of
    [] ->      let subfacts = unify_factset fecTheo 
		    	       otherterms
                               (facts state) Map.empty
                in 
		 (map (\ (remainingfacts,sub1) -> substitute_interstate fecTheo sub1
                            (state{porflag=False,
				   facts=remainingfacts,
				   ik=undiffIKstate (ik state)
			           },(lhs,neg,cond,rhs,rtype))) subfacts)
    [lhswterm] -> 
      concatMap 
	(\ (wfact,rest,overridden) -> 
              case catMaybes [(unify_facts freeAlg wfact lhswterm Map.empty)] of
	       [] -> []
	       sub0 -> 
	        let otherterms'=concatMap (\ s0 -> map (substitute_fact s0) otherterms) sub0
                    subfacts = concatMap (\ s0 -> unify_factset fecTheo (map (substitute_fact s0) otherterms) 
                                                  rest s0) sub0
                in 
		if por && rtype
 	        then let (afa,bfa) = partition ((==) wfact) (popo state) in 
                     if (afa==[]) 
		     then
		       (map (\ (remainingfacts,sub1) -> (substitute_interstate fecTheo sub1
                             (state{porflag=False,
				    facts=remainingfacts,
				    ik=undiffIKstate (ik state),
				    popo=overridden++bfa},(lhs,neg,cond,rhs,rtype)))) subfacts)
	             else 
                      if (checkNIKempty (ik state)) then 
                        [] --- we can't use anything new
	              else
			 (map (\ (remainingfacts,sub1) -> substitute_interstate fecTheo sub1
                             (state{porflag=True,
				    facts=remainingfacts,
				    popo=overridden++bfa},(lhs,neg,cond,rhs,rtype))) subfacts)
	        else 
                  (map (\ (remainingfacts,sub1) -> substitute_interstate fecTheo sub1
                            (state{porflag=False,
				   facts=remainingfacts,
				   ik=undiffIKstate (ik state),
				   popo=(if rtype then  overridden++(popo state)++rest
				   	 else popo state)
			           },(lhs,neg,cond,rhs,rtype))) subfacts)
         ) (splatters isWTerm (my_partial_order (por) (facts state)))
    _ -> error ("multiple waiting terms in lhs of a rule: "++(show lhs))


compses (Number i) (Number j) = compare j i
compses _ _ = EQ

my_partial_order :: Bool -> [Fact] -> [Fact]
my_partial_order por l =
 if por then
   (sortBy 
    (\ f1 f2 ->
       case (f1,f2) of
	((W step1 sender1 receiver1 stk1 ltk1 ses1),(W step2 sender2 receiver2 stk2 ltk2 ses2)) ->
           let cmp = compses ses2 ses1 in
	   case cmp of 
	    EQ -> if (step1 == step2) then
                     case (stk1,stk2) of
                       (Atom i a, Atom j b) -> compare a b
                       (_, _) -> error "Not as expected!"
                  else
                     compare step1 step2
	    _  -> cmp
        ((W _ _ _ _ _ _),_) -> LT
	(_,(W _ _ _ _ _ _)) -> GT
	(_,_) -> EQ) l)
 else l

splatters :: (a->Bool) -> [a] -> [(a,[a],[a])]
splatters f l = splatters0 f l [] []

splatters0 f [] _ _ = []
splatters0 f (x:xs) l1 l2 = 
 if f x then (x,xs++l1,l2):(splatters0 f xs (x:l1) (x:l2)) 
        else                splatters0 f xs (x:l1)    l2

unify_facts :: FECTheo -> Fact -> Fact -> Substitution -> Maybe Substitution
unify_facts fecTheo f1 f2 sub = 
  if (same_root_symbol f1 f2) then (unify_facts0 fecTheo f1 f2 sub)
  else Nothing

unify_facts0 :: FECTheo -> Fact -> Fact -> Substitution -> Maybe Substitution
unify_facts0 fecTheo (W i m1 m2 m3 m4 m5) (W i' m1' m2' m3' m4' m5') sub1 =
  if (i /= i') then Nothing else 
  let unifers = unifyF fecTheo sub1 
                [(m1,m1'),(m2,m2'),(m3,m3'),(m4,m4'),(m5,m5')]
  in case unifers of
      [] -> Nothing
      (x:_) -> Just x
unify_facts0 fecTheo (BinOpF m1 m2 m3) (BinOpF m1' m2' m3') sub1 =
  (unify_facts0 fecTheo (W 0 m1  m2  m3  (atom_dummy) ( atom_dummy))
               (W 0 m1' m2' m3' (atom_dummy) ( atom_dummy))) sub1
unify_facts0 fecTheo (Secret m1 m2) (Secret m1' m2') sub1 =
  unify_facts0 fecTheo (BinOpF m1 m2 m2) (BinOpF m1' m2' m2') sub1 
unify_facts0 fecTheo (Request m1 m2 m3 m4 m5) (Request m1' m2' m3' m4' m5') sub1 =
  if (m5/=m5') then Nothing else 
  unify_facts0 fecTheo (W 0 m1 m2 m3 m4 m4) (W 0 m1' m2' m3' m4' m4') sub1 
unify_facts0 fecTheo (Witness m1 m2 m3 m4) (Witness m1' m2' m3' m4') sub1 =
  unify_facts0 fecTheo (W 0 m1 m2 m3 m4 m4) (W 0 m1' m2' m3' m4' m4') sub1 
unify_facts0  fecTheo (M m1 m2 m3 m4 m5 m6) (M m1' m2' m3' m4' m5' m6') sub =
  unify_facts0  fecTheo (W m1 m2 m3 m4 m5 m6) (W m1' m2' m3' m4' m5' m6') sub
unify_facts0 fecTheo t1 t2 _ = Nothing

same_root_symbol :: Fact -> Fact -> Bool
same_root_symbol (W _ _ _ _ _ _) (W _ _ _ _ _ _) = True
same_root_symbol (M _ _ _ _ _ _) (M _ _ _ _ _ _) = True
same_root_symbol (Secret _ _) (Secret _ _)       = True
same_root_symbol (Give _ _) (Give _ _)           = True
same_root_symbol (Request _ _ _ _ _) (Request _ _ _ _ _) = True
same_root_symbol (Witness _ _ _ _) (Witness _ _ _ _) = True
same_root_symbol (BinOpF op1 _ _) (BinOpF op2 _ _) = op1==op2
same_root_symbol _ _ = False

unify_factset0 :: FECTheo -> Fact -> [Fact] -> [Fact] -> Substitution 
	       -> [([Fact],Substitution)]

unify_factset0 _ f [] rest sigma = []
unify_factset0 fecTheo f (s:set) rest sigma =
 (map (\ sigma -> 
        let siggi = substitute_fact sigma in
	((map siggi set)++(map siggi rest),sigma))
      (maybeToList (unify_facts fecTheo f s sigma)))++
 (unify_factset0 fecTheo f set (s:rest) sigma)

unify_factset :: FECTheo -> [Fact] -> [Fact] -> Substitution 
		-> [([Fact],Substitution)]
unify_factset _ [] set sigma = [(set,sigma)]
unify_factset fecTheo (f:facts) set sigma =
  concatMap 
   (\ (restset,sigma) -> 
        unify_factset0 fecTheo (substitute_fact sigma f) restset [] sigma)
   (unify_factset fecTheo facts set sigma)

very_lazy = False

generate_check_state :: Bool -> FECTheo -> InterState -> [InterState]
generate_check_state very_lazy fecTheo (state,rule@(lhs,neg,cond,rhs,rtype)) =
  let list = gencheck fecTheo (cs state) Map.empty in
  if null list then [] else
  if very_lazy then [(state,rule)] else
  map (\ (constraints',sub) -> 
	 substitute_interstate fecTheo sub
	 (state{cs=constraints'},(lhs,neg,cond,rhs,rtype)))
  (gencheck fecTheo (cs state) Map.empty) 

{- Step 2: LHS m term if present -}

match_msg_fact ::  Bool -> FECTheo -> InterState -> [InterState]
match_msg_fact very_lazy fecTheo currstate@(state,(lhs,neg,cond,rhs,rtype)) =
 let (constraints,ineq) = (cs state)
     lhsmterms = filter isMTerm lhs 
 in
  case lhsmterms of
  [] ->  
     let notmterms = filter isMTerm neg in
      case notmterms of
      [] ->
        if (checkNIKempty (ik state))
	then 
	 generate_check_state very_lazy fecTheo currstate
        else [] 
      _ -> 
	error ("error in matching LHS msg term " ++ (show lhsmterms)++"\n"++(show neg))
  [M i real off recv mterm ses] -> 
   let notmterms = filter isMTerm neg  in 
    case notmterms of 
    [] ->
     generate_check_state very_lazy fecTheo
     (state { cs = (constraints++[mkDFromState [mterm] (ik state)],
                    checkineqs fecTheo (ineq++ cond)),
	      history=(history state)++[M i (UnOp opAgent (atom_i)) off recv mterm ses]},
      (lhs,neg,cond,rhs,rtype))
    p -> error ("negative knowledge (case: lhsmt not empty)"++(show p)++"\nState/Rule: "++(showInterState currstate))
  _ -> error "multiple message terms"


iknows2msg :: Fact -> Msg
iknows2msg (M _ _ _ _ m _) = m
iknows2msg _ = error "convert fact other than ik"


nonIDsub domain sub = 
  (filter (\ x -> elem x domain) (map fst sub))==[]

containsnonIDsub domain [] = False
containsnonIDsub domain (sub:subs) = 
  (nonIDsub domain sub) || (containsnonIDsub domain subs)

{- Step 2b: Match negative facts and inequalities -}

match_rest :: FECTheo -> InterState -> [InterState]
match_rest fecTheo (state,(lhs,neg,cond,rhs,rtype)) =
  let domain = nub
	       ((concatMap var_fact (facts state))
	        ++ (vars_IKState (ik state))
	        ++ (concatMap var_fact (popo state))
	        ++ (concatMap constr_vars (fst (cs state))))
      subs = 
        concatMap (\ neg_fact -> catMaybes ((\x -> map (\y -> unify_facts fecTheo x y Map.empty) (facts state)) (neg_fact))) neg
        --- concatMap (\x -> catMaybes $ map (\y -> unify_facts fecTheo x y Map.empty) (facts state)) neg
  in if (containsnonIDsub domain (map Map.toList subs)) then []
     --- this condition checks whether a negative fact can be *matched* with the current state 
     --- *without* substituting variables in the current state ("domain"). When no match (but
     --- maybe a unifier) can be found ... (unifier -> negative conditions on variables)
     else 
       let p1 = map (\sub -> 
	             (state{cs=(fst (cs state), 
				checkineqs fecTheo (cond++((negsub [] sub):(snd (cs state)))))},
		      (lhs,neg,cond,rhs,rtype))) subs
	   p3 = [(state{cs=(fst (cs state), 
				checkineqs fecTheo ((snd (cs state))++cond++(negsubs [] subs)))},
		      (lhs,neg,cond,rhs,rtype))]

       in filter (\ (state,_) -> isSatisfiable (snd (cs state))) p3

normalize_step :: InterState -> [InterState]
normalize_step s = [s] 


{- Step 3: Perform the actual step -}

--- (b,time,facts,ik,nik,ppa,constraints,hst),
perform_step :: Int -> InterState -> InterState
perform_step sfb (state,(lhs,neg,cond,rhs,rtype)) =
  (state{time=(time state)+1,
	 facts=union (filter (\x -> (not (isMTerm x)) && (sff sfb x)) rhs) 
               (facts state)},(lhs,neg,cond,rhs,rtype))
 

succfilter :: Int -> State -> State
succfilter sfb state =  state{facts=filter (sff sfb) (facts state)}

sff :: Int -> Fact -> Bool
sff sfb (W _ _ _ _ _ ses) = bnd sfb ses
sff sfb _ = True
bnd :: Int -> Msg -> Bool
bnd sfb (UnOp op xc) = True
bnd sfb _ = True

{- Step 4: Update Intruder knowledge -}

normalizeSes :: Msg -> Msg
normalizeSes (UnOp op m) = normalizeSes m
normalizeSes m = m

mytail [] = []
mytail (x:xs) = xs

isWeak (Request _ _ _ _ False) = True
isWeak _ = False

analz_knowl :: Bool -> AlgTheo -> Bool -> InterState -> [InterState]
analz_knowl veryLazy theo@(fecTheo,_) por (state,(lhs,neg,cond,rhs,rtype)) = 
 let mterms = filter isMTerm rhs
     newterms = [ m | M _ _ _ _ m _ <- rhs] in
  if mterms==[] then 
        [(state,(lhs,neg,cond,rhs,rtype))]
  else
    let ana = if veryLazy then [(cs state,Map.empty,ik state)]
	      else analz theo (cs state) (getallIK (ik state)) newterms
        possibilities = if por && rtype
			then ana
                        else map 
			     (\ (constraints',sub',ikstate) -> 
                                (constraints',sub',undiffIKstate ikstate)) 
			     ana
     in
     map (\ (constraints',sub,ikstate)
          -> substitute_interstate fecTheo sub 
 	     (state{ik=ikstate,
		    cs=constraints',
		    history=(history state)++mterms},(lhs,neg,cond,rhs,rtype)))
         possibilities


firstNonSimpleConstraint [] = (Nothing,[])
firstNonSimpleConstraint ((a,b,c):xs) =
  if (filter (not . isVar) a)/=[] then (Just (a,b,c),xs)
  else let (sc,cs) = firstNonSimpleConstraint xs
       in (sc,(a,b,c):xs)
isSimple r = case (firstNonSimpleConstraint r) of
	       (Nothing,lala) -> True
	       _ -> False

{- Putting it all together -}

successors :: Bool -> AlgTheo -> Bool -> Int -> (Int -> Rule) -> State -> [State]
successors very_lazy theo@(fecTheo,_) por sfb rule s = --- was: state 
 let r = new_var_rename s (rule (getTime s)) in         
  (if very_lazy
   then concatMap
	(\ (state,_) ->
	   case perform_constraint_reduction theo state of
	   [] -> []
	   [x] -> [x]
	   _ -> [state])
   else map fst)
  (compList [(analz_knowl very_lazy theo por) . (perform_step sfb),
 	     match_rest fecTheo,
	     match_msg_fact very_lazy fecTheo,
	     normalize_step,
	     match_lhs_waiting_term fecTheo por] (s,r))

comp :: (a->[a]) -> (a->[a]) -> a -> [a]
comp f g = (concatMap f) . g

compList :: [(a->[a])] -> a->[a]
compList = foldr comp return

perform_constraint_reduction :: AlgTheo -> State -> [State]
perform_constraint_reduction (algtheo@(fecTheo,_)) s = 
  map (\ (cs',sub) -> substitute_state fecTheo sub s{cs=cs'}) 
  (reduce algtheo (cs s))

reduce :: AlgTheo -> Constraints -> [(Constraints,Substitution)]
reduce (algtheo@(fecTheo,_)) constraints = 
 map fst 
 (foldl
  (\ possibilities constraint ->
     concatMap 
     (\ ((constraints,sub),currentIK) ->
	let (t,ik,nik) = 
	      substitute_constraint sub constraint
	    nik' = diffMT nik (fst (getallIK currentIK)) in
	concatMap 
	(\ (constraints',sub',currentIK') ->
	   let ikstate = if isEmptyMT ik 
			 then undiffIKstate currentIK'
			 else currentIK'
	       constraint'= mkDFromState t ikstate in
	       zip 
	       (gencheck0 fecTheo [] 
		(substitute_constraint sub' constraint')
		constraints' sub') 
	       (repeat ikstate))
	(analz algtheo constraints (getallIK currentIK) (mtToList nik')))
     possibilities)
  [((([],snd constraints),Map.empty),(emptyIK,emptyIK,False))]
  (fst constraints))

getTime :: State -> Int
getTime = time

prlist :: String -> State -> String
prlist goal state = goal++"*"++
		    (show_factlist (history state) False)++"\n\n"++
		    "% Reached State:\n"++
		    (show_factlist (facts state) True)

base :: Msg -> Int
base (Number i) = i
base (UnOp op m) = base m
base m = error ("Message "++(show m)++" has no base")
  

match_lhs_waiting_term_must :: FECTheo -> Bool -> InterState -> [InterState]
match_lhs_waiting_term_must fecTheo por (state,(lhs,neg,cond,rhs,rtype)) =
 let lhswterms = filter isWTerm lhs 
     otherterms = filter (\ x -> (not (isWTerm x)) && (not (isMTerm x))) lhs
 in
 case otherterms of
  (x:xs) -> []
  _ ->
   case lhswterms of
    [] -> [(state,(lhs,neg,cond,rhs,rtype))] 
    [lhswterm] -> 
      concatMap 
	(\ (wfact,rest,overridden) -> 
              case catMaybes [(unify_facts freeAlg wfact lhswterm Map.empty)] of
	       [] -> []
	       sub0 -> 
                 (map (\ sub1 -> 
                        (substitute_interstate fecTheo sub1
                         (state{porflag=False,
				facts=rest,
				ik=undiffIKstate (ik state),
				popo =  (popo state)++
				        (if por && rtype then []
                                         else overridden++rest)},
			  (lhs,neg,cond,rhs,rtype))))
                      sub0))
        (splatters isWTerm (facts state))
    _ -> error ("multiple state facts in the lhs of a rule: "++(show lhs))

match_msg_fact_must :: FECTheo -> InterState -> [InterState]
match_msg_fact_must fecTheo (state,(lhs,neg,cond,rhs,rtype)) =
 let (constraints,ineq) = cs state
     lhsmterms = filter isMTerm lhs 
 in
  case lhsmterms of
  [] -> [(state,(lhs,neg,cond,rhs,rtype))]
  [M i real off recv mterm ses] -> 
    if (msg_vars mterm)/=[] then []
    else 
    let csl=gencheck fecTheo (constraints++[mkDFromState [mterm] (ik state)],checkineqs fecTheo (ineq++cond)) Map.empty
        constraints' = fst (head csl)
    in if csl==[] then []
       else [(state{cs=constraints',
		    history=(history state)++[M i (UnOp opAgent ( atom_i)) off recv mterm ses]},(lhs,neg,cond,rhs,rtype))]
  _ -> error "multiple message terms"

{- Step 2b: Match negative facts and inequalities -}

match_rest_must :: InterState -> [InterState]
match_rest_must (state,(lhs,[],[],rhs,rtype)) = [(state,(lhs,[],[],rhs,rtype))]
match_rest_must (state,(lhs,neg,cond,rhs,_)) = []

perform_step_must :: Int -> InterState -> [InterState]
perform_step_must sfb (state,(lhs,neg,cond,rhs,rtype)) =
 let stage1 = filter (\x -> (not (isMTerm x)) 
                       && (sff sfb x)) rhs
     stage2 = filter (\x -> (not (isWTerm x))) stage1
 in if stage2==[] then 
            [(state{time=(time state)+1,
	            facts=union stage1 (facts state)},
	     (lhs,neg,cond,rhs,rtype))]
    else []

successors_must :: AlgTheo -> Bool -> Int -> (Int -> Rule) -> State -> [State]
successors_must theo@(fecTheo,_) por sfb rule s = 
  let r = new_var_rename s (rule (getTime s)) in 
             (concatMap ((map fst) . (analz_knowl very_lazy theo por))
              (concatMap (perform_step_must sfb)
	       (concatMap (match_rest_must )
                (concatMap (match_msg_fact_must fecTheo)
                 (concatMap normalize_step
  	          (match_lhs_waiting_term_must fecTheo por (s,r)))))))

type Hornclause = (String,Fact,[Fact])

normalizeHC :: AlgTheo -> Int -> [Hornclause] -> (Int,State) -> (Int,State)
normalizeHC theo sfb _ (0,state) = error "The Hornclauses may have run into a non-termination---giving up." 
normalizeHC theo sfb [] (max,state) = (max,state)
normalizeHC theo sfb (clause:clauses) (max,state) =
  let (max',state1) = normalizeHC theo sfb clauses (max,state)
  in if max'==0 then (0,state1) else
     case tryHC theo sfb clause state1 of
     Nothing -> (max',state1)
     Just state2 -> normalizeHC theo sfb (clause:clauses) ((max'-1),state2)

tryHC :: AlgTheo -> Int -> Hornclause -> State -> Maybe State
tryHC theo sfb (name,head,body) state =   -- if head = ik we should create 2 rules
	case head of
	(M step _ _ _ msg _) -> listToMaybe $ successors False theo False sfb (\ i -> (body,[(BinOpF (Number 1) (msg) (Number step))],[],(M 0 (Number 1) (Number 2) (Number 3) (BinOp opApply (Alby (name)) (vars2Msg (concatMap var_fact body))) (Number 5)):(BinOpF (Number 1) (msg) (Number step)):head:body,False)) state
	otherwise -> let vars = vars2Msg (concatMap var_fact body)
				in if vars == Var 77777777 then 
					if vars2Msg (concatMap var_fact [head]) == Var 77777777 then listToMaybe $ successors False theo False sfb (\ i -> (body,[head],[],(M 0 (Number 1) (Number 2) (Number 3) (BinOp opApply (Alby (name)) (Alby name)) (Number 5)):head:body,False)) state else 
					listToMaybe $ successors False theo False sfb (\ i -> (body,[head],[],(M 0 (Number 1) (Number 2) (Number 3) (BinOp opApply (Alby (name)) (vars2Msg (concatMap var_fact [head]))) (Number 5)):head:body,False)) state 
				else listToMaybe $ successors False theo False sfb (\ i -> (body,[head],[],(M 0 (Number 1) (Number 2) (Number 3) (BinOp opApply (Alby (name)) (vars2Msg (concatMap var_fact body))) (Number 5)):head:body,False)) state

successorsHC :: [Hornclause] -> Bool -> AlgTheo -> Bool -> Int -> (Int -> Rule) -> State -> [State]
successorsHC hcs very_lazy theo@(fecTheo,_) por sfb rule s = --- was: state 
 let r = new_var_rename s (rule (getTime s)) in         
  map  ((\ x -> snd $ normalizeHC theo sfb  hcs (100,x)) . fst)
  (compList [(analz_knowl very_lazy theo por) . (perform_step sfb),
 	     match_rest fecTheo,
	     match_msg_fact very_lazy fecTheo,
	     normalize_step,
	     match_lhs_waiting_term fecTheo por] (s,r))

		 
vars2Msg :: [Var] -> Msg --function that builds a Msg from a list of Variables [Vars].
vars2Msg [] = Var 77777777
vars2Msg (v:vs) = 
	case vs of 
		[] -> (Var v)
		otherwise -> (BinOp opPair (vars2Msg vs) (Var v))
