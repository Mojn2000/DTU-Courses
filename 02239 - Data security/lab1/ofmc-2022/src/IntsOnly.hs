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

module IntsOnly where
import Data.List
import qualified Data.Map as Map
import Data.Maybe
import Data.Char
import Data.Int
import Constants

type Var = Int
type UnOp = Int64
type BinOp = Int64

--- predefined binary operators (because of internal use)
opCrypt  = stringToOp "crypt"
opScrypt = stringToOp "scrypt"
opPair   = stringToOp "pair"
opApply  = stringToOp "apply"
opXor    = stringToOp "xor"
opExp    = stringToOp "exp"
opSum    = stringToOp "sum"
opProd   = stringToOp "prod"
opNAPair = stringToOp "napair"

--- predefined unary operators (because of internal use)
opInv   = stringToOp "inv_"

--- predefined type symbols (unary function symbols)  
opAgent = stringToOp "agent_"
opNonce = stringToOp "nonce_"
opPk    = stringToOp "public_ke_"
opSk    = stringToOp "symmetric_"
opFu    = stringToOp "function_" 
opNat   = stringToOp "nat_"
opSet   = stringToOp "set_"

allTypes :: [UnOp]
allTypes =  [opNonce,opSk,opPk,opAgent,opFu,opNat,opSet]

encodeChar :: Char -> Integer
encodeChar c =
  let (i::Integer) = toInteger (ord c) in
  --- underscore:
  if i==95 then 0 else
  --- [0-9] ---> [1-10]
  if (i>=48) && (i<=57) then i-47 else
  --- [A-Z] ---> [11-36]
  if (i>=65) && (i<=90) then i-54 else
  --- [a-z] ---> [37-62]
  if (i>=97) && (i<=122) then i-60 else
  error ("Identifier contains illegal character "++[c])

decodeChar :: Integer -> Char
decodeChar i =
  let (i0::Int) = fromIntegral i in
  if i==0 then '_' else
  if (i>=1) && (i<=10) then chr (i0+47) else
  if (i>=11) && (i<=36) then chr (i0+54) else
  if (i>=37) && (i<=62) then chr (i0+60) else
  error ("Illegal encoding of a character "++(show i))

stringToOp :: String -> BinOp

stringToOp str
 | str `elem` ["nonce","agent","inv","function","nat","set"] =
     stringToOp0 (str++"_")
 | str == "text" = opNonce
 | str == "public_key" = opPk
 | str == "symmetric_key" = opSk
 | otherwise = stringToOp0 str


stringToOp0 string = 
   let loop [] (n::Integer) = n
       loop (c:cs) n = loop cs ((n * 64) + (encodeChar c))
   in  if (length string)>10 && (not grace) then 
       	     error ("Custom symbol "++(string)++" has more than ten chars...")
       else (fromIntegral ((loop (take 10 string) 0)+(toInteger minInt64)))

opToString :: BinOp -> String
opToString n =
    let loop n
          | n<=0         = ""
          | otherwise    = (decodeChar (n `mod` 64)):
                           (loop (n `div` 64))
    in reverse (loop ((toInteger n)-(toInteger minInt64)))

intrudible :: BinOp -> Bool
intrudible op =
  (decodeChar ((toInteger op) `mod` 64)) /= '_'

(minInt64::Int64) = minBound 

-- | The 'Msg' data-type defines the message term algebra, and is
--   hence /the/ fundamental data-structure of the entire program. 
data Msg =
  Atom Int String
  -- ^ Atoms (constants) are represented by a name 
  --   (that is later used to display) and a unique 
  --   integer identifier (for faster comparison)
  | Number Int
  -- ^ To represent 'normal' constant numbers like step and session 
  --   numbers. 
  | Var Var
  -- ^ Variables are only represented by a unique integer identifier
  | UnOp UnOp Msg
  -- ^ 'UnOp' represents the old type-coercion functions, as well
  --   as the asymmetric inverse 'inv' and the successor symbol 's'.
  | BinOp BinOp Msg Msg
  -- ^ 'BinOp' represents all (cryptographic) operators 
  | Alby String
  deriving (Eq,Ord)
---  deriving (Eq,Show,Ord)

-- | Comparison function for atoms
compare_atoms i a j b =
  (i==j) && ((i/=atom_incomparable) || (a==b))

-- | 'atom_i' (the /intruder/) should be the only atom that
--   literally appears in the code. However we need some more ...
atom_i :: Msg
atom_i =  (Atom 6 "i")

-- | atom for errors
atom_error :: Msg
atom_error = (Atom 0 "error")

