{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module Search where
import IntsOnly
import Remola
import Symbolic
import NewIfParser
import Data.Maybe
import Data.List
import Constants
import Decomposition
import Control.Parallel.Strategies

varstart=221


getmaxstep :: [(Int -> Rule)] -> [(Msg,Int)] -> Bool -> ([(Msg,Int)],Bool)
getmaxstep [] n b = (n,False)
getmaxstep (f:fs) n b = 
  let (_,_,_,r,_) = f 0
      step = map (\ (W step _ _ m _ _) -> (m,step)) 
                 (filter (\ fact -> 
                           case fact of 
                           (W _ _ _ _ _ _) -> True
                           _ -> False) r)
      loop (m,s) ([],b) = ([(m,s)],b && (s>0))
      loop (m,s) (((m',s'):ms),b) = 
         if m==m' 
	 then if s>s' then (((m,s):ms),b) else (((m,s'):ms),True)
         else let (ms',b') = (loop (m,s) (ms,b))
	      in ((m',s'):ms',b')
      (job,b') = foldr loop (n,False) step
  in getmaxstep fs job b'


data Tree a = Node a [Tree a]
type MonState = (Int,State) 
--- a monadic state, i.e. State and a counter for the variables.

successor :: AlgTheo -> Bool -> Int -> [(Int -> Rule)] -> MonState -> [MonState]
--- sfb: bound on the session repetitions
--- rules: a set of rules parametrized over the time point (this
---        timepoint is not necessary in future versions).
--- state: the current state (with monad)
--- result: successor states (with monads)

successor theo por sfb rules (seed,state) =
  zip (repeat seed) (concatMap (\rule -> successors very_lazy theo por sfb rule state) rules) 

successorHC :: [Hornclause] -> AlgTheo -> Bool -> Int -> [(Int -> Rule)] -> MonState -> [MonState]
--- sfb: bound on the session repetitions
--- rules: a set of rules parametrized over the time point (this
---        timepoint is not necessary in future versions).
--- state: the current state (with monad)
--- result: successor states (with monads)

successorHC hcs theo por sfb rules (seed,state) =
  zip (repeat seed) (concatMap (\rule -> successorsHC hcs very_lazy theo por sfb rule state) rules) 

successor_must :: AlgTheo -> Bool -> Int -> [(Int -> Rule)] -> MonState -> [MonState]
successor_must theo por sfb rules (seed,state) =
  case concatMap (\ rule -> successors_must theo por sfb rule state) rules of
  [] -> successor theo por sfb rules (seed,state)
  x  -> [(seed, head x)]

wellformed :: String -> Bool
wellformed errmsg = (prefix "secrecy" errmsg) || (prefix "authen" errmsg)

prefix [] _ = True
prefix (x:xs) (y:ys) = x==y && (prefix xs ys)
prefix _ _ = False

general_attack_check :: AlgTheo ->  Bool -> [(Int -> Rule)] -> State -> Maybe String
general_attack_check theo por attack_rules state =
  let attack_states = successor theo False 707 attack_rules (1000,state)
  in if attack_states == [] then Nothing else
     let attack_state --- @(b,t,f,oi,ni,po,cs,h)
           = snd (head attack_states) 
         (W _ _ errmsg _ _ _) = head (filter isWTerm (facts attack_state))
     in
      Just (prlist (show errmsg) attack_state)

type Succ_rel a = (Int,a) -> [(Int,a)]


treeconstruct0 :: Int -> Succ_rel a -> (Int,a) -> Tree a
--- depth: bound on the tree-size
--- rules,state: as above.
--- output tree of states
treeconstruct0 0     succ_rel (seed,state) = Node state []
treeconstruct0 depth succ_rel mstate =  
 Node (snd mstate) (map (treeconstruct0 (depth-1) succ_rel) (succ_rel mstate))

treeconstruct :: [Hornclause] -> AlgTheo -> Bool -> Bool ->  Int -> Int -> (State,[Int->Rule]) -> Tree State
--- given sfb and depth as above
--- and an if-description
--- output: tree of states
treeconstruct hcs theo must por sfb depth (state0,rules) = 
  treeconstruct0 depth ((if must then error "successor_must theo" else successorHC hcs theo) por sfb rules) (varstart, state0)

wrids :: Int -> (State -> Bool) -> Tree State -> (String,Int)
wrids 0 p (Node a l) = if p a then ("Lalala"++(prlist "?" a),0) else ([],1)
wrids n p (Node a l) = if p a then ("Lalala"++(prlist "?" a)++rest,nds) else (rest,nds)
      where (rest,nds) = foldr (\ (s1,i1) (s2,i2) -> (s1++s2,i1+i2)) 
			       ("",0)
			       (map (wrids (n-1) p) l)

wrids2 :: Int -> (State -> Maybe String) -> Tree State -> (String,Int)
wrids2 0 p (Node a l) = case p a of
  Just att -> ('*' : att, 1) 
  Nothing -> (nothing_found, 1)
wrids2 n p (Node a l) =
   case p a of
    Just att -> ('*': att, nds)
    Nothing -> (rest, nds)
    where 
      (rest, nds) = foldr go ("", 0) (parMap rdeepseq (wrids2 (n - 1) p) l)
      go (s1, i1) (s2, i2) = case s1 of 
        '*' : _ -> (s1, i1)
        _       -> (s2, i1 + i2)


type Statistics = (Int,Int)
--- 1st int: vip --- the number of nodes visited
--- 2nd int: depth -- maximum depth visited
init_stats = (0,0)
inc_vip (vip,depth) = (vip+1,depth)
get_vip (vip,_) = vip
inc_depth (vip,depth) = (vip,depth+1)
max_depth (vip,depth) depth' = (vip,max(depth,depth'))
get_depth (_,depth) = depth

