{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module Remola where
import Data.List
import Data.Maybe
import Constants
import IntsOnly
import Decomposition
import MsgTree
import qualified Data.Map as Map
{- | A D-From Constraint is a list of messages the intruder has to generate
     and two message trees representing the /old/ and /new/ knowledge of the
     intruder. Note that a Constraint with new knowledge is handled as a normal
     From Constraint (without CD). This is for historic reasons. Actually, 
     a from-Constraint should mean that the old intruder knowledge is empty. 
     (This will be fixed; however higher-level modules need to be cleaned 
     first.)
-}
type Constraint = ([Msg],MsgTree,MsgTree)


-- | The substitution for entire constraint stores (includes
--   the check if substituted inequalities are satisfiable).
substitute_constraints :: FECTheo -> Substitution -> Constraints -> Constraints
substitute_constraints fecTheo sub (cs,ineqs) = 
  (map (substitute_constraint sub) cs, substineqs fecTheo sub ineqs)

substitute_constraint :: Substitution -> Constraint -> Constraint
substitute_constraint sub (ts,ik1,ik2) =
          (map (substitute sub) ts, 
	   substituteMT sub ik1,  substituteMT sub ik2 )

-- | A constraint store contains a list of @D-from@ constraints 
--   and inequalities.
type Constraints = ([Constraint],[Inequality])


-- | The results of all lazy intruder functions are of this 
--   type: a set of pairs of (simple) constraint stores with
--   a substitution.
type Possibilities = [(Constraints,Substitution)]

-- | The variables of a constraint
constr_vars :: Constraint -> [Var]
constr_vars (t,ik,nik) = 
  (concatMap msg_vars t)++(varsMT ik)++(varsMT nik)

-- | True if a given constraint is /simple/, i.e. all terms
--   to generate are variables.
simple :: Constraint -> Bool
simple (l,_,_) = (filter (not . isVar) l)==[]

newImpl=True

-- | True, if the constraint is a From-constraint (i.e. without
--   differentiation). [As noted above, in this case the new
--   intruder knowledge is empty; this will be changed.]
isFrom :: Constraint -> Bool
isFrom (_,ik,nik) = 
  isEmptyMT (if newImpl then ik else nik)

isDFrom = not . isFrom

-- | Transform a D-from into a From constraint by merging
--   old and new intruder knowledge
undiff :: Constraint -> Constraint
undiff (t,ik,nik) = ---
  if newImpl then (t,emptyMT,addMT nik ik)
  else (t,addMT nik ik,emptyMT)

-- | Make a From constraint
mkFrom :: 
  [Msg] 
  -- ^ A set of messages to generate
  -> MsgTree 
  -- ^ A message tree of the intruder knowledge
  -> Constraint
  -- ^ Resulting constraint
mkFrom m ik = if newImpl then (m,emptyMT,ik)
	      else (m,ik,emptyMT)

-- | Make a DFrom constraint
mkDFrom :: 
  [Msg] 
  -- ^ A set of messages to generate
  -> MsgTree 
  -- ^ A message tree of the old intruder knowledge
  -> MsgTree 
  -- ^ A message tree of the new intruder knowledge
  -> Constraint
  -- ^ Resulting constraint  
mkDFrom m ik nik = (m,ik,nik)

-- | The main function of the lazy intruder. Given a constraint
--   store, and an initial substitution (where @vars(constraints)
--   intersect dom(substitution) = emptyset@), the function returns
--   a list of possibilities, i.e. pairs of simple constraint
--   stores and substitutions. 
--
--   Note that this function assumes that the given inequalities are 
--   satisfiable; however, for all substitutions which performed 
--   to solve the constraints, the procedure will check that the
--   inequalities remain satisfiable.
gencheck :: FECTheo -> Constraints -> Substitution -> Possibilities
gencheck fecTheo constraints sub0 = 
  foldl 
  (\ possibilities c ->
     concatMap 
     (\ (constraints,sub) -> 
	gencheck0 fecTheo [] 
        (substitute_constraint sub c)
        constraints sub) 
     possibilities)
  [(([],snd constraints),sub0)] (fst constraints)

{- | Basis of gencheck. It can be called whenever a new constraint
     @c@ should be added to an already simple constraint set @cs@ (rather
     than calling 'gencheck' on @cs++[c]@). Note that this includes
     checking the inequalities if they are affected.
-}
gencheck0 :: 
  FECTheo -> 
  [Msg]
  -- ^ Auxiliary parameter: leave empty in top call. (Used to 
  --   carry the list of variables in the terms to generate.)
  -> Constraint 
  -- ^ The new constraint to be added. (Will be added at the 
  --    end of the constraint list given in the next paramter.)
  -> Constraints 
  -- ^ An already simple constraint store
  -> Substitution 
  -- ^ An initial substitution (all given constraints must already
  --   be substituted)
  -> Possibilities
  -- ^ Result is again a list of simple constraints and substitutions.
gencheck0 fecTheo [] constraint@([],ik,nik) constraints@(cs,ineq) sub = 
  if isFrom constraint then [(constraints,sub)] else []
gencheck0 fecTheo vars constraint@([],ik,nik) constraints@(cs,ineq) sub = 
  -- In case we use CDiff, we can prune here if all variables 
  -- are typed and nik contains nothing of any such type.
  -- Possible heuristics to try: always prune here when using CDiff.
  if (isDFrom constraint) && checktypingvars then []
  else [((cs++[(vars,ik,nik)],ineq),sub)]
  where niktypes = typesMT nik
        checktypingvars = (all isTyped vars) 
			  && (any (\ x -> not (elem (typeof x) niktypes)) vars)
gencheck0 fecTheo@(_,theoryOf) vars constraint@(t:terms,ik,nik) constraints@(cs,ineq) sub = 
  --- be lazy:
  if isSimple  t     then gencheck0 fecTheo (vars++[t])  (terms,ik,nik)  constraints sub else
  --- check for containment (without unification) in nik:
  if elemMT t nik then gencheck0 fecTheo vars (undiff (terms,ik,nik)) constraints sub else
  --- check for containment (without unification) in ik:
  if elemMT t ik then gencheck0 fecTheo vars         (terms,ik,nik)  constraints sub else
  let --- compute all unifiers with sth. in nik:
      fstcl_substlist = checksubstineqs fecTheo ineq (elemMT_unifyF fecTheo sub t nik)
      fstcl_unif_possibilities = 
        concatMap 
	(\ (sub',ineq') -> 
	   gencheck fecTheo
	   (substitute_constraints fecTheo sub' (cs++[undiff (vars++terms,ik,nik)],ineq'))
	   sub')
	fstcl_substlist
      --- compute all unifiers with sth. in ik:
      sndcl_substlist1 = elemMT_unifyF fecTheo sub t ik
      sndcl_substlist0 = if (elem sub sndcl_substlist1) then [sub] else sndcl_substlist1
      sndcl_substlist = checksubstineqs fecTheo ineq sndcl_substlist0
      sndcl_unif_possibilities = 
        if (elem sub sndcl_substlist0) then 
          gencheck0 fecTheo vars (terms,ik,nik) (cs,ineq) sub
        else
        concatMap
	(\ (sub',ineq') -> 
           gencheck fecTheo
	   (substitute_constraints fecTheo sub' (cs++[(vars++terms,ik,nik)],ineq')) 
	   sub')
	sndcl_substlist
      --- compute how the term can be composed from its subterms
      comp_possibilities =
	concatMap 
        (\ (l,_) ->
             gencheck0 fecTheo vars (union l terms,ik,nik) constraints sub) 
        (filter (\ (_,sub) -> (Map.toList sub)==[])
        (case t of 
           BinOp op m1 m2 ->
             let otherops = theoryOf op
                 ops = if otherops==[] then [op] else otherops in
             concatMap (\ op' -> if op'==(stringToOp "fst") then error "FSTbinop" 
				 else topdecF fecTheo op' t) (filter intrudible ops)
           UnOp op m -> 
               --- using that currently all FEC-affected ops are binary
               if intrudible op then [([m],Map.empty)] else []
           _ -> []))


  in if elem sub (map fst fstcl_substlist)
     then gencheck0 fecTheo vars (undiff (terms,ik,nik)) constraints sub
     else nub (fstcl_unif_possibilities ++ sndcl_unif_possibilities ++ comp_possibilities)


---------------------------------------------

-- | Type to represent intruder knowledge for analysis: in addition to
--   the usual message, it contains a set of messages that need to be 
--   checked for decryption in case new knowledge is learned.
--   Fix: might be extended even into a four-tuple to reflect
--   constraint-differentiation.
type IK = (MsgTree,[Msg])

-- | empty intruder knowledge
emptyIK :: IK
emptyIK = (emptyMT,[])

-- | concatenate two intruder knowledges
catIK :: IK -> IK -> IK
catIK (ik1,ik2) (ik1',ik2') = (addMT ik1 ik1',union ik2 ik2')

-- | true, if the intruder knowledge is empty.
isEmptyIK :: IK -> Bool
isEmptyIK (ik,_) = isEmptyMT ik

-- | all variables appearing in IK
vars_IK :: IK -> [Var]
vars_IK (ik,undec) = (varsMT ik)++(concatMap msg_vars undec)

type IKstate = (IK,IK,Bool)

showIKstate :: IKstate -> String
showIKstate (ik,nik,b) = (show ik)++(if b then "\n" else "")++(show nik)

substituteIK sub (ik,msg) = (substituteMT sub ik, map (substitute sub) msg)

substituteIKstate :: Substitution -> IKstate -> IKstate
substituteIKstate sub (ik,nik,b) = (substituteIK sub ik, 
				    substituteIK sub nik,b)


undiffIKstate :: IKstate -> IKstate
undiffIKstate (ik,nik,b) = (ik,nik,False)

checkNIKempty :: IKstate -> Bool
checkNIKempty (ik,nik,b) = 
  (isEmptyIK nik) || (not b)

mkStdFromState :: [Msg] -> IKstate -> ([Msg],MsgTree,MsgTree)
mkStdFromState t (ik,nik,b) =
 if newImpl then (t,emptyMT,fst (catIK ik nik))
 else (t,fst (catIK ik nik),emptyMT)

mkDFromState :: [Msg] -> IKstate -> ([Msg],MsgTree,MsgTree)
mkDFromState t (ik,nik,b) = 
 if b then (t,fst ik,fst nik)
 else if newImpl then (t,emptyMT,fst (catIK ik nik)) 
		 else (t,fst (catIK ik nik),emptyMT)

vars_IKState :: IKstate -> [Var]
vars_IKState (ik,nik,b) = (vars_IK ik)++(vars_IK nik)

getallIK :: IKstate -> IK
getallIK (ik,nik,b) = catIK ik nik

mkinitialIKstate :: [Msg] -> IKstate
mkinitialIKstate ik = 
  if newImpl then (emptyIK,(listToMT ik,[]),False)
  else ((listToMT ik,[]),emptyIK,False)

-- | Analyis procedure of the lazy intruder
analz :: AlgTheo -> 
  Constraints
  -- ^ A set of simple constraints
  -> IK
  -- ^ Current state of intruder knowledge, closed under analysis rules
  -> [Msg] 
  -- ^ A list of newly learnt messages
  -> [(Constraints,Substitution,IKstate)]
  -- ^ Result is a list, where each element consists of 
  --   a simple constraint store, a substitution, the new and 
  --   the old intruder knwoledge.
analz theo constraints (allmsg,undeciphered) msgs =
 (map 
 (\ (r,s,[],crypties,res) -> 
    (r,s,((allmsg,undeciphered),(diffMT res allmsg,diff crypties undeciphered),True)))
 (analz0 theo True (constraints,Map.empty,msgs,undeciphered,allmsg)))

-- | Auxiliary function of 'analz'. Meaning of the three message
--   sets:
--
--  1. the not yet processed items
--
--  2. encrypted messages for which we haven't (yet) found the key
--
--  3. resulting new intruder knowledge 
--
--  Also: there is a boolean that is set initially to true and whenever something
--  new is learnt, meaning that the not yet decrypted messages must be checked another 
--  time 
analz0 :: AlgTheo -> Bool ->  (Constraints,Substitution,[Msg],[Msg],MsgTree) 
	       -> [(Constraints,Substitution,[Msg],[Msg],MsgTree)]
analz0 theo False (constraints,sub,[],test,azed) = [(constraints,sub,[],test,azed)]
analz0 theo True (constraints,sub,[],test,azed) = analz0 theo False (constraints,sub,test,[],azed)
analz0 theo@(fecTheo,(decanaTheo,_)) bool (constraints@(cs,ineq),sub,n:new,test,azed)
 | (isVar n) = analz0 theo bool (constraints,sub,new,test,azed)
 | otherwise =  
    if (isPair n) then 
      let (BinOp _ m1 m2) = n in
      analz0 theo bool (constraints,sub,m1:m2:new,test,azed) else
    if (notOp n) then analz0 theo True (constraints,sub,new,test,addToMT azed n) else
       let gencheck_m m = 
	     map snd (gencheck0 fecTheo [] (mkFrom [m] azed) constraints sub)
           intruder_knows m = elem sub (gencheck_m m)
	   tds  = decana2 decanaTheo fecTheo n
	   tds0 = filter (\ (_,m,_) -> (not ((intruder_knows m) || (isVar m)))) tds
           tds1 = map (\ (k,m,sub') -> 
		       (k,m,sub',substitute_constraints fecTheo sub' constraints)) tds0
           tds' = filter (\ (_,_,_,cs) -> isSatisfiable (snd cs)) tds1
           (k,m,sub',constr') = head tds' 
	   sub''  = mergesub sub sub'
           azed'' = substituteMT sub' azed 
           ps = map snd (gencheck0 fecTheo [] (mkFrom [k] azed'') constr' sub'')
           newnew sub 
                  = (if (tail tds')==[] then (:) (substitute sub m) 
		     else ((:) (substitute sub m)) . 
			  ((:) (substitute sub n))) 
		    (map (substitute sub) (new++test)) in
       if tds'==[] then analz0 theo bool (constraints,sub,new,test,addToMT azed n) else 
       if ps==[] then analz0 theo bool (constraints,sub,new,n:test,addToMT azed n) else  
       if elem sub ps 
       then analz0 theo True (constraints,sub,newnew Map.empty,[],addToMT azed n)
       else
       (analz0 theo True ((fst constr',checkineqs fecTheo ((negsubs [] ps)++(snd constr'))),
		     sub'',new,test,addToMT azed'' n))++
            (concatMap 
             (\ sub' ->
		let constraints' = substitute_constraints fecTheo sub' constr'
		    sub''' = mergesub sub' sub'' in
                    if isSatisfiable (snd constraints') then
                      analz0 theo True 
		 	(constraints',sub''',newnew sub''',[],
			 addToMT (substituteMT sub' azed'') (substitute sub' n))
                        else [])  ps) 

isPair :: Msg -> Bool
isPair (BinOp op _ _) = (op==opPair) || (op==opNAPair)
isPair _ = False

notOp :: Msg -> Bool
notOp m =
  case m of
    UnOp _ _ -> False
    BinOp _ _ _ -> False
    _ -> True


-- | initialization function for the intruder knowledge: closure under
--   analysis.
init_ana :: AlgTheo -> [Msg] -> IKstate
init_ana theo ik0 =
  let (_,_,(ik1,ik2,b)) = head (analz theo ([],[]) emptyIK ik0)
  in (ik1,ik2,False)


-- | Show function for constraints.
show_constraints :: Constraints -> String 
show_constraints (cs,ineq) = 
  (concatMap (\ (ts,ik1,ik2) -> 
	     "dfrom("++(show ts)++" , "++(showMT ik1)++" , "++(showMT ik2)++")\n") 
   cs)
  ++"  where "++(show_inequalities ineq)++"\n"

-- | Show function for possibilities.
show_possibilities :: Possibilities -> String
show_possibilities = 
  concatMap (\ (constraints,sub) -> (show_constraints constraints) ++(show_sub sub)++"\n \n")
