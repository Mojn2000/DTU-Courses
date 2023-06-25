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

module Ast where
import Data.List
import Data.Maybe
import Msg

-- | The type @Protocol@ is the type for the result of the AnB-Parser,
-- i.e. the topmost structure of the Abstract Syntax Tree (AST)
type Protocol = (String,Types,Knowledge,Abstraction,Actions,Goals)

----------- Protocol Description --------------

-- | The (atomic) type identifiers
data Type = Agent Bool Bool -- ^ flags: static, honest; both currently unused
          | Number -- ^ aka nonce
          | SeqNumber -- ^ aka sequence number
          | PublicKey 
          | SymmetricKey 
          | Function -- ^ for free user-defined function symbols (no input/output type specification)
          | Purpose -- ^ special type for the purpose-argument of witness and request facts
          | Custom String -- ^ Now allowing users to introduce their custom types
          | Untyped -- ^ default for constants/variables that do not have a type declaration 
          deriving (Eq,Show)

-- | A type declaration consist of a type and a list of identifiers
-- (constants or variables) that have that type
type Types = [(Type,[Ident])] 

-- | A knowledge declaration consists of an identifier for a role
-- (constant or variable; should be of type Agent!) and a list of
-- messages that this role initially knows. The variables in that
-- knowledge should always be of type Agent; this is not checked now,
-- however. NEW: Additionally, we have a set of pairs of messages that
-- express inequalities of terms in the instantiation of the
-- knowledge. One can use this for instance to express with A/=B that
-- the roles A and B must be played by different agents.
type Knowledge = ([(Ident,[Msg])],[(Msg,Msg)])

-- | A peer is the endpoint of a channel (i.e. sender or
-- receiver). The identifier is the real name (according to the
-- specification), the bool says whether this agent is
-- pseudonymous. The third is the pseudonym in case the agent is
-- pseudonymous.
type Peer = (Ident,Bool,Maybe Msg)

-- | A channel is characterized by a sender and receiver peer, and by
-- a channel type, e.g.  @ ((A,False,Nothing),Secure,(B,True,PKB)) @
type Channel = (Peer,ChannelType,Peer)

-- | An action consists of a channel (sender, channeltype, receiver)
-- and a message being sent. Additionally, there are two optional
-- message terms for modeling zero-knowledge protocols, namely a
-- pattern for the receiver, and a message that the sender must know
type Action = (Channel,Msg,Maybe Msg,Maybe Msg) 

-- | List of actions
type Actions = [Action]

-- | The different supported channel types
data ChannelType = Insecure -- ^ @ -> @ standard channel
                 | Authentic  -- ^ @ *-> @ sender and intended recipient secured
                 | Confidential  -- ^ @ ->* @ recipient secured
                 | Secure   -- ^ @ *->* @ both authentic and confidential
                 | FreshAuthentic  -- ^ @ *->> @ like authentic, but protected against replay
                 | FreshSecure -- ^ @ *->>* @ like secure, but protected against replay
                 deriving (Eq,Show)

-- | The pre-defined set of goals
data Goal = ChGoal Channel Msg -- ^ Goals that are expressed in channel notation
          | Secret Msg [Peer] Bool -- ^ Standard secrecy goal
          | Authentication Peer Peer Msg -- ^ Standard authentication
                                         -- goal (including replay
                                         -- protection; corresponds to
                                         -- Lowe's injective
                                         -- agreement)
          | WAuthentication Peer Peer Msg -- ^ Weaker form of
                                          -- authentication: no
                                          -- protection against
                                          -- replay. Corresponds to
                                          -- Lowe's non-injective
                                          -- agreement.
          deriving (Eq,Show)

-- | List of gaols
type Goals = [Goal]

-- | For the annotation of abstractions: to express that a variable
-- (identifier) should be abstracted into a given term. This
-- represents replacing in the entire description all occurrences of
-- that variable with that term.
type Abstraction = [ (Ident,Msg) ]
 