show_stats :: Statistics -> String
show_stats (vip,depth) = if vip==0 then "" else
                         "  visitedNodes: "++(show vip)++" nodes\n"
                         ++"  depth: "++(show depth)++" plies\n"

neusuch :: AlgTheo -> Bool -> Bool -> [Int -> Rule] -> [Hornclause] -> (State -> Maybe String) -> Int -> Int -> Int ->
   ([(Int,State)],[(Int,State)]) -> Statistics -> (String,Statistics)
--- given a rule set, an attack predicate, a max. number of states in
--- memory, a max. depth bound and a list of trees. Perform breadth-first search
--- until reaching the max. number, then proceed with depth first search.

nothing_found = "No attacks found.\n"
nothing_found_bound = "No attacks found.%(reached depth restriction)\n"
reached_balance = "neusuch: reached balance.\n"

neusuch theo must por rules hcs predicate balance 0 _ _ stats
 = (nothing_found, stats) --- was: nothing_found_bound

neusuch theo must por rules hcs predicate balance depth sfb ([], []) stats
 = (nothing_found, stats)

neusuch theo must por rules hcs predicate balance depth sfb ([], l) stats
 = neusuch theo must por rules hcs predicate balance (depth - 1) sfb (reverse l, []) (inc_depth stats)

neusuch theo must por rules hcs p balance depth sfb (xs', ys) (s1, s2)
 = let xs = take balance xs'
       results = catMaybes $ parMap rdeepseq (p . snd) xs
       successors = if must then error "MUST CURRENTLY not supported" else
                          concatMap (successorHC hcs theo por sfb rules) xs
       newBalance = balance - length xs
    in case results of
      (att : _) -> (att, (s1, s2))
      [] ->
        if length xs' >= balance
          then (reached_balance, (s1 + length xs, s2))
          else neusuch theo must por rules hcs p newBalance (depth - 1) sfb (successors, ys) (s1 + length xs, s2 + 1)

exec_check0 :: AlgTheo -> Bool -> [Int -> Rule] -> (State -> Maybe [Fact]) -> Int -> Int -> Int ->
   ([(Int,State)],[(Int,State)]) -> Statistics -> (Maybe [Fact],Statistics)

exec_check0 theo por rules predicate balance 0 _ _ stats
 = error "Executability check stopped due to bounds." 
exec_check0 theo por rules predicate balance depth sfb ([],[]) stats
 = (Nothing,stats)
exec_check0 theo por rules predicate balance depth sfb ([],l) stats
 = exec_check0 theo por rules predicate balance (depth-1) sfb (reverse l,[]) 
   (inc_depth stats)
exec_check0 theo por rules p balance depth sfb (x:xs,ys) stats
 = let isAttack = (p (snd x)) in
   if (isJust isAttack) then (isAttack, stats) 
   else let succ_x = (successor theo por sfb rules x) 
            isAttack = (listToMaybe . catMaybes . (map (p . snd))) succ_x
        in if (isJust isAttack) then (isAttack,stats) else
	   if (((length succ_x) < balance))
	   then exec_check0 theo por rules p (balance-(length succ_x)+1) depth sfb 
		   (xs, (reverse succ_x) ++ ys) (inc_vip stats)
	   else 
	    error "exec_check0: reached balance. Please report this bug."

partition_by_session :: [Fact] -> [[Fact]]
partition_by_session [] = [[]]
partition_by_session (x:xs) = 
        let (same_session,other_session) = 
		partition ((==) (get_session x).get_session) xs
        in ((x:same_session):(partition_by_session other_session))

get_session :: Fact -> Int
get_session  (W _ _ _ _ _ (Number session)) = session 



xexec_check :: AlgTheo -> Bool -> [Int -> Rule] -> [(Msg,Int)] -> (Int,State) -> (Bool,[Fact])
xexec_check theo por rules final_states (a,initial_state) =
--- @(a,(b,c,initial_facts,d,e,f,g,h)) =
  let (state_facts,other_facts) = partition isWTerm (facts initial_state)
      state_partition = partition_by_session state_facts
      analysis = (map (\ (c,session_facts) -> 
		exec_check0 theo por rules (\ state -> check_states state final_states) 
		  100000 100000 100000 
		  ([(a,initial_state{time=c,
				     facts=session_facts++other_facts})],[])
		  init_stats) (zip (map ((*)(length rules)) [1..n]) state_partition))
      n = length state_partition
      (sessco,remains) = partition isJust (map fst analysis)
  in if (remains==[])
     then (True,(concatMap fromJust sessco))
     else (False,(concatMap fromJust sessco))


check_states :: State -> [(Msg,Int)] -> Maybe [Fact]
check_states state [] = 
  Just (history state)
check_states state dings@((m,i):mis) =
  let not_finished = filter (\ f -> case f of 
			              (W i' _ _ m' _ _) -> (i>i') && (m'==m)
				      _ -> False) (facts state) in
  if (not_finished==[]) && (isJust (check_states state mis))
  then Just ((filter (not . isWTerm) (facts state))++(history state))
  else Nothing




shn2 :: (State -> Maybe String) -> (Int -> Tree State) -> [Int] -> String 
shn2 p tree l = 
  let state = (top (mytraverse (tree ((length l)+1) ) l)) in
    (showState3 state)
        ++ "\n" ++ (printniveau (mytraverse (tree ((length l)+1) ) l)) ++ "\n"

sprintTree :: Tree State -> String
sprintTree tree = printniveau2 "" tree


top :: Tree a -> a
top (Node a _) = a

children :: Tree a -> [Tree a]
children (Node _ l) = l

nth :: Tree a -> Int -> Tree a
nth t n = nthl (children t) n

nthl [] _ = error "Ply to short"
nthl (x:_) 0 = x
nthl (_:xs) n = nthl xs (n-1)

nprint :: State -> String
nprint state = (if (porflag state) then "***" else "")++(show (history state))

nprintt :: Tree State -> String
nprintt (Node a l) = nprint a

nprintwl :: State -> String
nprintwl = show . init . history

nprinttwl :: Tree State -> String
nprinttwl (Node a l) = nprintwl a

nprintl :: [Fact] -> State -> String
nprintl lab state =
   let consume [] l = l
       consume (x:xs) (y:ys) = consume xs ys
   in  print_trace  (consume lab (history state))

print_trace :: [Fact] -> String
print_trace [] = ""
print_trace (x:xs) = (show x)++"\n"++(print_trace xs)

nprinttl :: [Fact] -> Tree State -> String
nprinttl lab (Node a l) = nprintl lab a

printniveau :: Tree State -> String
printniveau (Node state l) = 
  let showalt [] i = ""
      showalt (x:xs) i = 
        "("++(show i)++")\n"++(nprinttl (history state) x)++"\n"++(showalt xs (i+1))
  in 
     "\n"++(print_trace (history state))++"\n"++(showalt l 0)++"\n"

printniveau2 :: String -> Tree State -> String
printniveau2 indent (Node state l) = 
  let showalt [] i = ""
      showalt (x:xs) i = 
        indent++"("++(show i)++") "++(nprinttl2 (history state) x)++
	(printniveau2 (indent++"|") x)++(showalt xs (i+1))
  in 
  showalt l 0

nprintl2 :: [Fact] -> State -> String
nprintl2 lab state =
   let consume [] l = l
       consume (x:xs) (y:ys) = consume xs ys
   in  print_trace2 (consume lab (history state))

print_trace2 :: [Fact] -> String
print_trace2 [] = ""
print_trace2 (x:xs) = (show x)++(print_trace xs)

nprinttl2 :: [Fact] -> Tree State -> String
nprinttl2 lab (Node a l) = nprintl2 lab a

mytraverse :: Tree a -> [Int] -> Tree a
mytraverse t [] = t
mytraverse t (x:xs) = mytraverse (nth t x) xs

len (Node _ l) = length l






