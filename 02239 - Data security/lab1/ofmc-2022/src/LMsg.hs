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

---------- Messages -----------------------

module LMsg(LMsg,lanalysis,mkname,zipl)  where
import Msg 
import Data.List
import Data.Maybe
import StateMonad
import AnBOnP

-- | Labeled message: the message itself as it was specified in AnB,
-- and another message labeling it, representing the view that a
-- particular agent has on it. Example: @(h(N),HN)@ if we have what is
-- supposed to be a hash of a nonce, and we model an agent who cannot
-- check this (because he does not know the nonce and cannot invert
-- it).
type LMsg = (Msg,Msg)

--------------------------------------------------
--------------------- Ground Dolev-Yao -----------

{-
lsynthesizable :: [LMsg] -> Msg -> Maybe Msg
lsynthesizable ik m =
 listToMaybe (catMaybes (map (lsynthesizable0 ik) (eqMod eqModBound stdTheo [m])))


lsynthesizable0 :: [LMsg] -> Msg -> Maybe Msg
lsynthesizable0 ik m =
  case catMaybes (map (\ (t,l) -> if t==m then Just l else Nothing) ik) of
  (x:_) -> Just x
  _ ->
   case m of
    Atom _             -> Nothing
    Comp Inv _         -> Nothing
    Comp (Userdef _) _ -> error ("Not yet supported: "++(show m))	
    Comp op ms         -> allMay op (lsynthesizable ik) ms

allMay :: Operator -> (Msg -> Maybe Msg) -> [Msg] -> Maybe Msg
allMay op f list =
 let list' = map f list in
  if all isJust list' 
  then Just (Comp op (catMaybes list'))
  else Nothing
-}

llsynthesizable :: [LMsg] -> Msg -> [Msg]
llsynthesizable ik m =
  if (synthesizable (map fst ik) m) then [m] else []

llsynthesizable0 :: [LMsg] -> Msg -> [Msg]
llsynthesizable0 ik m =
  (concatMap (\ (t,l) -> if t==m then [l] else []) ik)++
  (case m of
    Atom _             -> []
    Comp Inv _         -> []
    Comp (Userdef _) _ -> error ("Not yet supported: "++(show m))
    Comp op ms         -> lallMay op (llsynthesizable ik) ms)

lallMay :: Operator -> (Msg -> [Msg]) -> [Msg] -> [Msg]
lallMay op f =
 (map (Comp op)) . cartProd . (map f)

cartProd :: [[Msg]] -> [[Msg]]
cartProd = 
  foldr 
  (\ list lists 
  -> [x:xs|x<-list, xs<-lists])
  [[]]

data AnalysisState = AnaSt { new  :: [LMsg],
			     test :: [LMsg],
			     done :: [LMsg],
			     ik0  :: [LMsg],
			     sub  :: Substitution }


linitAna lik = AnaSt 
 { new=lik,test=[],done=[],sub= \x->x, ik0=lik }

type AnaM a = State AnalysisState a

top     = do st <- get
	     (return . head . new) st
getik   = do st <- get
	     return (nub ((new st) ++ (done st) ++ (test st)))
getikOut= do st <- get
	     return (ik0 st,(nub (((new st) ++ (done st) ++ (test st))\\(ik0 st))))
pop     = do st <- get
	     put (st {new  = tail (new st), done = (head (new st)):(done st)})
delay   = do st <- get
	     put (st {new  = tail (new st), test = (head (new st)):(test st)})
push ms = do pop
	     st <- get
	     put (st {new = ms++(new st)++(test st),test = []})
isEmpty = do st <- get
	     return (null (new st))
substitute x t = do st <- get
	       	    sub' <- return (addSub (sub st) x t )
	       	    put (st {new=sublml sub' (new st),
		    	        test=sublml sub' (test st),
			        done=sublml sub' (done st),
				ik0=sublml sub' (ik0 st),	
			        sub=sub'})
obtainName x = do st <- get
	       	  return ((sub st) (mkname x))

sublml :: Substitution -> [LMsg] -> [LMsg]
sublml sub = map (\ (t,d) -> ( sub t, sub d)) 



lanalysis0 = 
  do b <- isEmpty
     (if b then getikOut else 
      do x <- top
         ik <- getik
         (case fst x of
          Atom _ -> pop
          Comp Crypt [Comp Inv [k],p] ->
            --- another way to derive p! 
	    --- so we do not do this check: 
            --- if synthesizable ((map fst ik)\\[fst x]) p then pop else
            case llsynthesizable (ik\\[x]) k of
	    [] -> delay
	    l -> 
	      case snd x of 
	      Comp Crypt [k',p'] -> 
	        push [(p,p')]
              Atom x ->
	        do p'<-obtainName p
		   k'<-obtainName (Comp Inv [k])
		   substitute x (Comp Crypt [k',p'])
		   push [(p,p')]
	      _ -> error ("Decomposition: "++(show x))
          Comp Crypt [k,p] -> 
            case llsynthesizable (ik\\[x]) (Comp Inv [k]) of
	    [] -> delay
	    l -> 
	      case snd x of 
	      Comp Crypt [k',p'] -> 
	        push [(p,p')]
              Atom x ->
	        do p'<-obtainName p
		   k'<-obtainName k
		   substitute x (Comp Crypt [k',p'])
		   push [(p,p')]
	      _ -> error ("Decomposition: "++(show x))
          Comp Scrypt [k,p] -> 
	    case llsynthesizable (ik\\[x]) k of
	    [] -> delay
	    l -> 
	      case snd x of
	      Comp Scrypt [k',p'] ->
	       push [(p,p')]
	      Atom x ->
	       do p' <- obtainName p
	          k' <- obtainName k
	          substitute x (Comp Scrypt [k',p'])
	          push [(p,p')]
	      _ -> error ("Decompositon: "++(show x))
          Comp Cat ms  ->
	    case snd x of 
	    Comp Cat ms' -> push (zipl ms ms')
	    Atom x -> do ms' <- mapM obtainName ms
	    	      	 substitute x (Comp Cat ms')
			 push (zipl ms ms')
            _ -> error ("Decompositon: "++(show x))
          Comp Inv   _ -> pop
          Comp Apply ms -> 
           case snd x of
	   Comp Apply _ -> pop
	   Atom a ->
	    let ms' = map (llsynthesizable (ik\\[x])) ms in 
	    if [] `elem` ms' then do delay
	    else do substitute a (Comp Apply (map head ms'))
	    	    pop
          Comp Exp   _ -> pop 
	  Comp Xor [a,b] -> 
	   case (llsynthesizable (ik\\[x]) a,llsynthesizable (ik\\[x]) b) of
	   ([],[]) -> delay
	   _ -> case (snd x) of
	     	Atom t -> do a' <- obtainName a
		       	     b' <- obtainName b
			     substitute t (Comp Xor [a',b'])
			     push [(a,a'),(b,b')] 
		Comp Xor [a',b'] -> push [(a,a'),(b,b')]
		_ -> error ("Lanalysis not yet supported: "++(show x))
          _ -> error ("Lanalysis not yet supported: "++(show x)))
	 lanalysis0)

-- | Like zip with an additional check that the lengths of the zipped lists are identical
zipl :: [a] -> [b] -> [(a,b)]
zipl l1 l2 = if (length l1)==(length l2) then zip l1 l2 else error "ZIP with different length!"

-- | Main analysis function: given a set of labeled messages, compute
-- the closure under analysis rules. This is typically used in the
-- translation step after an agent has learned a new message. The
-- existing labels of the messages may be updated by this, because
-- analysis reveals new checks that can be performed. Also, the result
-- distinguishes the 'old' and 'new' messages (i.e. messages that were
-- part of the given knowledge but may have new labels are
-- distinguished from messages obtained by analysis steps).
lanalysis :: [LMsg] -> ([LMsg],[LMsg])
lanalysis = 
  (evalState lanalysis0) . linitAna



------------ Pretty Printing -----------------------
{-
ot = IF
ppLMsg :: Msg -> String
ppLMsg (Atom x) = ppId x
ppLMsg (Comp f xs) = 
  case f of 
  Cat -> catty ot xs
  Apply -> "apply("++(ppLMsgList xs)++")"
  Crypt -> "crypt("++(ppLMsgList xs)++")"
  Scrypt -> "scrypt("++(ppLMsgList xs)++")"
  Inv -> "inv("++((ppLMsg.head) xs)++")"
  Exp -> "exp("++((ppLMsgList.deCat.head) xs)++")"
  _ -> (show f)++"("++(ppLMsgList xs)++")"
ppLMsgList = ppXList ppLMsg ","
-}


-- | This function generates a 'unique' variable name of the form @Xsomething@ from a given message; 
mkname :: Msg -> Msg
mkname x = Atom ("X"++(mkname0 x) )
 where mkname0 = foldMsg (\a->a) 
		 (\f xs-> (if printable f then show f else "")++(concat xs))
       printable f =  f `elem` [Crypt,Scrypt,Exp,Inv,Xor]
