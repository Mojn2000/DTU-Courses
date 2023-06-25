{-# OPTIONS_GHC -w #-}
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

module AnBParser where
import Lexer
import Ast
import Msg
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (Protocol)
	| HappyAbsSyn5 (Abstraction)
	| HappyAbsSyn6 (())
	| HappyAbsSyn8 (Types)
	| HappyAbsSyn9 (Type)
	| HappyAbsSyn10 ([Ident])
	| HappyAbsSyn11 (Knowledge)
	| HappyAbsSyn12 ([(Ident,[Msg])])
	| HappyAbsSyn13 ([(Msg,Msg)])
	| HappyAbsSyn14 ([Msg])
	| HappyAbsSyn15 (Msg)
	| HappyAbsSyn17 (Actions)
	| HappyAbsSyn18 (Action)
	| HappyAbsSyn19 (ChannelType)
	| HappyAbsSyn21 (Channel)
	| HappyAbsSyn23 (Peer)
	| HappyAbsSyn24 (Goals)
	| HappyAbsSyn25 (Goal)
	| HappyAbsSyn26 ([Peer])

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128 :: () => Int -> ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,209) ([0,0,0,1,0,0,16384,0,0,8192,0,0,0,0,0,0,0,4,0,0,0,0,512,0,0,32,0,0,4096,0,0,0,0,0,2,0,256,0,0,0,0,0,0,0,4096,0,0,0,0,32,0,0,128,0,0,16384,0,0,0,4096,0,0,0,0,0,0,0,256,0,0,0,0,0,0,0,0,0,0,0,0,4096,0,0,0,256,0,0,32,0,0,45056,2,0,0,44032,0,0,0,32768,0,0,0,64,1024,0,0,0,0,0,0,0,36,0,0,0,0,0,0,0,0,0,45056,2,0,0,44032,0,0,0,11008,0,0,0,16384,0,0,0,0,128,0,0,172,0,0,0,0,0,0,16384,0,0,0,0,32772,0,0,16384,8192,0,0,1024,2048,0,0,2752,0,0,0,688,0,0,0,172,0,0,0,0,4096,0,16384,0,4,0,0,8,0,0,0,120,0,0,0,0,0,0,64,0,0,0,2048,512,0,0,4,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11008,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,8,0,0,1,0,0,0,0,0,0,44032,0,0,0,11008,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,45056,2,0,0,44032,16384,0,0,0,2176,0,0,0,0,0,0,688,0,0,0,0,0,0,0,0,40,0,49152,10,0,0,0,32768,8704,0,0,2,0,0,0,30,192,0,0,0,2,0,688,256,0,0,8,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,64,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,0,1,0,0,0,256,0,11008,0,0,0,0,0,128,0,0,0,64,0,0,40,0,0,0,0,0,49152,10,0,0,4096,0,1,0,0,0,4096,0,0,2048,0,0,64,1024,0,0,0,0,16,0,0,0,0,0,1,0,0,0,0,0,0,0,256,0,0,44032,0,0,0,0,0,256,0,64,1024,0,0,0,128,0,0,0,0,0,0,0,8,0,16384,0,4,0,0,0,0,0,44032,0,0,0,0,2048,0,0,2752,0,0,0,4096,0,0,0,0,32,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_anbparser","protocol","absdec","optSemicolon","abslist","typedec","type","identlist","knowdec","knowspec","wheredec","msglist","msg","msgNOP","actionsdec","action","channeltype","channeltypeG","channel","channelG","peer","goalsdec","goal","peers","ident","\"(\"","\")\"","\"{\"","\"}\"","\"{|\"","\"|}\"","\":\"","\";\"","\"*->*\"","\"*->\"","\"->*\"","\"->\"","\"*->>\"","\"*->>*\"","\"%\"","\"!=\"","\"!\"","\".\"","\",\"","\"[\"","\"]\"","\"Protocol\"","\"Knowledge\"","\"where\"","\"Types\"","\"Actions\"","\"Abstraction\"","\"Goals\"","\"guessable\"","\"authenticates\"","\"weakly\"","\"on\"","\"secret\"","\"between\"","%eof"]
        bit_start = st * 62
        bit_end = (st + 1) * 62
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..61]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (49) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (49) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (34) = happyShift action_4
action_2 _ = happyFail (happyExpListPerState 2)

