module StateMonad where
import GHC.Base
import GHC.Show

default ()

{- Mockup of the Standard Haskell State Monad since many installations do not have it anymore -}

data State s v = State { st :: s -> (v,s) } 
instance Monad (State s) where
  --return :: alpha -> State s alpha
  return = \ v -> State (\s -> (v,s))
  -- (>>=) :: State s alpha -> (alpha -> State s beta) -> State s beta
  m1 >>= m2 = State (\ s1 -> let (v,s2) = st m1 s1 
                             in st (m2 v) s2 )
instance Functor (State s) where
    -- fmap :: (alpha->beta) -> State s alpha -> State s beta
    fmap = liftM

instance Applicative (State s) where
    pure  = return
    (<*>) = ap
    

get = State (\s -> (s,s))
put = \ s -> State (\ _ -> ((),s))
evalState = \ m init -> let (v,s) = st m init in v
