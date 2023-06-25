{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module Translator where
import Constants
import Ast
import Msg
import LMsg
import MsgPat
import Data.List
import Data.Maybe
import AnBOnP

--------- Facts, Rules, and the Translation State ---------------

data Fact = State Ident [LMsg]
     	  | FPState Ident [Msg]
          | Iknows Msg
	  | Fact Ident [Msg]
	  deriving (Eq,Show)

type Rule = ([Fact],Eqs,[Ident],[Fact])
lhs (l,_,_) = l
rhs (_,_,r) = r
frv (_,f,_) = f

identsF :: Fact -> [Ident]
identsF (State _ msgs) = error "identsf of state"
identsF (FPState _ msgs) = nub (concatMap idents msgs)
identsF (Iknows msg) = nub (idents msg)
identsF (Fact _ msgs) = nub (concatMap idents msgs)

identsFL m = nub (concatMap identsF m)

type Rule' = (Rule,ProtocolState,ProtocolState)

type Eqs = [(Msg,Msg)]

type Role = (Ident,[Rule'])

data ProtocolTranslationState = PTS { protocol :: Protocol,
     			      	      options  :: AnBOptsAndPars,
				      roles    :: [Role],
				      rules    :: [Rule],
				      initial  :: String }

mkPTS :: Protocol -> AnBOptsAndPars -> ProtocolTranslationState
mkPTS protocol options = PTS { protocol = protocol, options = options, roles=[], rules=[],initial="" }
				       

---- Translation Stage 1: Creating Rules 
----------------------------------------

createRules :: ProtocolTranslationState -> ProtocolTranslationState
createRules pts =
  let (p@(_,types,knowledge,abstractions,actions,goals)) = protocol pts
      frMsg = fresh p 
      pks = concatMap snd ((filter (\ (x,y) -> x==PublicKey)) types)
      roles = 
       (snd . head . 
        (filter (\ x -> case (fst x) of Agent _ _ ->True;_ -> False))) 
	types 
  in pts {rules = manageRules 0 frMsg (\x -> initialState (lookupL x knowledge)) actions pks}

manageRules step fresh states actions pks =
        --- about step number (=list index+1)
        --- initially 0: there is no incoming message
        --- finally (length actions): there is no outgoing message
	let ((a,ctin,b,min,minp,minzk),(b',ctout,c,mout,_,_))
             = if step == (length actions) 
	       then (toJust (Just (last actions)),toJust Nothing) else 
	       if step == 0
	       then (toJust Nothing, toJust (Just (head actions))) else
	       (toJust (Just (actions !! (step-1))), 
	        toJust (Just (actions !! step)))
            thisfresh = case mout of 
			Nothing -> []
			Just (_,_,_,mout',_) -> 
			  intersect fresh (idents mout')
            freshpks = intersect pks thisfresh
            ub = if b==Nothing 
	         then if b'==Nothing 
		      then error ("Undefined Receiver in step"++(show step))
		      else fromJust b'
                 else if b'==Nothing 
		      then fromJust b
		      else if b/=b' 
			   then error ("Receiver: "++(show b)++
				       " and Sender/NextMsg is "++(show b'))
			   else fromJust b
	    (rule,state')=createRule thisfresh freshpks ub (states ub) min mout in
  	   rule:
	   (if step == (length actions) then [] else
	    manageRules (step+1) (fresh \\ thisfresh) 
	    (\x -> if x==ub then state' else states x) actions pks)

createRule fresh freshpks role state incomin outgoin = 
       let (state1,msg1) = 
             case incomin of
             Nothing -> (state,Atom "i")
	     Just (sender,ct,receiver,recm,Nothing) -> 
              let st = (receiveMsg recm state) in
	      (st,chtrafo False sender ct receiver (snd (last st)))
	     Just (sender,ct,receiver,recm,Just recmp) -> 
              let st = (receiveLMsg (recm,recmp) state) in
	      (st,chtrafo False sender ct receiver (snd (last st)))
           (state2,msg2) = 
             case outgoin of
             Nothing -> (state1,Atom "i")
	     Just (sender,ct,receiver,sndm,_) ->
              let state1'=peertrafo receiver msg1 state1
		  st = sendMsg sndm (state1'++(map (\x -> (Atom x,Atom x)) fresh)++(map (\x -> (Comp Inv [Atom x],Comp Inv [Atom x])) freshpks))
	      in (st,chtrafo True sender ct receiver (snd (last st)))
       in  
       (((State role 
          (((nubBy eqSnd) . (\x -> (Atom role, Atom role):(x++[(Atom "SID",Atom "SID")])) . 
	    (take (length state))) state1)):
         (if msg1==(Atom "i") then [] else [Iknows msg1]),[],
	 fresh,
	 (State role
          (((nubBy eqSnd)  . (\x -> (Atom role,Atom role):(x++[(Atom "SID",Atom "SID")]))) state2)):
	 (if msg2==(Atom "i") then [] else [Iknows msg2])),state2)

eqSnd (_,a) (_,b) = a==b

isAgent (Agent _ _)  = True
isAgent _ = False
gettype :: Types -> Ident -> Type
gettype types id = let typedec = map fst $ filter (elem id . snd) types 
                   in if (length typedec) == 0 then error $ id++" has no declared type."
                      else if (length typedec)>1 then error $ id++" has conflicting type declarations: "++(show typedec)
                      else head typedec 

fresh :: Protocol -> [Ident]
fresh (_,types,(knowl,_),_,actions,_) =
  let longterm = nub $ concatMap ((concatMap idents) . snd) knowl
      all = nub $ concatMap (\ (_,m,_,_) -> idents m) actions
            --- here we don't count sender/receiver names (can't be fresh)
      fresh = nub ( all \\ longterm)
      longterm_fresh = filter (not . isAgent . (gettype types)) (filter isVariable longterm)
      const_fresh = filter (not . isVariable) fresh
  in if const_fresh/=[] then error $ "Error: the following constant(s) are not contained in initial knowledge of any role: "++(ppIdList const_fresh)
     else if longterm_fresh/=[] then error $ "Error: the following variable(s) occur in the initial knowledge but are not of type agent: "++(ppIdList longterm_fresh)
     else fresh

toJust :: Maybe Action -> 
	  (Maybe Ident,ChannelType,Maybe Ident,
	   Maybe(Peer,ChannelType,Peer,Msg,Maybe Msg),
	   Maybe Msg,Maybe Msg)
toJust Nothing = (Nothing,Secure,Nothing,Nothing,Nothing,Nothing)
toJust (Just ((sp@(a,_,_),ct,rp@(b,_,_)),m,mp,zk)) = 
       (Just a,Secure,Just b,Just (sp,ct,rp,m,mp),mp,zk)

---------- Channel Transformation ---------

chtrafo :: Bool -> Peer -> ChannelType -> Peer -> Msg -> Msg

chtrafo isSender (sender,psender,Just _) ct (receiver,preceiver,_) msg = 
  error "Not yet implemented: custom pseudos in protocol."
chtrafo isSender (sender,psender,_) ct (receiver,preceiver,Just _) msg = 
  error "Not yet implemented: custom pseudos in protocol."

chtrafo isSender (sp@(sender,psender,Nothing)) ct (rp@(receiver,preceiver,Nothing)) msg = 
  case ct of
   Insecure ->
    if psender then
      let id = if isSender then peerToMsgKnwn sp
	                   else peerToMsgUKnwn sp in
        (Comp Cat 
	 [id,msg])
    else
	 msg
   Authentic -> 
    if psender then
      let id = if isSender then peerToMsgKnwn sp
	                   else peerToMsgUKnwn sp in
        (Comp Cat 
	 [id,
	  Comp Crypt 
	  [Comp Inv
	   [Comp Apply 
	    [Atom "authChCr",id]],
           msg]])
    else
     (Comp Crypt [Comp Inv [Comp Apply [Atom "authChCr",Atom sender]],msg])
   Confidential ->
    if preceiver then 
      let id = if isSender then peerToMsgUKnwn rp
			   else peerToMsgKnwn rp in
        (Comp Crypt [Comp Apply [Atom "confChCr",id],msg])

    else
    (Comp Crypt [Comp Apply [Atom "confChCr",Atom receiver],msg])
   Secure ->
    if psender then 
      let ids = if isSender then peerToMsgKnwn sp
	                    else peerToMsgUKnwn sp in
      if preceiver then error "Secure channel with mutual pseudonymity..."
      else 
       Comp Cat
       [ids,
        Comp Scrypt 
        [Comp Apply 
	 [Atom "secChCr",
	  Comp Cat
	  [ids,
	   Atom receiver]],
	 msg]]
    else if preceiver then
      let idr = if isSender then peerToMsgUKnwn rp
			    else peerToMsgKnwn rp in
        Comp Scrypt 
        [Comp Apply 
	 [Atom "secChCr",
	  Comp Cat 
	  [Atom sender,
	   idr]],
	 msg]
    else
    Comp Scrypt 
    [Comp Apply [Atom "secChCr",Comp Cat [Atom sender,Atom receiver]],
     msg]

peertrafo :: Peer -> Msg -> ProtocolState -> ProtocolState
peertrafo (receiver,ispseudo,Just _) inmsg protostate = 
  error "Not yet implemented: alternative pseudos in protocol."
peertrafo (receiver,ispseudo,Nothing) inmsg protostate =  
  let pseus = (nub . (filter (isPrefixOf "Pseudonym")) .
	       idents) inmsg in
  if (length pseus)>1 then error ("Too much pseudo in inmsgs="++
				  (show inmsg)++" namely "++(show pseus))
  else if (length pseus)==0 then 
	  if ispseudo then error ("Contact pseudo!"++(show inmsg)) else
	  protostate
       else
	let [pseu]=pseus in
	if (Atom pseu) `elem` (map snd protostate) then protostate
	else protostate++[(Atom pseu,Atom pseu)]

peerToMsgKnwn :: Peer -> Msg
peerToMsgKnwn (a,False,_) = Atom a
peerToMsgKnwn (a,True,Nothing)  = Comp Apply [Atom "pseudonym",Atom a]
peerToMsgKnwn (a,True,Just _)  = error "N/A"
peerToMsgUKnwn :: Peer -> Msg
peerToMsgUKnwn (a,False,_) = Atom a
peerToMsgUKnwn (a,True,Just _)  = error "N/A"
peerToMsgUKnwn (a,True,Nothing)  = Atom ("Pseudonym"++a)


lookupL :: Ident -> Knowledge -> [Msg]
lookupL x ([],_) = error ("Initial knowledge of role "++(show x)++" not specified.")
lookupL x (((y,k):ys),ineq) = if x==y then k else lookupL x (ys,ineq)


----- Translation Stage 2: add steps
------------------------------------

rulesAddSteps :: ProtocolTranslationState -> ProtocolTranslationState
rulesAddSteps pts = 
  let counter inc (State role (player:ids)) (facts,db) = 
       ((State role (player:(((\x -> (x,x)) . Atom . show) (db role)):ids)):facts,
        \x -> if x==role then (db role)+inc else db x)
      counter inc fact (facts,db) = (fact:facts,db)
      adds [] db = []
      adds ((l,[],f,r):xs) db =
       let (l',db') = foldr (counter 1) ([],db) l
           (r',db'') = foldr (counter 0) ([],db') r
       in (l',[],f,r'):(adds xs db'')
  in pts {rules = adds (rules pts) (\x -> 0)}

---- Translation Stage 3: adding goals
---------------------------------------

addGoals :: ProtocolTranslationState -> ProtocolTranslationState
addGoals pts =
 let rs = rules pts
 in 
  if lversion then pts else
  let (_,_,_,_,_,goals) = protocol pts
      folder (ChGoal ((speer@(sender,_,_)), channeltype, (rpeer@(receiver,_,_))) msg) rs =
        let (i,pattern) = findFirstKnow rs sender msg 1
	    pre = take (i-1) rs
	    post = drop (i-1) rs
	    (l,[],f,r) = head post
	    newfacts = 
	      (if channeltype==Secure || channeltype==Confidential 
	      	  || channeltype==FreshSecure
	       then [Fact "secret" [pattern,
				    goalpeer False
				        rpeer (head post)]]
	       else [])++
	      (if channeltype==Secure || channeltype==Authentic 
	      || channeltype==FreshAuthentic || channeltype==FreshSecure
	       then [Fact "witness" 
		     [goalpeer True -- peerToMsgKnwn 
		      speer (head post),
		      goalpeer False -- peerToMsgUKnwn 
		      rpeer (head post),
		      mkPurpose (Comp Cat [goalpeer True rpeer (head post2),
                                                          goalpeer False speer (head post2),
                                                          msg]),pattern]]
               else [])
	    rs' = pre++[(l,[],f,newfacts++r)]++(tail post)
	    (i2,pat) = findLastKnow rs' receiver msg 1 Nothing
	    pre2 = take (i2-1) rs'
	    post2 = drop (i2-1) rs'
	    (l2,[],f2,r2) = head post2
	    newfacts' =
	      (if channeltype==FreshSecure || channeltype==FreshAuthentic
	       then [Fact "request" [goalpeer True -- peerToMsgKnwn 
				     rpeer (head post2),
				     goalpeer False -- peerToMsgUKnwn 
				     speer (head post2),
				     mkPurpose (Comp Cat [goalpeer True rpeer (head post2),
                                                          goalpeer False speer (head post2),
                                                          msg]),pat,Atom "SID"]]
               else 
	       if channeltype==Secure || channeltype==Authentic
	       then [Fact "wrequest" [goalpeer True -- peerToMsgKnwn 
				      rpeer (head post2),
				      goalpeer False -- peerToMsgUKnwn 
				      speer (head post2),
				      mkPurpose (Comp Cat [goalpeer True rpeer (head post2),
                                                          goalpeer False speer (head post2),
                                                          msg]),pat]]
		else [])
	    rs2' = pre2++[(l2,[],f2,newfacts'++r2)]++(tail post2)
	in rs2' 
      folder (Secret msg peers b) rs =
        foldr (folder2 (Secret msg peers b)) rs peers
      folder2 (Secret msg (peers::[Peer]) False) (peer@(pee,_,_)::Peer) rs =
        let (i,pattern) = findLastKnow rs pee msg 1 Nothing
	    pre = take (i-1) rs
	    post = drop (i-1) rs
	    (l,[],f,r) = head post
            secrecyset = Comp Apply [Atom "secrecyset", Comp Cat [goalpeer False peer (head post), Atom "SID", mkPurpose msg]]
	    newfacts = 
	      ((Fact "secrets" [pattern, secrecyset]): --- was: Atom ("secrecyset(SID)")]):
	       [Fact "contains" [secrecyset, -- was: Atom "secrecyset(SID)",
	        goalpeer False p (head post)]
	       | p <- peers])
	    rs' = pre++[(l,[],f,newfacts++r)]++(tail post)
	in rs'
      -- new stuff: guessable secret (when flag of Secret... is true):
      folder2 (Secret msg (peers::[Peer]) True) (peer@(pee,_,_)::Peer) rs =
        updateAllContain rs pee msg 1 peer peers
{-
        let (i,pattern) = findLastKnow rs pee msg 1 Nothing
	    pre = take (i-1) rs
	    post = drop (i-1) rs
	    (l,[],f,r) = head post
            secrecyset = Comp Apply [Atom "secrecyset", Comp Cat [goalpeer False peer (head post), Atom "SID", mkPurpose msg]]
	    newfacts = 
	      ((Fact "secrets" [pattern, secrecyset]): --- was: Atom ("secrecyset(SID)")]):
	       [Fact "contains" [secrecyset, -- was: Atom "secrecyset(SID)",
	        goalpeer False p (head post)]
	       | p <- peers])
	    rs' = pre++[(l,[],f,newfacts++r)]++(tail post)
	in rs'
-}
  in pts {rules = foldr folder rs goals}

mkPurpose :: Msg -> Msg
mkPurpose m = Comp Apply [Atom "typePurpose", let (Atom s)= mkname m in (Atom $ "p"++(tail s))]
---mkPurpose (Atom m) = Comp Apply [Atom "typePurpose", Atom ("purpose"++m)]
---mkPurpose m = Comp Apply [Atom "typePurpose", Atom "purpose"]
  


goalpeer :: Bool -> Peer -> Rule -> Msg
goalpeer isKnown (a,False,Nothing) (_,[],_,r) = Atom a
goalpeer isKnown (a,True,Nothing) _ = 
	 if isKnown then (Comp Apply [Atom "pseudonym",Atom a])
	 else Atom ("Pseudonym"++a)
goalpeer isKnown (a,True,Just msg) (_,_,_,r) = 
  let (State role msgs) = head r in
  if msg `elem` (map snd msgs) then msg
  else let msg' = mkname msg
       in if msg' `elem` (map snd msgs) then msg'
	  else error "Pseudo not found!"
          
getKnow :: [Fact] -> Ident -> Maybe [LMsg]
getKnow [] ident = Nothing
getKnow ((State player know):facts) ident =
  if (player==ident) then Just know
  else getKnow facts ident
getKnow (f:fs) ident = getKnow fs ident

getSent :: [Fact] -> [Msg]
getSent [] = []
getSent ((Iknows m):fs) = m:(getSent fs)
getSent (_:fs) = getSent fs

findFirstKnow :: [Rule] -> Ident -> Msg -> Int -> (Int,Msg)
findFirstKnow [] ident msg i = 
  error ((ppMsg Pretty msg)++" is never known by "++(ppId ident))
findFirstKnow ((l,[],f,r):rules) ident msg i = 
  case getKnow r ident of
  Nothing -> findFirstKnow rules ident msg (i+1)
  Just know -> maybe (findFirstKnow rules ident msg (i+1)) (\x->(i,x))(synthesisPattern know msg) 

findLastKnow :: [Rule] -> Ident -> Msg -> Int -> Maybe (Int,Msg) -> (Int,Msg)
findLastKnow [] ident msg i Nothing = 
  error ((ppMsg Pretty msg)++" is never known by "++(ppId ident))
findLastKnow [] ident msg i (Just (n,pat))=(n,pat)
findLastKnow ((l,[],f,r):rules) ident msg i maybe_n_pat = 
  case getKnow r ident of
  Nothing -> findLastKnow rules ident msg (i+1) maybe_n_pat
  Just know -> 
    maybe (findLastKnow rules ident msg (i+1) maybe_n_pat)
    	  (\ x -> findLastKnow rules ident msg (i+1) (Just (i,x)))
	  (synthesisPattern know msg)

--updateAllContain :: [Rule] -> Ident -> Msg -> Int -> [Rule]
updateAllContain [] _ _ _ _ _  = []
updateAllContain ((l,[],f,r):rules) ident msg i peer peers =
 (
  case getKnow r ident of -- is this a rule for the specified peer ident?
  Nothing -> (l,[],f,r)  -- no
  Just know -> -- yes, the local knowledge is know
    case filter (\ (x,_) -> x==msg) know of  -- check for msg in the patterns
     [] -> (l,[],f,r)  -- not there, so skip
     ((_,m):_) -> 
       -- the concrete message is m, see if that is contained in the sent messages
       --let ms = filter (hasSubterm m) $ getSent r
       let sent = getSent r
           --ms0 = map (replaceST (Atom "guessPW") m) sent
           ms = concatMap (supertopcheckerbunny m) sent -- ms0 \\ sent
           secrecyset = Comp Apply
                        [Atom "guessSecrecyset",
                         Comp Cat [goalpeer False peer (l,[],f,r), Atom "SID", mkPurpose msg]]
	   newfacts = if null ms then [] else
	      ([Fact "guessChal" [m, secrecyset]|m<-ms]++
	       [Fact "contains" [secrecyset,goalpeer False p (l,[],f,r)]
	       | p <- peers])
       in  (l,[],f,r++newfacts)
 ):(updateAllContain rules ident msg (i+1) peer peers)

guessPW = Atom "guessPW"

supertopcheckerbunny :: Msg -> Msg -> [Msg]
-- stcb pw m  -- for a guessable password and a message that may contain it,
-- return all those messages that would constitute a successful guessing attack on m, replacing pw by guessPW
supertopcheckerbunny pw t =
  case t of
   (Comp Scrypt [k,m]) -> 
    let k' = replaceST guessPW pw k
        m' = replaceST guessPW pw m
    in if k'/=k then [k'] else
       if m'/=m then [Comp Scrypt [k',m']] else []
   (Comp Cat [m1,m2]) ->
     let m1' = replaceST guessPW pw m1
         m2' = replaceST guessPW pw m2
     in if m1/=m1' then [m1'] else []
        ++ if m2/=m2' then [m2'] else []
   (Comp Xor _) -> error "Guessing for XOR not implemented"
   _ -> let t' = replaceST guessPW pw t
        in if t'/=t then [t'] else []

replaceST :: Msg -> Msg -> Msg -> Msg
-- replaceST r s t = t[s->r]
replaceST r s t =
  if s == t then r else
  case t of
   Comp f ms -> Comp f $ map (replaceST r s) ms
   _ -> t


hasSubterm :: Msg -> Msg -> Bool
hasSubterm m1 m2 = m1 == m2 ||
  case m2 of
   Comp f ms -> any (hasSubterm m1) ms
   _ -> False

subtermList :: Msg -> [Msg] -> Bool
subtermList m = any (subterm m)

subterm :: Msg -> Msg -> Bool
subterm m1 m2 =
  if m1==m2 then True
  else case m2 of
        Atom _ -> False
	Comp f xs -> subtermList m1 xs






--- Stage 4: Adding the initial state
-------------------------------------

addInit :: ProtocolTranslationState -> ProtocolTranslationState
addInit pts=
  let (_,typdec,knowledge,_,_,_)=protocol pts
      args = options pts
      absInit = getinitials (rules pts) knowledge
      jn = numSess args
      n::Int
      n = if (jn==Nothing) 
	  then error "Unbounded sessions currently not supported." 
	  else fromJust jn
      (_,ineq) = knowledge
      (facts0,honest,aglili,agents0,ik0,ineq') = instantiate n absInit ineq
      facts = facts0++
              ik0++(getCrypto agents0)
      agents = ((++) ["i","A","B"]) agents0
  in
  pts { 
   initial = 
    (if typed args then 
       ("section types:\n"++
        (ppIdList agents)++",AnB_A,AnB_B:agent\n"++
     	(printTypes typdec)++"\n")
     else "")++
    "section inits:\n"++
    " initial_state init1 :=\n"++
    (ppFactList IF facts)++
    (concatMap (\x -> " & "++(ppId x)++"/=i") honest)++
---    (concatMap (\ (x,y) -> " & "++(ppId x)++"/="++(ppId y)) [(x,y) | x<-agents0, y<-agents0, x/=y])++
---    (error $ (show aglili) ++ (show (concatMap (\ (x,y) -> " & "++(ppId x)++"/="++(ppId y)) [(x,y) | l<-aglili, x<-l, y<-l, x/=y])))++ 
    (concatMap (\ (s,t) -> " & "++(ppMsg IF s)++"/="++(ppMsg IF t)) ineq')++
    "\n\n"++
    "section rules:\n"}
  
getCrypto :: [Ident]->[Fact]
getCrypto agents =
  map Iknows 
  ((Atom "confChCr"):(Atom "authChCr"):
   (Comp Inv [Comp Apply [Atom "authChCr",Atom "i"]]):
   (Comp Inv [Comp Apply [Atom "confChCr",Atom "i"]]):
   [Comp Apply [Atom "secChCr",Comp Cat [Atom "i",Atom other]]
   | other <- agents\\["i"]]++
   [Comp Apply [Atom "secChCr",Comp Cat [Atom other,Atom "i"]]
   | other <- agents\\["i"]]++
   [Comp Apply [Atom "secChCr",Comp Cat [Atom "i",Comp Apply [Atom "pseudonym",Comp Cat [Atom other]]]]
   | other <- agents\\["i"]]++
   [Comp Apply [Atom "secChCr",Comp Cat [Comp Apply [Atom "pseudonym",Comp Cat [Atom other]],Atom "i"]]
   | other <- agents\\["i"]])


printTypes :: Types -> String
printTypes = 
 let f (Agent _ _,ids) = (ppIdList ids)++":agent\n"
     f (Number,ids) = (ppIdList ids)++":text\n"
     f (SeqNumber,_) = ""
     f (PublicKey,ids) =  (ppIdList ids)++":public_key\n"
     f (SymmetricKey,ids) =  (ppIdList ids)++":symmetric_key\n"
     f (Function,ids) = (ppIdList ids)++":function\n"
     f (Custom x,ids) = (ppIdList ids)++":t_"++x++"\n"
     f (Untyped,_) = ""
 in concatMap f 

getIK0 :: [Fact] -> [Fact]
getIK0 states =
   let f (Atom a) = 
	if (isVariable a) && (a/="SID")
	then Atom "i"
	else Atom a
       f (Comp o as) = Comp o (map f as)
   in  ((map (Iknows . f)) . 
        nub . 
	(concatMap getMsgs) . 
        (filter (\ (State role msgs) -> isVariable role)))
       states


getMsgs :: Fact -> [Msg]
getMsgs (State role msgs) = map snd msgs 
getMsgs (FPState role msgs) =  msgs 
getMsgs (Iknows msg) = [msg]
getMsgs (Fact _ msgs) = msgs


getinitials :: [Rule] -> Knowledge -> [Fact]
getinitials rules =
  (map (\ (x,y) -> State x (map (\z-> (z,z)) ((Atom x):(Atom "0"):(((analysis y)\\[Atom x])++[Atom "SID"]))))) . fst  

instantiate :: Int -> [Fact] -> [(Msg,Msg)] -> ([Fact],[Ident],[[Ident]],[Ident],[Fact],[(Msg,Msg)])
instantiate n states ineq = 
  let nstates = zip states [1..]
      inst0 i n (State role msgs) = 
        let f (Atom a) = 
	      if (isVariable a) && (a/="SID")
	      then Atom (a++"_"++(show i)++"_"++(show n))
	      else Atom a
	    f (Comp o as) = Comp o (map f as)
	    varcheck =  (nub (concatMap vars (map snd msgs))) \\ (nub (filter isVariable (map (\ (Atom x) -> x) (filter isAtom (map snd msgs)))))
        in if varcheck==[]
	   then insSid n (State role (map (\ (x,y) -> (f x,f y))msgs))
	   else error 
	   	("Currently not supported:\n "++
		 " role "++role++" does not know "++(show varcheck)++"\n"++
		 " but functions of "++(show varcheck)++"\n.")
      ik0 i n (State role msgs) = 
        let f (Atom a) = 
	      if (isVariable a) && (a/="SID")
	      then if a==role then (Atom "i")
	      	   else Atom (a++"_"++(show i)++"_"++(show n))
	      else Atom a
	    f (Comp o as) = Comp o (map f as)
        in if isVariable role 
	   then map (Iknows . f) (map snd msgs)
	   else []
      ik = nub (concat [ik0 i k f|  k<-[1..n], (f,i)<-nstates])
      insSid i (State r m) =
        State r ((init m)++(map (\x->(x,x)) [Atom (show (2*i))]))
      instfacts = [inst0 i k f|  k<-[1..n], (f,i)<-nstates]
      instineq0 i n (s,t) =
         let f (Atom a) = 	  
              if (isVariable a) && (a/="SID")
	      then Atom (a++"_"++(show i)++"_"++(show n))
	      else Atom a
	     f (Comp o as) = Comp o (map f as)
         in (f s, f t)
      instineq = [instineq0 i k e | k<-[1..n], (_,i) <-nstates, e <-ineq ]
      aglili =  [ nub [name++"_"++(show ( i))++"_"++(show k)  | k<-[1..n]]
		   | (State r msgs,i)<-nstates,
		     name <- ((filter ((/=) "SID")).
		                     (filter isVariable).
				     (concatMap idents).
				     (concatMap getMsgs)) [(State r msgs)],
		      isVariable name]
      honestNames = 
               nub 
                    [ name++"_"++(show ( i))++"_"++(show k) 
		    | (State _ ((_,Atom name):_),i)<-nstates, k<-[1..n],
		      isVariable name]
      allNames = (nub.
		  (filter ((/=) "SID")).
		  (filter isVariable).
	          (concatMap idents).
		  (concatMap getMsgs)) instfacts
  in (instfacts,
      honestNames,
      aglili,
      allNames,
      (Iknows $ Atom "guessPW"):ik,instineq )

--- Stage 5: printing the rules
--------------------------------

getTypes :: Protocol -> Types
getTypes (_,t,_,_,_,_) = t

-- <paolo> 
ruleList :: Bool -> ProtocolTranslationState -> String
ruleList if2cif pts = -- pass the list of SQNs
                 ruleListIF (initial pts, rules pts) (trTypes2Ids (getTypes (protocol pts)) SeqNumber) if2cif

ruleListIF :: (String,[Rule]) -> [Ident] -> Bool -> String
-- ruleListIF (init,rules) _ _ | trace ("ruleListIF\n" ++ init ++ "\n" ++ foldr (\a s ->(ppRule IF a ++"\n") ++s ) ""  rules) False = undefined
ruleListIF (init,rules) sqns if2cif =
                                let ruleIF [] _ = ""
                                    ruleIF (x:xs) n = let 
                                                         -- rule hacked SQN
                                                         nr1 = ppRuleIFHack x sqns
                                                         -- IF2CIF
                                                         nr2 = if if2cif then ppRuleIF2CIF nr1 else nr1
                                                      in  "step trans"++(show n)++":=\n"++ (ppRule IF nr2)++"\n"++(ruleIF xs (n+1))
                                in init ++ (ruleIF rules 0)

ppRuleIF2CIF :: Rule -> Rule
-- ppRuleIF2CIF r | trace ("ppRuleIF2CIF\n\tr: " ++ ppRule IF r) False = undefined
ppRuleIF2CIF (l,eq,f,r) = let
                                l1 = map (\x -> subfactIF2CIFik subMsgIF2CIF x) l
                                l2 = map (\x -> subfactIF2CIFik subMsgIF2CIFLabel x) l1
                                r1 = map (\x -> subfactIF2CIFik subMsgIF2CIF x) r
                                r2 = map (\x -> subfactIF2CIFik subMsgIF2CIFLabel x) r1
                          in(l2, eq, f, r2)

subMsgIF2CIF :: Msg -> Msg
-- subMsgIF2CIF m | trace ("subMsgIF2CIF\n\tm: " ++ show m) False = undefined
-- rewrite messages IF/Annotated AnB -> CryptIF
subMsgIF2CIF (Comp Cat (Atom "atag":[Comp Cat [Atom a,msg]])) = Comp Crypt [Comp Inv [Comp Apply [Atom "sk",Atom a]], msg]
subMsgIF2CIF (Comp Cat (Atom "fatag":[Comp Cat [Atom a,msg]])) = Comp Crypt [Comp Inv [Comp Apply [Atom "sk",Atom a]], msg]
subMsgIF2CIF (Comp Cat (Atom "ctag":[Comp Crypt [Comp Apply [Atom "blind",Atom b],msg]])) = Comp Crypt [Comp Apply [Atom "pk",Atom b], msg]
subMsgIF2CIF (Comp Cat (Atom "stag":[Comp Crypt [Comp Apply [Atom "blind",Atom b],Comp Cat [Atom a,msg]]])) = Comp Crypt [Comp Apply [Atom "pk",Atom b],Comp Crypt [Comp Inv [Comp Apply [Atom "sk",Atom a]], msg]]
subMsgIF2CIF (Comp Cat (Atom "fstag":[Comp Crypt [Comp Apply [Atom "blind",Atom b],Comp Cat [Atom a,msg]]])) = Comp Crypt [Comp Apply [Atom "pk",Atom b],Comp Crypt [Comp Inv [Comp Apply [Atom "sk",Atom a]], msg]]
subMsgIF2CIF (Comp Cat (Atom "plain":[Atom msg])) = Atom msg
subMsgIF2CIF (Comp Cat (Atom "ctag":[Atom msg])) = Atom msg 
subMsgIF2CIF (Comp Cat (Atom "stag":[Atom msg])) = Atom msg 
subMsgIF2CIF (Comp Cat (Atom "fstag":[Atom msg])) = Atom msg
subMsgIF2CIF (Comp Cat (Atom "plain":x:[])) = x
subMsgIF2CIF (Comp Cat (Atom "ctag":x:[])) = x
subMsgIF2CIF (Comp Cat (Atom "stag":x:[])) = x
subMsgIF2CIF (Comp Cat (Atom "fstag":x:[])) = x
subMsgIF2CIF (Comp Cat (Atom "plain":xs)) = (Comp Cat xs)
subMsgIF2CIF (Comp Cat (Atom "ctag":xs)) = (Comp Cat xs)
subMsgIF2CIF (Comp Cat (Atom "stag":xs)) = (Comp Cat xs)
subMsgIF2CIF (Comp Cat (Atom "fstag":xs)) = (Comp Cat xs)
--subMsgIF2CIF (Comp Crypt [Comp Apply [Atom "blind",_],_]) = Atom "blind"   -- blind cleanup  iknows(pair(stag,crypt(apply(blind,A),pair(B,pair(A,Msg))))) => stateR(... crypt(apply(blind,A),pair(B,pair(A,Msg))),pair(stag,crypt(apply(blind,A),pair(B,pair(A,Msg))))
-- subMsgIF2CIF (Comp op xs) = Comp op (map (\x -> (subMsgIF2CIF x)) xs)
subMsgIF2CIF m = m

replace old new l = join new . split old $ l
join sep [] = []
join sep lists = foldr1 (\ x y -> x++sep++y) lists
split sep list =
  let split0 accword acclist sep [] = reverse ((reverse accword):acclist)
      split0 accword acclist sep list = if isPrefixOf sep list 
                                        then split0 "" ((reverse accword):acclist) sep (drop (length sep) list)
                                        else split0 ((head list):accword) acclist sep (tail list)
  in split0 [] [] sep list


subMsgIF2CIFLabel :: Msg -> Msg
-- subMsgIF2CIFLabel (Atom a) | trace ("subMsgIF2CIFLabel\n\tAtom a: " ++ show a) False = undefined
subMsgIF2CIFLabel (Atom a) = Atom (replace "XCryptblind" "XCryptpk" a)       -- blind cleanup
subMsgIF2CIFLabel (Comp op xs) = Comp op (map subMsgIF2CIFLabel xs)

filterLMsg :: [LMsg] -> [LMsg]
-- filterLMsg msgs | trace ("filterLMsg\n\tmsgs: " ++ show msgs) False = undefined
filterLMsg [] = []
filterLMsg (x:[]) = [x]
filterLMsg (x@(Atom "blind",Atom "blind"):xs) = [x] ++ filterLMsg xs 
filterLMsg ((Atom "blind",_):xs) = filterLMsg xs      -- blind cleanup
filterLMsg (x:xs) = if elem (snd(x)) (map snd xs) then xs else [x] ++ (filterLMsg xs)

--subfactIF2CIF :: Substitution -> Fact -> Fact
---- subfactIF2CIF _ (State r msgs)| trace ("subfactIF2CIF\n\tr: " ++ show r ++ "\n\tmsgs: " ++ show msgs) False = undefined
--subfactIF2CIF sub (FPState r msgs) = FPState r (nub(map sub msgs))
--subfactIF2CIF sub (State r msgs) = let
--                                        msgs1 = filterLMsg (map (\ (x,y)-> (sub x, sub y)) msgs)
--                                   in State r msgs1
--subfactIF2CIF sub (Iknows msg) = Iknows (sub msg)
--subfactIF2CIF sub (Fact ident msgs) = Fact ident (nub(map sub msgs))
---- subfactIF2CIF _ f = f

subfactIF2CIFik :: Substitution -> Fact -> Fact
-- subfactIF2CIFIK _ (State r msgs)| trace ("subfactIF2CIFIK\n\tr: " ++ show r ++ "\n\tmsgs: " ++ show msgs) False = undefined
subfactIF2CIFik sub (Iknows msg) = Iknows (sub msg)
subfactIF2CIFik _ f = f


-------------------------------------
endstr :: Bool -> String
endstr noowngoal = 
  "section attack_states:\n"++
  "  attack_state secrecy :=\n"++
  "    secret(AnB_M,AnB_A).\n"++
  "    iknows(AnB_M)\n"++
  "    & AnB_A/=i\n\n"++
  "  attack_state weak_auth :=\n"++
  "    request(AnB_A,AnB_B,AnB_PURP,AnB_MSG,SID)\n"++
  "    & not(witness(AnB_B,AnB_A,AnB_PURP,AnB_MSG))\n"++
  "    & AnB_B/=i\n"++
  (if noowngoal then "    & AnB_A/=AnB_B\n\n" else "\n" ) ++
  "  attack_state weak_auth :=\n"++
  "    wrequest(AnB_A,AnB_B,AnB_PURP,AnB_MSG)\n"++
  "    & not(witness(AnB_B,AnB_A,AnB_PURP,AnB_MSG))\n"++
  "    & AnB_B/=i\n"++
  (if noowngoal then "    & AnB_A/=AnB_B\n\n" else "\n" ) ++
  "  attack_state strong_auth :=\n"++
  "    request(AnB_A,AnB_B,AnB_PURP,AnB_MSG,SID).\n"++
  "    request(AnB_A,AnB_B,AnB_PURP,AnB_MSG,SID2)\n"++
  "    & SID/=SID2\n"++
  "    & AnB_B/=i\n"++
  (if noowngoal then "    & AnB_A/=AnB_B\n\n" else "\n" ) ++
  "  attack_state secrets :=\n"++
  "    secrets(AnB_M,AnB_SET).\n"++
  "    iknows(AnB_M)\n"++
  "    & not(contains(AnB_SET,i))\n"++
  "  attack_state guesswhat :=\n"++
  "    guessChal(AnB_M,AnB_SET).\n"++
  "    iknows(AnB_M)\n"++
  "    & not(contains(AnB_SET,i))\n"

-- </paolo> 

isntIknowsFunction (Iknows msg) = isntFunction msg
isntIknowsFunction _ = True

isIknows (Iknows _) = True
isIknows _ = False

reorder :: [Msg] -> [Msg]
reorder l = 
       let name = head l
           step = head . tail $ l
           session = last l
           rest = init $ drop 2 l
       in name:session:step:rest

ppFact Isa (State role msgs) = error "State-Fact in ISA mode" 
ppFact Isa (FPState role msgs) = "State (r"++(ppId role)++",["++(ppMsgList Isa (filter isntFunction msgs))++"])"
ppFact outf (State role msgs) = "state_r"++(ppId role)++"("++(ppMsgList outf (reorder (map snd msgs)))++")"
ppFact outf (FPState role msgs) = error "ppFact: should not have FPState" --- "state_r"++(ppId role)++"("++(ppMsgList outf msgs)++")"
ppFact outf (Iknows msg) = "iknows("++(ppMsg outf msg)++")"
ppFact outf (Fact i m) = (ppId i)++"("++(ppMsgList outf m)++")"

ppFactList outf = (ppXList (ppFact outf) ".\n") . (filter isntIknowsFunction)

ppEq outf (x,y) = (ppMsg outf x)++"/="++(ppMsg outf y)

ppRule Isa (l,eq,f,r) 
 = (ppXList (ppFact Isa) ";\n" (filter isntIknowsFunction l))++"\n"++
   (if eq==[] then "" else " | "++(ppXList (ppEq Isa) ";\n" eq))++"\n"++ 
   (if f==[] then "=>" else error "fresh variable remaining")++"\n"++
   (ppXList (ppFact Isa) ";\n" (filter isntIknowsFunction r))++"\n"

ppRule outf (l,[],f,r) = (ppFactList outf l)++"\n"++
                     (if f==[] then "=>" else "=[exists "++(ppIdList f)++"]=>")++"\n"++
		     (ppFactList outf r)++"\n"

ppRuleList Isa list =
  let ppRL Isa (x:xs) c = "step rule_"++(show c)++":\n"++(ppRule Isa x)++"\n"++(ppRL Isa xs (c+1))
      ppRL Isa [] _ = "" 
  in ppRL Isa list 0

ppRuleList outf list = ppXList (ppRule outf) "\n" list

ppInit str ot list =
  let ppFP0 ot (x:xs) c = str++"_"++(show c)++": "++(ppFact ot x)++";\n"++(ppFP0 ot xs (c+1))
      ppFP0 ot [] _ = "" 
  in ppFP0 ot (filter isntIknowsFunction list) 0

ppFP str ot list =
  let ppFP0 ot (x:xs) c = str++"_"++(show c)++": "++(ppFact ot x)++";\n"++(ppFP0 ot xs (c+1))
      ppFP0 ot [] _ = "" 
  in ppFP0 ot list 0

subfact :: Substitution -> Fact -> Fact
subfact sub (FPState r msgs) = FPState r (map sub msgs)
subfact sub (State r msgs) = State r (map (\ (x,y)-> (sub x,sub y)) msgs)
subfact sub (Iknows msg) = Iknows (sub msg)
subfact sub (Fact ident msgs) = Fact ident (map sub msgs)

subrule sub (l,eq,f,r) = (map (subfact sub) l, 
                                     map (\ (x,y) -> (sub x,sub y)) eq,
                          f, 
                          map (subfact sub) r)

-- <Paolo> --
-- hack to handle sequence numbers

-- sample
--  A *->B : sn(N,B),Msg
--  L => R
--  where sn(X,Y) occuring in L.
--  L . not(contains(X,seen(B)))  => R.contains(X,seen(B)))

-- example
-- step trans1:=
-- state_rB(B,0,inv(apply(sk,B)),inv(apply(pk,B)),sk,pk,A,SID).
-- iknows(crypt(inv(apply(sk,A)),pair(B,pair(SQN,Msg)))).not(contains(SQN,seen(B)))
-- =>
-- request(B,A,purposeMsg,Msg,SID).
-- state_rB(B,1,inv(apply(sk,B)),inv(apply(pk,B)),sk,pk,A,Msg,SQN,crypt(inv(apply(sk,A)),pair(B,pair(SQN,Msg))),SID).contains(SQN,seen(B))

ppRuleIFHack :: Rule -> [Ident] -> Rule
-- apply sqn hack [Ident]=list of SQNs                     
ppRuleIFHack ([],[],f,r) _ = ([],[],f,r)
ppRuleIFHack (l,[],f,r) sqns =  let 
                                        a = getRule2Agent l
                                        sqnList = nub (getFacts2SQN l sqns)
                                        nl = l++ (map (\x -> (notcsterm x a)) sqnList)
                                        nr = r++ (map (\x -> (csterm x a)) sqnList)
                                in (nl,[],f,nr)                   
ppRuleIFHack _ _ = error "Sequence Number translation error"                  
                     
getRule2Agent :: [Fact] -> Ident
getRule2Agent xs = getFact2Agent (head (xs))

getFact2Agent :: Fact -> Ident
getFact2Agent f = case f of 
                        State id _ -> id
                        _ -> ""           

-- retuns a list of SQNs
getFacts2SQN :: [Fact] -> [Ident] -> [Ident]
getFacts2SQN [] _ = []
getFacts2SQN (x:xs) sqns = getFact2SQN x sqns ++ getFacts2SQN xs sqns

getFact2SQN :: Fact -> [Ident] -> [Ident]
getFact2SQN f sqns = case f of 
                         State _ _ -> []
                         FPState _  _ -> []
                         Fact _  _ -> []
                         Iknows m -> getMsg2SQN m sqns

getMsg2SQN :: Msg -> [Ident] -> [Ident]
getMsg2SQN (Atom id) sqns = if (elem id sqns) then [id] else []
getMsg2SQN (Comp _ []) _ = [] 
getMsg2SQN (Comp _ (m:ms)) sqns = getMsg2SQN m sqns ++ getMsgs2SQN ms sqns

getMsgs2SQN :: [Msg] -> [Ident] -> [Ident]
getMsgs2SQN ([]) _ = [] 
getMsgs2SQN (m:ms) sqns = getMsg2SQN m sqns ++ getMsgs2SQN ms sqns 

-- SQN, AgentName .contains(SQN,seen(B))
csterm :: Ident -> Ident -> Fact
csterm sqn agent = Fact "contains" [Atom sqn, Comp (Userdef "seen") [Atom agent]]

-- SQN, AgentName .not(contains(SQN,seen(B)))
notcsterm :: Ident -> Ident -> Fact
notcsterm sqn agent = Fact "not" [Comp (Userdef "contains") [Atom sqn, Comp (Userdef "seen") [Atom agent]]]

-- adjust the Types to translate the SQNs in Numbers
trAdjTypes :: Types -> Type -> Type -> Types
trAdjTypes t from_t to_t =      let
                                        idents = trTypes2Ids t from_t
                                        t1 = trTypesMoveIds t from_t idents to_t
                                in t1   

-- extract the list of ids from Type
-- used in preprocessing of Protocol

trTypes2Ids :: Types -> Type -> [Ident]
trTypes2Ids [] _ = []
trTypes2Ids types t = concatMap snd ((filter (\(x,_) -> x==t)) types)

trTypesMoveIds :: Types -> Type ->[Ident] -> Type -> Types
trTypesMoveIds [] _ _ _= []
trTypesMoveIds t _ [] _ = t
trTypesMoveIds (x:xs) from_t idents to_t = [(trTypeMoveIds x from_t idents to_t)] ++ (trTypesMoveIds xs from_t idents to_t)

trTypeMoveIds :: (Type,[Ident]) -> Type -> [Ident] -> Type -> (Type,[Ident])
trTypeMoveIds (t,idents) from_t idents1 to_t = if t==to_t then (t,nub(idents++idents1)) else if t==from_t then (t,[]) else (t,idents)

-- </Paolo> --                          