action_3 (62) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (27) = happyShift action_5
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (52) = happyShift action_6
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (34) = happyShift action_7
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (27) = happyShift action_10
action_7 (8) = happyGoto action_8
action_7 (9) = happyGoto action_9
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (50) = happyShift action_13
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (27) = happyShift action_12
action_9 (10) = happyGoto action_11
action_9 _ = happyFail (happyExpListPerState 9)

action_10 _ = happyReduce_10

action_11 (35) = happyShift action_17
action_11 (6) = happyGoto action_16
action_11 _ = happyReduce_5

action_12 (46) = happyShift action_15
action_12 _ = happyReduce_11

action_13 (34) = happyShift action_14
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (27) = happyShift action_22
action_14 (11) = happyGoto action_20
action_14 (12) = happyGoto action_21
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (27) = happyShift action_12
action_15 (10) = happyGoto action_19
action_15 _ = happyFail (happyExpListPerState 15)

action_16 _ = happyReduce_8

action_17 (27) = happyShift action_10
action_17 (8) = happyGoto action_18
action_17 (9) = happyGoto action_9
action_17 _ = happyReduce_4

action_18 _ = happyReduce_9

action_19 _ = happyReduce_12

action_20 (53) = happyShift action_25
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (51) = happyShift action_24
action_21 _ = happyReduce_14

action_22 (34) = happyShift action_23
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (27) = happyShift action_30
action_23 (28) = happyShift action_31
action_23 (30) = happyShift action_32
action_23 (32) = happyShift action_33
action_23 (14) = happyGoto action_34
action_23 (16) = happyGoto action_35
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (27) = happyShift action_30
action_24 (28) = happyShift action_31
action_24 (30) = happyShift action_32
action_24 (32) = happyShift action_33
action_24 (13) = happyGoto action_27
action_24 (15) = happyGoto action_28
action_24 (16) = happyGoto action_29
action_24 _ = happyFail (happyExpListPerState 24)

action_25 (34) = happyShift action_26
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (27) = happyShift action_49
action_26 (47) = happyShift action_50
action_26 (17) = happyGoto action_45
action_26 (18) = happyGoto action_46
action_26 (21) = happyGoto action_47
action_26 (23) = happyGoto action_48
action_26 _ = happyFail (happyExpListPerState 26)

action_27 _ = happyReduce_13

action_28 (43) = happyShift action_43
action_28 (46) = happyShift action_44
action_28 _ = happyFail (happyExpListPerState 28)

action_29 _ = happyReduce_21

action_30 (28) = happyShift action_42
action_30 _ = happyReduce_23

action_31 (27) = happyShift action_30
action_31 (28) = happyShift action_31
action_31 (30) = happyShift action_32
action_31 (32) = happyShift action_33
action_31 (15) = happyGoto action_41
action_31 (16) = happyGoto action_29
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (27) = happyShift action_30
action_32 (28) = happyShift action_31
action_32 (30) = happyShift action_32
action_32 (32) = happyShift action_33
action_32 (15) = happyGoto action_40
action_32 (16) = happyGoto action_29
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (27) = happyShift action_30
action_33 (28) = happyShift action_31
action_33 (30) = happyShift action_32
action_33 (32) = happyShift action_33
action_33 (15) = happyGoto action_39
action_33 (16) = happyGoto action_29
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (35) = happyShift action_38
action_34 (6) = happyGoto action_37
action_34 _ = happyReduce_5

