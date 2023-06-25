{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright Nicklas Bo Jensen 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module FPTranslator where
import Ast
import Msg
import MsgPat
import LMsg
import Data.List
import Data.Maybe
import Translator
import AnBOnP
---import qualified StateMonad
import qualified Data.Set as Set

data HornRep = HR { initialH  :: [Fact],
                    absrulesH :: [Rule],
                    rulesH    :: [([Fact],[Fact])],
                    typesH    :: Types }
                 deriving (Eq,Show)

encodeTypes :: Types -> Substitution -> Substitution 
encodeTypes [] sub = sub
encodeTypes ((Untyped,_):ts) sub = encodeTypes ts sub
encodeTypes ((Agent _ _,ids):ts) sub = 
 encodeTypes ts 
 (foldr 
  (\ ident sub -> 
      addSub sub ident (Comp Apply 
      	     	        [Atom "typeAgent", 
			 Atom (if (isVariable ident) ||  ident=="i" || ident=="b" then ident else "a")]))
  sub ids)
encodeTypes ((typE,ids):ts) sub = 
  encodeTypes ts 
  (typeAll sub ids
   (case typE of
    Agent _ _  -> "typeAgent"
    Number     -> "typeNumber"
    PublicKey  -> "typePK"
    SymmetricKey -> "typeSK"
    Function   -> "typeFun"
    Purpose -> "typePurpose"
    Untyped    -> error "Unsupported type"))
 where typeAll sub ids typE = 
          foldr (\ ident sub -> 
                     addSub sub ident (Comp Apply [Atom typE, Atom ident])) 
          sub ids

skencode :: [Fact] -> [Rule] -> ([Fact],[Rule])
skencode init rules = 
  (map skencf init, 
   map (\ (l,eq,v,r) -> 
          (map skencf l,
	   map (\ (x,y) -> (skencm x, skencm y)) eq,
	   v, 
	   map skencf r)) rules)

skencf (State r msgsp) = State r (map (\ (x,y) -> (skencm x, skencm y)) msgsp)
skencf (FPState r msgs) = FPState r (map skencm msgs)
skencf (Iknows m) = Iknows (skencm m)
skencf (Fact f ms) = 
    let ms'=map skencm ms
    in if f=="wrequest" then Fact "request" (ms'++[(Atom "SID")])
       else Fact f ms'

--- Fact (if f=="wrequest" then "request" else f) (map skencm ms)

skencm (Atom m) = Atom m
skencm (m@(Comp Apply [Atom "typeSK",xs])) = m
skencm (m@(Comp Apply [Atom "sk",xs])) = Comp Apply [Atom "typeSK", m]
skencm (Comp f xs) = Comp f (map skencm xs)


typer :: Types -> [Fact] -> [Rule] -> ([Fact],[Rule])
typer types init rules =
   (map (subfact ts) init, 
    map (\ (l,eq,v,r) -> 
    	   (map (subfact ts) l, 
	    map (\ (x,y) -> (ts x,ts y)) eq,
	    v, 
	    map (subfact ts) r)) rules)
 where ts = encodeTypes types (\x->x)

typeit :: Types -> Msg -> Msg
typeit types = encodeTypes types (\x -> x) 


mksub :: [(Ident,Msg)] -> Substitution
mksub = foldl (\ sub (v,t) -> addSub sub v t) (\x -> x)

decpair (Iknows (Comp Cat xs)) = concatMap decpair [Iknows m | m <- xs]
decpair m = [m]

decpair' :: [Fact] -> ([Fact],[Fact])
decpair' fs =
 let ik = map (\ (Iknows x) -> x) (filter isIknows fs)
     nonik = filter (not . isIknows) fs
     (decs,pairs) = decpair'' ik [] []
 in (nub (nonik++(map Iknows decs)),nub (map Iknows pairs))

decpair'' ((Comp Cat xs):ms) decs pairs = 
  decpair'' (xs++ms) decs ((Comp Cat xs):pairs)
decpair'' (m:ms) decs pairs = decpair'' ms (m:decs) pairs 
decpair'' [] decs pairs = (decs,pairs)



isICat (Iknows (Comp Cat _)) = True
isICat _ = False

fp :: [[Fact]->[Fact]] -> [Fact] -> [Fact]
fp rules ik = 
  let nik1 = nub ( (concatMap (\ r -> r ik) rules))
      (nik,dapairs) = decpair' nik1
      diff = setminus nik ik
      ik' = diff++ik
      attacks = filterattacks diff
  in if (diff==[]) 
     then dapairs
     else dapairs++diff++(fp rules ik')


traceback :: [[Fact] -> [(Fact,[Fact])]] -> [Fact] -> [Fact] -> Fact -> String -> String
traceback rulesh ik0 ik fact str = 
  let nik11 =( (concatMap (\ r -> r ik) rulesh))
      nik1 = nub (map fst nik11)
      (nik,dapairs) = decpair' nik1
      diff = setminus nik ik
      ik' = diff++ik
      attacks = filterattacks diff
      (mi::Fact) = fst(head(tail nik11))
  in if ( fact `elem` ik0) then (str++"which is given\n") else
     if ( fact `elem` diff) 
     then 
       let derivations = filter (\x -> modPair fact (fst x)) nik11
       	   newgoals = if derivations==[] 
	   	      then error ("Traceback error\n"++
		      	   	  (ppFact Pretty fact)++"\n"++
				  (ppFact Pretty mi)++"\n"++
				  (show (modPair fact mi))++"\n"++
				  (ppXList show  "\n" nik11))
		      else snd (head derivations)
       in concatMap (\ f -> str++(ppFact Pretty f)++"\n"++
       	      	      (traceback rulesh ik0 ik0 f ('-':str))) newgoals
     else traceback rulesh ik0 ik' fact str


elemBy eq e = any (eq e)

modPair (Iknows m) (Iknows m') = modPairMsg m m'
modPair f f' = f==f'
modPairMsg m (Comp Cat msgs) = any (modPairMsg m) msgs
modPairMsg m m' = m==m'

{- new version of the fixedpoint/rule application to account for history -}

rule2fact2facth :: Rule -> [Fact] -> [(Fact,[Fact])]
rule2fact2facth (l,eq,[],r) state = 
  concat 
  [map (\f -> ((subfact sub) f,facts)) r 
  | (sub,facts) <- matchRh (\x->x) l state [],
    all ineqCheck (map (subeq sub) eq) 
  ]

ineqCheck :: (Msg,Msg) -> Bool
ineqCheck (a,b) = null (match0 [(b,a)]  (\x->x))

subeq :: (Msg->Msg) -> (Msg,Msg) -> (Msg,Msg)
subeq sub (a,b) = (sub a,sub b)

matchRh :: Substitution -> [Fact] -> [Fact] -> [Fact] -> [(Substitution,[Fact])]
matchRh sub [] state substate = [(sub,substate)]
matchRh sub (r:rs) state substate = 
  concat [matchRh sub' (map (subfact sub') rs) (map (subfact sub') state) (fact:substate) | (sub',fact) <- matchAnyFh r state sub ]

matchAnyFh :: Fact -> [Fact] -> Substitution -> [(Substitution,Fact)]
matchAnyFh fact [] sub = []
matchAnyFh fact (f:fs) sub = 
  (map (\ s -> (s,f)) (matchF fact f sub))++(matchAnyFh fact fs sub)

-------------------------------------------

rule2fact2fact :: Rule -> [Fact] -> [Fact]
rule2fact2fact (l,eq,[],r) state = 
  concat 
  [map (subfact sub) r 
  | sub <- matchR (\x->x) l state, 
    all ineqCheck (map (subeq sub) eq) 
  ]

matchR :: Substitution -> [Fact] -> [Fact] -> [Substitution]
matchR sub [] state = [sub]
matchR sub (r:rs) state = 
  concat [matchR sub' (map (subfact sub') rs) (map (subfact sub') state) | sub' <- matchAnyF r state sub ]

matchAnyF :: Fact -> [Fact] -> Substitution -> [Substitution]
matchAnyF fact [] sub = []
matchAnyF fact (f:fs) sub = 
  (matchF fact f sub)++(matchAnyF fact fs sub)
  
setminus ik1 ik2 = foldr delete ik1 ik2 

matchF :: Fact -> Fact -> Substitution -> [Substitution]

matchF (FPState m msgs) (FPState m' msgs') sub = 
  if (length msgs) /= (length msgs') then [] 
  else match0 (zip ( msgs) ( msgs')) sub
matchF (Iknows m) (Iknows m') sub = 
  match0 [(m,m')] sub
matchF (Fact id msgs) (Fact id' msgs') sub =
  if id /= id' || (length msgs /= length msgs') then [] 
  else match0 (zip msgs msgs') sub
matchF (State _ _) _ _ = error "State Fact in FP!"
matchF _ (State _ _) _ = error "State Fact in FP!"
matchF _ _ _ = []


getMsgs' :: Fact -> Msg
getMsgs' (Iknows msg) = msg
getMsgs' f = error ("getMsgs': " ++(show f))


li :: Rule -> [Rule]
li (l,eq,[],r) = 
 let ik = map getMsgs' (filter isIknows l)
     l' = (filter (not . isIknows) l) 
 in [(l'++(map Iknows ik'),eq,[],r) | ik' <- nub (dy ik), (filter isCat ik')==[] ]

dy :: [Msg] -> [[Msg]]
dy [] = [[]]
dy (x:xs) = [ nub (x'++xs') | x'<-dy0 x, xs' <- dy xs] 

dy0 m = [m]:(decdy0 m)

decdy0 :: Msg -> [[Msg]]
decdy0 (Atom _) = []
decdy0 (Comp Inv _) = []
decdy0 (Comp Apply xs) = if isAtype (head xs) then [] else dy xs
decdy0 (Comp f xs) = dy xs

lazyintruder :: Msg -> [Msg] -> Substitution -> [Substitution]
--- given a symbolic message t and a ground intruder knowledge M 
--- (and an initial substitution \sigma0 that has already been performed),
--- compute a complete set of \sigma such that t \sigma \in dy(M)
lazyintruder t ik sub0 =
  (concatMap (\ x -> match0 [(t,x)] sub0) ik)++
  (case t of
     (Atom _) -> []
     (Comp Inv _) -> []
     (Comp Apply xs) -> 
       if isAtype (head xs) then [] else 
       foldr (\ t subs -> 
       	     	concatMap (\ sub -> lazyintruder (sub t) ik sub) subs) 
       [sub0] xs
     (Comp f xs) -> 
       foldr (\ t subs  -> 
       	     	concatMap (\ sub -> lazyintruder (sub t) ik sub) subs) 
       [sub0] xs)


toFPStateR True  (l,[],v,r) = (map toFPState l,[],v,map toFPState r)
toFPStateR False (l,[],v,r) =
 let getstate ((State r m):_) = Just (State r m)
     getstate (_:ms) = getstate ms
     getstate [] = Nothing
 in case getstate r of
    Nothing -> toFPStateR True (l,[],v,r)
    Just (State _ m) -> 
       toFPStateR True (subrule (xscryptsub (head (match0 (map ( \ (x,y)->(y,x)) m) ( \x -> x) ))) (l,[],v,r))
 




xscryptsub :: Substitution ->  Substitution
xscryptsub sigma = 
  foldMsg (\ y -> if isJust (stripPrefix "XScrypt" y) 
  	       	  then Atom "i" else sigma (Atom y))
	  (\ f xs -> Comp f xs)

toFPState (State r m) = FPState r (map snd m)
toFPState (FPState _ _) = error "FPstate present in given description!"
toFPState f = f

hornFP0 crefiners verify hr abstractlist opts header = 
  let --- eliminate fresh variables
      silent s = if (outt opts)/=Isa then "" else s
      insilent s = if (outt ( opts))/=Isa then s else ""
      absrule (l,[],freshv,r) = 
        (l,[],[], map (subfact (mksub (filter (\ (x,y) -> x `elem` freshv) 
	       	   	    	    abstractlist))) r)
      ainit = initialH hr
      (ainit0,rules0) = skencode ainit 
      		      	(concatMap genuineAbsRule (map  absrule 
			      (absrulesH hr)))	
      types = typesH hr
      (tinit,rules1) = typer (types0++types) ainit0 rules0
      --- lazy intruder construction statically
      rules0'= intruderAna++(attackRules abstractlist)++  
      	       --- rules closed under intruder construction
      	       (concatMap li rules1)
      irules = take (iterateFP opts) rules0'
      rules' = if (outt opts)==FPI 
      	       then if (length rules0')<(iterateFP opts) 
		    then error "Iteration finished"
		    else irules
	       else rules0'
      rules''= map rule2fact2fact rules'
      rulesh'' =map rule2fact2facth rules'
      display = Isa
      myfilter = \x-> True -- isIknows
      fixedpoint =  (fp rules'' tinit)
      attacks = filterattacks fixedpoint
      attacksStr = if null attacks 
      		   then insilent "SAFE" 
		   else 
      		   "\n(*** Attacks: *****************)\n"++
    		   (ppXList (ppFact Pretty) "\n\n" attacks)++
		   ("\n\n\nDerivation of first attack:\n")++
		   (ppFact Pretty (head attacks))++"\n"++
		   (traceback rulesh'' tinit tinit (head attacks) "-")
      mainstr =((silent 
      	      	(header++
		 "section rules:\n"++
     	         (ppRuleList display rules')++
		 "\nsection initial state:\n"++
    		 (ppInit "init" display tinit)++
    		 "\nsection fixedpoint:\n"++
    		 (ppFP "fp" display (filter myfilter fixedpoint)) ++
    		 "\nsection abstraction:\n"++
    		 (ppXList (\ (n,t) -> n++"->"++(ppMsg Isa t)) ";\n"  abstractlist)++"\n"))++
    		 attacksStr++
    		"\n"
   		)
  in
     if verify && (not (null attacks)) 
     then let refiners0 = map (drop 3) (filter (isPrefixOf "abs") (identsFL attacks)) 
	      refiners = nub (refiners0++crefiners)
          in   
	  if (length refiners)==(length crefiners) 
	  then "**************** AUTO REFINE FAILED. *********************"++attacksStr
	  else
     	  "(**** REFINING ABSTRACTION: "++(show refiners)++" *****)\n"
	  ++ (hornFP (refiners++crefiners) verify opts hr)
     else mainstr


getpurposes (l,_,_,r) = concatMap getpurpfact (l++r)

getpurpfact (Fact f (_:_:(Atom purpose):_)) 
  | f=="request" || f=="witness"  = [purpose]
  | f=="wrequest" = error "wrequest not understood here"
  | otherwise = []
getpurpfact _ = []

hornFP :: [Ident] -> Bool -> AnBOptsAndPars -> HornRep -> String
hornFP refiners verify opts hr =
   hornFP0 refiners verify hr{typesH=types} abs opts
   ("Protocol: "++protn++
   	    "\nTypes:\n"++(show ((Purpose,purposes):types))++"\n")
  where protn = "N.N."
        types = (Purpose,purposes):(typesH hr)
  	purposes = nub (concatMap getpurposes (absrulesH hr))
        abbi = if null (rulesH hr) 
	       then concatMap (newabsrule (makerefine refiners (absrulesH hr)) types)
	            	      (absrulesH hr)
	       else []
        abs =  (map (\ (x,y) -> (x,dotypeabs x y)) abbi)
	dotypeabs x y = case (typeit types (Atom x),typeit types y) of 
	       	        (Comp Apply [Atom type1,_],Comp Apply [Atom type2,_]) 
			  -> if (isAtype (Atom type1))
			     then
			      if  (isAtype (Atom type2)) then 
			       if type1==type2 then (checkEQtypes y)
			       else error ("Ill-typed abstraction: "++
			     	           (show x)++" vs. "++(show y)++":"++(show type1)++" vs. "++(show type2))
			      else
			      (Comp Apply [Atom type1,checkEQtypes y])
                             else
			      error ("Untypable abstraction: "++(show x)++"->"++(show y))
			(Comp Apply [Atom type1,_],_) 
			  ->  (Comp Apply [Atom type1,checkEQtypes y])
			_ -> error ("Untypable abstraction: "++(show x)++"\n Details:"++(show ((typeit types (Atom x),typeit types y)))++"\n Tpyes: "++(show types))
        checkEQtypes (Atom x) = Atom x
	checkEQtypes (Comp Apply ((Atom "equals"):x)) =
	   case x of
	   [(Comp Cat [Atom a,b])] -> (Comp Apply ((Atom "equals"):(Comp Cat [Atom a,dotypeabs a b]):[]))
	   _ -> error ("EQTypes: "++(show x))
	checkEQtypes (Comp Apply ((Atom "autoEquals"):x)) =
	   case x of
	   [Atom x] -> let xabbis = [ z | (y,z) <- abbi, y==x ]
	               in if null xabbis then (Atom "autoEqualsRemoved") 
		       	  else (Comp Apply ((Atom "equals"):(Comp Cat [Atom x,dotypeabs x (head xabbis)]):[]))
	   _ -> error ("EQTypes-Auto: "++(show x))
	checkEQtypes (Comp f xs) = Comp f (filter ((/=) (Atom "autoEqualsRemoved")) (map checkEQtypes xs))



ruleListFP :: [Ident] -> Bool -> ProtocolTranslationState -> String
ruleListFP refiners verify pts =  
  ruleListFP0 ags refiners verify types  abs (pts, map (toFPStateR False) (rules pts))
   ("Protocol: "++protn++
   	    "\nTypes:\n"++(show ((Purpose,purposes):types))++"\n")
  where (protn,types,_,abbiGiven,_,goals) = (protocol pts)
  	purposes = [ "purpose"++m | (ChGoal (_,ch,_) (Atom m)) <- goals, 
		     		    ch/=Insecure, ch/=Confidential ]
        hasAuthenticationGoals = not $ null purposes
	ags = if hasAuthenticationGoals && (authlevel (options pts)==Weak)
	      then ["a","b"] else ["a"]
        abbi = if null abbiGiven 
	       then concatMap (newabsrule (makerefine refiners (rules pts)) types) (rules pts)
	       else abbiGiven
        abs =  (map (\ (x,y) -> (x,dotypeabs x y)) abbi)
	dotypeabs x y = case (typeit types (Atom x),typeit types y) of 
	       	        (Comp Apply [Atom type1,_],Comp Apply [Atom type2,_]) 
			  -> if (isAtype (Atom type1))
			     then
			      if  (isAtype (Atom type2)) then 
			       if type1==type2 then (checkEQtypes y)
			       else error ("Ill-typed abstraction: "++
			     	           (show x)++" vs. "++(show y)++":"++(show type1)++" vs. "++(show type2))
			      else
			      (Comp Apply [Atom type1,checkEQtypes y])
                             else
			      error ("Untypable abstraction: "++(show x)++"->"++(show y))
			(Comp Apply [Atom type1,_],_) 
			  ->  (Comp Apply [Atom type1,checkEQtypes y])
			_ -> error ("Untypable abstraction: "++(show x))
        checkEQtypes (Atom x) = Atom x
	checkEQtypes (Comp Apply ((Atom "equals"):x)) =
	   case x of
	   [(Comp Cat [Atom a,b])] -> (Comp Apply ((Atom "equals"):(Comp Cat [Atom a,dotypeabs a b]):[]))
	   _ -> error ("EQTypes: "++(show x))
	checkEQtypes (Comp Apply ((Atom "autoEquals"):x)) =
	   case x of
	   [Atom x] -> let xabbis = [ z | (y,z) <- abbi, y==x ]
	               in if null xabbis then error ("autoEquals---"++(show x))
		       	  else (Comp Apply ((Atom "equals"):(Comp Cat [Atom x,dotypeabs x (head xabbis)]):[]))
	   _ -> error ("EQTypes-Auto: "++(show x))
	checkEQtypes (Comp f xs) = Comp f (map checkEQtypes xs)

type Refining = [(Ident,RefLev)] 

data RefLev = Actor	-- only the agent creating the value
            | Actors	-- all agents participating (and known to the creator)
	    | Complete  -- all information that is known to the actor
	    deriving (Eq,Show)

makerefine :: [Ident] -> [Rule] -> Refining
makerefine fein rules = concat [map (\x -> if x `elem` fein then (x,Complete) else (x,Actors)) freshv  | (l,[],freshv,r) <- rules]

statemsgs :: [Fact] -> [Fact] -> [Msg]
statemsgs l r = 
  let s = (concat [(map fst msgs) | (State _ msgs) <- (l++r)]) ++
   	  (concat [msgs | (FPState _ msgs) <- (l++r)]) in
  if null s then error ("No state facts in "++(show (l++r)))
  else s

newabsrule :: Refining -> Types -> Rule -> Abstraction
newabsrule refining types (l,[],freshv,r) =
  let msgs0 = statemsgs l r  
      msgs = ((nub . (concatMap vars)) msgs0)\\ freshv
      agents = filter (\ x-> (getType types x)=="typeAgent") msgs
      othervars =  msgs \\  ("SID":agents)
      refs = [ case  reflev of
	       Actor    -> (ident,Comp Apply [Atom ("abs"++ident),Atom (head agents)])
	       Actors   -> (ident,Comp Apply [Atom ("abs"++ident),
	       		    	       	      Comp Cat (map Atom agents)])
	       Complete -> (ident,Comp Apply [Atom ("abs"++ident),
	       		   	       	      Comp Cat 
					      ((map Atom agents)++
					       [Comp Apply ((Atom "autoEquals"):(Atom x):[])
					       | x<-othervars])])
					       
	     | (ident,reflev) <- refining, ident `elem` freshv]
  in refs 

getType :: Types -> Ident -> Ident
getType types x =  
  let typen = nub
      	      [case typE of
      	       Agent _ _  -> "typeAgent"
    	       Number     -> "typeNumber"
    	       PublicKey  -> "typePK"
    	       SymmetricKey -> "typeSK"
    	       Function   -> "typeFun"
    	       Untyped    -> "UNTYPED"
	       _ -> error ("Unsupported Type: "++(show typE))
 	      | (typE,ids) <- types, x `elem` ids]
  in case typen of
     [] -> "UNTYPED"
     [t] -> t
     _ -> error ("Ambigous typing: "++(show x))

--- getting the genuine abstraction into place. Todo: multiple genuine abstractions in one rule
genuineAbsRule (l,[],[],r) = 
  let trans = nub ((concatMap getGen l)++(concatMap getGen r)) in 
  if trans==[] then [(l,[],[],r)] else
  if (length trans)>1 then error ("Abstraction failed (you may try to specify an abstraction manually or the classic module). Error details: multiple transformations in the genuine abstraction "++(show trans)) else
  let [(Atom s,t)] = trans 
      sub = mksub [(s,t)] 
  in [(map ((subfact sub).(eqRep True)) l,[],[],
       map ((subfact sub).(eqRep True)) r),
      (map (eqRep False) l,[(Atom s,t)],[],	 
       map (eqRep False) r)]

eqRep bool (FPState r msgs) = FPState r (map (eqRepM bool) msgs)
eqRep bool (Iknows m) = Iknows (eqRepM bool m)
eqRep bool (Fact f msgs) = Fact f (map (eqRepM bool) msgs)

eqRepM True (Comp Apply [Atom "equals",_]) = (Atom "1")
eqRepM False (Comp Apply [Atom "equals",_]) = (Atom "0")
eqRepM bool (Comp f ms) = Comp f (map (eqRepM bool) ms)
eqRepM _ (Atom a) = Atom a

getGen (FPState _ msgs) = concatMap getGenM msgs
getGen (Iknows m) = getGenM m
getGen (Fact _ msgs) = concatMap getGenM msgs

getGenM (Comp Apply [Atom "equals",Comp Cat [m1,m2]]) = [(m1,m2)]
getGenM (Comp _ ms) = concatMap getGenM ms
getGenM (Atom _) = []


ruleListFP0 ags crefiners verify types abstractlist (pts,rules) header = 
  let --- eliminate fresh variables
      silent s = if (outt (options pts))/=Isa then "" else s
      insilent s = if (outt (options pts))/=Isa then s else ""
      absrule (l,[],freshv,r) = 
        (l,[],[], map (subfact (mksub (filter (\ (x,y) -> x `elem` freshv) 
	       	   	    	    abstractlist))) r)
      ainit = abstract_initial ags pts
      (ainit0,rules0) = skencode ainit (concatMap genuineAbsRule (map  absrule rules))
      (tinit,rules1) = typer (types0++types) ainit0 rules0
      --- lazy intruder construction statically
      rules0'= intruderAna++(attackRules abstractlist)++  
      	       (concatMap li rules1)
      irules = take (iterateFP (options pts)) rules0'
      rules' = if (outt (options pts))==FPI 
      	       then if (length rules0')<(iterateFP (options pts)) 
		    then error "Iteration finished"
		    else irules
	       else rules0'
      rules''= map rule2fact2fact rules'
      rulesh'' =map rule2fact2facth rules'
      display = Isa
      myfilter = \x-> True -- isIknows
      fixedpoint =  (fp rules'' tinit)
      attacks = filterattacks fixedpoint
      attacksStr = if null attacks 
      		   then insilent "SAFE"
		   else 
      		   "\n(*** Attacks: *****************)\n"++
    		   (ppXList (ppFact Pretty) "\n\n" attacks)++
		   ("\n\n\nDerivation of first attack:\n")++
		   (ppFact Pretty (head attacks))++"\n"++
		   (traceback rulesh'' tinit tinit (head attacks) "-")
      mainstr =((silent 
      	      	(header++
		 "section rules:\n"++
     	         (ppRuleList display rules')++
		 "\nsection initial state:\n"++
    		 (ppInit "init" display tinit)++
    		 "\nsection fixedpoint:\n"++
    		 (ppFP "fp" display (filter myfilter fixedpoint)) ++
    		 "\nsection abstraction:\n"++
    		 (ppXList (\ (n,t) -> n++"->"++(ppMsg Isa t)) ";\n"  abstractlist)++"\n"))++
    		 attacksStr++
    		"\n"
   		)
  in
     if verify && (not (null attacks)) 
     then let refiners0 = map (drop 3) (filter (isPrefixOf "abs") (identsFL attacks)) 
	      refiners = nub (refiners0++crefiners)
          in   
	  if (length refiners)==(length crefiners) 
	  then "**************** AUTO REFINE FAILED. *********************"++attacksStr
	  else
     	  "(**** REFINING ABSTRACTION: "++(show refiners)++" *****)\n"
	  ++ (ruleListFP (refiners++crefiners) verify pts)
     else mainstr

filterattacks = filter isAttack



isAttack (Fact "attack" _) = True
isAttack _ = False

intruder = Comp Apply [Atom "typeAgent",Atom "i"]

types0 :: Types
types0 = [(Function,["pk"]),(Agent True True,["a","b","i"]),(Number,["ni"])] 

mkmsgpat :: Msg -> LMsg
mkmsgpat x = (x,x)




abstract_initial :: [Ident] -> ProtocolTranslationState-> [Fact]
abstract_initial ags pts =
 let  (_,typdec,knowledge,_,_,_)=protocol pts
      absInit = map toFPState (getinitials (rules pts) knowledge)
  in nub ([Iknows (Atom m) | m <-["ni","i"]]++(abstract_initial0 ags absInit))

abstract_initial0 :: [Ident] -> [Fact] -> [Fact]
abstract_initial0 ags [] = []
abstract_initial0 ags ((FPState r ((Atom name):rest)):other) =
  let other_names = nub [ n | (Atom n) <- rest, isVariable n, n/="SID" ]
      absname = if isVariable name then ags else [name]
      insts [] sub = [sub]
      insts (n:names) sub = (insts names (addSub sub n (Atom "i")))++
      	    	      	    (concat [insts names (addSub sub n (Atom ag)) | ag <-ags])
  in [subfact sub (FPState r ((Atom ag):rest)) 
     | ag<-absname, sub <- insts other_names (addSub (\x -> x) name (Atom ag))]++
     (if isVariable name then 
      [Iknows (sub m)
      |  sub <- insts other_names (addSub (\x -> x) name (Atom "i")), m<-rest]
      else [])++
     (abstract_initial0 ags other)
abstract_initial0 ags m = error ("Fact in initial: "++(show m))

intruderAna = [([Iknows (Comp Crypt [(Atom "K"),(Atom "M")]),
	      	 Iknows (Comp Inv [Atom "K"])],
		 [],[],
		 [Iknows (Atom "M")]),
	       ([Iknows (Comp Crypt [Comp Inv [Atom "K"],(Atom "M")]),
	       	 Iknows (Atom "K")],
		 [],[],
		 [Iknows (Atom "M")]),
	       ([Iknows (Comp Scrypt [(Atom "K"),(Atom "M")]),
	         Iknows (Atom "K")],
		 [],[],
		 [Iknows (Atom "M")]),
	       ([Iknows (Comp Cat [(Atom "M1"),(Atom "M2")])],
	         [],[],
		 [Iknows (Atom "M1"),Iknows (Atom "M2")])]

attackRules abstractionlist = 
  ([Fact "secret" [Atom "M",Comp Apply [Atom "typeAgent",Atom "a"]],
    Iknows (Atom "M")],
   [],
   [],
   [Fact "attack" [Comp Cat [Atom "secrecy",Atom "M"]]]):
  [ ([Fact "request" [Atom "A",Atom "B",Comp Apply [Atom "typePurpose",Atom ("purpose"++pv)],Atom "M",Atom "SID"]],
     [(Atom "B",Comp Apply [Atom "typeAgent",Atom "i"]),
      (Atom "M",
       Comp Apply [typ,Comp Apply 
       	    	       [(Atom fp),
		        Comp Cat 
			((Atom "B"):(Atom "A"):
		         [Atom ("Arg"++(show i))| i<-[1..((length args)-2)]])]])
     ],
     [],
     [Fact "attack" [Comp Cat [Atom "authentication",Atom "A",Atom "B",Atom "M"]]])
  | (pv,Comp Apply [typ,Comp Apply [(Atom fp),(Comp Cat args)]]) 
     <- abstractionlist
  ]


type IK = [Msg] 
type IKFilter = Msg -> Bool
type AbstractProt = (IK,[IK -> IK],IKFilter)

ppFPMsgList = ppXList show ","
ppFPMsgIKList = ppXList ppFPIKMsg ","

ppFPIKMsg m = (show m)++"<-ik"

getCrypto :: [Ident]->[Fact]
getCrypto agents =
  map Iknows 
  ((Atom "confChCr"):(Atom "authChCr"):
   (Comp Inv [Comp Apply [Atom "authChCr",Atom "i"]]):
   (Comp Inv [Comp Apply [Atom "confChCr",Atom "i"]]):
   [Comp Apply [Atom "secChCr",Comp Cat [Atom "i",Atom other]]
   | other <- agents, other/="i"]++
   [Comp Apply [Atom "secChCr",Comp Cat [Atom other,Atom "i"]]
   | other <- agents, other/="i"])

