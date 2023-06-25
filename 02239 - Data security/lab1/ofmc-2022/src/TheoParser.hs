{-# OPTIONS_GHC -w #-}
{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2020
(C) Copyright Jakub Janaszkiewicz 2022
(C) Copyright Paolo Modesti 2012
(C) Copyright Nicklas Bo Jensen 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

module TheoParser where
import TheoLexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 ([PTheo])
	| HappyAbsSyn5 (PTheo)
	| HappyAbsSyn6 (PSigSec)
	| HappyAbsSyn8 ([PTopdec])
	| HappyAbsSyn10 ([PTopdecCase])
	| HappyAbsSyn11 ([PUncond])
	| HappyAbsSyn12 ([Int])
	| HappyAbsSyn14 ([(PTerm,PTerm)])
	| HappyAbsSyn16 ([PDecana])
	| HappyAbsSyn18 ([(PIneq,[PTerm],[PTerm])])
	| HappyAbsSyn19 ([([PTerm],[PTerm])])
	| HappyAbsSyn20 (PProt)
	| HappyAbsSyn21 (PSection)
	| HappyAbsSyn22 ([PTypeDecl])
	| HappyAbsSyn26 (PTypeDecl)
	| HappyAbsSyn27 (PType)
	| HappyAbsSyn31 ([PType])
	| HappyAbsSyn32 ([(PIdent,PState)])
	| HappyAbsSyn33 ((PIdent,PState))
	| HappyAbsSyn34 ([(PIdent,PRule)])
	| HappyAbsSyn35 ((PIdent,PRule))
	| HappyAbsSyn36 ([PSubst])
	| HappyAbsSyn38 (PSubst)
	| HappyAbsSyn39 ([(PIdent, PCNState)])
	| HappyAbsSyn40 ((PIdent, PCNState))
	| HappyAbsSyn41 (PCNState)
	| HappyAbsSyn42 ((PNState,[PCondition]))
	| HappyAbsSyn43 (PState)
	| HappyAbsSyn44 (PNFact)
	| HappyAbsSyn46 (([PNFact],[PCondition]))
	| HappyAbsSyn47 (PFact)
	| HappyAbsSyn48 ([PFact])
	| HappyAbsSyn49 (PTerm)
	| HappyAbsSyn50 ([PTerm])
	| HappyAbsSyn51 ([PCondition])
	| HappyAbsSyn52 (PCondition)
	| HappyAbsSyn53 ([PIdent])

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
 action_92 :: () => Int -> ({-HappyReduction (HappyIdentity) = -}
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
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81,
 happyReduce_82,
 happyReduce_83,
 happyReduce_84,
 happyReduce_85,
 happyReduce_86,
 happyReduce_87,
 happyReduce_88,
 happyReduce_89,
 happyReduce_90,
 happyReduce_91,
 happyReduce_92,
 happyReduce_93,
 happyReduce_94,
 happyReduce_95,
 happyReduce_96,
 happyReduce_97,
 happyReduce_98,
 happyReduce_99,
 happyReduce_100,
 happyReduce_101,
 happyReduce_102,
 happyReduce_103,
 happyReduce_104,
 happyReduce_105,
 happyReduce_106,
 happyReduce_107,
 happyReduce_108,
 happyReduce_109,
 happyReduce_110,
 happyReduce_111,
 happyReduce_112,
 happyReduce_113,
 happyReduce_114,
 happyReduce_115,
 happyReduce_116,
 happyReduce_117,
 happyReduce_118 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,154) ([0,0,0,0,0,4,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,32,0,0,0,0,0,2048,0,0,0,0,0,64,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,16,0,0,0,0,1024,0,0,0,0,0,49152,0,0,0,0,0,0,0,0,4,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,3072,0,0,0,0,0,0,192,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,8192,0,0,0,0,0,0,0,512,0,0,0,0,0,4,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,12,0,0,0,0,0,0,0,2,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,3072,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,49152,0,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,2304,0,0,0,0,0,0,4,0,0,0,0,0,0,8,0,0,0,0,0,0,8192,0,0,0,0,0,12,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,8384,0,0,0,0,0,0,0,256,0,0,0,0,0,0,0,0,0,0,0,32768,16,0,0,0,0,0,0,0,8,0,0,0,0,4224,0,0,0,0,0,49152,0,0,0,0,0,0,2048,0,0,0,0,0,0,192,0,0,0,0,0,0,512,0,0,0,0,0,0,0,8,0,0,0,0,32768,0,0,0,0,0,0,0,2048,0,0,0,0,0,2048,0,0,0,0,0,0,0,512,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3072,0,0,0,0,0,0,2048,0,0,0,0,0,0,128,0,0,0,0,0,49152,0,0,0,0,0,0,0,2,0,0,0,0,0,192,0,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,0,2048,1,0,0,0,0,0,512,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,16384,0,0,0,0,0,0,264,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_theoparser","theoryFile","subtheory","signaturesec","oparitys","topdecsec","topdeclarations","topdecCases","topdecUncond","intrudersec","fecsec","cancelsec","equations","anasec","decanas","decanaCases","decanaCases2","sections","section","propdec","prop","backwardsLTL","sigdec","ftypedec","myftype","typedecs","typedec","mytype","mytypes","initials","initial","rulez","rule","freshvar","substs","subst","goalz","goal","cnstate","nstate","state","nfact","negfact","nfacts","fact","facts","term","terms","conditions","condition","vars","varcos","const","var","num","'('","')'","'['","'|'","']'","':'","'='","if","'{'","'}'","\":=\"","\"=>\"","\"(-)\"","'/'","'&'","'.'","','","'*'","'->'","\"/=\"","decana","analysis","cancellation","fec","'=='","theory","topdec","topdecU","signature","exists","equ","less","not","step","sect","sectypes","secprop","secinits","secrules","secgoals","gol","init","property","\"[]\"","\"/\\\\\"","\"\\/\"","'-'","'~'","\"<->\"","\"[-]\"","%eof"]
        bit_start = st * 108
        bit_end = (st + 1) * 108
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..107]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (83) = happyShift action_3
action_0 (4) = happyGoto action_4
action_0 (5) = happyGoto action_5
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (83) = happyShift action_3
action_1 (5) = happyGoto action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyFail (happyExpListPerState 2)

action_3 (56) = happyShift action_7
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (108) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (83) = happyShift action_3
action_5 (4) = happyGoto action_6
action_5 (5) = happyGoto action_5
action_5 _ = happyReduce_1

action_6 _ = happyReduce_2

action_7 (63) = happyShift action_8
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (86) = happyShift action_10
action_8 (6) = happyGoto action_9
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (80) = happyShift action_13
action_9 (14) = happyGoto action_12
action_9 _ = happyReduce_20

action_10 (63) = happyShift action_11
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (55) = happyShift action_18
action_11 (7) = happyGoto action_17
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (85) = happyShift action_16
action_12 (8) = happyGoto action_15
action_12 _ = happyReduce_7

action_13 (63) = happyShift action_14
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (55) = happyShift action_25
action_14 (56) = happyShift action_26
action_14 (15) = happyGoto action_23
action_14 (49) = happyGoto action_24
action_14 _ = happyReduce_22

action_15 (79) = happyShift action_22
action_15 (16) = happyGoto action_21
action_15 _ = happyReduce_24

action_16 (63) = happyShift action_20
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_4

action_18 (71) = happyShift action_19
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (57) = happyShift action_32
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (84) = happyShift action_31
action_20 (9) = happyGoto action_30
action_20 _ = happyFail (happyExpListPerState 20)

action_21 _ = happyReduce_3

action_22 (63) = happyShift action_29
action_22 _ = happyFail (happyExpListPerState 22)

action_23 _ = happyReduce_21

action_24 (64) = happyShift action_28
action_24 _ = happyFail (happyExpListPerState 24)

action_25 (58) = happyShift action_27
action_25 _ = happyReduce_104

action_26 _ = happyReduce_103

action_27 (55) = happyShift action_25
action_27 (56) = happyShift action_26
action_27 (49) = happyGoto action_38
action_27 (50) = happyGoto action_39
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (55) = happyShift action_25
action_28 (56) = happyShift action_26
action_28 (49) = happyGoto action_37
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (78) = happyShift action_36
action_29 (17) = happyGoto action_35
action_29 _ = happyReduce_27

action_30 _ = happyReduce_8

action_31 (58) = happyShift action_34
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (74) = happyShift action_33
action_32 _ = happyReduce_5

action_33 (55) = happyShift action_18
action_33 (7) = happyGoto action_45
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (55) = happyShift action_44
action_34 _ = happyFail (happyExpListPerState 34)

action_35 _ = happyReduce_25

action_36 (58) = happyShift action_43
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (55) = happyShift action_25
action_37 (56) = happyShift action_26
action_37 (15) = happyGoto action_42
action_37 (49) = happyGoto action_24
action_37 _ = happyReduce_22

action_38 (74) = happyShift action_41
action_38 _ = happyReduce_105

action_39 (59) = happyShift action_40
action_39 _ = happyFail (happyExpListPerState 39)

action_40 _ = happyReduce_102

action_41 (55) = happyShift action_25
action_41 (56) = happyShift action_26
action_41 (49) = happyGoto action_38
action_41 (50) = happyGoto action_48
action_41 _ = happyFail (happyExpListPerState 41)

action_42 _ = happyReduce_23

action_43 (55) = happyShift action_25
action_43 (56) = happyShift action_26
action_43 (49) = happyGoto action_47
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (74) = happyShift action_46
action_44 _ = happyFail (happyExpListPerState 44)

action_45 _ = happyReduce_6

action_46 (55) = happyShift action_25
action_46 (56) = happyShift action_26
action_46 (49) = happyGoto action_50
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (59) = happyShift action_49
action_47 _ = happyFail (happyExpListPerState 47)

action_48 _ = happyReduce_106

action_49 (61) = happyShift action_53
action_49 (64) = happyShift action_54
action_49 (18) = happyGoto action_52
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (59) = happyShift action_51
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (64) = happyShift action_59
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (78) = happyShift action_36
action_52 (17) = happyGoto action_58
action_52 _ = happyReduce_27

action_53 (55) = happyShift action_25
action_53 (56) = happyShift action_26
action_53 (49) = happyGoto action_57
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (60) = happyShift action_56
action_54 (19) = happyGoto action_55
action_54 _ = happyReduce_32

action_55 _ = happyReduce_29

action_56 (55) = happyShift action_25
action_56 (56) = happyShift action_26
action_56 (62) = happyShift action_66
action_56 (49) = happyGoto action_38
action_56 (50) = happyGoto action_65
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (77) = happyShift action_64
action_57 _ = happyFail (happyExpListPerState 57)

action_58 _ = happyReduce_26

action_59 (60) = happyShift action_62
action_59 (65) = happyShift action_63
action_59 (10) = happyGoto action_60
action_59 (11) = happyGoto action_61
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (84) = happyShift action_31
action_60 (9) = happyGoto action_73
action_60 _ = happyReduce_9

action_61 (60) = happyShift action_62
action_61 (65) = happyShift action_63
action_61 (10) = happyGoto action_72
action_61 (11) = happyGoto action_61
action_61 _ = happyReduce_13

action_62 (55) = happyShift action_25
action_62 (56) = happyShift action_26
action_62 (49) = happyGoto action_38
action_62 (50) = happyGoto action_71
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (56) = happyShift action_70
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (55) = happyShift action_25
action_64 (56) = happyShift action_26
action_64 (49) = happyGoto action_69
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (62) = happyShift action_68
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (76) = happyShift action_67
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (60) = happyShift action_78
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (76) = happyShift action_77
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (64) = happyShift action_76
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (82) = happyShift action_75
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (62) = happyShift action_74
action_71 _ = happyFail (happyExpListPerState 71)

action_72 _ = happyReduce_14

action_73 _ = happyReduce_10

action_74 (60) = happyShift action_62
action_74 (11) = happyGoto action_83
action_74 _ = happyReduce_15

action_75 (55) = happyShift action_25
action_75 (56) = happyShift action_26
action_75 (49) = happyGoto action_82
action_75 _ = happyFail (happyExpListPerState 75)

action_76 (60) = happyShift action_56
action_76 (19) = happyGoto action_81
action_76 _ = happyReduce_32

action_77 (60) = happyShift action_80
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (55) = happyShift action_25
action_78 (56) = happyShift action_26
action_78 (49) = happyGoto action_38
action_78 (50) = happyGoto action_79
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (62) = happyShift action_86
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (55) = happyShift action_25
action_80 (56) = happyShift action_26
action_80 (49) = happyGoto action_38
action_80 (50) = happyGoto action_85
action_80 _ = happyFail (happyExpListPerState 80)

action_81 _ = happyReduce_28

action_82 (66) = happyShift action_84
action_82 _ = happyFail (happyExpListPerState 82)

action_83 _ = happyReduce_16

action_84 (60) = happyShift action_62
action_84 (65) = happyShift action_63
action_84 (10) = happyGoto action_89
action_84 (11) = happyGoto action_61
action_84 _ = happyFail (happyExpListPerState 84)

action_85 (62) = happyShift action_88
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (60) = happyShift action_56
action_86 (19) = happyGoto action_87
action_86 _ = happyReduce_32

action_87 _ = happyReduce_31

action_88 (60) = happyShift action_56
action_88 (19) = happyGoto action_91
action_88 _ = happyReduce_32

action_89 (67) = happyShift action_90
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (60) = happyShift action_62
action_90 (65) = happyShift action_63
action_90 (10) = happyGoto action_92
action_90 (11) = happyGoto action_61
action_90 _ = happyReduce_11

action_91 _ = happyReduce_30

action_92 _ = happyReduce_12

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 ([happy_var_1]
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_2  4 happyReduction_2
happyReduction_2 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1 : happy_var_2
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happyReduce 7 5 happyReduction_3
happyReduction_3 ((HappyAbsSyn16  happy_var_7) `HappyStk`
	(HappyAbsSyn8  happy_var_6) `HappyStk`
	(HappyAbsSyn14  happy_var_5) `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 ((happy_var_4,happy_var_5,happy_var_6,happy_var_7)
	) `HappyStk` happyRest

happyReduce_4 = happySpecReduce_3  6 happyReduction_4
happyReduction_4 (HappyAbsSyn6  happy_var_3)
	_
	_
	 =  HappyAbsSyn6
		 (happy_var_3
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  7 happyReduction_5
happyReduction_5 (HappyTerminal (TNUM _ happy_var_3))
	_
	(HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn6
		 ([(happy_var_1,happy_var_3)]
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happyReduce 5 7 happyReduction_6
happyReduction_6 ((HappyAbsSyn6  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TNUM _ happy_var_3)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 ((happy_var_1,happy_var_3):happy_var_5
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_0  8 happyReduction_7
happyReduction_7  =  HappyAbsSyn8
		 ([]
	)

happyReduce_8 = happySpecReduce_3  8 happyReduction_8
happyReduction_8 (HappyAbsSyn8  happy_var_3)
	_
	_
	 =  HappyAbsSyn8
		 (happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happyReduce 8 9 happyReduction_9
happyReduction_9 ((HappyAbsSyn10  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ([(happy_var_3,happy_var_5,happy_var_8)]
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 9 9 happyReduction_10
happyReduction_10 ((HappyAbsSyn8  happy_var_9) `HappyStk`
	(HappyAbsSyn10  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((happy_var_3,happy_var_5,happy_var_8):happy_var_9
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 7 10 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVAR _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 ([PCond (happy_var_2,happy_var_4) happy_var_6]
	) `HappyStk` happyRest

happyReduce_12 = happyReduce 8 10 happyReduction_12
happyReduction_12 ((HappyAbsSyn10  happy_var_8) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVAR _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 ((PCond (happy_var_2,happy_var_4) happy_var_6):happy_var_8
	) `HappyStk` happyRest

happyReduce_13 = happySpecReduce_1  10 happyReduction_13
happyReduction_13 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 ([PUncond happy_var_1]
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_2  10 happyReduction_14
happyReduction_14 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 ((PUncond happy_var_1):happy_var_2
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  11 happyReduction_15
happyReduction_15 _
	(HappyAbsSyn50  happy_var_2)
	_
	 =  HappyAbsSyn11
		 ([happy_var_2]
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happyReduce 4 11 happyReduction_16
happyReduction_16 ((HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn50  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (happy_var_2:happy_var_4
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_0  12 happyReduction_17
happyReduction_17  =  HappyAbsSyn12
		 ([]
	)

happyReduce_18 = happySpecReduce_0  13 happyReduction_18
happyReduction_18  =  HappyAbsSyn12
		 ([]
	)

happyReduce_19 = happySpecReduce_3  13 happyReduction_19
happyReduction_19 _
	_
	_
	 =  HappyAbsSyn12
		 ([]
	)

happyReduce_20 = happySpecReduce_0  14 happyReduction_20
happyReduction_20  =  HappyAbsSyn14
		 ([]
	)

happyReduce_21 = happySpecReduce_3  14 happyReduction_21
happyReduction_21 (HappyAbsSyn14  happy_var_3)
	_
	_
	 =  HappyAbsSyn14
		 (happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_0  15 happyReduction_22
happyReduction_22  =  HappyAbsSyn14
		 ([]
	)

happyReduce_23 = happyReduce 4 15 happyReduction_23
happyReduction_23 ((HappyAbsSyn14  happy_var_4) `HappyStk`
	(HappyAbsSyn49  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 ((happy_var_1,happy_var_3):happy_var_4
	) `HappyStk` happyRest

happyReduce_24 = happySpecReduce_0  16 happyReduction_24
happyReduction_24  =  HappyAbsSyn16
		 ([]
	)

happyReduce_25 = happySpecReduce_3  16 happyReduction_25
happyReduction_25 (HappyAbsSyn16  happy_var_3)
	_
	_
	 =  HappyAbsSyn16
		 (happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happyReduce 6 17 happyReduction_26
happyReduction_26 ((HappyAbsSyn16  happy_var_6) `HappyStk`
	(HappyAbsSyn18  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 ((happy_var_3,happy_var_5):happy_var_6
	) `HappyStk` happyRest

happyReduce_27 = happySpecReduce_0  17 happyReduction_27
happyReduction_27  =  HappyAbsSyn16
		 ([]
	)

happyReduce_28 = happyReduce 6 18 happyReduction_28
happyReduction_28 ((HappyAbsSyn19  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (map (\ (x,y) -> ([(happy_var_2,happy_var_4)],x,y)) happy_var_6
	) `HappyStk` happyRest

happyReduce_29 = happySpecReduce_2  18 happyReduction_29
happyReduction_29 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn18
		 (map (\ (x,y) -> ([],x,y)) happy_var_2
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happyReduce 8 19 happyReduction_30
happyReduction_30 ((HappyAbsSyn19  happy_var_8) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn50  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn50  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 ((happy_var_2,happy_var_6):happy_var_8
	) `HappyStk` happyRest

happyReduce_31 = happyReduce 7 19 happyReduction_31
happyReduction_31 ((HappyAbsSyn19  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn50  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (([],happy_var_5):happy_var_7
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_0  19 happyReduction_32
happyReduction_32  =  HappyAbsSyn19
		 ([]
	)

happyReduce_33 = happySpecReduce_1  20 happyReduction_33
happyReduction_33 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn20
		 ([happy_var_1]
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_2  20 happyReduction_34
happyReduction_34 (HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1 : happy_var_2
	)
happyReduction_34 _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  21 happyReduction_35
happyReduction_35 (HappyAbsSyn22  happy_var_3)
	_
	_
	 =  HappyAbsSyn21
		 (PTypeSec happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  21 happyReduction_36
happyReduction_36 (HappyAbsSyn22  happy_var_3)
	_
	_
	 =  HappyAbsSyn21
		 (PTypeSec happy_var_3
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  21 happyReduction_37
happyReduction_37 (HappyAbsSyn32  happy_var_3)
	_
	_
	 =  HappyAbsSyn21
		 (PInitSec happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  21 happyReduction_38
happyReduction_38 (HappyAbsSyn34  happy_var_3)
	_
	_
	 =  HappyAbsSyn21
		 (PRuleSec happy_var_3
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  21 happyReduction_39
happyReduction_39 (HappyAbsSyn39  happy_var_3)
	_
	_
	 =  HappyAbsSyn21
		 (PGoalSec happy_var_3
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  21 happyReduction_40
happyReduction_40 (HappyAbsSyn22  happy_var_3)
	_
	_
	 =  HappyAbsSyn21
		 (PTypeSec happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  22 happyReduction_41
happyReduction_41 _
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_42 = happySpecReduce_2  22 happyReduction_42
happyReduction_42 _
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_43 = happyReduce 5 23 happyReduction_43
happyReduction_43 (_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 ([]
	) `HappyStk` happyRest

happyReduce_44 = happyReduce 8 23 happyReduction_44
happyReduction_44 (_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 ([]
	) `HappyStk` happyRest

happyReduce_45 = happySpecReduce_3  24 happyReduction_45
happyReduction_45 _
	_
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_46 = happySpecReduce_1  24 happyReduction_46
happyReduction_46 _
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_47 = happySpecReduce_1  24 happyReduction_47
happyReduction_47 _
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_48 = happySpecReduce_1  24 happyReduction_48
happyReduction_48 _
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_49 = happySpecReduce_3  24 happyReduction_49
happyReduction_49 _
	_
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_50 = happySpecReduce_3  24 happyReduction_50
happyReduction_50 _
	_
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_51 = happySpecReduce_3  24 happyReduction_51
happyReduction_51 _
	_
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_52 = happySpecReduce_2  24 happyReduction_52
happyReduction_52 _
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_53 = happySpecReduce_2  24 happyReduction_53
happyReduction_53 _
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_54 = happySpecReduce_2  24 happyReduction_54
happyReduction_54 _
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_55 = happySpecReduce_2  24 happyReduction_55
happyReduction_55 _
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_56 = happySpecReduce_2  24 happyReduction_56
happyReduction_56 _
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_57 = happySpecReduce_1  25 happyReduction_57
happyReduction_57 _
	 =  HappyAbsSyn22
		 ([] --- ignore this bs.
	)

happyReduce_58 = happySpecReduce_2  25 happyReduction_58
happyReduction_58 _
	_
	 =  HappyAbsSyn22
		 ([] --- ignore this bs.
	)

happyReduce_59 = happySpecReduce_3  26 happyReduction_59
happyReduction_59 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn53  happy_var_1)
	 =  HappyAbsSyn26
		 (Decl happy_var_3 happy_var_1
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happyReduce 4 27 happyReduction_60
happyReduction_60 (_ `HappyStk`
	(HappyAbsSyn31  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (Comp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_61 = happySpecReduce_1  27 happyReduction_61
happyReduction_61 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn27
		 (Atomic happy_var_1
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  27 happyReduction_62
happyReduction_62 _
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  27 happyReduction_63
happyReduction_63 _
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  28 happyReduction_64
happyReduction_64 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn22
		 ([happy_var_1]
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_2  28 happyReduction_65
happyReduction_65 (HappyAbsSyn22  happy_var_2)
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1 : happy_var_2
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_3  29 happyReduction_66
happyReduction_66 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn53  happy_var_1)
	 =  HappyAbsSyn26
		 (Decl happy_var_3 happy_var_1
	)
happyReduction_66 _ _ _  = notHappyAtAll 

happyReduce_67 = happyReduce 4 30 happyReduction_67
happyReduction_67 (_ `HappyStk`
	(HappyAbsSyn31  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (Comp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_68 = happySpecReduce_1  30 happyReduction_68
happyReduction_68 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn27
		 (Atomic happy_var_1
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  31 happyReduction_69
happyReduction_69 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn31
		 ([happy_var_1]
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  31 happyReduction_70
happyReduction_70 (HappyAbsSyn31  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1 : happy_var_3
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  32 happyReduction_71
happyReduction_71 (HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn32
		 ([happy_var_1]
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_2  32 happyReduction_72
happyReduction_72 (HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn32
		 (happy_var_1 : happy_var_2
	)
happyReduction_72 _ _  = notHappyAtAll 

happyReduce_73 = happyReduce 4 33 happyReduction_73
happyReduction_73 ((HappyAbsSyn43  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn33
		 ((happy_var_2,happy_var_4)
	) `HappyStk` happyRest

happyReduce_74 = happySpecReduce_1  34 happyReduction_74
happyReduction_74 (HappyAbsSyn35  happy_var_1)
	 =  HappyAbsSyn34
		 ([happy_var_1]
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_2  34 happyReduction_75
happyReduction_75 (HappyAbsSyn34  happy_var_2)
	(HappyAbsSyn35  happy_var_1)
	 =  HappyAbsSyn34
		 (happy_var_1 : happy_var_2
	)
happyReduction_75 _ _  = notHappyAtAll 

happyReduce_76 = happyReduce 10 35 happyReduction_76
happyReduction_76 ((HappyAbsSyn43  happy_var_10) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn36  happy_var_8) `HappyStk`
	(HappyAbsSyn41  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn35
		 ((happy_var_2,(happy_var_7,happy_var_10,happy_var_8))
	) `HappyStk` happyRest

happyReduce_77 = happySpecReduce_0  36 happyReduction_77
happyReduction_77  =  HappyAbsSyn36
		 ([]
	)

happyReduce_78 = happyReduce 5 36 happyReduction_78
happyReduction_78 (_ `HappyStk`
	(HappyAbsSyn36  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn36
		 (happy_var_4
	) `HappyStk` happyRest

happyReduce_79 = happySpecReduce_1  37 happyReduction_79
happyReduction_79 (HappyAbsSyn38  happy_var_1)
	 =  HappyAbsSyn36
		 ([happy_var_1]
	)
happyReduction_79 _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_3  37 happyReduction_80
happyReduction_80 (HappyAbsSyn36  happy_var_3)
	_
	(HappyAbsSyn38  happy_var_1)
	 =  HappyAbsSyn36
		 (happy_var_1 : happy_var_3
	)
happyReduction_80 _ _ _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_1  38 happyReduction_81
happyReduction_81 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn38
		 ((happy_var_1,Nothing)
	)
happyReduction_81 _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_3  38 happyReduction_82
happyReduction_82 (HappyAbsSyn49  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn38
		 ((happy_var_1,Just happy_var_3)
	)
happyReduction_82 _ _ _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_1  39 happyReduction_83
happyReduction_83 (HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn39
		 ([happy_var_1]
	)
happyReduction_83 _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_2  39 happyReduction_84
happyReduction_84 (HappyAbsSyn39  happy_var_2)
	(HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn39
		 (happy_var_1 : happy_var_2
	)
happyReduction_84 _ _  = notHappyAtAll 

happyReduce_85 = happyReduce 7 40 happyReduction_85
happyReduction_85 ((HappyAbsSyn41  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn40
		 ((happy_var_2,happy_var_7)
	) `HappyStk` happyRest

happyReduce_86 = happySpecReduce_1  41 happyReduction_86
happyReduction_86 (HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn41
		 (happy_var_1
	)
happyReduction_86 _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_1  42 happyReduction_87
happyReduction_87 (HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn42
		 (happy_var_1
	)
happyReduction_87 _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_1  43 happyReduction_88
happyReduction_88 (HappyAbsSyn48  happy_var_1)
	 =  HappyAbsSyn43
		 (happy_var_1
	)
happyReduction_88 _  = notHappyAtAll 

happyReduce_89 = happySpecReduce_1  44 happyReduction_89
happyReduction_89 (HappyAbsSyn47  happy_var_1)
	 =  HappyAbsSyn44
		 (Plain happy_var_1
	)
happyReduction_89 _  = notHappyAtAll 

happyReduce_90 = happySpecReduce_1  44 happyReduction_90
happyReduction_90 (HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn44
		 (happy_var_1
	)
happyReduction_90 _  = notHappyAtAll 

happyReduce_91 = happyReduce 4 45 happyReduction_91
happyReduction_91 (_ `HappyStk`
	(HappyAbsSyn47  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn44
		 (Not happy_var_3
	) `HappyStk` happyRest

happyReduce_92 = happyReduce 4 45 happyReduction_92
happyReduction_92 (_ `HappyStk`
	(HappyAbsSyn47  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn44
		 (Not happy_var_3
	) `HappyStk` happyRest

happyReduce_93 = happySpecReduce_0  46 happyReduction_93
happyReduction_93  =  HappyAbsSyn46
		 (([],[])
	)

happyReduce_94 = happySpecReduce_1  46 happyReduction_94
happyReduction_94 (HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn46
		 (([happy_var_1],[])
	)
happyReduction_94 _  = notHappyAtAll 

happyReduce_95 = happySpecReduce_3  46 happyReduction_95
happyReduction_95 (HappyAbsSyn46  happy_var_3)
	_
	(HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn46
		 ((happy_var_1 : fst happy_var_3,snd happy_var_3)
	)
happyReduction_95 _ _ _  = notHappyAtAll 

happyReduce_96 = happySpecReduce_3  46 happyReduction_96
happyReduction_96 (HappyAbsSyn46  happy_var_3)
	_
	(HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn46
		 ((happy_var_1 : fst happy_var_3,snd happy_var_3)
	)
happyReduction_96 _ _ _  = notHappyAtAll 

happyReduce_97 = happySpecReduce_3  46 happyReduction_97
happyReduction_97 (HappyAbsSyn51  happy_var_3)
	_
	(HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn46
		 (([happy_var_1],happy_var_3)
	)
happyReduction_97 _ _ _  = notHappyAtAll 

happyReduce_98 = happyReduce 4 47 happyReduction_98
happyReduction_98 (_ `HappyStk`
	(HappyAbsSyn50  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn47
		 ((happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_99 = happySpecReduce_0  48 happyReduction_99
happyReduction_99  =  HappyAbsSyn48
		 ([]
	)

happyReduce_100 = happySpecReduce_1  48 happyReduction_100
happyReduction_100 (HappyAbsSyn47  happy_var_1)
	 =  HappyAbsSyn48
		 ([happy_var_1]
	)
happyReduction_100 _  = notHappyAtAll 

happyReduce_101 = happySpecReduce_3  48 happyReduction_101
happyReduction_101 (HappyAbsSyn48  happy_var_3)
	_
	(HappyAbsSyn47  happy_var_1)
	 =  HappyAbsSyn48
		 (happy_var_1 : happy_var_3
	)
happyReduction_101 _ _ _  = notHappyAtAll 

happyReduce_102 = happyReduce 4 49 happyReduction_102
happyReduction_102 (_ `HappyStk`
	(HappyAbsSyn50  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn49
		 (PCompT happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_103 = happySpecReduce_1  49 happyReduction_103
happyReduction_103 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn49
		 (PVar happy_var_1
	)
happyReduction_103 _  = notHappyAtAll 

happyReduce_104 = happySpecReduce_1  49 happyReduction_104
happyReduction_104 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn49
		 (PConst happy_var_1
	)
happyReduction_104 _  = notHappyAtAll 

happyReduce_105 = happySpecReduce_1  50 happyReduction_105
happyReduction_105 (HappyAbsSyn49  happy_var_1)
	 =  HappyAbsSyn50
		 ([happy_var_1]
	)
happyReduction_105 _  = notHappyAtAll 

happyReduce_106 = happySpecReduce_3  50 happyReduction_106
happyReduction_106 (HappyAbsSyn50  happy_var_3)
	_
	(HappyAbsSyn49  happy_var_1)
	 =  HappyAbsSyn50
		 (happy_var_1 : happy_var_3
	)
happyReduction_106 _ _ _  = notHappyAtAll 

happyReduce_107 = happySpecReduce_1  51 happyReduction_107
happyReduction_107 (HappyAbsSyn52  happy_var_1)
	 =  HappyAbsSyn51
		 ([happy_var_1]
	)
happyReduction_107 _  = notHappyAtAll 

happyReduce_108 = happySpecReduce_3  51 happyReduction_108
happyReduction_108 (HappyAbsSyn51  happy_var_3)
	_
	(HappyAbsSyn52  happy_var_1)
	 =  HappyAbsSyn51
		 (happy_var_1 : happy_var_3
	)
happyReduction_108 _ _ _  = notHappyAtAll 

happyReduce_109 = happyReduce 6 52 happyReduction_109
happyReduction_109 (_ `HappyStk`
	(HappyAbsSyn49  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (PEq happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_110 = happyReduce 6 52 happyReduction_110
happyReduction_110 (_ `HappyStk`
	(HappyAbsSyn49  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn49  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (PLess happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_111 = happyReduce 4 52 happyReduction_111
happyReduction_111 (_ `HappyStk`
	(HappyAbsSyn52  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (PNot happy_var_3
	) `HappyStk` happyRest

happyReduce_112 = happyReduce 4 52 happyReduction_112
happyReduction_112 (_ `HappyStk`
	(HappyAbsSyn52  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (PNot happy_var_3
	) `HappyStk` happyRest

happyReduce_113 = happySpecReduce_1  53 happyReduction_113
happyReduction_113 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn53
		 ([happy_var_1]
	)
happyReduction_113 _  = notHappyAtAll 

happyReduce_114 = happySpecReduce_3  53 happyReduction_114
happyReduction_114 (HappyAbsSyn53  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn53
		 (happy_var_1 : happy_var_3
	)
happyReduction_114 _ _ _  = notHappyAtAll 

happyReduce_115 = happySpecReduce_1  54 happyReduction_115
happyReduction_115 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn53
		 ([happy_var_1]
	)
happyReduction_115 _  = notHappyAtAll 

happyReduce_116 = happySpecReduce_1  54 happyReduction_116
happyReduction_116 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn53
		 ([happy_var_1]
	)
happyReduction_116 _  = notHappyAtAll 

happyReduce_117 = happySpecReduce_3  54 happyReduction_117
happyReduction_117 (HappyAbsSyn53  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn53
		 (happy_var_1 : happy_var_3
	)
happyReduction_117 _ _ _  = notHappyAtAll 

happyReduce_118 = happySpecReduce_3  54 happyReduction_118
happyReduction_118 (HappyAbsSyn53  happy_var_3)
	_
	(HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn53
		 (happy_var_1 : happy_var_3
	)
happyReduction_118 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 108 108 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TCONST _ happy_dollar_dollar -> cont 55;
	TVAR _ happy_dollar_dollar -> cont 56;
	TNUM _ happy_dollar_dollar -> cont 57;
	TOPENB _ -> cont 58;
	TCLOSEB _ -> cont 59;
	TOPENSQB _ -> cont 60;
	TBAR _ -> cont 61;
	TCLOSESQB _ -> cont 62;
	TCOLON _ -> cont 63;
	TEQ _ -> cont 64;
	TIF _ -> cont 65;
	TLBRACE _ -> cont 66;
	TRBRACE _ -> cont 67;
	TDEF _ -> cont 68;
	TIMPL _ -> cont 69;
	TPREVIOUS _ -> cont 70;
	TSLASH _ -> cont 71;
	TAND _ -> cont 72;
	TDOT _ -> cont 73;
	TCOMMA _ -> cont 74;
	TSTAR _ -> cont 75;
	TARROW _ -> cont 76;
	TNEQ _ -> cont 77;
	TDECANA _ -> cont 78;
	TANALYSIS _ -> cont 79;
	TCANCELLATION _ -> cont 80;
	TFEC _ -> cont 81;
	TCOMP _ -> cont 82;
	TTHEO _ -> cont 83;
	TTOPDEC _ -> cont 84;
	TTOPDECU _ -> cont 85;
	TSECSIG _ -> cont 86;
	TEXISTS _ -> cont 87;
	TEQUAL _ -> cont 88;
	TLESS _ -> cont 89;
	TNOT _ -> cont 90;
	TSTEP _ -> cont 91;
	TSECTION _ -> cont 92;
	TSECTYPES _ -> cont 93;
	TSECPROP _ -> cont 94;
	TSECINITS _ -> cont 95;
	TSECRULES _ -> cont 96;
	TSECGOALS _ -> cont 97;
	TGOAL _ -> cont 98;
	TINIT _ -> cont 99;
	TPROP _ -> cont 100;
	TGLOBALLY _ -> cont 101;
	TCONJ _ -> cont 102;
	TDISJ _ -> cont 103;
	TNEG _ -> cont 104;
	TNEG _ -> cont 105;
	TBWEVENTUALLY _ -> cont 106;
	TBWGLOBALLY _ -> cont 107;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 108 tk tks = happyError' (tks, explist)
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
theoparser tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


happyError :: [Token] -> a
happyError tks = error ("Theory-Parser: error at " ++ lcn ++ "\n" ++ (show tks))
        where
        lcn =   case tks of
                  [] -> "end of file"
                  tk:_ -> "line " ++ show l ++ ", column " ++ show c
                        where
                        AlexPn _ l c = token_posn tk


type PProt = [PSection]

data PSection= PTypeSec [PTypeDecl]
              |PInitSec [(PIdent,PState)]  
              |PRuleSec [(PIdent,PRule)]
              |PGoalSec [(PIdent,PCNState)]
              deriving (Eq,Show)

data PTypeDecl=Decl PType [PIdent]  
            deriving (Eq,Show)

data PType=Atomic PIdent
          |Comp PIdent [PType]
            deriving (Eq,Show)

type PRule=(PCNState,PState,[PSubst])

type PState=[PFact]
type PNState=[PNFact]
type PCNState=(PNState,[PCondition])


---- Terms, Facts, NFacts & Conditions

type PTheo = (PSigSec,([(PTerm,PTerm)]),[PTopdec],[PDecana])

type PSigSec = [(PIdent,Int)]

type PTopdec = (PIdent,PTerm,[PTopdecCase])

data PTopdecCase = PUncond [PUncond]
                 | PCond (PIdent,PTerm) [PTopdecCase]
                 deriving (Eq,Show)

type PUncond = ([PTerm])


type PDecana = (PTerm,[(PIneq,[PTerm],[PTerm])])

type PIneq = [(PTerm,PTerm)]

data PTerm=  PConst PIdent
             | PVar PIdent
             | PCompT PIdent [PTerm]
            deriving (Eq,Show)

type PFact=(PIdent,[PTerm])

type PSubst=(PIdent, Maybe PTerm)

data PNFact=Not PFact
           |Plain PFact
            deriving (Eq,Show)

data PCondition=PEq PTerm PTerm
               |PLess PTerm PTerm
               |PNot PCondition
            deriving (Eq,Show)
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

