{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module PrettyUgly where
import Data.Maybe
import Data.Char
import Data.Maybe
import Data.List
import qualified Data.Map as Map
import Constants
import IntsOnly
import Decomposition
import MsgTree
import Remola
import Symbolic
import NewIfLexer
import NewIfParser
import TheoLoad

groundnormalize_fact :: AlgTheo -> Fact -> Fact
groundnormalize_fact algTheo = mapfact (groundnormalizationCF algTheo)


extractRules:: PProt->[PRule]
extractRules []=[]
extractRules (x:xs) = case x of PRuleSec ys -> map snd ys 
				_	    -> extractRules xs


-----------------------------------------------------------------------
-----------------------------------------------------------------------
---    converts PProt from NewIfParser into [Lrules] for Lifp       ---
-----------------------------------------------------------------------
-----------------------------------------------------------------------




getfirstinit :: [PSection] -> PCNState

getfirstinit list = let l= (catMaybes (map (\x -> case x of 
                                                       (PInitSec ys)  -> Just ys
  		   		                       _ -> Nothing) list))
                    in if (length l)/=1 
		    then error ("There are "++(show (length l))++" initial state sections")
                       else 
                        if (length (head l))/=1 
			then error ("There are "++(show (length (head l)))++" initial states")
		        else snd (head (head l))
getfirstrules :: [PSection] -> [((PIdent,PRule),Int)]
getfirstrules list = 
  let list' = catMaybes (map (\x -> case x of 
                                        PRuleSec ys  -> Just ys
 		   		        _ -> Nothing) list)
  in if (length list')/=1 then error ("There are "++(show (length list'))++" rule sections")
     else zip (head list')[1..]

getfirsthc :: [PSection] -> [PHornclause]
getfirsthc ((PHornSec x):_) = x
getfirsthc (_:xs) = getfirsthc xs
getfirsthc [] = []

getfirstgoalz :: [PSection] -> [(PIdent,PRule)]
getfirstgoalz list = 
  let l = catMaybes (map (\x -> case x of 
			(PGoalSec xs) -> Just xs
		        _ -> Nothing) list)
   in if (length l)/=1 then error 
	("There are "++(show (length l))++" goal sections")
      else let goals = head l
	   in if goals==[] then error "No goals declared!"
	      else ---(error . show) 
		     (map goal2rule goals)

dummy_state :: Maybe PIdent -> PFact
dummy_state (Just name) = ("state_dummy",[PConst "6*i", PConst name, PConst "6*i", PConst "0*0", PConst "17*17"])
dummy_state Nothing = ("state_dummy",[PConst "6*i", PConst "6*i", PConst "0*0", PConst "17*17"])

goal2rule :: (PIdent,PCNState) -> (PIdent,PRule)
goal2rule (name,(pnfacts , conditions)) =
 let iknowsfacts = filter (\ fact -> case fact of
				      Plain ("iknows",[m]) -> True
				      Plain ("iknows",ms) -> error (show ms)
				      _ -> False) pnfacts
     statefacts  = filter (\ fact -> case fact of
				      Plain (op,ms) -> isPrefixOf "state" op 
				      _ -> False) pnfacts
     addfacts = (if (length statefacts)==0 then  [Plain (dummy_state Nothing)] else [])
     rhs = 
        (dummy_state (Just name)) : 
        (plains pnfacts)
 in  (name, ((pnfacts++addfacts, conditions), rhs,[]))


plains [] = []
plains ((Plain x):xs) = x:(plains xs)
plains (_:xs) = plains xs


pprintProt:: ExAlgTheo -> Bool -> Bool -> (String->Int,PProt)->(State,[Int -> Rule],[Int],[Int->Rule],Maybe (Int->Rule),[Hornclause])
  --- initial, rules, secret sessions, vars of rules
pprintProt algtheo cd normalize (renaming,sections) = 
  let ( ruleSec) = getfirstrules sections
      ( initSec) = getfirstinit sections
      hcs = getfirsthc sections
      goalz = zip (getfirstgoalz sections) [1..]
      transgoals = pprintRules algtheo False normalize False renaming goalz
      execCR = execCheckRule False algtheo False normalize False renaming goalz
  in 
    (pprintInitialState algtheo initSec, 
     pprintRules algtheo cd normalize False renaming ruleSec, 
     [], 
     transgoals, 
     execCR,
     map (pprinthc algtheo) hcs)

ikfilter ("iknows",_) = True
ikfilter _ = False

varFact:: PFact->[Msg]
varFact (id, terms)= concatMap varTerm terms

varTerm:: PTerm->[Msg]
varTerm (PVar x)= [Var (myread x "varTerm-var")]
varTerm (PCompT "agent" [PVar x]) = [UnOp opAgent (Var (myread x "varterm-Comp"))]
varTerm (PCompT x args)=concatMap varTerm args
varTerm _ = []

pprinthc :: ExAlgTheo -> PHornclause -> Hornclause
pprinthc (_,tab) (name,head,body) = (name,pprintFact tab head, map (pprintFact tab) body)

pprintInitialState :: ExAlgTheo -> PCNState -> State
pprintInitialState (_,tab) cnstate = 
  if (forgetPos (fst cnstate))/=[] then error "Initial state has negative predicates!" else
  let state = forgetNeg (fst cnstate)
      condis = (snd cnstate)
      outcond = map (pprintCond tab) condis 
      (ik0,other) = partition ikfilter state
      ik0' = map (\ ("iknows",[n]) -> pprintTerm tab n) ik0
      other' = pprintState True False tab ((dummy_state Nothing):other)
      (vars)   = (nub (concatMap varFact state))
      initial_ik_mt = listToMT ik0'
      addtionalConstraints = if vars==[] then [] else [mkDFrom (( vars)) initial_ik_mt initial_ik_mt]
  in 
     State
     {porflag=False,
      time=1,
      facts=other',
      ik=mkinitialIKstate ik0',
      popo=[],
      cs=(addtionalConstraints,outcond),
      history=[]}

ism :: Fact -> Bool
ism (M _ _ _ _ _ _) = True
ism _ = False

pprintCond :: Symboltable -> PCondition -> Inequality
pprintCond tab (PEq t1 t2) = error "Positive equality in condition."
pprintCond tab (PLess t1 t2) = error "Cannot handle comparison yet."
pprintCond tab (PNot (PEq t1 t2)) = Negsub [] [(pprintTerm tab t1,pprintTerm tab t2)]

type Ifsub = Map.Map String PTerm

preproConds :: ([PCondition],Ifsub) -> ([PCondition],Ifsub)
preproConds ([],sub) = ([],sub)
preproConds (((PEq (PVar v) t):conds),sub) =
  let sub' = Map.insert v t sub in
  preproConds (map (ifsubcond sub') conds,sub') 
preproConds (x:xs,s) = let (xs',s') = preproConds (xs,s) in (x:xs',s')

ifsubcond :: Ifsub -> PCondition -> PCondition
ifsubcond sub (PEq t1 t2) = PEq (ifsubterm sub t1) (ifsubterm sub t2)
ifsubcond sub (PLess t1 t2) = PLess (ifsubterm sub t1) (ifsubterm sub t2)
ifsubcond sub (PNot t) = PNot (ifsubcond sub t) 

ifsubterm :: Ifsub -> PTerm -> PTerm
ifsubterm sub (PVar p) =
  case Map.lookup p sub of
    Nothing -> PVar p
    Just t  -> t
ifsubterm sub (PCompT t l) = PCompT t (map (ifsubterm sub) l)
ifsubterm _ t = t

ifsubnstate :: Ifsub -> PNState -> PNState
ifsubnstate sub 
  = map (\ fact ->
            case fact of
              Plain f -> Plain (ifsubfact sub f)
              Not   f -> Not (ifsubfact sub f))

ifsubfact :: Ifsub -> PFact -> PFact 
ifsubfact sub (f,arg) = (f,map (ifsubterm sub) arg)

ifsubstate :: Ifsub -> PState -> PState
ifsubstate sub = map (ifsubfact sub) 

hasNoSpecial [] = True
hasNoSpecial ((W _ _ _ _ _ _):xs) = hasNoSpecial xs
hasNoSpecial ((M _ _ _ _ _ _):xs) = hasNoSpecial xs
hasNoSpecial _ = False

cdiffwarn = "The protocol is not safe for the current constraint differentiation implementation. Please use \"-nocd\" to turn constraint differentiation off."


execCheckRule :: Bool -> ExAlgTheo -> Bool -> Bool -> Bool -> (String -> Int) -> [((PIdent,PRule),Int)]
	   -> Maybe (Int -> Rule)
execCheckRule genlabel (algtheo,table) cd normalize abstract rename [] = 
    if genlabel || (not grace) then Nothing else 
    Just 
       (\ number -> 
         let (id,((ls0,aem0),rs0,fresh_stuff)) = (goal2rule ("execCheck",([Plain ("iknows",[PCompT "reach_" [PVar "1172",PConst $ "rule"++(show number)]])],[]))) 
             (aem,ifsub) = preproConds (aem0,Map.empty)
	     ls = ifsubnstate ifsub ls0
 	     label = ("iknows",[PCompT "reach_" [PConst id,PConst $ "rule"++(show number)]])
             rs = ifsubstate ifsub (rs0++(if genlabel then [label] else []))
             rhs  = popro False (pprintState False False table rs)
             lhs  = popro True (pprintState False cd table (forgetNeg ls))
             neg  = pprintState False False table (forgetPos ls)
	     ineq = map (pprintCond table) aem
	     rtype = (not cd) || ((null neg) && (hasNoSpecial lhs)) --- && (not prolific))
             rhss = (lhs,neg,ineq,rhs,rtype)
          in
     	    (\ (lhs',neg',ineq',rhs',rtype) -> 
               let vars = (var_rule (lhs',neg',ineq',rhs',rtype)) \\ (map (rename . fst) fresh_stuff)
	           sub  = makesub (zip vars (map Var [1..]))
	    	   f1 = map (substitute_fact sub)
	    	   f2 = substineqs freeAlg sub in        	   
        	   (f1 lhs', 
         	    f1 neg', 
         	    f2 ineq, 
         	    replace_fresh_stuffi rename fresh_stuff (f1 rhs') number,rtype))
     		    rhss)

pprintRules:: ExAlgTheo -> Bool -> Bool -> Bool -> (String -> Int) -> [((PIdent,PRule),Int)]
	   ->[Int -> Rule]
pprintRules (algtheo,table) cd normalize abstract rename [] = []
pprintRules (algtheo,table)  cd normalize abstract rename rulez@(((id,((ls0,aem0),rs0,fresh_stuff)),number):rules) =
    let (aem,ifsub) = preproConds (aem0,Map.empty)
        ls = ifsubnstate ifsub ls0
 	label = ("iknows",[PCompT "reach_" [PConst id,PConst $ "rule"++(show number)]])
        rs = ifsubstate ifsub (rs0++(if generateLabels then [label] else []))
        prolific = (length $ filter isW rhs) > 1 
        lhs  = popro True (pprintState False cd table (forgetNeg ls))
        neg  = pprintState False False table (forgetPos ls)
	ineq = map (pprintCond table) aem
        rhs  = popro False (pprintState False False table rs)
	rtype = (not cd) || ((null neg) && (hasNoSpecial lhs))
        rhss = if normalize 
               then (normalizeRHS algtheo)
		    (map (rename . fst) fresh_stuff)
                    (lhs,neg,ineq,rhs,rtype)
               else [(lhs,neg,ineq,rhs,rtype)] in
    (map 
     (\ (lhs',neg',ineq',rhs',rtype) -> 
        let vars = (var_rule (lhs',neg',ineq',rhs',rtype)) \\ (map (rename . fst) fresh_stuff)
	    sub  = makesub (zip vars (map Var [1..]))
	    f1 = map (substitute_fact sub)
	    f2 = substineqs freeAlg sub in
        (\ i -> 
        (f1 lhs', 
         f1 neg', 
         f2 ineq, 
         replace_fresh_stuffi rename fresh_stuff (f1 rhs') i,rtype)))
     rhss)++ (pprintRules (algtheo,table) cd normalize abstract rename rules)

normalizeRHS :: AlgTheo -> [Int] -> Rule -> [Rule]
normalizeRHS algtheo@(_,(_,(canceqs,thO))) fresh_stuff (lhs,neg,ineq,rhs,rtype) =
  let subtermslhs = concatMap subtermsF lhs in
  case (partition isMTerm rhs) of 
   ([M i real off recv mterm ses],facts') ->
    map 
    (\ (msg,sub,ineq') -> 
       (map (substitute_fact sub) lhs,
        map (substitute_fact sub) neg,
        ineq',
	(map ((groundnormalize_fact algtheo) . (substitute_fact sub))
          ((M i real off recv msg ses):facts')),rtype))
    (filter 
     (\ (msg,sub,ineq') ->
         (disjoint fresh_stuff 
          (concatMap (\ (x,t) -> x:(msg_vars t)) (Map.toList sub)) )
      )
     (normalizationCF algtheo 0 
      (mterm,Map.empty,
       ineq ++ (concatMap ((noredexAny canceqs) . Var) (msg_vars mterm )) 
       ++ (let lhsirredices = (reduceRedices thO mterm (subtermslhs++(map Var (msg_vars mterm)))) in
           lhsirredices))))
   _ -> [(lhs,neg,ineq,rhs,rtype)]



subtermsF :: Fact -> [Msg]
subtermsF (M _ m1 m2 m3 m4 m5) = concatMap subterms [m1,m2,m3,m4,m5]
subtermsF (W _ m1 m2 m3 m4 m5) = concatMap subterms [m1,m2,m3,m4,m5]
subtermsF (Secret m1 m2)       = concatMap subterms [m1,m2]
subtermsF (Give m1 m2)         = concatMap subterms [m1,m2]
subtermsF (Request m1 m2 m3 m4 b) = concatMap subterms [m1,m2,m3,m4]
subtermsF (Witness m1 m2 m3 m4) = concatMap subterms [m1,m2,m3,m4]
subtermsF (BinOpF m1 m2 m3)    = concatMap subterms [m1,m2,m3]


subterms :: Msg -> [Msg]
subterms m@(UnOp op t) = union [m] (subterms t)
subterms m@(BinOp op t1 t2) = union [m] (union (subterms t1) (subterms t2))
subterms m = [m]


normalizeRule :: Rule -> [Int -> Rule]
normalizeRule (lhs,neg,cond,rhs,rtype) = 
 [ ( \ i -> (lhs,neg,cond,map (substitute_fact (makesub [((-17000),Number i)])) rhs,rtype)) ]


replace_fresh_stuff :: (String -> Int) -> [PSubst] -> [Fact] -> Int 
		    -> [Fact]
replace_fresh_stuff rename ((a,exi):as) rhs i =
   replace_fresh_stuff rename as (rplfstate a (rename a) i rhs) i
replace_fresh_stuff rename [] rhs i = rhs

rplfstate :: PIdent -> Int -> Int -> [Fact] -> [Fact]
rplfstate a v i = map (substitute_fact (Map.insert v (UnOp opNonce (BinOp opNAPair (Atom atom_incomparable a) (Var i))) Map.empty))


replace_fresh_stuffi :: (String -> Int) -> [PSubst] -> [Fact] -> Int 
		    -> [Fact]
replace_fresh_stuffi rename ((a,exi):as) rhs i =
   replace_fresh_stuffi rename as (rplfstatei a (rename a) i rhs) i
replace_fresh_stuffi rename [] rhs i = rhs

rplfstatei :: PIdent -> Int -> Int -> [Fact] -> [Fact]
rplfstatei a v i = map (substitute_fact (Map.insert v (UnOp opNonce (BinOp opNAPair (Atom atom_incomparable a) (Number i))) Map.empty))

tailR [] = error "you promised that wouldn't happen"
tailR x = tail x

ischNumber :: PTerm -> Maybe Int
ischNumber (PConst (c:cs)) = 
  if (isDigit c) 
  then if elem '*' cs then
       let sndpart = tail (dropWhile ((/=) '*') cs) in
       ischNumber (PConst sndpart)
       else Just((myread (c:cs) "isNumber")+0)
  else Nothing
ischNumber (PCompT "nat" [t]) = ischNumber t
ischNumber _ = Nothing                

getses tab (PVar x) = (Var (myread x "getses-var"))
getses tab (PCompT "nat" [PConst n]) = if "sl_" `isPrefixOf` n then Number (myread (drop 3 n) "getses-compt-sl") else  if n=="dummy_nat" then Number 1729 else Number (myread n "getses-compt")
getses tab  (PCompT "nat" [PVar n]) = (Var (myread n "getses-compt-var"))
getses tab  (PConst n) = if n=="dummy_nat" then Number 1729 else Number (myread n "getsess const")
getses tab  (PCompT "s" [t]) = error "Error with s(session)"
getses tab  x = pprintTerm tab x --- error ("Bogus session number: "++(show x))

isW (W _ _ _ _ _ _) = True
isW _ = False

isM (M _ _ _ _ _ _) = True
isM _ = False


compress :: [Fact] -> [Fact]
compress [] = []
compress (m:[]) = [m]
compress ((M a b c d m e):(M _ _ _ _ m' _):ms) = 
  compress ((M a b c d (BinOp opNAPair m m') e):ms)

checkdumym ((W a b c d e f):_) = (show a)++" "++(concatMap show [b,c,d,e,f])
checkdumym _ = ""

popro :: Bool -> [Fact] -> [Fact]
popro isLhs list =
  let (ws,list1) = partition isW list
      (ms',list2) = partition isM list1
      ms = compress ms'
  in if (length ms)==0 then list 
     else if (length ws)/=1 then 
     	    let [(M _ _ _ _ m _)] = ms
	    in (ws++(M 0 (UnOp opAgent (atom_i)) (UnOp opAgent ( atom_i)) (UnOp opAgent ( atom_i))  m (Number 17)):list2)
     else if (length ms)/=1 then error ("Wrong number of M-facts "++(show ms))
     else let [(W step init resp m1 m2 ses)] = ws
	      [(M _ _ _ _ m _)] = ms
	  in ((W step init resp m1 m2 ses):
	      (if isLhs then 
                 M 0 (UnOp opAgent (atom_i)) (UnOp opAgent ( atom_i)) init m ses
               else
		 M 0 init init (UnOp opAgent ( atom_i)) m ses):list2)


pprintFact tab (op,ts) =
          if isPrefixOf "state" op then
	    let role=drop 6 op
                nums = (catMaybes (map ischNumber ts))++[99]
            in 
	       if (length nums)<1 then error ("There are not enough numbers in the state fact "++(show ts))
               else if (length ts < 3) then error ("Too little information in state "++ (show ts))
	       else
               (W (head nums) 
                  (pprintTerm tab (head ts)) 
		  (pprintTerm tab (head (tail ts))) 
	          (pprintTerm tab (PConst role))
		  (foldr (BinOp opNAPair) ( atom_dummy) 
	            (map (pprintTerm tab) (init (tail (tail ts)))))
                   (getses tab (last ts))
                   )
          else if op=="error" then 
                     let msg = case ts of
                                 [PConst m] -> m
                                 _ -> "error" in
                     (BinOpF atom_error (Atom 0 msg) atom_error)
          else if op=="iknows" then 
             let [m1] = ts
             in (M 0 (atom_a) (atom_a) (atom_a) (pprintTerm tab m1) (Atom 0 "0"))
	  else if op=="give" then
	         let (m1:m2:[])=ts
                 in (Give (pprintTerm tab m1) (pprintTerm tab m2))
          else if op=="contains" then
                case ts of 
                 [t1,t2] -> (BinOpF (atom_contains) 
		             (pprintTerm tab t1) (pprintTerm tab t2))
                 _ -> let ts'= map (pprintTerm tab) ts in                          
                          (BinOpF (atom_contains) (head ts')
		           (foldl (\ x y -> BinOp opPair x y)
			          (head (tail ts')) (tail (tail ts'))))
{-
                 let [t1,t2] = ts
                 in (BinOpF (atom_contains) 
		           (pprintTerm tab t1) (pprintTerm tab t2)) 
-}
          else
            if (op=="witness") || (op=="switness") || (op=="wwitness") then 
                 case ts of
		   (m1:m2:m3:m4:[]) -> 
		      (BinOpF atom_witness  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
		   (m1:m2:m3:m4:m5:[]) ->
		      (BinOpF atom_witness  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
            else if (op=="wrequest") then 
                 case ts of
		   (m1:m2:m3:m4:[]) -> 
		      (BinOpF atom_wrequest  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
		   (m1:m2:m3:m4:m5:[]) ->
		      (BinOpF atom_wrequest  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
            else if (op=="request") || (op=="srequest") then 
                 case ts of
		   (m1:m2:m3:m4:[]) -> error "request without session ID"
		   (m1:m2:m3:m4:m5:[]) ->
		      (BinOpF atom_request  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (pprintTerm tab m5)) 
            else if (op=="secret") then
	         case ts of
	         (m1:m2:[]) -> (Secret (pprintTerm tab m1) (pprintTerm tab m2))
                 (m1:m2:m3:[]) -> (Secret (BinOp opNAPair (pprintTerm tab m1) (pprintTerm tab m2)) (pprintTerm tab m3))
                 _ -> error ("Secrecy fact with "++(show (length ts))++" arguments. (Expected: 2 or 3)")
            else BinOpF (Atom atom_incomparable op) (foldr1 (BinOp opPair) (map (pprintTerm tab) ts)) atom_i
	         --- error ("Unknown Fact Symbol "++(show op))


pprintState:: Bool -> Bool -> Symboltable -> PState->[Fact]
pprintState isinit cd tab facts =
  let loop (op,ts) =
          if isPrefixOf "state" op then
	    let role=drop 6 op
                nums = (catMaybes (map ischNumber ts))++[99]
            in 
	       if (length nums)<1 then error ("There are not enough numbers in the state fact "++(show ts))
               else if (length ts < 3) then error ("To few information in state "++ (show ts))
	       else
               (W (head nums) 
                  (pprintTerm tab (head ts)) 
		  (pprintTerm tab (head (tail ts))) 
	          (pprintTerm tab (PConst role))
		  (foldr (BinOp opNAPair) ( atom_dummy) 
	            (map (pprintTerm tab) (init (tail (tail ts)))))
                   (getses tab (last ts))
                   )
          else if op=="error" then 
                     let msg = case ts of
                                 [PConst m] -> m
                                 _ -> "error" in
                     (BinOpF atom_error (Atom 0 msg) atom_error)
          else if op=="iknows" then 
             let [m1] = ts
             in (M 0 (atom_a) (atom_a) (atom_a) (pprintTerm tab m1) (Atom 0 "0"))
	  else if op=="give" then
	         let (m1:m2:[])=ts
                 in (Give (pprintTerm tab m1) (pprintTerm tab m2))
          else if op=="contains" then
                case ts of 
                 [t1,t2] -> (BinOpF (atom_contains) 
		             (pprintTerm tab t1) (pprintTerm tab t2))
                 _ -> let ts'= map (pprintTerm tab) ts in                          
                          (BinOpF (atom_contains) (head ts')
		           (foldl (\ x y -> BinOp opPair x y)
			          (head (tail ts')) (tail (tail ts'))))
{-
                 let [t1,t2] = ts
                 in (BinOpF (atom_contains) 
		           (pprintTerm tab t1) (pprintTerm tab t2)) 
-}
          else
            if (op=="witness") || (op=="switness") || (op=="wwitness") then 
                 case ts of
		   (m1:m2:m3:m4:[]) -> 
		      (BinOpF atom_witness  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
		   (m1:m2:m3:m4:m5:[]) ->
		      (BinOpF atom_witness  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
            else if (op=="wrequest") then 
                 case ts of
		   (m1:m2:m3:m4:[]) -> 
		      (BinOpF atom_wrequest  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
		   (m1:m2:m3:m4:m5:[]) ->
		      (BinOpF atom_wrequest  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (Atom 6 "i")) 
            else if (op=="request") || (op=="srequest") then 
                 case ts of
		   (m1:m2:m3:m4:[]) -> error "request without session ID"
		   (m1:m2:m3:m4:m5:[]) ->
		      (BinOpF atom_request  (BinOp opNAPair (pprintTerm tab m1)
			(BinOp opNAPair (pprintTerm tab m2) (BinOp opNAPair(pprintTerm tab m3) 
			(pprintTerm tab m4)))) (pprintTerm tab m5)) 
            else if (op=="secret") then
	         case ts of
	         (m1:m2:[]) -> (Secret (pprintTerm tab m1) (pprintTerm tab m2))
                 (m1:m2:m3:[]) -> (Secret (BinOp opNAPair (pprintTerm tab m1) (pprintTerm tab m2)) (pprintTerm tab m3))
                 _ -> error ("Secrecy fact with "++(show (length ts))++" arguments. (Expected: 2 or 3)")
            else BinOpF (Atom atom_incomparable op) (foldr1 (BinOp opPair) (map (pprintTerm tab) ts)) atom_i
	         --- error ("Unknown Fact Symbol "++(show op))
      newstate = map loop facts
      replacesessions 0 0 ((W s a b c d (Number ses)):facts) = 
	  (W s a b c d (Number ses)):(replacesessions ses (ses+1) facts)
      replacesessions 0 0 ((W s a b c d ses):facts) = 
          (W s a b c d ses):(replacesessions 0 0 facts)
      replacesessions 0 0 (fact:facts) =
          fact:(replacesessions 0 0 facts)
      replacesessions n m ((W s a b c d (Number ses)):facts) =
          if (m==ses) then  
            (W s a b c d (Number n)):(replacesessions n (m+1) facts)
	  else
	    (W s a b c d (Number ses)):(replacesessions ses (ses+1) facts)
      replacesessions n m ((W s a b c d ses):facts) =
	error ("replacesessions: "++(show ses))
      replacesessions n m (fact:facts) =
        fact:(replacesessions n m facts)
      replacesessions n m [] = []
  in 
  resession newstate 
	
getroles :: [Fact] -> [(Msg,Int)]
getroles [] = []
getroles ((W _ _ _ (Atom _ "dummy") _ ( sid)):facts) =
  getroles facts
getroles ((W _ _ _ c _ (Number sid)):facts) =
  (c,sid):(getroles facts)
getroles (_:facts) = getroles facts

getdist [] _ = 0
getdist ((r,s):xs) seen =
  let loop [] = 0
      loop ((r',s'):zs) = if r==r' then s-s' else loop zs
      dist = loop seen
  in if dist==0 then getdist xs ((r,s):seen)
     else dist

resession state =
 let list = getroles state
     d = getdist list []
     ((_,offset):_) = list
     renaming x = if d==0 then 1 
     	      	  else ((x-offset) `div` d)+1
 in 
 if list==[] then state else
 if []/=
 (filter (\ x -> x `mod` d /=0)
  [ s1-s2 | (r1,s1) <- list, (r2,s2) <- list, r1==r2, s1>s2 ])
 then if grace then (renamer renaming state)
      else error "Inconsistent session IDs"   
 else 
 (renamer renaming state)	

renamer ren [] = []
renamer ren (f@(W _ _ _ (Atom _ "dummy") _ ( sid)):facts) =
  f:(renamer ren facts)
renamer ren ((W s a b c d (Number sid)):facts) =
  (W s a b c d (Number (ren sid))):(renamer ren facts)
renamer ren (f:facts)  =
  f:(renamer ren facts)



pprintSession:: (Int->Int)->PTerm->Msg
pprintSession f (PCompT tp [PConst x]) = error "Aber Hallo!" --- Session (f (myread x))		--- faellt weg, wenn nats rausfliegen!
pprintSession f _ = Number 100


myread a str =
  let (a',b) = span isDigit a
  in if a'==[] then error ("myread: "++a++" "++str)
     else read a' 

pprintTerm :: Symboltable -> PTerm->Msg
pprintTerm tab (PConst a) = 
  let (i,s) = span isDigit a
  in if i==[] then Atom atom_incomparable (if (head s)=='*' then error "!!!" else s) 
     else (Atom (read i) (if s==[] 
     	  	      	  then error ("There should not be a numeric here: "++(show a)) 
			  else (tail s)))
pprintTerm tab (PVar a) = Var (myread a "pprintTerm") 
pprintTerm tab (PCompT a args)
  | a=="message" =  (pprintTerm tab (head args))
  | a=="protocol_id" = (pprintTerm tab (head args))
  | length args == 1 =
      case Map.lookup a tab of
       Nothing -> 
         if a=="hash_func" then 
	    UnOp (stringToOp "function") (pprintTerm tab (head args))
         else
	    UnOp (stringToOp a) (pprintTerm tab (head args))
       Just (binop,intrudible,arityReal,arityInternal) ->
         if arityInternal==1 then
            UnOp binop (pprintTerm tab (head args))
         else 
            BinOp binop (pprintTerm tab (head args))
                        (pprintTerm tab (head args))
  | length args == 2 = 
     BinOp (stringToOp a) 
     (pprintTerm tab (head args)) (pprintTerm tab (head (tail args)))
  | length args < 2 = 
      error $ "List of args: "++a
  | otherwise = 
     BinOp (stringToOp a) 
     (pprintTerm tab (head args)) (pprintTermList tab (tail args))

pprintTermList tab [] = error "Empty List at pprint"
pprintTermList tab [x] = pprintTerm tab x
pprintTermList tab (x:xs) = BinOp opPair (pprintTerm tab x) (pprintTermList tab xs)

prune:: [PTerm]->[PTerm]
prune [x]= [PConst "Etc"]
prune (a@(PCompT x args):xs)| x=="public_key" = prune xs
			    | x=="nonce" && args== [PConst "ni"]  = prune xs
			    | x=="nat" = prune xs
			    | otherwise = a: prune xs


									
forgetNeg::PNState->PState
forgetNeg []=[]
forgetNeg ((Not x):xs) = forgetNeg xs
forgetNeg ((Plain x):xs) = (x:(forgetNeg xs))

forgetPos :: PNState -> PState
forgetPos [] = []
forgetPos ((Not x):xs) = x:(forgetPos xs)
forgetPos ((Plain x):xs) = forgetPos xs

			
steps :: PProt -> [PTerm]
steps [] = []
steps ((PTypeSec x):ss)=steps ss
steps ((PInitSec x):ss)=nub $ (concatMap (stepCNState . snd) x)  ++(steps ss)
steps ((PRuleSec x):ss)=nub $ (concatMap (stepRule .snd) x)  ++(steps ss)
steps ((PGoalSec x):ss)=nub $ (concatMap (stepCNState .snd) x)  ++(steps ss)
steps ((PHornSec x):ss)=nub $ (concatMap stepHorn x)++(steps ss)

stepHorn (name,head,body) = concatMap stepFact (head:body)

stepRule::PRule->[PTerm]
stepRule (ls,rs,x)=(stepCNState ls) ++ (stepState rs)

stepCNState::PCNState->[PTerm]
stepCNState (nstate, conds)=(concatMap stepNFact nstate)

stepState::PState->[PTerm]
stepState facts=concatMap stepFact facts

stepNFact:: PNFact->[PTerm]
stepNFact (Plain fact) = stepFact fact
stepNFact (Not fact) = stepFact fact

stepFact:: PFact->[PTerm]
stepFact (id, terms)= if "state" `isPrefixOf` id then [last terms] else []


idProt::PProt -> [PIdent]
idProt []=[]
idProt ((PTypeSec x):ss)=idProt ss
idProt ((PInitSec x):ss)=(concatMap (idCNState.snd) x)  ++(idProt ss)
idProt ((PRuleSec x):ss)=(concatMap (idRule .snd) x)  ++(idProt ss)
idProt ((PGoalSec x):ss)=(concatMap (idCNState .snd) x)  ++(idProt ss)
idProt ((PHornSec x):ss)=(concatMap idHorn x)++(idProt ss)

idHorn (name,head,body) = concatMap idFact (head:body)

idRule::PRule->[PIdent]
idRule (ls,rs,x)=(idCNState ls) ++ (idState rs)

idCNState::PCNState->[PIdent]
idCNState (nstate, conds)=(concatMap idNFact nstate) ++ (concatMap idCond conds)

idCond (PEq a b) = concatMap idTerm [a,b]
idCond (PLess a b) = concatMap idTerm [a,b]
idCond (PNot cond) = idCond cond

idState::PState->[PIdent]
idState facts=concatMap idFact facts

idNFact:: PNFact->[PIdent]
idNFact (Plain fact) = idFact fact
idNFact (Not fact) = idFact fact

idFact:: PFact->[PIdent]
idFact (id, terms)= concatMap idTerm terms

idTerm:: PTerm->[PIdent]
idTerm (PConst x) = [x]
idTerm (PVar x)=[x]
idTerm (PCompT x args)=concatMap idTerm args




-----------------------------------------------------------------------
-----------------------------------------------------------------------
---	modifies PProt according to our needs:                      ---
---								    ---
---  - replaces variables by their indices			    ---    
---  - throws away Conditions in CNState			    ---
---  - throws away information on newly introduced variables	    ---
---								    ---
--- modProt is working entirely on the PProt-Structures		    ---
---								    ---
-----------------------------------------------------------------------
-----------------------------------------------------------------------



modProt:: PProt->(String->Int,PProt)
modProt prot=
 let  f = basenamecheck (getnaming basename (nub (idProt prot)))
      f' = basenamecheck' (getnaming2 basename (nub (idProt prot)))
      basenamecheck f v = 
         let v' = renaming_base v 
         in if (v'=="0") then f v else v'
      basenamecheck' f v = 
         let v' = renaming_base v
         in if (v'=="0") then f v else myread v' "basenamecheck"
      getnaming i [] var = "0"				   
      getnaming i (x:xs) var = if (var==x) then show i	    
                               else getnaming (i+1) xs var  
      getnaming2 i [] var = 0			   
      getnaming2 i (x:xs) var = if (var==x) then i	    
                                else getnaming2 (i+1) xs var  
      stepping = foldr (\ (term,step) f -> \ x-> if x==term then step else f x)
      	       	       (\ x -> error $ "step number not recognized: "++(show x)++"\nKnown:"++(show (steps prot))) 
		       (zip (steps prot) [1..])
 in (f',modSecs stepping f prot)

modSecs::(PTerm -> Int) -> (PIdent->String)-> PProt->PProt
modSecs stepping f []=[]
modSecs stepping f (x:xs) = case x of 
		   	     PRuleSec ys -> (PRuleSec  (map ( \ (a,b)-> (a,(modRule stepping f) b)) ys)):(modSecs stepping f xs)
			     PInitSec ys -> (PInitSec  (map ( \ (a,b)-> (a,(modCNState stepping f) b)) ys)):(modSecs stepping f xs)
                             PGoalSec ys -> (PGoalSec  (map (\ (a,b) -> (a,(modCNState stepping f) b)) ys)):(modSecs stepping f xs)
                             PHornSec hcs -> (PHornSec  $ map (\ (name,head,body) -> (name,modFact stepping f head, map (modFact stepping f) body)) hcs):(modSecs stepping f xs)
			     --- _ -> modSecs stepping f xs
			     PTypeSec ys -> modSecs stepping f xs
			     _ -> error $ "Unknown section: " ++ (show x)

modRule:: (PTerm -> Int) -> (PIdent->String) -> PRule -> PRule
modRule stepping f (ls,rs,x)=(modCNState stepping f ls,modState stepping f rs,x)


modCNState::(PTerm -> Int) -> (PIdent->String)->PCNState->PCNState
modCNState stepping f (nstat,conds)=(map (modNFact stepping f) nstat, map (modCond f) conds)


modCond :: (PIdent -> String) -> PCondition -> PCondition
modCond f (PEq t1 t2)   = PEq (modTerm f t1) (modTerm f t2)
modCond f (PLess t1 t2) = PLess(modTerm f t1)(modTerm f t2)
modCond f (PNot c)      = PNot (modCond f c)

modState:: (PTerm -> Int) -> (PIdent->String)->PState->PState
modState stepping f stat= map (modFact stepping f) stat

modNFact:: (PTerm -> Int) -> (PIdent->String)->PNFact->PNFact
modNFact stepping f (Plain fac)=Plain (modFact stepping f fac)
modNFact stepping f (Not fac)=Not (modFact stepping f fac)

modFact::  (PTerm -> Int) -> (PIdent->String)->PFact->PFact
modFact stepping f (id,terms) = 
 if isPrefixOf "state"  id then 
     let name = head terms
	 sess = head $ tail terms
     	 step = head . tail . tail $ terms
	 othr = tail . tail . tail $ terms
     in    (id, (map (modTerm f) (name:step:othr))++[(modTerm0 f sess)])
 else (id, map (modTerm f) terms)


--- preliminary version: this one throws out the "fresh"-operator!
---			 replaces KA, KB by a "table" construction involving A,B	
modTerm ::(PIdent->String)->PTerm->PTerm
modTerm f (PConst a) = if (f a)=="" then error $ "modTerm "++(show a) else (PConst ((f a)++"*"++a))
modTerm f (PVar a) = PVar (f a)
modTerm f (PCompT a args) = PCompT a (map (modTerm f) args)
	
modTerm0 ::(PIdent->String)->PTerm->PTerm
modTerm0 f (PConst a) = (PConst ( a))
modTerm0 f (PVar a) = PVar (f a) 
modTerm0 f (PCompT a args) = PCompT a (map (modTerm0 f) args)
	 





-----------------------------------------------------------------------
-----------------------------------------------------------------------
--- Drops the Type-Section from the protocol and		    ---
--- applies unary Type-operators to every specified		    ---
--- element in the parse tree					    ---
-----------------------------------------------------------------------
-----------------------------------------------------------------------


typeProt:: PProt -> PProt
typeProt prot = let tmap = getAtomicTypes prot 
		in let iter [] = []	       --- iter :: PProt->PProt
		       iter ((PTypeSec decs):secs)= iter secs
		       iter ((PRuleSec rules):secs)= ((PRuleSec (map (\ (x,y)-> (x, typeRule tmap y)) rules)):(iter secs))
		       iter ((PInitSec stat):secs)= ((PInitSec (map (\ (x,y)-> (x, typeCNState tmap y)) stat)):(iter secs))
	 	       iter ((PGoalSec stat):secs)= ((PGoalSec (map (\ (x,y)-> (x, typeCNState tmap y)) stat)):(iter secs))
		       iter ((PHornSec horns):secs) = ((PHornSec (map (\ (name,head,body) -> (name,typeFact tmap head, map (typeFact tmap) body)) horns)):(iter secs))
		   in iter prot


typeRule::[(PIdent,PIdent)]->PRule->PRule
typeRule ls (l,r,x)= (typeCNState ls l, typeState ls r, x)

typeState::[(PIdent,PIdent)]->PState->PState
typeState ls facts=map (typeFact ls) facts


--- until now typing is NOT applied to Conditions, as we
--- currently throw them away anyway!

typeCNState::[(PIdent,PIdent)]->PCNState->PCNState
typeCNState ls (nstate,cond)= (map (typeNFact ls) nstate, cond)

typeFact::[(PIdent,PIdent)]->PFact->PFact
typeFact ls (id,trms)=(id, map (typeTerm ls) trms)

typeNFact::[(PIdent,PIdent)]->PNFact->PNFact
typeNFact ls (Plain fact)=Plain (typeFact ls fact)
typeNFact ls (Not fact)=Not (typeFact ls fact)

--- applies unary type operators to PConst and PVar-terms
--- now typing is also applied to composed terms
typeTerm:: [(PIdent,PIdent)]-> PTerm->PTerm 
---typeTerm ls (PCompT name args) = PCompT name (map (typeTerm ls) args)

typeTerm ls (PCompT name args) = 
	 let iter [] x = PCompT x (map (typeTerm ls) args)     --- iter::[(Pid,Pid)]->Pid->PTerm
	     iter ((n,t):nts) x = if n==x then PCompT t [PCompT x (map (typeTerm ls) args)] else iter nts x
	 in iter ls name

typeTerm ls (PConst name) = let iter [] x = PConst x     --- iter::[(Pid,Pid)]->Pid->PTerm
				iter ((n,t):nts) x = if n==x then PCompT t [PConst x] else iter nts x
			    in iter ls name
typeTerm ls (PVar name) =   let iter [] x = PVar x     --- iter::[(Pid,Pid)]->Pid->PTerm
				iter ((n,t):nts) x = if n==x then PCompT t [PVar x] else iter nts x
			    in iter ls name


--- extracts [(name, type)] - pairs for atomic type declarations 
--- from protocol-parse-tree

getAtomicTypes::PProt-> [(PIdent,PIdent)]
getAtomicTypes []=[]
getAtomicTypes ((PTypeSec []):ss) = getAtomicTypes ss
getAtomicTypes ((PTypeSec decs):ss) = 
	    let iter [] ls = [] 		--- iter::[PTypeDecl] -> [(PIdent,PIdent)] ->[(PIdent,PIdent)]
		iter ((Decl d ids):ds) ls = case d of 
			    Atomic tname  -> (map (\ x-> (x, tname)) ids ) ++ iter ds ls 
			    _ -> iter ds ls
	    in iter decs []
getAtomicTypes (s:ss)=getAtomicTypes ss




-----------------------------------------------------------------------
-----------------------------------------------------------------------
---  Performs substitutions on the newly introduces variables       ---
-----------------------------------------------------------------------
-----------------------------------------------------------------------


substProt:: PProt -> PProt
substProt [] = []	      
substProt ((PRuleSec rules):secs)= ((PRuleSec (map (\ (x,y)-> (x, substRule y)) rules)):(substProt secs))
substProt (a:secs)= a: substProt secs


substRule::PRule->PRule
substRule (l,r,[])= (l,r,[])
substRule (l,r,x)= (l, substState x r, x)   --- replace only right hand side of rule

substState::[PSubst]->PState->PState
substState s facts=map (substFact s) facts


substFact::[PSubst]->PFact->PFact
substFact s (id,trms)=(id, map (substTerm s) trms)

substTerm :: [PSubst] -> PTerm -> PTerm
substTerm s (PVar w) = substVar s w 
substTerm s (PCompT f args) = PCompT f (map (substTerm s) args)
substTerm _ const = const


substVar:: [PSubst] -> PIdent -> PTerm
substVar [] y = PVar y
substVar ((x,Just t):ss) y | x==y    = t                    
                            | otherwise= substVar ss y
substVar ((x, Nothing):ss) y | x==y = PVar y
			      | otherwise = substVar ss y



---------------------------------------------------------

data Typing = AsGiven | Untyped | StronglyTyped deriving Eq


ifparser :: ExAlgTheo -> Typing -> Bool -> Bool -> String ->  (State, [Int -> Rule], [Int],[Int -> Rule],Maybe (Int -> Rule),[Hornclause])
ifparser algtheo typing cd normalize inputstr =
   let tokens1 = alexScanTokens inputstr
       typeTrafo = if typing==AsGiven then typeProt else (\x->x)
   in 
     ((pprintProt algtheo cd normalize) . modProt . typeTrafo . parser) tokens1

