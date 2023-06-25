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

module Constants where

-- | The value of nodes in memory where we stop to search 
--   breadth-first and start depth-first.
--   FIX: should be adjusted ;-)
nodemax :: Int
nodemax = 5000 --- 1000000 

-- | The depth where we stop if the tree has infinite size.
depthbound :: Int
depthbound = 1000000

-- | There are several cases where OFMC must quit with an error, without grace. 
--   Do only set to true for experiments!
grace :: Bool
grace = False 

-- | Give out transitions with labels?
generateLabels = False

-- | Print it pretty, i.e. @crypt(K,M)@ is printed as @{M}K@
-- and @scrypt(K,M)@ as @{|M|}K@ and @pair(M1,M2)@ as @M1,M2@.
printMsgsPretty = True
