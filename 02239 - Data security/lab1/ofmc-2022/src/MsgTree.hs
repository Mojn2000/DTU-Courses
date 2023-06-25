{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}


module MsgTree where
import Data.List
import qualified Data.Map as Map
import Data.Maybe
import Constants
import IntsOnly
import Decomposition

-- |  @ [[ emptyMT ]] = emptyset @
emptyMT :: MsgTree
-- | @ elemMT M MT <=> M in [[ MT ]] @
elemMT ::  Msg -> MsgTree -> Bool
-- | @ [[ unitMT M ]] = { M } @
unitMT :: Msg -> MsgTree
-- | @ [[ addToMT MT M ]] = { M } union [[ MT ]] @
addToMT ::  MsgTree -> Msg -> MsgTree
-- | @ [[ delFromMT MT M ]] = [[ MT ]] \ { M } @
delFromMT ::  MsgTree -> Msg -> MsgTree
-- | @ isEmptyMT M <=> M = emptyMT @ (where we haven't defined '=' yet)
isEmptyMT :: MsgTree -> Bool
-- | @ [[ addMT MT1 MT2 ]] = [[ MT1 ]] union [[ MT2 ]] @
addMT ::  MsgTree -> MsgTree -> MsgTree
-- | @ [[ addListToMT MT L ]] = (mkset L) union [[ MT ]] @
addListToMT ::  MsgTree -> [Msg] -> MsgTree
-- | @ [[ diffMT MT1 MT2 ]] = [[ MT1 ]] \ [[ MT2 ]] @
diffMT :: MsgTree -> MsgTree -> MsgTree
-- | @ [[ delListFromMT MT L ]] = [[ MT ]] \ (mkset L) @
delListFromMT ::  MsgTree -> [Msg] -> MsgTree
-- | @ [[ listToMT MT ]] = mkset MT @
listToMT ::  [Msg] -> MsgTree
-- | @ mkset (mtToList MT) = [[ MT ]] @
mtToList :: MsgTree -> [Msg]
-- | The show function.
showMT :: MsgTree -> String

-- | Like 'elemMT', but considering algebraic equations and unifying
--   variables. 
elemMT_unify :: FECTheo -> Msg -> MsgTree -> [Substitution]
--  Like 'elemMT', but considering algebraic equations (but not
--   performing unification). 
---elemMT_modEQ :: Msg -> MsgTree -> [Substitution]
-- | @ [[ substitute sub MT ]] = { M sub | M in [[ MT ]] } @
substituteMT :: Substitution -> MsgTree -> MsgTree
-- | All variables that occur in any message of the tree.
varsMT :: MsgTree -> [Int]
-- | The types of messages occuring in a message tree.
typesMT :: MsgTree -> [UnOp]

--- These two are just aliases:

delListFromMT = foldl delFromMT 
unitMT = addToMT emptyMT 

--- needed?
diff [] l = []
diff (x:xs) l = if (elem x l) then diff xs l
			      else x:(diff xs l)


data MsgTree = MTNode { atoms   :: [(Int,String)],
	                numbers :: [Int],
		        vars    :: [Int],
			unops   :: [(UnOp,Msg)],
			binops  :: [(BinOp,Msg,Msg)]
                      }
     deriving Eq
instance Show MsgTree where
  showsPrec _ mt = 
   showString
    ("{"++(showlist ((map (\ (i,s) -> Atom i s) (atoms mt))++
                     (map Number (numbers mt))++
                     (map Var (vars mt))++
                     (map (\ (unop,msg) -> UnOp unop msg) (unops mt))++
                     (map (\ (binop,m1,m2) -> BinOp binop m1 m2) (binops mt))))
        ++"}\n")

showlist :: (Show a) => [a] -> String
showlist [x] = show x
showlist (x:xs) = (show x)++","++(showlist xs)
showlist [] = "" --- error "Showlist: empty list"

showMT = show . mtToList
emptyMT = MTNode {atoms=[],numbers=[],vars=[],unops=[],binops=[]}
listToMT = addListToMT emptyMT
addListToMT = foldr (\ a b  -> addToMT b a)
isEmptyMT = (==) emptyMT

addToMT node (Atom i s) =
  let as = atoms node
  in  if elem (i,s) as then node 
      else node {atoms = (i,s):as}
addToMT node (Number i)  =
  let as = numbers node
  in  if elem i as then node 
      else node {numbers = i:as}
addToMT node (Var i)  =
  let as = vars node
  in  if elem i as then node 
      else node {vars = i:as}
addToMT node (UnOp op m) =
  let as = unops node
  in if elem (op,m) as then node
     else node {unops = (op,m):as}
addToMT node (BinOp op m1 m2) =
  let as = binops node
  in if elem (op,m1,m2) as then node
     else node {binops = (op,m1,m2):as}
addToMT node (Alby str) = node -- I do nothing :P

elemMT (Atom i s)  node = elem (i,s) (atoms node)
elemMT (Number i)  node = elem i (numbers node)
elemMT (Var i)     node = elem i (vars node)
elemMT (UnOp op m) node = elem (op,m) (unops node)
elemMT (BinOp op m1 m2) node = elem (op,m1,m2) (binops node)

delFromMT node (Atom i s) = 
  let as = atoms node
  in  if elem (i,s) as then node
      else node {atoms = delete (i,s) as}
delFromMT node (Number i) = 
  let as = numbers node
  in  if elem i as then node
      else node {numbers = delete i as}
delFromMT node (Var i) = 
  let as = vars node
  in  if elem i as then node
      else node {vars = delete i as}
delFromMT node (UnOp op m) =
  let as = unops node
  in  if elem (op,m) as then node
      else node {unops = delete (op,m) as}
delFromMT node (BinOp op m1 m2) =
  let as = binops node
  in  if elem (op,m1,m2) as then node
      else node {binops = delete (op,m1,m2) as}

addMT mt1 mt2 = 
 MTNode {atoms  =union (atoms mt1) (atoms mt2),
         numbers=union (numbers mt1) (numbers mt2),
         vars   =union (vars mt1) (vars mt2),
         unops  =union (unops mt1) (unops mt2),
	 binops =union (binops mt1) (binops mt2)
        }

diffMT mt1 mt2 = 
 MTNode {atoms  =diff (atoms mt1) (atoms mt2),
         numbers=diff (numbers mt1) (numbers mt2),
         vars   =diff (vars mt1) (vars mt2),
         unops  =diff (unops mt1) (unops mt2),
	 binops =diff (binops mt1) (binops mt2)
        }

mtToList node =
  [Atom a i | (a,i) <- atoms node]++
  [Number i | i <- numbers node]++
  [Var i    | i <- vars node]++
  [UnOp op m | (op,m) <- unops node]++
  [BinOp op m1 m2 | (op,m1,m2) <- binops node]

substituteMT sub node =
  --- listToMT (map (substitute sub) (mtToList node))
  let node1 = node { vars = [],
		     unops = [(op,(substitute sub) m)| 
			      (op,m) <- unops node],
		     binops = [(op,(substitute sub) m1,
				(substitute sub) m2)| 
			       (op,m1,m2) <- binops node]}
  in addListToMT node1 [substitute sub (Var v)|v<-vars node] 

elemMT_unify fecTheo = elemMT_unifyF fecTheo Map.empty

elemMT_unifyF fecTheo sub m@(BinOp op _ _) node = 
  concat [unifyF fecTheo sub [(m,(BinOp op t1 t2))] | (op',t1,t2) <- binops node, op==op']
elemMT_unifyF fecTheo sub m@(UnOp op _) node = 
  concat [unifyF fecTheo sub [(m,(UnOp op t))] | (op',t) <- unops node, op==op']
elemMT_unifyF fecTheo sub m node =
  if case m of 
     (Atom i s)  -> elem (i,s) (atoms node) 
     (Number i)  -> elem i (numbers node)
     (Var i)     -> error "elemMT_unify called with variable"
  then [sub] else []


varsMT node = 
 nub (
  (vars node)
  ++(concatMap (\ (op,m) -> msg_vars m) (unops node))
  ++(concatMap (\ (op,m1,m2) -> (msg_vars m1)++(msg_vars m2)) (binops node)))

typesMT node = 
 nub (map fst (unops node))