-- | 'atom_a' and the following are constants used in 'PrettyUgly'
--   FIX: (to be cleaned)
atom_a :: Msg
atom_a = (Atom 1 "a")

-- | Needed for the BinOpF below FIX: will be changed
atom_contains :: Msg
atom_contains = (Atom 3 "contains")

-- | Some other atoms for BinOpF. FIX: will be changed
atom_witness = (Atom 11 "witness")
atom_request = (Atom 12 "request")
atom_wrequest = (Atom 13 "wrequest")
atom_secret = (Atom 14 "secret")

-- | Whenever we need an atom that doesn't matter (like 'etc')
--   FIX: Will vanish one day ...
atom_dummy :: Msg
atom_dummy = (Atom 5 "dummy")

-- | A reserved atom for old IF files that don't yet have unique 
--   Int identifiers (so unification procedure must back up on the
--   string identifiers). 
--   FIX: will be changed when time ...
atom_incomparable :: Int
atom_incomparable = 10

-- | 'renaming_base' defines the translation of all special atoms 
--   (like 'atom_i') into int-identifiers. Used in 'PrettyUgly'.
renaming_base "i" = "6"
---renaming_base "I" = error "I"
renaming_base "a" = "1"
renaming_base "contains" = "3"
renaming_base "dummy" = "5"
renaming_base "etc" = "5"
renaming_base _ = "0"

-- | To be safely beyond all terms like 'atom_i', starting naming them 
--   at 'basename'
basename :: Int
basename = 20

-- | Obtain all variables from a message term
msg_vars :: Msg -> [Var]
msg_vars (Atom _ _) = []
msg_vars (UnOp _ m) = msg_vars m
msg_vars (BinOp _ m1 m2) = union (msg_vars m1) (msg_vars m2)
msg_vars (Var v) = [v]
msg_vars (Number _) = []
msg_vars (Alby _) = []

-- | Obtain all variables with their types from a message term 
--   (error, if variable is untyped)
msg_typed_vars :: Msg -> [Msg]
msg_typed_vars (Atom _ _) = []
msg_typed_vars m@(UnOp op (Var v)) = [m]
msg_typed_vars (UnOp _ m) = msg_typed_vars m
msg_typed_vars (BinOp _ m1 m2) = union (msg_typed_vars m1) (msg_typed_vars m2)
msg_typed_vars (Var v) = error ("msg_typed_vars: untyped variable"++(show v))
msg_typed_vars (Number _) = []

-- | Given a variable identifier and a message, 'occurs' is true if
--   the variable occurs in the message.
occurs :: Var -> Msg -> Bool
occurs x = (elem x) . msg_vars 

-- | Does the message contain variables
groundmsg :: Msg -> Bool
groundmsg (Atom _ _) = True
groundmsg (UnOp _ m) = groundmsg m
groundmsg (BinOp _ m1 m2) = (groundmsg m1) && (groundmsg m2)
groundmsg (Var v) = False
groundmsg (Number _) = True

-- | true, if the given message term is a variable or a typed variable.
--   Note that with this definition, also @inv(var)@ and @s(var)@ count
--   as typed variables. This reflects that all such terms on the LHS of
--   a lazy intruder constraint are /simple/, as the intruder can generate
--   fresh values of any type, including private keys. 
isVar :: Msg -> Bool
isVar (Var _) = True
isVar (UnOp _ m) = isVar m
isVar _ = False

-- | New alternative to 'isVar': returns true if the given term consists
--   of only variables and intruder-composable terms (i.e. when the intruder
--   is trivially able to construct something of this form.)
isSimple :: Msg -> Bool
isSimple (Var _) = True
isSimple (UnOp op m) = 
  if op `elem` allTypes then isSimple m else False
--- (intrudible op) && 
---  (op/=opInv) && (isSimple m)
--- isSimple (BinOp op m1 m2) = --- (intrudible op) && 
---  (isSimple m1) && (isSimple m2)
isSimple _ = False


-- | true, if the given message is a typed variable 
--   (but not an untyped variable). This can be exploited in Constraint
--   Differentiation.
isTypedVar :: Msg -> Bool
isTypedVar (UnOp _ m) = isVar m
isTypedVar _ = False

-- | true, if the given message has a type as outermost application
isTyped :: Msg -> Bool
isTyped (UnOp _ m) = True
isTyped _ = False

-- | Gives the operator of a 'UnOp' message.
typeof :: Msg -> UnOp
typeof (UnOp op _) = op


---------- SUBSTITUTION

-- | Substitutions are implemented as finite maps, and hence
--   most functions of that data-type apply.
type Substitution = Map.Map Var Msg 


