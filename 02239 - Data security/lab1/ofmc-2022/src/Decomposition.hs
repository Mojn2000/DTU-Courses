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

module Decomposition where
import Data.List
import qualified Data.Map as Map
import Data.Maybe
import Constants
import IntsOnly

type AlgTheo    = (FECTheo,CancelTheo) 
type FECTheo    = (BinOp -> TopdecTheo,BinOp -> [BinOp])
type CancelTheo = (DecanaTheo,NormalizationRules)

type TopdecTheo   = BinOp -> [(TT_decomp,[TT_case])]
data TT_case      = Unconditional [[Msg]]
                  | Conditional TT_Condition [TT_case]
                  deriving (Eq,Show)
type TT_Condition = (Var,TT_decomp)
type TT_decomp    = (BinOp,[Var])

type DecanaTheo         = [DecanaRule]
type NormalizationRules = (Equations,BinOp->Maybe Equations)

type Equations = [(Msg,Msg)]

type DecanaRule = (Msg,[Inequality],Msg,Msg)

-------------------- concrete
stop = 200
isRuleVar v = v<(-1000)

-----------------------------

metaTopdec :: TopdecTheo -> (BinOp -> Msg -> [([Msg],Substitution)])
metaTopdec theo op (Var x) =
  --- if x<0 then error ("Topdec "++(show x)++","++(opToString op)) else
  case freshvarfrom x of
    Nothing -> []
    Just z1 -> [([Var z1,Var (z1+1)],makesub [(x,BinOp op (Var z1) (Var (z1+1)))])]
