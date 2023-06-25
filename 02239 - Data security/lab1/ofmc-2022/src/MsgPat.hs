{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

-------- Msg Patterns ------------------------------------

module MsgPat(ProtocolState,mkname,initialState,receiveMsg,sendMsg,receiveLMsg,lversion,synthesisPattern,replacePat) where
import Msg
import LMsg
import Ast
import Data.List
import Data.Maybe
import AnBOnP

---type LMsg = (Msg,Msg)

-- | The type @ProtocolState@ characterizes the local state of an
-- honest agent in a protocol execution by a set of labeled messages,
-- i.e. the form the messages are supposed to have according to the
-- AnB specification and the actual view on that form that the agent
-- in question has.
type ProtocolState = [LMsg]

-- | Pretty printing labeled messages
ppLMsg ot (Atom x,Atom y) = (ppId x)++"%"++(ppId y)
ppLMsg ot (m, Atom y) = (ppMsg ot m)++"%"++(ppId y)
ppLMsg ot (Comp f xs, Comp g ys) = 
  let zs = zipl xs ys in
  case f of 
  Cat -> ppLMsgList ot zs
  Apply -> ((ppLMsg ot) (head zs))++"("++(ppLMsgList ot (tail zs))++")"
  Crypt -> "{"++(((ppLMsg ot) . head . tail) zs)++"}"++(ppLMsg ot (head zs))
  Scrypt ->  "{|"++(((ppLMsg ot) . head . tail) zs)++"|}"++(ppLMsg ot (head zs))
  _ -> (show f)++"("++(ppLMsgList ot zs)++")"

-- | Print a list of labeled messages
ppLMsgList :: OutputType -> [LMsg] -> String
ppLMsgList Pretty = ppXList (ppLMsg Pretty) "\n"
ppLMsgList ot = ppXList (ppLMsg ot) ","

-- | switch for an experimental version
lversion :: Bool
lversion = False 

--- internal function -- | This function is initially used to get a labeling for messages
mklabel :: Msg -> LMsg
mklabel = (\x -> (x,mkname x))

-- | generate the initial state of a local agent from its knowledge specification
initialState :: [Msg] -> ProtocolState
initialState ik0 =
 if lversion then ((\ (x,y)->x++y) . lanalysis . (map mklabel)) ik0 else
 let ik = analysis ik0 in
 map (\ x -> (x,reshape ik x)) ik

-- | compute the new protocol state of an agent that corresponds to
-- the reception of a new message. This is typically used for the LHS
-- state-fact of an honest agent in a transition rule: given the state
-- after the last transition rule (a list of labeled messages) and the
-- newly received message (without label), compute the labeled
-- messages for the state-fact of the LHS.
receiveMsg :: Msg -> ProtocolState -> ProtocolState
receiveMsg msg state =
  if lversion then
   let (m':ik0,new) = lanalysis ((msg,(reshape (map fst state) msg)):state)
   in ik0++new++[m']
 else
  let ik0 = map fst state
      ik  = analysis (msg:ik0)
      nik = ik \\ (msg:ik0)
  in 
  (map (\(m,p) -> (m,reshapePat ("In receiveMsg\n"++(show msg)++"\n"++(show state)) ik (m,p))) state)
  ++ (map (\ msg -> (msg, reshape ik msg)) nik)
  ++ [(msg,reshape ik msg)]

--- possible improvement: only the incoming message is stored, not
--- all the other messages from NIK. Note that some functions rely
--- on an analyzed intruder knowledge.
reshape :: [Msg] -> Msg -> Msg
reshape ik (Atom a)=Atom a
reshape ik (msg@(Comp f xs)) =
 if f==Exp || f==Xor then 
  case 
   [(f',xs') |
   (Comp f' xs') <- eqMod  eqModBound stdTheo [msg], f==f',
   all (indy ik) xs']
  of
  [] -> mkname msg
  ((f',xs'):_) -> Comp f' (map (reshape ik) xs')
 else
  case (opening msg) of
  Nothing ->  error "Invariant violation (Nothing in reshape)" 
  Just list -> if all (indy ik) list 
	       then Comp f (map (reshape ik) xs)
	       else mkname msg

showik = ppXList (ppMsg IF) "\n"

reshapePat :: String -> [Msg] -> LMsg -> Msg

reshapePat str ik m =  
 case m of
 (Comp Apply _,Comp Cat _) -> error ("Incompatible reshape pattern: "++str) 
 _ -> 
  case (reshapePat0 ik m) of
  Nothing -> error ("Pattern Problem:\n"++(showik ik)++"\n->\n"++(ppLMsg Pretty m)++" ")
  Just p -> p


reshapePat0 :: [Msg] -> LMsg -> Maybe Msg
reshapePat0 ik (Atom a,Atom b)=
  if a==b then Just (Atom a) else Nothing 
reshapePat0 ik (Atom a,Comp f xs) =
  error ("Pattern "++(show (Comp f xs))++" more concrete than actual msg "++a)
reshapePat0 ik (msg@(Comp f xs),pat@(Atom a)) =
 if f==Xor then if all (indy ik) xs then Just (Comp Xor (map (reshape ik) xs)) else Just (Atom a) else
  case (opening msg) of
  Nothing -> error "Invariant violated: Nothing in reshape" 
  Just list -> if all (indy ik) list 
	       then Just (Comp f (map (reshape ik) xs))
	       --- here we need to go into classical reshape as
	       --- further pattern is not yet available
	       else Just (Atom a) 
	       --- get the old pattern
reshapePat0 ik (msg@(Comp Apply xs),pat@(Comp Cat ys)) = error ("Incompatible patterns:\n"++(show ik)++"\n"++(show msg)++"\n"++(show pat))
reshapePat0 ik (msg@(Comp f xs),pat@(Comp g ys)) 
 |f==Apply && g==Cat = error "Super duper strange."
 |otherwise =
  if msg==pat then (Just pat) else
  if f==Exp || f==Xor then 
    (listToMaybe
     [ Comp g xs''
         |
         (Comp f' xs') <- eqMod eqModBound stdTheo [msg], f==f', 
         (xs'' -- ::[ Msg]
           ) <- [catMaybes (map (reshapePat0 ik) (zipl xs' ys))],
         (length xs'')==(length xs)])
  else
   if f==g then 
    let test = zipl xs ys in
    if null (filter (\ x -> case x of 
       	    	            (Comp Apply _, Comp Cat _) -> True 
		  	    _ -> False) test) then
      deJust f (mapM (reshapePat0 ik) (zipl xs ys))
    else error ("Show :\n"++(show msg)++"\n"++(show msg))
   else if f==Apply && g==Cat then error "It is apply and Cat" 
   else error ("Patterns do not completely agree:\n\n"++(show msg)++"\n\nvs.\n\n"++(show pat))

deJust f (Just ms) = Just (Comp f ms)
deJust f Nothing = Nothing

opening :: Msg -> Maybe [Msg]
opening msg = 
  case msg of
  Comp Crypt [Comp Inv [k],m] -> Just [k]
  Comp Crypt [k,m] -> Just [Comp Inv [k]]
  Comp Scrypt [k,m]-> Just [k]
  Comp Cat _ -> Just []
  Comp Inv [k] -> Just []
  Comp Apply ms -> Just ms
  Comp Exp ms -> Just ms
  Comp Xor ms -> error "Opening: didn't cach XOR"
  _ -> error ("Opening: Not yet supported: "++(show msg))

--- Note: when using probabilistic encryption, we actually  cannot check that
--- {M}K has form {.}. even if we know M and K, but not inv(K).
--- We leave it, though, as probabilistic encryption must be modeled
--- by explicit nonces (introduced by AnBParser).

-----------------------

-- | Counterpart to receiveMsg: given a message to be sent (according
-- to the protocol specification) and the current execution state as a
-- list of labeled messages, check that, and how, this sendendum can
-- be generated and add it with appropriate label to the protocol state.
sendMsg :: Msg -> ProtocolState -> ProtocolState
sendMsg msg state =
  case synthesisPattern state msg of
  Nothing -> error ("Protocol not executable:\n\n"++
  	     	    "At the following state of the knowledge:\n"++
		    (ppLMsgList Pretty state)++"\n\n"++
		    "...one cannot compose the following message:\n"++
  	     	    (ppMsg Pretty msg)++"\n"++
		    (getProblem state msg "")
		   )
  Just p -> state++[(msg,p)]

getProblem :: ProtocolState -> Msg -> String -> String
getProblem ik (Atom a) ind = ""
getProblem ik (Comp f xs) ind =
  concat [ ind++(ppMsg Pretty x)++"\n"++
  	   (getProblem ik x (ind++"|")) 
	 | x <- xs, isNothing (synthesisPattern ik x) ]
    

-- | Given a protocol state and an unlabled message (on AnB level) to
-- compose, check if that is possible, and if so, give a label for that. 
synthesisPattern :: ProtocolState -> Msg -> (Maybe Msg)
synthesisPattern ik =
  listToMaybe . 
  catMaybes .
  (map (synthesisPattern0 ik)) .
  (eqMod 3 stdTheo) .
  return

synthesisPattern0 :: ProtocolState -> Msg -> (Maybe Msg)
synthesisPattern0 ik m =
  case getElem m ik of
  Just p -> Just p
  Nothing ->
   case m of
    Atom _             -> Nothing
    Comp Inv _         -> Nothing
    Comp (Userdef _) _ -> error ("Not yet supported: "++(show m))
    Comp Xor list      -> 
     let ik0=map fst ik in
     if synthesizable ik0 m then 
      if (all (synthesizable ik0) list) then
        Just (Comp Xor (map (fromJust . (synthesisPattern0 ik)) list))
      else
        head
        [ Just (normalizeXor (mkxor d1 d2))
	| (Comp Xor l1,d1) <- ik,
	  (Comp Xor l2,d2) <- ik,
	  l1/=l2, 
	  m==normalizeXor (Comp Xor (l1++l2))
	]
     else Nothing
    Comp f ms          -> 
     let mps = map (synthesisPattern0 ik) ms
     in if Nothing `elem` mps then Nothing
        else Just (Comp f (map fromJust mps))

replacePat :: ProtocolState -> Msg -> [Msg]
replacePat _ m = [m]


mkxor (Comp Xor l1) (Comp Xor l2) = Comp Xor (l1++l2)
mkxor (Comp Xor l1) b = Comp Xor (b:l1)
mkxor a (Comp Xor l2) = Comp Xor (a:l2)
mkxor a b = Comp Xor [a,b]

getElem x [] = Nothing
getElem x ((m,p):mps) = if x==m then Just p else getElem x mps

-------------------

enlabel ((Atom a),(Atom b)) = (Atom a,Atom b)
enlabel ((Comp f xs), (Comp g ys)) = 
  if f/=g || (length xs)/=(length ys) then error "error in function enlabel" else
  let (xs',ys') = unzip (map enlabel (zipl xs ys))
  in (Comp f xs', Comp g ys')
enlabel ((Comp f xs),(Atom b)) = ((Comp f xs),mkname (Atom b))

-- | Variant of receiveMsg when pattern for the received message is
-- given (for modeling zero-knowledge proofs).
receiveLMsg :: LMsg -> ProtocolState -> ProtocolState
receiveLMsg (msg,msgp) state =
 if lversion then
   let (m':ik0,new) = lanalysis ((enlabel (msg,msgp)):state)
   in (ik0++new++[m'])
 else 
  let ik0  = map fst state
      ik   = analysis (msg:ik0)
      nik  = ik \\ ik0
  in 
  (map (\ (m,p) -> (m,reshapePat "" ik (m,p))) state)
  ++ (reshapePatAna (msg,msgp) (nik\\[msg]))
  ++ [(msg,reshapePat "" ik (msg,msgp))]

reshapePatAna :: LMsg -> [Msg] -> [LMsg]
reshapePatAna (msg,msgp) ik =
  let mmap = allposL (msg,msgp) 
      lookup m = let mp = [ p | (m',p) <- mmap, m==m'] in 
      	       	 if null mp then error ("did not find "++(ppMsg Pretty m)) else head mp
  in map (\m -> (m,lookup m)) ik

allposL :: LMsg -> [LMsg]
allposL (mp@(Comp f xs, Comp g ys)) = 
 if f==g then mp:(concatMap allposL (zipl xs ys))
 else error ("Pattern problem:\n"++(show f)++"\nvs\n"++(show g))
allposL mp = [mp]

{-
getKnowPat :: LMsg -> [Msg]
getKnowPat (m,p) = nub (m:(getKnow0 (m,p)))

getKnow0 (Atom x,Atom _) = [Atom x]
getKnow0 (Atom x,_) = error "Pattern more precise than term!"
getKnow0 (Comp f xs,Atom y) = [Atom y] 
getKnow0 m@(Comp Apply (f:xs),Comp Apply (g:ys)) = 
  if f/=g then error ("Message Pattern!"++(show m)) else
  (Comp Apply (f:xs)):(concatMap getKnow0 (zipl xs ys))
getKnow0 m@(Comp f xs,Comp g ys) = 
  if f/=g then error ("Message Pattern!"++(show m)) else
  (Comp f xs):(concatMap getKnow0 (zipl xs ys))

-}