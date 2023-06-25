{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module TheoLoad (theoparse,ExAlgTheo,Symboltable) where

import Data.Char
import Data.Maybe
import qualified Data.Map
import Constants
import IntsOnly
import Decomposition 
import MsgTree
import Remola
import Symbolic
import TheoLexer
import TheoParser


type Symboltable = Data.Map.Map String (BinOp,Bool,Int,Int)

makeEntry :: 
  Symboltable -- old symboltable
  -> String   -- new operator name
  -> Int      -- arity
  -> Bool     -- intruderaccessible?
  -> Bool     -- appears in topdec?
  -> Symboltable -- new symboltable

makeEntry table opStr arity intrAcc topdecy =
  case (Data.Map.lookup opStr table) of
   Just _ -> errorth ("Second definition of "++opStr)
   Nothing ->
     let opStr_ = opStr 
         opInt  = stringToOp opStr_ 
         newArity = if topdecy 
		    then 2 else arity
     in Data.Map.insert opStr (opInt,intrAcc,arity,newArity) table

errorth str = error ("Error in theory-file: "++str)

type ExAlgTheo = (AlgTheo,Symboltable)

theoparse :: String ->  ExAlgTheo 
theoparse inputstr =
   let tokens = alexScanTokens inputstr in 
   theoparsefile (theoparser tokens)

theoparsefile :: [PTheo] -> ExAlgTheo
theoparsefile x = 
  foldl theoparseSubtheo ((freeAlg,([],([],\x -> Nothing))),Data.Map.empty) x

theoparseSubtheo :: ExAlgTheo -> PTheo -> ExAlgTheo
theoparseSubtheo (((subtheotopdec,subtheo),(decanatheo,cancel)),tab) (signature,canceqs,[],decanas) =
  let ops = parseSig signature in
  (((subtheotopdec,\ x -> if x `elem` ops then [] else subtheo x),
   (decanatheo++ (parseDecana decanas),parseCancel canceqs cancel)),tab)
theoparseSubtheo (((subtheotopdec,subtheo),(decanatheo,cancel)),tab)
                 (signature,canceqs,topdecs,decanas)  =
  let ops = parseSig signature
      (newtheo,ops') = theoparseTopdec topdecs ops 
      table = parseSigPass2 signature tab ops' in
   (((\ x -> if x `elem` ops then newtheo 
              else subtheotopdec x,
     \ x -> if x `elem` ops then ops' else subtheo x), 
       (decanatheo++ (parseDecana decanas),parseCancel canceqs cancel)),table)

parseCancel ::  [(PTerm,PTerm)]  -> NormalizationRules -> NormalizationRules
parseCancel pequations (eqs,theoryOf) =
  let allterms = concatMap (\ (x,y) -> x:y:[]) pequations
      allops = concatMap getops allterms
      allvars = (concatMap ptermvars allterms)
      register = foldl registerVar initialRegister2 allvars
      neweqs = map 
               (\ (x,y) -> (ppterm register x, ppterm register y)) pequations
  in (neweqs++eqs,(\ op -> if op `elem` allops then Just neweqs else theoryOf op))

getops (PCompT op ts) = (stringToOp op):(concatMap getops ts)
getops _ = []

parseSig :: PSigSec -> [BinOp]
parseSig [] = []
parseSig ((op0,arity):signature) = 
  let op = stringToOp op0
      ops = parseSig signature in
  if op0=="napair" then 
    errorth "Overloading the builtin symbol 'napair' is not permitted." else
  if (arity<0) then errorth ("Operator "++op0++" has arity<0.") else
  if (arity>2) then errorth ("Operator "++op0++" has arity>2.") else
  op:ops

parseSigPass2 :: PSigSec -> Symboltable -> [BinOp] -> Symboltable
parseSigPass2 [] tab0 ops = tab0
parseSigPass2 ((op0,arity):signature) tab0 ops = 
  let table = parseSigPass2 signature tab0 ops in
  makeEntry table op0 arity True 
                   ((stringToOp op0) `elem` ops)

theoparseTopdec :: [PTopdec] -> [BinOp] -> (TopdecTheo,[BinOp])
theoparseTopdec topdecs ops =
  let partition = partitionBy (\ (id,t,c) (id',t',c') -> id==id') topdecs
      ops' = filter (\ op -> any (\ (op',_) -> op==op') reordered) ops
      reordered 
       = map 
         (\ topdecs -> 
           let (ident,_,_) = head topdecs
               op = stringToOp ident in
           if (not (op `elem` ops))
           then errorth ("Operator "++ident++" undeclared in subtheory.") else
           (op,map (\ (_,t,c) -> parseTopdecPattern (t,c) ops) topdecs))
         partition
  in (mkfunc reordered,ops')
       

mkfunc :: [(BinOp,[(TT_decomp,[TT_case])])] -> BinOp -> [(TT_decomp,[TT_case])]
mkfunc ((op,topdectheo):tds) op' = 
  if op==op' then topdectheo else mkfunc tds op'
mkfunc [] op' = errorth ("Undefined case: "++(opToString op'))


parseTopdecPattern :: 
  (PTerm,[PTopdecCase]) -> [BinOp] -> (TT_decomp,[TT_case])
parseTopdecPattern (PCompT operator [PVar vident1, PVar vident2],cases) ops =
  let register = foldl registerVar initialRegister [vident1,vident2]
      [v1,v2]  = map (lookupVar register) [vident1,vident2]
      op = stringToOp operator in
   if (not (op `elem` ops))
   then errorth ("Operator "++operator++" undeclared in subtheory.") else
   ((op,[v1,v2]),parseTopdecCases cases register)
parseTopdecPattern (PCompT operator [PVar vident],cases) ops =
  let register = registerVar initialRegister vident
      v  = lookupVar register vident
      op = stringToOp operator in
   if (not (op `elem` ops))
   then errorth ("Operator "++operator++" undeclared in subtheory.") else
   ((op,[v,v]),parseTopdecCases cases register)
parseTopdecPattern (term,cases) ops =
  errorth  ("Illegal term in topdec pattern "++(show term))

parseTopdecCases :: 
  [PTopdecCase] -> VarRegister -> [TT_case]
  
adjustlen [x] = [x,x]
adjustlen l = l

parseTopdecCases [] register = []
parseTopdecCases ((PUncond list):cases) register =
  (Unconditional (map ((map (ppterm2 register)).adjustlen) list)):
  (parseTopdecCases cases register)
parseTopdecCases ((PCond (ident,term) ccases):cases) register =
  case term of
   PCompT operator [PVar vident1, PVar vident2] ->
     let i = lookupVar register ident 
         register' = foldl registerVar register [vident1,vident2]
         [v1,v2] = map (lookupVar register') [vident1,vident2] 
         op = stringToOp operator in
     (Conditional (i,(op,[v1,v2])) (parseTopdecCases ccases register'))
     :(parseTopdecCases cases register)
   PCompT operator [PVar vident] ->
     let i = lookupVar register ident 
         register' = registerVar register vident
         v = lookupVar register' vident
         register'' = registerVar register' ("clone"++vident) 
         vclone = lookupVar register'' ("clone"++vident)
         op = stringToOp operator in
     (Conditional (i,(op,[v,vclone])) (parseTopdecCases ccases register''))
     :(parseTopdecCases cases register)
   _ -> errorth ("Illegal term in topdecondition "++(show term))

type VarRegister = (PIdent->Int,Int,[PIdent])
-- | renaming, current number, registered variables (domain of function)

initialRegister = (\x -> errorth ("Undefined var "++x),0,[])
initialRegister2 = (\x -> errorth ("Undefined var "++x),-1200,[])

registerVar :: VarRegister -> PIdent -> VarRegister
registerVar register@(rename,current,registered) string =
  if string `elem` registered 
  then register else
  (\ x -> if x==string then current else rename x,
   current+1,
   string:registered)

lookupVar :: VarRegister -> PIdent -> Int
lookupVar (rename,_,_) string = rename string

ppterm :: VarRegister -> PTerm -> Msg
ppterm register (PVar ident) = Var (lookupVar register ident)
ppterm register (PCompT operator [t1,t2]) =
  BinOp (stringToOp operator) (ppterm register t1) (ppterm register t2)
ppterm register (PCompT operator [t]) =
  UnOp (stringToOp operator) (ppterm register t)
ppterm register (PConst str) = (Atom atom_incomparable str)
ppterm register t = 
  errorth ("Illegal term "++(show t))


--- this variant is called for topdec-stuff and replaces all unary operators by binary operators
ppterm2 :: VarRegister -> PTerm -> Msg
ppterm2 register (PVar ident) = Var (lookupVar register ident)
ppterm2 register (PCompT operator [t1,t2]) =
  BinOp (stringToOp operator) (ppterm2 register t1) (ppterm2 register t2)
ppterm2 register (PCompT operator [t]) =
  BinOp (stringToOp operator) (ppterm2 register t) (ppterm2 register t)
ppterm2 register (PConst str) = (Atom atom_incomparable str)
ppterm2 register t = 
  errorth ("Illegal term "++(show t))


parseDecana :: [PDecana] -> DecanaTheo 
parseDecana [] = []
parseDecana ((term,cases):decanas) =
 let vars = ptermvars term
     vars2 = filter (\ x-> not (x `elem` vars)) 
              (concatMap (\ (i,_,_) -> pineqvars i) cases)
     register = foldl registerVar initialRegister2 ( vars ++ vars2)
 in
  (map (\ (i,k,r) -> 
         (ppterm register term, 
          if i==[] then [Tauto] else map (ppineq (map (lookupVar register) vars2) register) i, 
          if k==[] then ppterm register term
          else pppterm register k, 
          pppterm register r))
   cases)++(parseDecana decanas)

ptermvars :: PTerm -> [PIdent]
ptermvars (PVar id) = [id]
ptermvars (PCompT op list) = concatMap ptermvars list
ptermvars _ = []

pineqvars :: [(PTerm,PTerm)]->[PIdent]
pineqvars = concatMap (\ (x,y) -> (ptermvars x)++(ptermvars y))

ppineq :: [Var] -> VarRegister -> (PTerm,PTerm) -> Inequality
ppineq v vr (t1,t2) = Negsub v [(ppterm vr t1,ppterm vr t2)]


pppterm :: VarRegister -> [PTerm] -> Msg
pppterm vr = (foldl1 (BinOp opNAPair)) . (map (ppterm vr))


mifoldl1 f x = if (length x) ==0 then atom_i else foldl1 f x
 