action_35 (46) = happyShift action_36
action_35 _ = happyReduce_20

action_36 (27) = happyShift action_30
action_36 (28) = happyShift action_31
action_36 (30) = happyShift action_32
action_36 (32) = happyShift action_33
action_36 (14) = happyGoto action_67
action_36 (16) = happyGoto action_35
action_36 _ = happyFail (happyExpListPerState 36)

action_37 _ = happyReduce_16

action_38 (27) = happyShift action_22
action_38 (12) = happyGoto action_66
action_38 _ = happyReduce_4

action_39 (33) = happyShift action_65
action_39 (46) = happyShift action_44
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (31) = happyShift action_64
action_40 (46) = happyShift action_44
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (29) = happyShift action_63
action_41 (46) = happyShift action_44
action_41 _ = happyFail (happyExpListPerState 41)

action_42 (27) = happyShift action_30
action_42 (28) = happyShift action_31
action_42 (30) = happyShift action_32
action_42 (32) = happyShift action_33
action_42 (14) = happyGoto action_62
action_42 (16) = happyGoto action_35
action_42 _ = happyFail (happyExpListPerState 42)

action_43 (27) = happyShift action_30
action_43 (28) = happyShift action_31
action_43 (30) = happyShift action_32
action_43 (32) = happyShift action_33
action_43 (15) = happyGoto action_61
action_43 (16) = happyGoto action_29
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (27) = happyShift action_30
action_44 (28) = happyShift action_31
action_44 (30) = happyShift action_32
action_44 (32) = happyShift action_33
action_44 (15) = happyGoto action_60
action_44 (16) = happyGoto action_29
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (55) = happyShift action_59
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (27) = happyShift action_49
action_46 (47) = happyShift action_50
action_46 (17) = happyGoto action_58
action_46 (18) = happyGoto action_46
action_46 (21) = happyGoto action_47
action_46 (23) = happyGoto action_48
action_46 _ = happyReduce_28

action_47 (34) = happyShift action_57
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (36) = happyShift action_53
action_48 (37) = happyShift action_54
action_48 (38) = happyShift action_55
action_48 (39) = happyShift action_56
action_48 (19) = happyGoto action_52
action_48 _ = happyFail (happyExpListPerState 48)

action_49 _ = happyReduce_43

action_50 (27) = happyShift action_51
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (34) = happyShift action_75
action_51 (48) = happyShift action_76
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (27) = happyShift action_49
action_52 (47) = happyShift action_50
action_52 (23) = happyGoto action_74
action_52 _ = happyFail (happyExpListPerState 52)

action_53 _ = happyReduce_33

action_54 _ = happyReduce_34

action_55 _ = happyReduce_35

action_56 _ = happyReduce_36

action_57 (27) = happyShift action_30
action_57 (28) = happyShift action_31
action_57 (30) = happyShift action_32
action_57 (32) = happyShift action_33
action_57 (15) = happyGoto action_73
action_57 (16) = happyGoto action_29
action_57 _ = happyFail (happyExpListPerState 57)

action_58 _ = happyReduce_29

action_59 (34) = happyShift action_72
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (46) = happyShift action_44
action_60 _ = happyReduce_22

action_61 (46) = happyShift action_71
action_61 _ = happyReduce_17

action_62 (29) = happyShift action_70
action_62 _ = happyFail (happyExpListPerState 62)

action_63 _ = happyReduce_27

action_64 (27) = happyShift action_30
action_64 (28) = happyShift action_31
action_64 (30) = happyShift action_32
action_64 (32) = happyShift action_33
action_64 (16) = happyGoto action_69
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (27) = happyShift action_30
action_65 (28) = happyShift action_31
action_65 (30) = happyShift action_32
action_65 (32) = happyShift action_33
action_65 (16) = happyGoto action_68
action_65 _ = happyFail (happyExpListPerState 65)

action_66 _ = happyReduce_15

