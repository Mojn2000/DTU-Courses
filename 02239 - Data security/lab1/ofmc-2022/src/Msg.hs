{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

-- | This module defines the @Msg@ data type for the AnB translators and several functions for it. 
module Msg(Ident,Operator(..),Msg(..),Theory,
           idents,isConstant,isAtom,isVariable,vars,isCat,foldMsg,
	   addSub,Substitution,
	   eqMod,eqModBound,(===),catty,deCat,stdTheo,
	   synthesizable,analysis,indy,
	   normalizeXor,
	   ppId,ppIdList,ppMsg,ppMsgList,ppXList,match0,isAtype,isntFunction)  where
import AnBOnP
import Data.List
import Data.Maybe
import StateMonad

-- | this is an internal constant to control the number of algebraic reasoning steps that the translator will use.
eqModBound = 3 

type Ident = String -- ^ this type is used for all symbols (constants, variables, functions, facts).

-- | Type for operators (function symbols) in message terms.
data Operator = 
       Crypt -- ^ asymmetric encryption
       | Scrypt -- ^ symmetric encryption 
       | Cat -- ^ concatenation---may be soon exchanged for family of n-tuples (n in Nat)  
       | Inv -- ^ private key of a given public key -- we plan to introduce a distinction between these mappings and other operators
       | Exp -- ^ modular exponentation
       | Xor -- ^ bitwise exclusive OR 
       | Apply -- ^ function application, e.g. @Apply(f,x)@ for @f(x)@ is old AVISPA IF standard for user defined functions, aka 1.5th-order logic! 
       | Userdef Ident -- ^ user-defined function symbols, may replace the above @Apply@ eventually. 
       deriving (Eq,Show)

-- | THE main data type...
data Msg = Atom Ident -- ^ Atomic terms, i.e. a constant (lower-case) or a variable (upper-case)
         | Comp Operator [Msg] -- ^ Composed term with an operator and a list of subterms
	 deriving Show

-- | Type to identify the position of a subterm with in a term, e.g. the @y@ in @f(g(x,y),z)@ has position @[0,1]@. 
type Position = [Int]

-- | Substitutions when already extended to a homomorphism on @Msg@ 
type Substitution = Msg -> Msg

-- | Equational theory as a set of pairs of messages that are supposed to be equal
type Theory = [(Msg,Msg)]

-- | The message type belongs to class @Eq@: so @==@ is defined on
-- @Msg@, namely as equivalence modulo via at most @eqModBound@ applications of an equivalence in 
-- @stdTheo@.
instance Eq Msg where
 a==b = a===b || elemBy (===) a (eqMod eqModBound stdTheo [b])

-- | A folding operation on messages (one functor for atomic and one for composed terms)
foldMsg :: (Ident -> a) -> (Operator -> [a] -> a) -> Msg -> a
foldMsg f g (Atom a) = f a
foldMsg f g (Comp h xs) = g h (map (foldMsg f g) xs)

-- | Identifiers (constants and variables) occuring in a given message
idents     :: Msg -> [Ident]
isConstant :: Ident -> Bool
isVariable :: Ident -> Bool

isAtom :: Msg -> Bool
isAtom (Atom _) = True
isAtom _ = False

idents       = foldMsg return (\x->concat)
isConstant x = elem (head x) ['a'..'z']
isVariable x = elem (head x) ['A'..'Z']
isCat (Comp Cat _) = True
isCat _ = False

-- | Variables of a given message
vars = (filter isVariable) . idents

--- internal function -- | @elemBy eq a list@ is true if @a@ is an element of @list@ modulo relation @eq@
elemBy eq a = any (eq a)

-- | syntactic equivalence on @Msg@
(===) :: Msg -> Msg -> Bool
(Atom ident)===(Atom ident') = ident==ident'
(Comp f xs)===(Comp g ys) = (f==g) && (all (\(x,y)->x===y) (zip xs ys))
_===_ = False

--- Algebraic equations ----

thA = Atom "TheoA"
thB = Atom "TheoB"
thC = Atom "TheoC"
thX = Atom "TheoX"
thY = Atom "TheoY"


stdAlgOps = [Exp,Xor]

stdEqs = [--- (A^X)^Y = (A^Y)^X
          (aexp (aexp thA thX) thY,
	   aexp (aexp thA thY) thX),
	  --- A xor B = B xor A
	  (axor thA thB, 
	   axor thB thA),
	  --- A xor (B xor C) = (A xor B) xor C
	  (axor thA (axor thB thC),
	   axor (axor thA thB) thC)]

aexp a b = Comp Exp [a,b] 
axor a b = Comp Xor [a,b] 

-- | standard equational theory for @exp@ and @xor@
stdTheo = stdEqs++[(r,l) | (l,r) <- stdEqs]

--- internal function -- | equivalence modulo one application of a rule of a theory
eqModOne :: Theory -> [Msg] -> [Msg]
eqModOne theo msgs =
  Data.List.nubBy (===)
      (msgs++
       (maxLength 10
       [ replace msg pos (sigma r)
       | (l,r) <- theo, msg <- msgs, (sigma,pos) <- matchAllPos l msg]))

maxLength 0 l = error ("Length exceeded: "++(show (take 10 l)))
maxLength _ [] = []
maxLength n (x:xs) = x:(maxLength n xs)

-- | equivalence modulo a given number of applications of rules of a theory
eqMod :: Int -> Theory -> [Msg] -> [Msg]
eqMod 0 theo msgs = msgs
eqMod n theo msgs = eqMod (n-1) theo (eqModOne theo msgs)


--- internal function -- | @replace m p m'@  replaces in message @m@ the subterm at position @p@ with @m'@. 
replace :: Msg -> Position -> Msg -> Msg
replace msg [] msg' = msg'
replace (Comp f xs) (i:pos) msg' =
  let (pre,(x:post)) = splitAt i xs in
  Comp f (pre++[replace x pos msg']++post) 

{-
--- internal function -- | all valid position in a @Msg@
positions :: Msg -> [Position]
positions = foldMsg (\x -> [[]])
		    (\_ xs-> []:[i:p| (i,x) <- zip [0..] xs, p<-x])
-}


--- internal function -- | positions where algebraic properties can be applied 
positionsAlg :: Msg -> [Position]
positionsAlg (Atom x) = []
positionsAlg (Comp f xs) = 
 (if f `elem` stdAlgOps then [[]] else [])++
 [i:p|(i,x) <- zip [0..] xs, p<-positionsAlg x]

--- internal function -- | returns the subterm of a message at a given position
atPos :: Position -> Msg -> Msg
atPos [] msg = msg
atPos (i:p) (Comp f xs) = atPos p (xs !! i)

--- internal function -- | @matchAllPos p m@ find all (algebraic) positions in @m@ that
-- match @p@
matchAllPos :: Msg -> Msg -> [(Substitution,Position)]
matchAllPos pattern msg =
  [ (sigma,pos)
  | pos <- positionsAlg msg, 
    sigma <- match pattern (atPos pos msg) ]

--- internal function -- | normal matching between terms
match :: Msg -> Msg -> [Substitution]
match m1 m2 = match0 [(m1,m2)] (\x->x)
--- warning: this is matching in free algebra!


-- | Matching function: takes a list of pairs @(p,m)@ of messages and
-- an initial substitution @sigma0@. (Typically, this is called with
-- the identity as an initial substitution.) We require that @sigma0@
-- does not substitute variables that occur in any pair @(p,m)@. The
-- procedure computes all substitutions @sigma@ that extend the
-- initial substitution @sigma0@ such that @p sigma=m@. Warning:
-- variables in @m@ may not be handled correctly, 
match0 :: [(Msg,Msg)] -> Substitution -> [Substitution]
match0 [] sigma = [sigma]
match0 ((Atom x,Atom y):rest) sigma =
  if x==y then match0 rest sigma else
  if isVariable x then 
    let tau = addSub sigma x (Atom y)
    in match0 (map (\(m1,m2) -> (tau m1,tau m2)) rest) tau
  else []
match0 ((Comp f xs,Comp g ys):rest) sigma =
  if f==g && (length xs)==(length ys) then
    match0 ((zip xs ys)++rest) sigma
  else []
match0 ((Atom x,m):rest) sigma =
  if isVariable x then
    let tau = addSub sigma x m
    in match0 (map (\(m1,m2) -> (tau m1,tau m2)) rest) tau
  else []
match0 _ sigma = []

{-
-- | for a weakly
--- typed model: do not match a variable for a non-atomic term
match0T :: [(Msg,Msg)] -> Substitution -> [Substitution]
match0T [] sigma = [sigma]
match0T ((Atom x,Atom y):rest) sigma =
  if x==y then match0T rest sigma else
  if isVariable x then 
    let tau = addSub sigma x (Atom y)
    in match0T (map (\(m1,m2) -> (tau m1,tau m2)) rest) tau
  else []
match0T ((Comp f xs,Comp g ys):rest) sigma =
  if f==g && (length xs)==(length ys) then
    match0T ((zip xs ys)++rest) sigma
  else []
match0T _ sigma = []
-}

{-
-- | matching modulo equational theory, however only if top is exp or xor!
matchEQ :: Msg -> Msg -> [Substitution]
matchEQ m1 m2 = matchEQ0 [(m1,m2)] (\x->x)

matchEQ0 :: [(Msg,Msg)] -> Substitution -> [Substitution]
matchEQ0 [] sigma = [sigma]
matchEQ0 ((Atom x,Atom y):rest) sigma =
  if x==y then matchEQ0 rest sigma else
  if isVariable x then 
    let tau = addSub sigma x (Atom y)
    in matchEQ0 (map (\(m1,m2) -> (tau m1,tau m2)) rest) tau
  else []
matchEQ0 ((a@(Comp f xs),b@(Comp g ys)):rest) sigma =
  if f==g && (length xs)==(length ys) then
   if f==Exp || f==Xor then
     concatMap (\eqs -> matchEQ0 eqs sigma) 
     [ (zip xs ys')++rest | Comp _ ys' <- (eqMod eqModBound stdTheo [b])]
   else
    matchEQ0 ((zip xs ys)++rest) sigma
  else []
matchEQ0 ((Atom x,m):rest) sigma =
  if isVariable x then
    let tau = addSub sigma x m
    in matchEQ0 (map (\(m1,m2) -> (tau m1,tau m2)) rest) tau
  else []
matchEQ0 _ sigma = []
-}

-- | @addSub sigma x t@ yields the substition @[x|->t] . sigma@ where
-- we assume that x and the variables of t are disjoint from the
-- domain of sigma and x does not occur in the range of sigma.
addSub :: Substitution -> Ident -> Msg -> Substitution
addSub sigma x t = 
  foldMsg (\ y -> if x==y then t else sigma (Atom y))
	  (\ f xs -> Comp f xs)

--------------------------------------------------
--------------------- Ground Dolev-Yao -----------

-- | Ground Dolev-Yao: @synthesizable ik m@ holds (for ground @ik@ and
-- @m@) if @m@ can be composed from messages in @ik@ (i.e. without
-- analysis steps). This does take the standard equational theory into
-- account.
synthesizable :: [Msg] -> Msg -> Bool
synthesizable ik m =
 any (synthesizable0 ik) (eqMod eqModBound stdTheo [m])


--- internal function
synthesizable0 :: [Msg] -> Msg -> Bool
synthesizable0 ik m =
  if m `elem` ik then True else
  case m of
   Atom _             -> False
   Comp Inv _         -> False
   Comp (Userdef _) _ -> error ("Not yet supported: "++(show m))
   Comp Xor list      -> 
     (all (synthesizable ik) list) ||
     (any (\(Comp Xor list')-> list'==list) 
          [normalizeXor (Comp Xor (l1++l2))
	  |Comp Xor l1<-ik, 
     	   Comp Xor l2<-ik, l1/=l2])
   Comp _ ms          -> all (synthesizable ik) ms

data AnalysisState = AnaSt { new  :: [Msg],
			     test :: [Msg],
			     done :: [Msg] }

initAna ik = AnaSt { new=ik,test=[],done=[] }

type AnaM a = State AnalysisState a

top     = do st <- get
	     (return . head . new) st
getik   = do st <- get
	     return (nub ((new st) ++ (done st) ++ (test st)))
pop     = do st <- get
	     put (st {new  = tail (new st), done = (head (new st)):(done st)})
delay   = do st <- get
	     put (st {new  = tail (new st), test = (head (new st)):(test st)})
push ms = do pop
	     st <- get
	     put (st {new = ms++(new st)++(test st),test = []})
pushMore ms 
        = do st <- get
	     put (st {new = nub (ms++(new st)++(test st)),test = []})
isEmpty = do st <- get
	     return (null (new st))

analysis0 = 
  do b <- isEmpty
     (if b then getik else 
      do x <- top
         ik <- getik
         (case x of
          Atom _ -> pop
          Comp Crypt [Comp Inv [k],p] ->
            if synthesizable (ik\\[x]) p then pop else
            if synthesizable (ik\\[x]) k then push [p] else delay
          Comp Crypt [k,p] -> 
            if synthesizable (ik\\[x]) p then pop else
            if synthesizable (ik\\[x]) (Comp Inv [k]) then push [p] else delay
          Comp Scrypt [k,p] -> 
            if synthesizable (ik\\[x]) p then pop else
            if synthesizable (ik\\[x]) k then push [p] else delay
          Comp Cat ms  -> push ms
          Comp Inv   _ -> pop
          Comp Apply _ -> pop
          Comp Exp   _ -> pop 
	  Comp Xor ms -> 
	   if (length ik)>200 then
	    error ("Exceeding length...: "++((show ms)++"\n"++(show (getallXors ms (ik\\[x])))++"\n"++(show ik)))
	   else
	    let new = (getallXors ms (ik\\[x]))\\ik in
	    if null new then do delay else do pushMore new
          _ -> error ("Analysis: Not yet supported: "++(show x)))
	 analysis0)

--- compute which of the components can be generated and 
--- also which other XORs have a common component
getallXors ::  [Msg] -> [Msg] -> [Msg]
getallXors terms ik = 
  let terms' = filter (not . (synthesizable ik)) terms in
  (if (length terms')/=(length terms) then [normalizeXor (Comp Xor terms')] else [])

-- | Normalize a ground term modulo the cancelation theory for XOR
-- (i.e. @t XOR t -> e@ and @t XOR e -> t@).
normalizeXor :: Msg -> Msg
normalizeXor (Comp f xs) = 
  let xs'= map normalizeXor xs
  in case f of
     Xor -> case getFirstDupRemoved xs [] of
     	    Nothing -> let xs''= filter ((/=)(Atom "e")) xs'
	    	       in case xs'' of 
			  [] -> Atom "e"
			  [x] -> x 
			  _ -> Comp Xor xs''
            Just xs'' -> normalizeXor (Comp Xor xs'')
     _ -> Comp f xs'
normalizeXor m = m

getFirstDupRemoved [] done = Nothing
getFirstDupRemoved (x:xs) done = 
  if x `elem` done then Just (((reverse done)\\[x])++xs)
  else getFirstDupRemoved xs (x:done)

{-
--- find out whether two lists of terms have a common element
xorIntersection :: [Msg] -> [Msg] -> Maybe Msg
xorIntersection terms1 terms2 =
  --- assuming normalized representation
  if null [ x | x<-terms1, x'<-terms2, x==x'] then Nothing else
  let rest = (terms1 \\ terms2) ++  (terms2\\terms1) in
  if (length rest)<2 then error "xor intersection" else Just (Comp Xor rest)
-}

-- | Analysis according to Dolev-Yao: given ground set of messages,
-- compute the closure under analysis steps (pairs are filtered out). 
analysis :: [Msg] -> [Msg]
analysis = (filter (not . isCat)) . (evalState analysis0) . initAna

-- | @indy ik m@ holds for ground @ik@ and @m@ if @ik |- m@ (Dolev-Yao
-- deduction modulo the standard equational theory).
indy :: [Msg] -> Msg -> Bool
indy = synthesizable . analysis

------------ Pretty Printing -----------------------

-- | True for an atomic identifier that is a typename. 
types = ["typeAgent","typeNumber","typePK","typeSK","typeFun","typePurpose"]
isAtype (Atom x) = x `elem` types
isAtype _ = False

-- | False for any term @t=f(...)@ and @f@ is a user-defined function
-- symbol.
isntFunction (Comp Apply (Atom "typeFun":_)) = False
isntFunction _ = True

ot = IF

-- | print identifiers (filter for alpha-numeric characters)
ppId :: Ident -> String
ppId = filter (\x -> elem x (['a'..'z']++['A'..'Z']++['0'..'9']))

-- | print list of identifiers, separated by commata
ppIdList = ppXList ppId ","


hideTypes = True

--- local
ppagentisa (Atom "i") = "dishonest i"
ppagentisa (Atom "a") = "honest a" 
ppagentisa (Atom "b") = "honest b" 
ppagentisa (Atom a) = if isVariable a then a else error ("Illegal agent name: "++(show a))
ppagentisa m = error ("Illegal agent name: "++(show m))

-- | print a message
ppMsg :: OutputType -> Msg -> String
ppMsg ot (Atom x) = 
  case ot of 
  Isa -> if x=="a" then error "UNTYPED agent a" else 
      	 if x=="b" then error "UNTYPED agent b" else
  	 if x=="i" then error "UNTYPED agent i" else
	 if x=="SID" then "(SID sid)" else 
	 if (length x)==1 && ((head x) `elem` ['0'..'9']) 
	      then "Step "++x else ppId x
  _ -> ppId x
ppMsg ot (Comp f xs) = 
  case f of 
  Cat -> case ot of
	 Pretty -> ppMsgList ot xs
	 IF -> catty IF xs
	 Isa -> catty Isa xs
  Apply -> case ot of 
	 Pretty -> if (isAtype  (head xs))&& hideTypes  then ppMsgList ot (tail xs)
	           else (ppMsg ot (head xs))++"("++(ppMsgList ot (tail xs))++")"
	 IF -> if (isAtype  (head xs))  
	       then ppMsgList ot (tail xs)
	       else "apply("++(ppMsgList ot xs)++")"
         Isa ->  
	       if (isAtype  (head xs))  
	       then case (head xs) of
	             (Atom "typeAgent") -> "Agent ("++(ppagentisa (head (tail xs)))++")"
		     (Atom "typeNumber") -> "Nonce ("++(ppMsgList ot (tail xs))++")"
		     (Atom "typeFun") -> ppMsgList ot (tail xs)
		     (Atom "typeSK") -> "SymKey ("++(ppMsgList ot (tail xs))++")"
		     (Atom "typePK") -> "PubKey ("++(ppMsgList ot (tail xs))++")"
		     (Atom "typePurpose") -> "Purpose ("++(ppMsgList ot (tail xs))++")"
		     (Atom any) -> error ("Unknown Isa type: "++(any))
	       else (ppMsg ot (head xs))++"("++(ppMsgList ot (tail xs))++")"
  Crypt -> case ot of
         Pretty ->  "{"++(((ppMsg ot) . head . tail) xs)++"}"++(ppMsg ot (head xs))
	 IF -> "crypt("++(ppMsgList ot xs)++")"
	 Isa -> "crypt("++(ppMsgList ot xs)++")"
  Scrypt -> case ot of
	 Pretty ->  "{|"++(((ppMsg ot) . head . tail) xs)++"|}"++(ppMsg ot (head xs))
	 IF -> "scrypt("++(ppMsgList ot xs)++")"
	 Isa -> "scrypt("++(ppMsgList ot xs)++")"
  Inv -> "inv("++(((ppMsg ot).head) xs)++")"
  Exp -> "exp("++(((ppMsgList ot)) xs)++")"
  Xor -> "xor("++(((ppMsgList ot)) xs)++")"
  -- <paolo> SQN hack
  Userdef id -> (id) ++"("++(ppMsgList ot xs)++")"
  -- </paolo> SQN hack
  -- _ -> (show f)++"("++(ppMsgList ot xs)++")"

-- | remove the Cat-operator from a message (return the list of concatenated messages).
deCat (Comp Cat ms) = ms

-- | print non-empty list of messages @[m1,...,mk]@ in the form
-- @pair(m1,pair(m2,...,mk))@ using @ppMsg@ for printing messages with
-- the given output format.
catty display [] = error "Empty Concatenation"
catty display [x] = ppMsg  display x
catty display [x,y] = "pair("++(ppMsg  display x)++","++(ppMsg  display y)++")"
catty display (x:y:z) = "pair("++(ppMsg  display x)++","++(catty display (y:z))++")"

-- | print list of messages (comma-separated)
ppMsgList ot list = 
  case ot of
  Isa -> ppXList (ppMsg ot) "," (filter firstorder list)
  _ -> ppXList (ppMsg ot) "," list

firstorder (Comp Apply [Atom "typeFun",_]) = False
firstorder _ = True

-- | generic printing functional: given a printer for type @alpha@, a
-- seperator, and a list of @alpha@-type elements, compute the
-- printout of this list using the @alpha@-printer and interspered by
-- the seperator.
ppXList :: (a -> String) -> String -> [a] -> String
ppXList ppX sep = concat . (intersperse sep) . (map ppX)

{-
type LMsg = (Msg,Msg)

initlabel :: [Msg] -> [LMsg]

initlabel list = map (\ (x,i) -> (x,Atom ("X_"++(show i)))) (zip list [1..])

--------------------------------------------------
--------------------- Ground Dolev-Yao labelled -----------


data LAnalysisState = LAnaSt { lnew  :: [LMsg],
 			       ltest :: [LMsg],
			       ldone :: [LMsg] }


linitAna ik = LAnaSt { lnew=ik,ltest=[],ldone=[] }

type LAnaM a = State LAnalysisState a

---------- topdec computation -----

type Signature = [(Operator,Int)]

stdSig :: Signature
stdSig = [(Exp,2)]

data Tree a = Node a [Tree a] deriving (Eq,Show)

takePly :: Int -> Tree a -> Tree a
takePly 0 (Node a _) = Node a []
takePly n (Node a ts) = Node a (map (takePly (n-1)) ts)

mapTree :: (a->b) -> Tree a -> Tree b
mapTree f (Node a ts) = Node (f a) (map (mapTree f) ts)

patterns :: Signature -> Tree (Msg,Substitution)
patterns sig = let n = (Atom "TD",\x->x) in
	       (patterns0 n sig)

powerset :: [a] -> [[a]]
powerset [] = [ [] ]
powerset (x:xs) = let powerxs = powerset xs
		  in powerxs ++ [ (x:subxs) | subxs <- powerxs ] 

patterns0 :: (Msg,Substitution) -> Signature -> Tree (Msg,Substitution)
patterns0 (term,subst) sig = 
  let vars = (filter isVariable) . idents
      vs = vars term
      powervs = (powerset vs) \\ [ [] ]
      replacements v = [ Comp op [Comp Cat [Atom (v++"."++(show i)) | i<-[1..n]]]
		       | (op,n) <- sig ]
      replacementsVS vs = zip vs ( map replacements vs )
      mksubVS vs = foldr (\ (v,ts) substSet  -> 
                            [ addSub sigma v t | sigma <- substSet, t<-ts ] )
                         [ subst ] (replacementsVS vs)
      nodes = [(sigma term,sigma) | vs <- powervs, sigma <- mksubVS vs]
  in Node (term,subst) [patterns0 n sig| n <- nodes]

showPatTree :: Tree (Msg,Substitution) -> String
showPatTree = showPatTree0 ""

showPatTree0 indent (Node (m,s) ts) =
  indent++(mishow m)++"\n"++(concatMap (showPatTree0 (indent++"  ")) ts)

mishow (Atom a) = a
mishow (Comp Exp [Comp Cat [a,b]]) = "exp("++(mishow a)++","++(mishow b)++")"

coveredby :: (Msg,Substitution) -> (Msg,Substitution) -> Bool
coveredby (m,_) (Comp op' [Comp Cat args'],_) =
  let ms = eqMod eqModBound stdTheo [m]
  in all (\ (Comp op [Comp Cat args])
	    -> op==op' && not (null (match0 (zip args' args) (\x->x)))) ms

coveredbySet :: (Msg,Substitution) -> [(Msg,Substitution)] -> Bool
coveredbySet n =
  any (coveredby n) 

patTreeFilter0 ::  [(Msg,Substitution)] -> Tree (Msg,Substitution) -> Tree (Msg,Substitution)
patTreeFilter0 list (Node a ts) =
  let ts' = filter (\ (Node a' ts') -> not (coveredbySet a' (a:list))) ts
  in (Node a (map (patTreeFilter0 (a:list)) ts'))

patTreeFilter (Node a ts) = Node a (map (patTreeFilter0 [a]) ts)

bfs :: Tree a -> [a]
bfs t = bfs0 [t] 

bfs0 [] = []
bfs0 ((Node a sts):ts) = a:(bfs0 (ts++sts))


filtered = process [] (bfs (patterns stdSig))

process seen (x:xs) = (if coveredbySet x seen then [] else [x])++(process (x:seen) xs)

(Node _ [mitree]) = patterns stdSig
filteredtree = processtree [] mitree

processtree seen (Node a ts) = 
  let process seen [] = []
      process seen ((n@(Node x ss)):ns) = 
        (if coveredbySet x seen then [] else [n])++(process (x:seen) ns)
  in Node a (map (processtree ((map (\ (Node x _) -> x) ts)++seen)) (process (a:seen) ts))




getnodes :: Tree a -> [a]
getnodes (Node a list) = map (\ (Node x _) -> x) list

-}