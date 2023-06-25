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

module If2Horn(if2horn,aslan2horn,HornRep) where
import Data.Maybe
import qualified Data.Map as Map
import Data.List
import Ast
import Msg
import Translator
import NewIfParser
import NewIfLexer
import FPTranslator



if2horn :: PProt -> HornRep
if2horn = if2horn0 (HR { initialH = [], absrulesH = [], rulesH = [], typesH = [] })

if2horn0 hr [] = hr
if2horn0 hr ((PTypeSec t):prot) = if2horn0 (type2horn hr t) prot
if2horn0 hr ((PInitSec [(_,state)]):prot) = if2horn0 (init2horn hr state) prot
if2horn0 hr ((PRuleSec rules):prot) = if2horn0 (transrules hr rules) prot
if2horn0 hr ((PGoalSec _):prot) = if2horn0 hr prot
if2horn0 hr _ = error ("Something in spec is "++notyet)

transrules hr [] = hr
transrules hr ((_,((lhs,cond),rhs,fresh)):rules) = 
  if null cond
  then let tr (Plain fact) = translateFact fact
           tr _ = error ("Negative facts are "++notyet)	
	   getfresh (f,Nothing) = f
	   getfresh _ = error ("Abstraction annotation is "++notyet)
       in  transrules 
       	   (hr{ absrulesH = (absrulesH hr)++
	   		    [(map tr lhs,
			     [],
	   	       	     map getfresh fresh,
			     map translateFact rhs)]})
	   rules
  else error ("Conditions in rules are "++notyet)

init2horn hr (pnstate,eq) = 
  let gethonestAgs [] = []
      gethonestAgs ((PNot (PEq (PVar alice) (PConst "i"))):xs) = 
      		   alice:(gethonestAgs xs)
      gethonestAgs _ = error ("Initial state has some condition that is "++notyet)
  in  hr { initialH = translateInitState pnstate (gethonestAgs eq)}

translateInitState [] _ = []
translateInitState ((Not _):_) _ = error ("Negative facts are "++notyet)
translateInitState ((Plain fact):facts) honestAgs =
  let f = translateFact fact
      p = getplayer f
      initialsub = if null p then (\ x -> x) 
      		   else (addSub (\x -> x) (head p) (Atom "a"))
      v = nub ((factvars f) \\ (p++honestAgs))
      insts [] sub = [sub]
      insts (n:names) sub = (insts names (addSub sub n (Atom "i")))++
      	    	      	    (insts names (addSub sub n (Atom "a")))
  in  nub ([subfact sub f | sub <- insts v initialsub]++(translateInitState facts honestAgs))
      
--- only return unsubstitutable variable, so to speak
getplayer :: Fact -> [Ident]
getplayer (FPState role ((Atom player):rest)) = if isVariable player then [player] else []
getplayer (State _ _) = error "Hae?"
getplayer _ = []


factvars :: Fact -> [Ident]
factvars = nub . (concatMap vars) . getMsgs

translateFact :: PFact -> Fact
translateFact ("iknows",[msg]) = Iknows (translateMsg msg)
translateFact (fact,msgs) =
  if isPrefixOf "state_" fact 
  then (FPState (drop 6 fact) (map translateMsg msgs))
  else (Fact fact (map translateMsg msgs))

translateMsg :: PTerm -> Msg
translateMsg (PConst id) = Atom id
translateMsg (PVar id) = Atom id
translateMsg (PCompT id ts) = 
  Msg.Comp
  (case id of
   "crypt" -> Crypt
   "scrypt" -> Scrypt
   "pair" -> Cat
   "inv" -> Inv
   "exp" -> Exp
   "xor" -> Xor
   "apply" -> Apply
   _ -> Userdef id)
  (map translateMsg ts)

type2horn hr [] = hr
type2horn hr ((Decl (NewIfParser.Comp _ _) _):_) = error ("Composed types "++notyet)
type2horn hr ((Decl (Atomic typ) idents):types) = 
  let hrtyp = transtyp typ 
  in
  type2horn 
  (case [ ids | (hrtyp',ids) <- typesH hr, hrtyp==hrtyp' ] of
   [] -> hr { typesH = (hrtyp,idents):(typesH hr)}
   [ids] ->  hr { typesH = (hrtyp,idents++ids):[(hrtyp',ids)| (hrtyp',ids) <- typesH hr, hrtyp/=hrtyp'] }) types
 
transtyp "agent" = Agent False False
transtyp "text" = Number
transtyp "function" = Function
transtyp "symmetric_key" = SymmetricKey
transtyp "public_key" = PublicKey
transtyp t = error ("Type "++t++notyet) 

aslan2horn :: String -> HornRep
aslan2horn = if2horn . parser . alexScanTokens

notyet = " not yet supported by the FP module, please use classic mode."