action_67 _ = happyReduce_19

action_68 _ = happyReduce_25

action_69 _ = happyReduce_24

action_70 _ = happyReduce_26

action_71 (27) = happyShift action_30
action_71 (28) = happyShift action_31
action_71 (30) = happyShift action_32
action_71 (32) = happyShift action_33
action_71 (13) = happyGoto action_85
action_71 (15) = happyGoto action_86
action_71 (16) = happyGoto action_29
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (27) = happyShift action_84
action_72 (28) = happyShift action_31
action_72 (30) = happyShift action_32
action_72 (32) = happyShift action_33
action_72 (47) = happyShift action_50
action_72 (15) = happyGoto action_79
action_72 (16) = happyGoto action_29
action_72 (22) = happyGoto action_80
action_72 (23) = happyGoto action_81
action_72 (24) = happyGoto action_82
action_72 (25) = happyGoto action_83
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (42) = happyShift action_78
action_73 (46) = happyShift action_44
action_73 _ = happyReduce_32

action_74 _ = happyReduce_41

action_75 (27) = happyShift action_30
action_75 (28) = happyShift action_31
action_75 (30) = happyShift action_32
action_75 (32) = happyShift action_33
action_75 (15) = happyGoto action_77
action_75 (16) = happyGoto action_29
action_75 _ = happyFail (happyExpListPerState 75)

action_76 _ = happyReduce_44

action_77 (46) = happyShift action_44
action_77 (48) = happyShift action_101
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (27) = happyShift action_30
action_78 (28) = happyShift action_31
action_78 (30) = happyShift action_32
action_78 (32) = happyShift action_33
action_78 (15) = happyGoto action_100
action_78 (16) = happyGoto action_29
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (46) = happyShift action_44
action_79 (56) = happyShift action_98
action_79 (60) = happyShift action_99
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (34) = happyShift action_97
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (36) = happyShift action_91
action_81 (37) = happyShift action_92
action_81 (38) = happyShift action_93
action_81 (39) = happyShift action_94
action_81 (57) = happyShift action_95
action_81 (58) = happyShift action_96
action_81 (20) = happyGoto action_90
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (54) = happyShift action_89
action_82 (5) = happyGoto action_88
action_82 _ = happyReduce_2

action_83 (27) = happyShift action_84
action_83 (28) = happyShift action_31
action_83 (30) = happyShift action_32
action_83 (32) = happyShift action_33
action_83 (47) = happyShift action_50
action_83 (15) = happyGoto action_79
action_83 (16) = happyGoto action_29
action_83 (22) = happyGoto action_80
action_83 (23) = happyGoto action_81
action_83 (24) = happyGoto action_87
action_83 (25) = happyGoto action_83
action_83 _ = happyReduce_46

action_84 (28) = happyShift action_42
action_84 (46) = happyReduce_23
action_84 (56) = happyReduce_23
action_84 (60) = happyReduce_23
action_84 _ = happyReduce_43

action_85 _ = happyReduce_18

action_86 (43) = happyShift action_43
action_86 (46) = happyShift action_44
action_86 _ = happyReduce_22

action_87 _ = happyReduce_47

action_88 _ = happyReduce_1

action_89 (34) = happyShift action_109
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (27) = happyShift action_49
action_90 (47) = happyShift action_50
action_90 (23) = happyGoto action_108
action_90 _ = happyFail (happyExpListPerState 90)

action_91 _ = happyReduce_37

action_92 _ = happyReduce_38

action_93 _ = happyReduce_39

action_94 _ = happyReduce_40

action_95 (27) = happyShift action_49
action_95 (47) = happyShift action_50
action_95 (23) = happyGoto action_107
action_95 _ = happyFail (happyExpListPerState 95)

action_96 (57) = happyShift action_106
action_96 _ = happyFail (happyExpListPerState 96)