metaTopdec theo op (BinOp op' t1 t2) =
  let interpret [] termlists sub = []
      interpret ((Unconditional msgslist):cases) termlist sub =
        [ (map (replacer termlist) msgs, sub) | msgs <- msgslist ]++
        (interpret cases termlist sub)
      interpret ((Conditional (v,(op,vars)) uncases):cases) termlist sub =
        let k=length termlist in
        if v>=k then error "decomposing nonexisting var" else
        if vars/=[k..(k+((length vars)-1))] 
        then error ("decomposition unexpected vars "++(show vars)++" "++(show [k..(k+(length vars))])) else
        let tds = metaTopdec theo op (termlist !! v) in
        (concat [ interpret uncases ((map (substitute sub') termlist)++ts) (mergesub sub sub') | (ts,sub') <- tds ])
        ++ (interpret cases termlist sub) in
  concat [ interpret cases [t1,t2] Map.empty | ((op'',[v1,v2]),cases) <- theo op, op'==op'']
metaTopdec _ _ _ = [] 

replacer :: [Msg] -> Msg -> Msg
replacer list (Var x)          = list !! x
replacer list (BinOp op m1 m2) = BinOp op (replacer list m1) (replacer list m2)
replacer list (UnOp op m)      = UnOp op (replacer list m)
replacer list m = m

topdecFreeAlg :: BinOp -> Msg -> [([Msg],Substitution)]
topdecFreeAlg _ (Var _) = 
  error "decomposing variable according to free algebra!"
--- this shouldn't happen since there are no recursive calls 
--- so it must be some  dumb asshole calling from outside ...
topdecFreeAlg op (BinOp op' t1 t2)
  | op==op' = [([t1,t2],Map.empty)]
  | otherwise = []
topdecFreeAlg _ _ = []

{- |   Topdec is the interface for all parts of the code that are
       affected by the algebraic properties of the operators,
       i.e. unification, and composition and analysis of messages by
       the (lazy) intruder.

       Topdec is defined as a complete set of unifiers for the problem
       @ t =F op(x1,x2) @, for given @t@,@op@ and fresh variables @x1@
       and @x2@. @F@ is the FEC theory.

       For efficiency, we don't give the variables @x1@ and @x2@, but
       rather let topdec return a list of messages instead
       (and currently this list has always length two).

       Restrictions:

       *  Only decomposition for binary operators --- unary operators are 
	  assumed to behave like in a free algebra.

       *  Variables are can be decomposed only to a bounded depth.

          The call @topdecF (Var x) op@ results in the creation of
          new variables @x1@ and @x1@ and the terms @(op,x1,x2)@. (The
          binary operator @op@ thus has the same meaning as in the
          'topdec' variant, only here it is not optional).

          Allowing infinite application of this decomposition step
          during unification results in non-termination. Therefore we
          mark every newly created variable to count its "generation"
          and bound the number of generations.  The current bound is
          one generation, e.g. for the variable @x1@ (and @x2@) of the
          above example we have @topdecF x1 _=[]@.
-}

topdecF :: FECTheo -> BinOp -> Msg -> [([Msg],Substitution)]
topdecF fecTheo op
 | ((snd fecTheo) op) == [] = topdecFreeAlg op
 | otherwise               = metaTopdec ((fst fecTheo) op) op

-- | Here is the screw to allow greater term depth...

freshvarfrom :: Var -> Maybe Var
freshvarfrom v
 | v<0       = Nothing --- error "Expanding Rule Vars!"
 | isFresh v = Nothing
 | otherwise = 
     Just (1000+(4*v))

isFresh :: Var -> Bool
isFresh v = if (v<0) then error "Expanding Rule Vars!" else v>=1000

{-
freshvarfrom :: Var -> Maybe Var
freshvarfrom v
 | v<0     = error "Expanding Rule Vars!"
 | v>=5000 = Nothing
 | otherwise = Just (1000+(4*v))

isFresh :: Var -> Bool
isFresh v = v>=5000
-}

------------------------------------

addsub list sub =
  foldl (\ sub' (x,t) -> 
           add_pair_safe sub' x (substitute sub' t)) 
  sub list

substeqs :: Substitution -> Equations -> Equations
substeqs sub = map (\ (x,y) -> (substitute sub x, substitute sub y))

substeqsv :: Substitution -> [Var] -> Equations -> Equations
substeqsv sub vars = map (\ (x,y) -> (substitutev sub vars x, 
                                      substitutev sub vars y))

-- | Unify two terms modulo the FEC theory. 
--   This procedure relies on termination of decompositions
unifyF :: FECTheo -> Substitution -> Equations -> [Substitution]
unifyF fecTheo sub [] = [sub]
unifyF fecTheo sub ((t,Var x):eqs) =
  if (occurs x t) 
  then if (t==(Var x)) then unifyF fecTheo sub eqs else []
  else let sub'=add_pair_safe sub x t
       in unifyF fecTheo sub' (substeqs sub' eqs)
unifyF fecTheo sub ((Var x,t):eqs) = unifyF fecTheo sub ((t,Var x):eqs)
unifyF fecTheo sub ((Atom i a, Atom j b):eqs) =
  if compare_atoms i a j b then unifyF fecTheo sub eqs else []
unifyF fecTheo sub ((Number i, Number j):eqs) =
  if i==j then unifyF fecTheo sub eqs else []
unifyF fecTheo sub ((UnOp op m, UnOp op' m'):eqs) =
  if op==op' then unifyF fecTheo sub ((m,m'):eqs) else []
unifyF fecTheo sub  ((BinOp op m1 m2,BinOp op' n1 n2):eqs) =
  let subtheo = (snd fecTheo) op in
  if (subtheo==[]) || (not (op' `elem` subtheo))  then 
      --- "free algebra operator"
      if (op/=op') then [] else
      unifyF fecTheo sub ((m1,n1):(m2,n2):eqs)
  else
      concatMap 
      (\ ([m1',m2'],sub') -> 
          unifyF fecTheo
                 (mergesub sub sub') 
                 ((m1',substitute sub' n1):
                  (m2',substitute sub' n2):
                  (substeqs sub' eqs)))
      (topdecF fecTheo op' (BinOp op m1 m2) )
unifyF _ _ _ = []

isTyped2 (UnOp f t) = f `elem` allTypes
isTyped2 _ = False
detype (UnOp f t) = t

-- | Unify two terms modulo the FEC theory, assuming that the right term in any pair
--   may contain unbounded (rule) variables, while the left one is bounded. Topdecs
--   are only applied to the left side of equations.
--   This procedure relies on termination of decompositions
unifySF :: FECTheo -> Substitution -> Equations -> [Substitution]
unifySF fecTheo sub [] = [sub]
unifySF fecTheo sub ((t,Var x):eqs) =
  if (occurs x t) 
  then if (t==(Var x)) then unifySF fecTheo sub eqs else []
  else let sub'=add_pair_safe sub x t
       in unifySF fecTheo sub' (substeqs sub' eqs)
--- unifySF fecTheo sub ((Var x,t):eqs) = unifySF fecTheo sub ((t,Var x):eqs)
unifySF fecTheo sub ((Atom i a, Atom j b):eqs) =
  if compare_atoms i a j b then unifySF fecTheo sub eqs else []
unifySF fecTheo sub ((Number i, Number j):eqs) =
  if i==j then unifySF fecTheo sub eqs else []
unifySF fecTheo sub ((UnOp op m, UnOp op' m'):eqs) =
  if op==op' then unifySF fecTheo sub ((m,m'):eqs) else []
unifySF fecTheo sub  ((BinOp op m1 m2,BinOp op' n1 n2):eqs) =
  let subtheo = (snd fecTheo) op in
  if (subtheo==[]) || (not (op' `elem` subtheo)) then
      --- "free algebra operator"
      if (op/=op') then [] else
      unifySF fecTheo sub ((m1,n1):(m2,n2):eqs)
  else
      concatMap 
      (\ ([m1',m2'],sub') -> 
          unifySF fecTheo
                 (mergesub sub sub') 
                 ((m1',substitute sub' n1):
                  (m2',substitute sub' n2):
                  (substeqs sub' eqs)))
      (topdecF fecTheo op' (BinOp op m1 m2) )
unifySF fecTheo sub ((Var x,BinOp op' n1 n2):eqs) =
  concatMap 
      (\ ([m1',m2'],sub') -> 
          unifySF fecTheo
                 (mergesub sub sub') 
                 ((m1',substitute sub' n1):
                  (m2',substitute sub' n2):
                  (substeqs sub' eqs)))
      (topdecF fecTheo op' (Var x))
unifySF _ _ _ = []

match :: FECTheo -> Substitution -> Equations -> [Substitution]
match fecTheo sub = (unifySF fecTheo sub) . (map ( \ (s,t) -> (ground s,t)))


{- | Decompose a term @t@ into two terms @t1,t2@, s.t. 
     if the intruder can generate @t1@, then he obtains @t2@.
     This function calls the 'topdec' function and therefore
     is aware of algebraic properties handled by 'topdec'.
   
     We implement the following analysis properties:
     (We write shortly @ m1 . m2 -> m3 @
      for "iknows(m1).iknows(m2) => iknows(m3)"
      )
  
      * @ op(K,M) . K         -> M @
        for @op@ in @ scrypt,xor,sum,prod @: 
	
      * @ crypt(inv(K),M) . K -> M @
      
      * @ crypt(K,M) . inv(K) -> M @
    
      * @ exp(M,K) . inv(K)   -> M @
  
      * @ exp(M,inv(K)) . K   -> M @

     The formal specification of @ decompose_analysis@:
     Given a set of rules r of the form 
     @ binop(Msg,Msg) . Msg -> Msg @ (Encrypted message,
     key term to decrypt, contents), 
     and a message @m@, the result of 'decompose_analysis' contains
     the pair @(t1,t2)@, iff for some rule 
     @ op(k,m) . kt -> mt @  and some substitution @sigma@ holds:
     @op(k,m) sigma = m@ (modulo the algebraic equations), 
     and @(t1,t2)= k1 sigma, mt sigma@.

     We thus have for instance:

     @ decompose_analysis (xor (xor a b) c) =
        [ ((xor a b),c), (c,(xor a b)), 
          ((xor a c),b), (b,(xor a c)), 
	  ((xor b c),a), (a,(xor b c)) ] @.

     Using 'topdec' instead of 'st_topdec' might exclude some
     more weird type-flaw attacks. 

-}


dropRuleVars sub =
 let list = Map.toList sub
     list' = filter (\ (x,t) -> not (isRuleVar x)) list
 in makesub list'

decana2 :: DecanaTheo -> FECTheo -> Msg -> [(Msg,Msg,Substitution)]
decana2 decanaTheo fecTheo m =
  let ruleloop
          (term,ineq,key,result) =
        map (\ (sub,_) -> (substitute sub key, substitute sub result, dropRuleVars sub))
        (checksubstineqs fecTheo ineq 
         (unifySF fecTheo Map.empty [(m,term)]))
  in (concatMap ruleloop decanaTheo)


show_decana :: (Msg,Msg,Substitution) -> String
show_decana (m1,m2,sub) = (show m1) ++ "->"++ (show m2)++ "---" ++ (show_sub sub)



-- | Data-structure for representing allquantified 
--   inequalities to exclude substitutions
data Inequality = Unsat 
                -- ^ False
                | Tauto
                -- ^ True
                | Negsub [Var] Equations
                -- ^ Forall @[Var]@: @Msg\/=Msg@\\\/...\\\/ @Msg\/=Msg@
                deriving (Eq,Show)

-- | Checks if the given inequalities are already 'Unsatisf' or not;
--   it does NOT perform a satisfiability check!
isSatisfiable :: [Inequality] -> Bool
isSatisfiable [Unsat] = False
isSatisfiable _ = True
--- reminds me of Prolog...


checkineqs :: FECTheo -> [Inequality] -> [Inequality]
checkineqs fecTheo [] = []
checkineqs fecTheo (x:xs) = 
  case checkineq fecTheo x of
   Unsat -> [Unsat] 
   Tauto -> checkineqs fecTheo xs
   ineq  -> 
     case checkineqs fecTheo xs of
       [Unsat] -> [Unsat]
       ineqs   -> ineq:ineqs

checkineq :: FECTheo -> Inequality -> Inequality
checkineq fecTheo Unsat = Unsat
checkineq fecTheo Tauto = Tauto
checkineq fecTheo ineq@(Negsub vars disjunction) = 
  case (unifyF fecTheo Map.empty 
         (map (\ (x,y) -> (freshfree vars x, freshfree vars y)) 
              disjunction)) of
    [] -> ineq 
    _  -> Unsat


-- | Substitute Inequalities and simplify them if possible.
substineqs :: FECTheo -> Substitution -> [Inequality] -> [Inequality]
substineqs fecTheo sub ineqs =
  let loop [] = []
      loop ((Negsub vars disjunction):ineqs) = 
        (Negsub vars (substeqsv sub vars disjunction)):(loop ineqs)
      loop (ineq:ineqs) = ineq:(loop ineqs)
  in  checkineqs fecTheo (loop ineqs)

mapmsg :: (Msg -> Msg) -> Msg -> Msg
mapmsg f (Var x) = f (Var x)
mapmsg f (UnOp op m) = 
  UnOp op (mapmsg f m)
mapmsg f (BinOp op m1 m2) = 
  BinOp op (mapmsg f m1) (mapmsg f m2)
mapmsg f m = m 

freshfree vars = 
 mapmsg 
 (\ (Var x) -> if x `elem` vars then Var x else Atom (x-1000) "freshterm")

rename by = mapmsg (\ (Var x) -> Var (x+by))

allVRename0 [] i = []
allVRename0 (x:xs) i = (x,Var i):(allVRename0 xs (i-1))

allVRename :: [Var] -> Substitution
allVRename list = makesub (allVRename0 list (-1))

makeNegsub :: [Var] -> Equations -> Inequality
makeNegsub = Negsub

pos x [] i = Nothing
pos x (y:ys) i = if x==y then Just i else pos x ys (i+1)

-- | Given a store of inequalities @ineq@, check if it is
--   satisfiable under given substitutions. It returns a subset
--   of the given substitutions (those under which @ineq@ is
--   satisfiable) along with the (simplified) inequalities under
--   this substitution.
checksubstineqs :: FECTheo -> [Inequality] -> [Substitution] ->  [(Substitution,[Inequality])]
checksubstineqs fecTheo ineqs = 
 (filter (isSatisfiable . snd)) .
    (map (\ sub -> 
            if checksub2 (Map.toList sub) then error ("Now what is this: "++(show_sub sub)++" inequality: "++(show ineqs))
            else (sub,substineqs fecTheo sub ineqs)))


-- | This function takes a list of substitutions @[sigma1,...,sigmak]@
--   and generates an inequality that represents the conjunction of
--   the negation of all sigma_i (see 'negsub').
negsubs :: [Var] -> [Substitution] -> [Inequality]
negsubs vars = map (negsub vars)

-- | For a substitution @[(v1,t1),...,(vn,tn)]@, this function 
--   generates the inequality @ v1\/=t1 \\\/ ... \\\/ vn\/=tn @.
negsub :: [Var] -> Substitution -> Inequality
negsub vars = negsub0 . Map.toList 
 where 
   negsub0 [] = Unsat
   negsub0 list = Negsub vars (map (\ (x,y) -> (Var x,y)) list)

-- | Show function for inequalities.
show_inequality :: Inequality -> String
show_inequality Tauto = "True"
show_inequality Unsat = "False"
show_inequality (Negsub vars list) = 
  (case vars of
    [] -> ""
    _  -> "Forall "++(show vars)++": ")++
  (foldr (\ (x,y) z -> (show x)++"/="++(show y)++" or "++z)
         "False" list)



normalizationCF :: AlgTheo -> Int ->
                   (Msg,Substitution,[Inequality]) -> 
                  [(Msg,Substitution,[Inequality])]
--- try unifying the lhs of an equation in a non-variable position in the term
--- if there is just one unifier, make case-split
--- (a) applying substitution and replaceing LHS with RHS
--- (b) negating the substitution and 

normalizationCF _ _ w@((Var _),_,_)    = [w]
normalizationCF _ _ w@((Atom _ _),_,_) = [w]
normalizationCF _ _ w@((Number _),_,_) = [w]
normalizationCF theo j w@((UnOp op m),sub,ineq) 
 | j>stop = error ("nontermination? "++(shownormaliz w))
 | otherwise =
    concatMap 
    (\ (m',sub',ineq') ->
      bunormCF theo j (UnOp op m',sub',ineq'))
    (normalizationCF theo (j+1) (m,sub,ineq))
normalizationCF theo j w@((BinOp op m1 m2),sub,ineq) 
 | j>stop = error ("nontermination? "++(shownormaliz w))
 | otherwise =
    concatMap 
    (\ (m1',sub1',ineq1') ->
        concatMap
        (\ (m2',sub2',ineq2') ->
           bunormCF theo j (BinOp op (substitute sub2' m1') m2',sub2',ineq2'))
        (normalizationCF theo (j+1) (substitute sub1' m2,sub1',ineq1')))
    (normalizationCF theo (j+1) (m1,sub,ineq))

shownormaliz :: (Msg,Substitution,[Inequality]) -> String
shownormaliz (m,s,i) = (show m)++"--"++(show_sub s)++"/"++(show_inequalities i)++"         "

bunormCF theo _ w@((Var _),_,_)    = [w]
bunormCF theo _ w@((Atom _ _),_,_) = [w]
bunormCF theo _ w@((Number _),_,_) = [w]
bunormCF theo@(fecTheo,_) j w@(t,sub,ineq) =
 if j>stop then error ("nontermination? "++(shownormaliz w)) else
 case superfstRuleApp theo j w of 
  Just (t',s,i,v) -> 
   (bunormCF theo (j+1) (t',s,i))++
   (let nineq = checkineqs fecTheo ((negsub v s):ineq) in
    if isSatisfiable nineq then (bunormCF theo (j+1)  (t,sub,nineq)) else [])
  Nothing -> [w]



superfstRuleApp :: AlgTheo -> Int -> (Msg,Substitution,[Inequality]) -> 
             Maybe (Msg,Substitution,[Inequality],[Var])
superfstRuleApp  (fecTheo,(_,(_,theoryOf))) j p@(UnOp op _,_,_) = 
  case theoryOf op of
    Just theo -> fstRuleApp fecTheo j theo p
    _ -> Nothing
superfstRuleApp (fecTheo,(_,(_,theoryOf))) j p@(BinOp op _ _,_,_) =
 case theoryOf op of
    Just theo -> fstRuleApp fecTheo j theo p
    _ -> Nothing

fstRuleApp :: FECTheo -> Int -> Equations ->  (Msg,Substitution,[Inequality]) -> 
                     Maybe (Msg,Substitution,[Inequality],[Var])
fstRuleApp fecTheo j ((lhs,rhs):eqs) (t,sub,ineq) =
 if (j>stop) then error "fstRuleApp: nontermination?"
 else
  case checksubstineqs fecTheo ineq (unifyF fecTheo sub [(t,lhs)]) of
   [] -> fstRuleApp fecTheo (j+1) eqs (t,sub,ineq)
   ((sub',ineqs'):_) -> 
       removeRuleVars fecTheo (substitute sub' rhs,sub',ineqs')
fstRuleApp fecTheo j [] _ = Nothing

removeRuleVars :: FECTheo -> (Msg,Substitution,[Inequality]) -> 
            Maybe (Msg,Substitution,[Inequality],[Var])
removeRuleVars fecTheo (t,sub,ineq) =
  --- the following filtering is OK since the substituted redex 
  --- can only contain rule variables that are not further substituted.
  --- (by closure of substitutions)
  let list = filter (not . isRuleVar . fst) (Map.toList sub) in
  let varslist = map (\ (x,t) -> (x,msg_vars t)) list
      vars = concatMap (\ (x,vs) -> x:vs) varslist
      varu = filter (((/=) []) . snd )
             (map (\ (x,vs) -> (x,filter isRuleVar vs)) varslist) in
  if  checksub2 list then error ("normalize this: "++(shownormaliz (t,sub,ineq))) else
  if  varu==[] then Just (t,(makesub list),ineq,[]) else
  --- check that all variables in the domain of the substitution
  --- are below expansion limit
  if (filter (isFresh . fst) varu)/=[] then Nothing else
  let --- the following cannot return @Nothing@ since we have checked that
      --- all variables in the domain of @sub@ are below expansion limit
      --- Also, we don't care if there are other occurrences (which may work better)
      Just nuvar = freshvarfrom (fst (head varu))
      nuvars = [nuvar+2,nuvar+3]
      olvars = foldr union [] (map snd varu)
      alpha0 = makesub (map (\ (x,y) -> (x,Var y)) (zip olvars nuvars ))
      alpha  = substitute alpha0
      nusub  = (map (\ (x,t) -> (x, alpha t)) list) 
  in  if (length olvars)>(length nuvars) then error "Improper renaming" else
      if ((nuvar+2) `elem` vars) then Nothing else 
      if ((nuvar+3) `elem` vars) then Nothing else 
                --- we have already expanded 
      if checksub nusub then 
      error ("normalize this: "++(shownormaliz (t,sub,ineq))++
             "--- I would do "++(show nusub))
      else 
        let mnusub = makesub nusub 
            nineqs = substineqs fecTheo mnusub ineq in
        if isSatisfiable nineqs then 
          Just (alpha t, mnusub, nineqs, take (length olvars) nuvars)
        else Nothing

checksub :: [(Int,Msg)] -> Bool

checksub sub =
  let varsleft = map fst sub
      varsright = concatMap (msg_vars . snd) sub 
      allvars = varsleft ++ varsright in
  ((filter (\ x -> x `elem` varsright) varsleft)/=[])
  || ((filter isRuleVar allvars)/=[])

checksub2 sub =
  let varsleft = map fst sub
      varsright = concatMap (msg_vars . snd) sub 
      allvars = varsleft ++ varsright in
  ((filter (\ x -> x `elem` varsright) varsleft)/=[])

ground (Var x) = Number (-x)
ground (UnOp op m) = UnOp op (ground m)
ground (BinOp op m1 m2) = BinOp op (ground m1) (ground m2)
ground t = t

deground (Number x) 
  | x<0  = Var (-x)
  | otherwise = Number x
deground (UnOp op m)   = UnOp op (deground m)
deground (BinOp op m1 m2) = BinOp op (deground m1) (deground m2)
deground t = t



groundnormalizationCF :: AlgTheo -> Msg -> Msg
groundnormalizationCF algTheo@(fecTheo,(_,(_,theoryOf))) t@(BinOp op m1 m2) =
 case theoryOf op of
  Nothing -> BinOp op (groundnormalizationCF algTheo m1) 
                      (groundnormalizationCF algTheo m2)
  Just theo ->
   case concatMap 
       (\ (lhs,rhs) -> 
           [ deground (substitute sub rhs) | sub <- match fecTheo Map.empty [(t,lhs)]])
       theo of
   [] -> BinOp op (groundnormalizationCF algTheo m1) 
                  (groundnormalizationCF algTheo m2)
   (x:xs) -> groundnormalizationCF algTheo x
groundnormalizationCF algTheo@(fecTheo,(_,(_,theoryOf))) t@(UnOp op m) =
 case theoryOf op of
  Nothing -> UnOp op (groundnormalizationCF algTheo m)
  Just theo ->
   case concatMap 
       (\ (lhs,rhs) -> 
           [ deground (substitute sub rhs) | sub <- match fecTheo Map.empty [(t,lhs)]])
       theo of
   [] -> UnOp op (groundnormalizationCF algTheo m)
   (x:xs) -> groundnormalizationCF algTheo x
groundnormalizationCF _ t = t

reduceRedices :: (BinOp -> Maybe Equations) -> Msg -> [Msg] -> [Inequality]
reduceRedices thO m@(UnOp op t) lhsSubterms =
  (if m `elem` lhsSubterms then (myirreduc thO op m) else [])
  ++ (reduceRedices thO t lhsSubterms)
reduceRedices thO m@(BinOp op t1 t2) lhsSubterms =
  (if m `elem` lhsSubterms then (myirreduc thO op m) else [])
  ++ (reduceRedices thO t1 lhsSubterms) ++ (reduceRedices thO t2 lhsSubterms)
reduceRedices thO _ _ = []

myirreduc theoryOf op t = 
 case theoryOf op of
 Just theo -> 
  map (\ (lhs,_) -> 
         let lhs'=rename (-30) lhs in 
         Negsub (msg_vars lhs') [(t, lhs')]) theo
 Nothing -> []

noredexAny :: Equations 
           -> Msg -> [Inequality]
noredexAny eqs t= 
 [Negsub (msg_vars (rename (-30) lhs)) [(t, (rename (-30) lhs))] 
    | (lhs,_) <- eqs]
 
partitionBy :: (a->a->Bool) -> [a] -> [[a]]
partitionBy comp list =
  let loop [] elem = [[elem]]
      loop (x:xs) elem = 
        if comp (head x) elem then ((elem:x):xs) else x:(loop xs elem)
  in foldl loop [] list

nfpopro :: FECTheo -> [(Msg,Substitution,[Inequality])]->[(Msg,Substitution,[Inequality])]
nfpopro fecTheo =
 fst .
 (foldl
 (\ (sol,ineq) (t,s,i) -> 
    if isSatisfiable (substineqs fecTheo s ineq) 
    then ((t,s,i):sol,(negsub [] s):ineq)
    else (sol,ineq))
 ([],[]))

show_topdec :: ([Msg],Substitution) -> String
show_topdec (ms,sub) = (show ms) ++ "---" ++ (show_sub sub)

show_inequalities = 
  foldr (\ x y -> "("++(show_inequality  x)++") and "++y) "True"


