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

module Term where
import Data.List
import Data.Map.Strict
import Data.Maybe
import Data.Char
import Data.Int

type Ident = Int64
type Arity = Int64
type Var   = Ident

-- Core Definition

data Term = Var Ident
          | Fun Ident [Term]
          deriving (Eq,Show,Ord)

-- Symboltable

data Declarations {
     clearnames :: Clearnames,
     symtab     :: Symbtab,
     counter    :: Ident
     }

type Clearnames = Data.Map String Ident
type Symbtab    = Data.Map Ident Symbol

data Symbol = Symbol {
     kind      :: Kind,
     clearname :: String
     }

type TypeExp = Term
type FunctionType = ([TypeExp],TypeExp)

data Kind = Variable
          | Function Arity
          | Mapping FunctionType
          | Fact Arity
          | BasicType
          deriving (Eq,Show,Ord)

initialstate :: Declarations
initialstate = Declarations { clearnames = Data.Map.empty,
                              symtab = Data.Map.empty,
                              counter = 0 }

type STM = State Declarations 

register :: STM (String -> Kind -> Ident)
register name kind =
         do state <- get
            let cn = clearnames state
                st = symtab state
                c  = counter state in
            put $ state {
                  clearnames = insertWith (\ x y -> error $ name++" already defined.") name c cn
                  symtab = insert c (Symbol { kind = kind, clearname = cn }) st
                  counter = cn+1 }
           return c

stddef = do
   intruder <- register "i"       $ Function 0
   alice    <- register "a"       $ Function 0
   bob      <- register "b"       $ Function 0
   opCrypt  <- register "crypt"   $ Function 2
   opScrypt <- register "scrypt"  $ Function 2
   opPub    <- register "pub"     $ Function 1
   opExp    <- register "exp"     $ Function 2
   opCons   <- register "cons"    $ Function 2
   tpPriv   <- register "PrivKey"   BasicType
   tpSym    <- register "SymKey"    BasicType
   tpAg     <- register "Agent"     BasicType
   mpSK     <- register "sk"      $ Mapping ([tpAg,tpAg],tpSym)
   tpPK     <- register "pk"      $ Mapping ([tpAg],tpPriv)
   iknows   <- register "iknows"  $ Fact 1
   attack   <- register "attack"  $ Fact 0
   secret   <- register "secret"  $ Fact 2
   contains <- register "in"      $ Fact 2
   begin    <- register "begin"   $ Fact 4
   end      <- register "end"     $ Fact 5

msg_vars :: Term -> [Var]
msg_vars (Var v) = [v]
msg_vars (Fun f args) = concatMap msg_vars args

-- | Given a variable identifier and a message, 'occurs' is true if
--   the variable occurs in the message.
occurs :: Var -> Term -> Bool
occurs x = (elem x) . msg_vars 

-- | Does the message contain variables
groundmsg :: Term -> Bool
groundmsg = null . msg_vars

-- | true, if the given message term is a variable.
--   Note that with this definition, also @inv(var)@ and @s(var)@ count
--   as typed variables. This reflects that all such terms on the LHS of
--   a lazy intruder constraint are /simple/, as the intruder can generate
--   fresh values of any type, including private keys. 
isVar :: Term -> Bool
isVar (Var _) = True
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
type Substitution = FiniteMap Var Msg 


-- | Compile a substitution into a function from messages to messages.
substitute :: Substitution -> Msg -> Msg
substitute sub (Atom i a)  = Atom i a
substitute sub (Var v)     = fromMaybe (Var v) (lookupFM sub v)
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
    let m = fromMaybe (Var v) (lookupFM sub v) in
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
  let (sub'::Substitution) = addToFM sub v t      
  in mapFM (substitute sub') sub'

-- | Merge two substitutions, folding the second one via
--   'add_pair_safe' to the first one. 
mergesub :: Substitution -> Substitution -> Substitution
mergesub sub1 sub2 = 
  foldr (\ (v,t) sub -> add_pair_safe sub v t) sub1 (fmToList sub2)

makesub :: [(Var,Msg)] -> Substitution
makesub [] = emptyFM
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
show_sub = show . fmToList