action_97 (27) = happyShift action_30
action_97 (28) = happyShift action_31
action_97 (30) = happyShift action_32
action_97 (32) = happyShift action_33
action_97 (15) = happyGoto action_105
action_97 (16) = happyGoto action_29
action_97 _ = happyFail (happyExpListPerState 97)

action_98 (60) = happyShift action_104
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (61) = happyShift action_103
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (44) = happyShift action_102
action_100 (46) = happyShift action_44
action_100 _ = happyReduce_31

action_101 _ = happyReduce_45

action_102 (27) = happyShift action_30
action_102 (28) = happyShift action_31
action_102 (30) = happyShift action_32
action_102 (32) = happyShift action_33
action_102 (15) = happyGoto action_117
action_102 (16) = happyGoto action_29
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (27) = happyShift action_49
action_103 (47) = happyShift action_50
action_103 (23) = happyGoto action_115
action_103 (26) = happyGoto action_116
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (61) = happyShift action_114
action_104 _ = happyFail (happyExpListPerState 104)

action_105 (46) = happyShift action_44
action_105 _ = happyReduce_48

action_106 (27) = happyShift action_49
action_106 (47) = happyShift action_50
action_106 (23) = happyGoto action_113
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (59) = happyShift action_112
action_107 _ = happyFail (happyExpListPerState 107)

action_108 _ = happyReduce_42

action_109 (27) = happyShift action_111
action_109 (7) = happyGoto action_110
action_109 _ = happyFail (happyExpListPerState 109)

action_110 _ = happyReduce_3

action_111 (39) = happyShift action_122
action_111 _ = happyFail (happyExpListPerState 111)

action_112 (27) = happyShift action_30
action_112 (28) = happyShift action_31
action_112 (30) = happyShift action_32
action_112 (32) = happyShift action_33
action_112 (15) = happyGoto action_121
action_112 (16) = happyGoto action_29
action_112 _ = happyFail (happyExpListPerState 112)

action_113 (59) = happyShift action_120
action_113 _ = happyFail (happyExpListPerState 113)

action_114 (27) = happyShift action_49
action_114 (47) = happyShift action_50
action_114 (23) = happyGoto action_115
action_114 (26) = happyGoto action_119
action_114 _ = happyFail (happyExpListPerState 114)

action_115 (46) = happyShift action_118
action_115 _ = happyReduce_53

action_116 _ = happyReduce_51

action_117 (46) = happyShift action_44
action_117 _ = happyReduce_30

action_118 (27) = happyShift action_49
action_118 (47) = happyShift action_50
action_118 (23) = happyGoto action_115
action_118 (26) = happyGoto action_125
action_118 _ = happyFail (happyExpListPerState 118)

action_119 _ = happyReduce_52

action_120 (27) = happyShift action_30
action_120 (28) = happyShift action_31
action_120 (30) = happyShift action_32
action_120 (32) = happyShift action_33
action_120 (15) = happyGoto action_124
action_120 (16) = happyGoto action_29
action_120 _ = happyFail (happyExpListPerState 120)

action_121 (46) = happyShift action_44
action_121 _ = happyReduce_49

action_122 (27) = happyShift action_30
action_122 (28) = happyShift action_31
action_122 (30) = happyShift action_32
action_122 (32) = happyShift action_33
action_122 (16) = happyGoto action_123
action_122 _ = happyFail (happyExpListPerState 122)

action_123 (35) = happyShift action_127
action_123 (6) = happyGoto action_126
action_123 _ = happyReduce_5

action_124 (46) = happyShift action_44
action_124 _ = happyReduce_50

action_125 _ = happyReduce_54

action_126 _ = happyReduce_6

action_127 (27) = happyShift action_111
action_127 (7) = happyGoto action_128
action_127 _ = happyReduce_4

action_128 _ = happyReduce_7