-- | Compile a substitution into a function from messages to messages.
substitute :: Substitution -> Msg -> Msg
substitute sub (Atom i a)  = Atom i a
substitute sub (Var v)     = fromMaybe (Var v) (Map.lookup v sub)
substitute sub (Number i)  = Number i
substitute sub (UnOp op m) = UnOp op (substitute sub m)
substitute sub (BinOp op m1 m2) = 
  BinOp op (substitute sub m1) (substitute sub m2)
substitute sub (Alby str) = Alby str 

-- | Compile a substitution into a function from messages to messages, 
--   excluding a set of variables.
substitutev :: Substitution -> [Var] -> Msg -> Msg
substitutev sub vars (Atom i a)  = Atom i a
substitutev sub vars (Var v)   
 | v `elem` vars = (Var v) 
 | otherwise     = 
    let m = fromMaybe (Var v) (Map.lookup v sub) in
    if disjoint (msg_vars m) vars then m
    else error ("There occurred an error in substitutions.\nThis bug may be caused by a normalization of an untyped variable. Please try with option -nonorm or adding type information/not using option -untyped.\nDetails of substitution error: "++(show_sub sub)++" "++(show v)++" after allq "++(show vars))
substitutev sub vars (Number i)  = Number i
substitutev sub vars (UnOp op m) = UnOp op (substitutev sub vars m)
substitutev sub vars (BinOp op m1 m2) = 
  BinOp op (substitutev sub vars m1) (substitutev sub vars m2)

disjoint m1 m2 = all (\ x -> not (x `elem` m2)) m1


-- | This function should be called when a pair @(v,t)@ is added 
--   and @v@ might already occur in a RHS term of the subsitution map.
--   We assume, however, that @t@ is already substituted with the
--   substitution.
add_pair_safe :: 	
  Substitution
  -- ^ Substitution to extend
  -> Var
  -- ^ A variable indentifier @v@ 	
  -> Msg
  -- ^ A message term @t@ to be substituted for @v@.
  -> Substitution
  -- ^ Result is a new substitution

add_pair_safe sub v t =
  let (sub'::Substitution) = Map.insert v t sub
  in Map.map (substitute sub') sub'

-- | Merge two substitutions, folding the second one via
--   'add_pair_safe' to the first one. 
mergesub :: Substitution -> Substitution -> Substitution
mergesub sub1 sub2 = 
  foldr (\ (v,t) sub -> add_pair_safe sub v t) sub1 (Map.toList sub2)

makesub :: [(Var,Msg)] -> Substitution
makesub [] = Map.empty
makesub ((x,t):sub) = add_pair_safe (makesub sub) x t

instance Show Msg where
  showsPrec _ e = 
    showString 
    (case e of 
       (Alby a) -> a
       (Atom i a) -> a
       (Var v) -> if (v>0) then "x"++(show v) else ("y"++(show (-v)))
       (UnOp op m) ->
         if op==opInv then "inv("++(show m)++")" else
         if op `elem` allTypes then
           --- for output with type info,
           --- uncomment the line
           ---	 ((opToString op)++"("++(show m)++")")
           --- and comment out following block:
   	    (case m of 
	      (BinOp op' m1 m2) -> 
                if op'==opNAPair then (show m1)++"("++(show m2)++")"
                               else show m
	      _ -> show m)
         else ((opToString op)++"("++(show m)++")") 
       (BinOp op m1 m2)
	  | (op==opCrypt) 
	      -> if printMsgsPretty then
                   "{"++(show m2)++"}_"
                   ++(case m1 of
                       BinOp _ _ _ -> "("++(show m1)++")"
                       _ -> show m1)
                 else
                   "crypt("++(show m1)++","++(show m2)++")"
	  | (op==opScrypt) 
	      -> if printMsgsPretty then 
                    "{|"++(show m2)++"|}_"
                    ++(case m1 of
                       BinOp _ _ _ -> "("++(show m1)++")"
                       _ -> show m1)
                 else  "scrypt("++(show m1)++","++(show m2)++")"  
          | op==opPair  -> if printMsgsPretty then (show m1)++","++(show m2)
                           else  "pair("++(show m1)++","++(show m2)++")"
	  | op==opApply -> (show m1)++"("++(show m2)++")"
          | op==opXor   -> (show m1)++" XOR "++(show m2) 
          | op==opNAPair -> (show m1)++","++(show m2)
	  | otherwise   -> ((opToString op)++"("++(show m1)++","++(show m2)++")")
       (Number i) -> (show i))

-- | show function for substitutions.
show_sub :: Substitution -> String
show_sub = show . Map.toList