happyReduce_1 = happyReduce 16 4 happyReduction_1
happyReduction_1 ((HappyAbsSyn5  happy_var_16) `HappyStk`
	(HappyAbsSyn24  happy_var_15) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_12) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_9) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 ((happy_var_3,happy_var_6,happy_var_9,happy_var_16,happy_var_12,happy_var_15)
	) `HappyStk` happyRest

happyReduce_2 = happySpecReduce_0  5 happyReduction_2
happyReduction_2  =  HappyAbsSyn5
		 ([]
	)

happyReduce_3 = happySpecReduce_3  5 happyReduction_3
happyReduction_3 (HappyAbsSyn5  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (happy_var_3
	)
happyReduction_3 _ _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  6 happyReduction_4
happyReduction_4 _
	 =  HappyAbsSyn6
		 (()
	)

happyReduce_5 = happySpecReduce_0  6 happyReduction_5
happyReduction_5  =  HappyAbsSyn6
		 (()
	)

happyReduce_6 = happyReduce 4 7 happyReduction_6
happyReduction_6 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 ([(happy_var_1,happy_var_3)]
	) `HappyStk` happyRest

happyReduce_7 = happyReduce 5 7 happyReduction_7
happyReduction_7 ((HappyAbsSyn5  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (((happy_var_1,happy_var_3):happy_var_5)
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_3  8 happyReduction_8
happyReduction_8 _
	(HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 ([(happy_var_1,happy_var_2)]
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happyReduce 4 8 happyReduction_9
happyReduction_9 ((HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	(HappyAbsSyn9  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((happy_var_1,happy_var_2):happy_var_4
	) `HappyStk` happyRest

happyReduce_10 = happySpecReduce_1  9 happyReduction_10
happyReduction_10 (HappyTerminal (TATOM _ happy_var_1))
	 =  HappyAbsSyn9
		 (case happy_var_1 of
	       "Agent" -> Agent False False
	       "Number" -> Number
               "SeqNumber" -> SeqNumber
	       "PublicKey" -> PublicKey
	       "Symmetric_key" -> SymmetricKey 
	       "Function" -> Function
	       "Untyped" -> Untyped
	       _ -> Custom happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  10 happyReduction_11
happyReduction_11 (HappyTerminal (TATOM _ happy_var_1))
	 =  HappyAbsSyn10
		 ([happy_var_1]
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  10 happyReduction_12
happyReduction_12 (HappyAbsSyn10  happy_var_3)
	_
	(HappyTerminal (TATOM _ happy_var_1))
	 =  HappyAbsSyn10
		 (happy_var_1:happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  11 happyReduction_13
happyReduction_13 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 ((happy_var_1,happy_var_3)
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  11 happyReduction_14
happyReduction_14 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 ((happy_var_1,[])
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happyReduce 5 12 happyReduction_15
happyReduction_15 ((HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn14  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (((happy_var_1,happy_var_3):happy_var_5)
	) `HappyStk` happyRest

happyReduce_16 = happyReduce 4 12 happyReduction_16
happyReduction_16 (_ `HappyStk`
	(HappyAbsSyn14  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 ([(happy_var_1,happy_var_3)]
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_3  13 happyReduction_17
happyReduction_17 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn13
		 ([(happy_var_1,happy_var_3)]
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happyReduce 5 13 happyReduction_18
happyReduction_18 ((HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (((happy_var_1,happy_var_3):happy_var_5)
	) `HappyStk` happyRest

happyReduce_19 = happySpecReduce_3  14 happyReduction_19
happyReduction_19 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1:happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  14 happyReduction_20
happyReduction_20 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  15 happyReduction_21
happyReduction_21 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  15 happyReduction_22
happyReduction_22 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn15
		 (Comp Cat [happy_var_1,happy_var_3]
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  16 happyReduction_23
happyReduction_23 (HappyTerminal (TATOM _ happy_var_1))
	 =  HappyAbsSyn15
		 (Atom happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happyReduce 4 16 happyReduction_24
happyReduction_24 ((HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Comp Crypt [happy_var_4,happy_var_2]
	) `HappyStk` happyRest

happyReduce_25 = happyReduce 4 16 happyReduction_25
happyReduction_25 ((HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (Comp Scrypt [happy_var_4,happy_var_2]
	) `HappyStk` happyRest

happyReduce_26 = happyReduce 4 16 happyReduction_26
happyReduction_26 (_ `HappyStk`
	(HappyAbsSyn14  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (if happy_var_1=="inv" then Comp Inv happy_var_3
			  else if happy_var_1=="exp" then Comp Exp happy_var_3
			  else if happy_var_1=="xor" then Comp Xor happy_var_3
			  else case happy_var_3 of
				 [x] -> Comp Apply ((Atom happy_var_1):[x])
				 _ -> Comp Apply ((Atom happy_var_1):[Comp Cat happy_var_3])
	) `HappyStk` happyRest

happyReduce_27 = happySpecReduce_3  16 happyReduction_27
happyReduction_27 _
	(HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (happy_var_2
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  17 happyReduction_28
happyReduction_28 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn17
		 ([happy_var_1]
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  17 happyReduction_29
happyReduction_29 (HappyAbsSyn17  happy_var_2)
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn17
		 ((happy_var_1:happy_var_2)
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happyReduce 7 18 happyReduction_30
happyReduction_30 ((HappyAbsSyn15  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 ((happy_var_1,happy_var_3,Just happy_var_5,Just happy_var_7)
	) `HappyStk` happyRest

happyReduce_31 = happyReduce 5 18 happyReduction_31
happyReduction_31 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 ((happy_var_1,happy_var_3,Just happy_var_5,Nothing)
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_3  18 happyReduction_32
happyReduction_32 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn18
		 ((happy_var_1,happy_var_3,Nothing,Nothing)
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  19 happyReduction_33
happyReduction_33 _
	 =  HappyAbsSyn19
		 (Secure
	)

happyReduce_34 = happySpecReduce_1  19 happyReduction_34
happyReduction_34 _
	 =  HappyAbsSyn19
		 (Authentic
	)

happyReduce_35 = happySpecReduce_1  19 happyReduction_35
happyReduction_35 _
	 =  HappyAbsSyn19
		 (Confidential
	)

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 _
	 =  HappyAbsSyn19
		 (Insecure
	)

happyReduce_37 = happySpecReduce_1  20 happyReduction_37
happyReduction_37 _
	 =  HappyAbsSyn19
		 (FreshSecure
	)

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 _
	 =  HappyAbsSyn19
		 (FreshAuthentic
	)

happyReduce_39 = happySpecReduce_1  20 happyReduction_39
happyReduction_39 _
	 =  HappyAbsSyn19
		 (Confidential
	)

happyReduce_40 = happySpecReduce_1  20 happyReduction_40
happyReduction_40 _
	 =  HappyAbsSyn19
		 (Insecure
	)

happyReduce_41 = happySpecReduce_3  21 happyReduction_41
happyReduction_41 (HappyAbsSyn23  happy_var_3)
	(HappyAbsSyn19  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn21
		 ((happy_var_1,happy_var_2,happy_var_3)
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  22 happyReduction_42
happyReduction_42 (HappyAbsSyn23  happy_var_3)
	(HappyAbsSyn19  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn21
		 ((happy_var_1,happy_var_2,happy_var_3)
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  23 happyReduction_43
happyReduction_43 (HappyTerminal (TATOM _ happy_var_1))
	 =  HappyAbsSyn23
		 ((happy_var_1,False,Nothing)
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  23 happyReduction_44
happyReduction_44 _
	(HappyTerminal (TATOM _ happy_var_2))
	_
	 =  HappyAbsSyn23
		 ((happy_var_2,True,Nothing)
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happyReduce 5 23 happyReduction_45
happyReduction_45 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 ((happy_var_2,True, Just happy_var_4)
	) `HappyStk` happyRest

happyReduce_46 = happySpecReduce_1  24 happyReduction_46
happyReduction_46 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 ([happy_var_1]
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_2  24 happyReduction_47
happyReduction_47 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1:happy_var_2
	)
happyReduction_47 _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  25 happyReduction_48
happyReduction_48 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 ((ChGoal happy_var_1 happy_var_3)
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happyReduce 5 25 happyReduction_49
happyReduction_49 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 ((ChGoal (happy_var_3,FreshAuthentic,happy_var_1) happy_var_5)
	) `HappyStk` happyRest

happyReduce_50 = happyReduce 6 25 happyReduction_50
happyReduction_50 ((HappyAbsSyn15  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 ((ChGoal (happy_var_4,Authentic,happy_var_1) happy_var_6)
	) `HappyStk` happyRest

happyReduce_51 = happyReduce 4 25 happyReduction_51
happyReduction_51 ((HappyAbsSyn26  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 ((Secret happy_var_1 happy_var_4 False)
	) `HappyStk` happyRest

happyReduce_52 = happyReduce 5 25 happyReduction_52
happyReduction_52 ((HappyAbsSyn26  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 ((Secret happy_var_1 happy_var_5 True)
	) `HappyStk` happyRest

happyReduce_53 = happySpecReduce_1  26 happyReduction_53
happyReduction_53 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  26 happyReduction_54
happyReduction_54 (HappyAbsSyn26  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn26
		 ((happy_var_1:happy_var_3)
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 62 62 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TATOM _ happy_dollar_dollar -> cont 27;
	TOPENP _ -> cont 28;
	TCLOSEP _ -> cont 29;
	TOPENB _ -> cont 30;
	TCLOSEB _ -> cont 31;
	TOPENSCRYPT _ -> cont 32;
	TCLOSESCRYPT _ -> cont 33;
	TCOLON _ -> cont 34;
	TSEMICOLON _ -> cont 35;
	TSECCH _ -> cont 36;
	TAUTHCH _ -> cont 37;
	TCONFCH _ -> cont 38;
	TINSECCH _ -> cont 39;
	TFAUTHCH _ -> cont 40;
	TFSECCH _ -> cont 41;
	TPERCENT _ -> cont 42;
	TUNEQUAL _ -> cont 43;
	TEXCLAM  _ -> cont 44;
	TDOT _ -> cont 45;
	TCOMMA _ -> cont 46;
	TOPENSQB _ -> cont 47;
	TCLOSESQB _ -> cont 48;
	TPROTOCOL _ -> cont 49;
	TKNOWLEDGE _ -> cont 50;
	TWHERE _ -> cont 51;
	TTYPES _ -> cont 52;
	TACTIONS _ -> cont 53;
	TABSTRACTION _ -> cont 54;
	TGOALS _ -> cont 55;
	TGUESS _ -> cont 56;
	TAUTHENTICATES _ -> cont 57;
	TWEAKLY _ -> cont 58;
	TON _ -> cont 59;
	TSECRET _ -> cont 60;
	TBETWEEN _ -> cont 61;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 62 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [String]) -> HappyIdentity a
happyError' = HappyIdentity . (\(tokens, _) -> happyError tokens)
anbparser tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


happyError :: [Token] -> a
happyError tks = error ("AnB Parse error at " ++ lcn ++ "\n" )
	where
	lcn = 	case tks of
		  [] -> "end of file"
		  tk:_ -> "line " ++ show l ++ ", column " ++ show c ++ " - Token: " ++ show tk
			where
			AlexPn _ l c = token_posn tk
{-# LINE 1 "templates/GenericTemplate.hs" #-}

















































































































































































































-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 











data Happy_IntList = HappyCons Int Happy_IntList




















infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action




indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.

