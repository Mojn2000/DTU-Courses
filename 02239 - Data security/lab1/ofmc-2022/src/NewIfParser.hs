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


module NewIfParser where
---import Char
---import List
import NewIfLexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (PProt)
	| HappyAbsSyn5 (PSection)
	| HappyAbsSyn6 ([PHornclause])
	| HappyAbsSyn7 (PHornclause)
	| HappyAbsSyn8 ([PFact])
	| HappyAbsSyn9 ([PTypeDecl])
	| HappyAbsSyn12 ([(PIdent,PCNState)])
	| HappyAbsSyn13 (PLTL)
	| HappyAbsSyn15 (())
	| HappyAbsSyn16 (PTypeDecl)
	| HappyAbsSyn17 (PType)
	| HappyAbsSyn21 ([PType])
	| HappyAbsSyn23 ((PIdent,PCNState))
	| HappyAbsSyn24 ([(PIdent,PRule)])
	| HappyAbsSyn25 ((PIdent,PRule))
	| HappyAbsSyn26 ([PSubst])
	| HappyAbsSyn28 (PSubst)
	| HappyAbsSyn29 ([(PIdent, PCNState)])
	| HappyAbsSyn30 ((PIdent, PCNState))
	| HappyAbsSyn31 (PCNState)
	| HappyAbsSyn32 ((PNState,[PCondition]))
	| HappyAbsSyn33 (PState)
	| HappyAbsSyn34 (PNFact)
	| HappyAbsSyn36 (([PNFact],[PCondition]))
	| HappyAbsSyn37 (PFact)
	| HappyAbsSyn39 (PTerm)
	| HappyAbsSyn40 ([PTerm])
	| HappyAbsSyn41 ([PCondition])
	| HappyAbsSyn42 (PCondition)
	| HappyAbsSyn43 ([PIdent])

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
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137,
 action_138,
 action_139,
 action_140,
 action_141,
 action_142,
 action_143,
 action_144,
 action_145,
 action_146,
 action_147,
 action_148,
 action_149,
 action_150,
 action_151,
 action_152,
 action_153,
 action_154,
 action_155,
 action_156,
 action_157,
 action_158,
 action_159,
 action_160,
 action_161,
 action_162,
 action_163,
 action_164,
 action_165,
 action_166,
 action_167,
 action_168,
 action_169,
 action_170,
 action_171,
 action_172,
 action_173,
 action_174,
 action_175,
 action_176,
 action_177,
 action_178,
 action_179,
 action_180,
 action_181,
 action_182,
 action_183,
 action_184,
 action_185,
 action_186,
 action_187,
 action_188,
 action_189,
 action_190,
 action_191,
 action_192,
 action_193,
 action_194,
 action_195,
 action_196,
 action_197,
 action_198,
 action_199,
 action_200,
 action_201,
 action_202,
 action_203,
 action_204,
 action_205,
 action_206,
 action_207,
 action_208,
 action_209,
 action_210,
 action_211,
 action_212,
 action_213,
 action_214,
 action_215,
 action_216,
 action_217,
 action_218,
 action_219,
 action_220,
 action_221,
 action_222,
 action_223,
 action_224,
 action_225,
 action_226,
 action_227,
 action_228,
 action_229,
 action_230,
 action_231,
 action_232,
 action_233,
 action_234,
 action_235,
 action_236,
 action_237,
 action_238,
 action_239,
 action_240,
 action_241,
 action_242,
 action_243,
 action_244,
 action_245,
 action_246,
 action_247,
 action_248,
 action_249,
 action_250,
 action_251,
 action_252,
 action_253,
 action_254,
 action_255,
 action_256,
 action_257,
 action_258,
 action_259,
 action_260,
 action_261,
 action_262,
 action_263,
 action_264,
 action_265,
 action_266,
 action_267,
 action_268,
 action_269,
 action_270,
 action_271,
 action_272,
 action_273,
 action_274,
 action_275,
 action_276,
 action_277,
 action_278,
 action_279,
 action_280,
 action_281,
 action_282,
 action_283,
 action_284,
 action_285,
 action_286 :: () => Int -> ({-HappyReduction (HappyIdentity) = -}
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
 happyReduce_118,
 happyReduce_119,
 happyReduce_120 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,543) ([0,0,0,0,128,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,65024,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,1536,0,0,0,0,0,48,0,0,0,0,0,0,0,32,0,0,0,0,32768,0,0,0,0,32768,0,0,0,0,0,0,24,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,64,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,256,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,64,0,0,0,0,0,0,0,0,0,0,12288,0,0,0,0,0,384,0,0,0,0,0,1024,0,0,0,0,0,8,0,0,0,0,1024,64,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,1536,0,0,0,0,0,1024,0,0,0,0,0,8192,0,0,0,0,3072,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,6144,0,0,0,0,0,64,0,0,0,0,0,2,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,64,0,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,2048,4,0,0,0,0,0,0,0,0,0,0,258,0,0,0,0,4096,8,0,0,0,0,0,0,0,0,0,0,516,0,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,2,0,0,0,0,8192,0,0,0,0,0,384,19464,1,0,0,0,8,0,0,0,0,24576,0,112,256,0,0,512,0,0,0,0,0,24,7168,16384,0,0,49152,0,224,512,0,0,1024,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,32768,1,0,0,0,8192,0,0,0,0,0,0,16,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,8,0,0,0,0,16384,0,0,0,0,0,512,0,0,0,0,0,32880,14336,49152,3,0,0,4,0,0,0,0,0,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,384,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,16,0,0,0,0,0,16400,0,0,0,0,1024,0,0,0,0,0,32,0,0,0,0,0,1,0,0,0,0,2048,0,0,0,0,0,2048,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,384,0,0,0,0,0,8,0,0,0,0,16384,0,0,0,0,0,512,0,0,0,0,0,16,0,0,0,0,32768,0,0,0,0,0,1024,0,0,0,0,0,64,0,0,0,0,0,0,1,0,0,0,4096,0,0,0,0,0,8192,0,0,0,0,32768,0,0,0,0,0,0,8,0,0,0,0,96,21250,0,0,0,0,3,0,0,0,0,6144,49280,20,0,0,0,192,42500,0,0,0,0,8198,1328,0,0,0,12288,33024,41,0,0,0,0,16,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,4096,0,0,0,0,0,256,0,0,0,0,8192,0,0,0,0,0,48,14336,32768,0,0,32768,1,448,1024,0,0,3072,0,0,0,0,0,96,0,0,0,0,0,3,0,0,0,0,6144,0,0,0,0,0,192,57344,0,2,0,0,6,1792,4096,0,0,12288,0,56,128,0,0,256,0,0,0,0,0,2048,0,0,0,0,0,128,0,96,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,2048,32,0,0,0,32768,1027,448,7680,0,0,7168,32,14,240,0,0,128,0,0,0,0,0,2055,896,15360,0,0,14336,64,28,480,0,0,448,57346,0,15,0,0,4110,1792,30720,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32880,14336,49152,3,0,0,0,0,0,0,0,2048,0,14,32,0,0,0,0,0,0,0,0,1032,0,768,0,0,6144,0,0,0,0,0,448,57346,0,15,0,0,4110,1792,30720,0,0,28672,128,56,960,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3072,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,0,512,0,0,0,0,512,0,0,0,0,0,16,0,0,0,0,16384,0,0,0,0,0,1024,0,0,0,0,0,32,0,0,0,0,0,0,8,0,0,0,256,0,0,0,0,0,24,7168,16384,0,0,49152,0,224,512,0,0,0,128,0,0,0,0,128,0,0,0,0,32768,2049,332,0,0,0,8192,256,0,0,0,0,0,8,0,0,0,0,16384,0,0,0,0,0,512,0,0,0,0,0,16,0,0,0,0,16,0,0,0,0,12288,33024,41,0,0,0,0,0,0,0,0,0,32768,1,0,0,0,8192,0,0,0,0,0,0,1024,0,0,0,0,8,0,0,0,0,16384,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,32768,1,0,0,0,0,3072,24640,10,0,0,0,96,21250,0,0,0,0,4099,664,0,0,0,0,0,0,0,0,0,192,42500,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,384,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2048,0,14,32,0,0,0,0,0,0,0,0,0,0,0,0,0,6144,0,0,0,0,0,192,0,0,0,0,0,6,0,0,0,0,8192,0,56,128,0,0,896,49156,1,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,512,0,384,0,0,0,0,0,0,0,0,0,2,0,0,0,0,8,0,0,0,0,16384,0,0,0,0,0,512,0,0,0,0,0,64,0,0,0,0,0,1024,0,0,0,0,0,1,0,0,0,0,4,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,2,0,0,0,0,4096,0,0,0,0,0,128,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,0,0,0,0,0,49152,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parser","sections","section","hornclauses","hornclause","body","propdec","prop","backwardsLTL","ltls","LTLGoal","sigdec","typeinclusion","ftypedec","myftype","typedecs","typedec","mytype","mytypes","initials","initial","rulez","rule","freshvar","substs","subst","goalz","goal","cnstate","nstate","state","nfact","negfact","nfacts","fact","facts","term","terms","conditions","condition","vars","varcos","const","var","'('","')'","'['","']'","':'","'='","'>'","\":=\"","\"=>\"","\"(-)\"","and","'.'","','","'*'","'->'","'/='","':-'","implies","or","'hc'","exists","equ","less","not","step","sect","sectypes","secsig","secprop","secinits","secrules","secgoals","sechornclauses","gol","attack","init","property","\"[]\"","\"/\\\\\"","\"\\/\"","'-'","'~'","\"<->\"","\"[-]\"","%eof"]
        bit_start = st * 91
        bit_end = (st + 1) * 91
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..90]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (72) = happyShift action_3
action_0 (4) = happyGoto action_4
action_0 (5) = happyGoto action_5
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (72) = happyShift action_3
action_1 (5) = happyGoto action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyFail (happyExpListPerState 2)

action_3 (73) = happyShift action_7
action_3 (74) = happyShift action_8
action_3 (75) = happyShift action_9
action_3 (76) = happyShift action_10
action_3 (77) = happyShift action_11
action_3 (78) = happyShift action_12
action_3 (79) = happyShift action_13
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (91) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (72) = happyShift action_3
action_5 (4) = happyGoto action_6
action_5 (5) = happyGoto action_5
action_5 _ = happyReduce_1

action_6 _ = happyReduce_2

action_7 (45) = happyShift action_41
action_7 (46) = happyShift action_37
action_7 (18) = happyGoto action_38
action_7 (19) = happyGoto action_39
action_7 (44) = happyGoto action_40
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (45) = happyShift action_36
action_8 (46) = happyShift action_37
action_8 (14) = happyGoto action_31
action_8 (15) = happyGoto action_32
action_8 (16) = happyGoto action_33
action_8 (20) = happyGoto action_34
action_8 (44) = happyGoto action_35
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (83) = happyShift action_30
action_9 (9) = happyGoto action_28
action_9 (10) = happyGoto action_29
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (82) = happyShift action_27
action_10 (22) = happyGoto action_25
action_10 (23) = happyGoto action_26
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (71) = happyShift action_24
action_11 (24) = happyGoto action_22
action_11 (25) = happyGoto action_23
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (80) = happyShift action_20
action_12 (81) = happyShift action_21
action_12 (12) = happyGoto action_17
action_12 (29) = happyGoto action_18
action_12 (30) = happyGoto action_19
action_12 _ = happyReduce_39

action_13 (66) = happyShift action_16
action_13 (6) = happyGoto action_14
action_13 (7) = happyGoto action_15
action_13 _ = happyReduce_11

action_14 _ = happyReduce_10

action_15 (66) = happyShift action_16
action_15 (6) = happyGoto action_61
action_15 (7) = happyGoto action_15
action_15 _ = happyReduce_11

action_16 (45) = happyShift action_60
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_8

action_18 _ = happyReduce_7

action_19 (81) = happyShift action_21
action_19 (29) = happyGoto action_59
action_19 (30) = happyGoto action_19
action_19 _ = happyReduce_79

action_20 (45) = happyShift action_58
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (45) = happyShift action_57
action_21 _ = happyFail (happyExpListPerState 21)

action_22 _ = happyReduce_6

action_23 (71) = happyShift action_24
action_23 (24) = happyGoto action_56
action_23 (25) = happyGoto action_23
action_23 _ = happyReduce_69

action_24 (45) = happyShift action_55
action_24 _ = happyFail (happyExpListPerState 24)

action_25 _ = happyReduce_5

action_26 (82) = happyShift action_27
action_26 (22) = happyGoto action_54
action_26 (23) = happyGoto action_26
action_26 _ = happyReduce_66

action_27 (45) = happyShift action_53
action_27 _ = happyFail (happyExpListPerState 27)

action_28 _ = happyReduce_9

action_29 (83) = happyShift action_30
action_29 (9) = happyGoto action_52
action_29 (10) = happyGoto action_29
action_29 _ = happyReduce_20

action_30 (45) = happyShift action_51
action_30 _ = happyFail (happyExpListPerState 30)

action_31 _ = happyReduce_4

action_32 (45) = happyShift action_36
action_32 (46) = happyShift action_37
action_32 (14) = happyGoto action_50
action_32 (15) = happyGoto action_32
action_32 (16) = happyGoto action_33
action_32 (20) = happyGoto action_34
action_32 (44) = happyGoto action_35
action_32 _ = happyReduce_51

action_33 (45) = happyShift action_36
action_33 (46) = happyShift action_37
action_33 (14) = happyGoto action_49
action_33 (15) = happyGoto action_32
action_33 (16) = happyGoto action_33
action_33 (20) = happyGoto action_34
action_33 (44) = happyGoto action_35
action_33 _ = happyReduce_49

action_34 (53) = happyShift action_48
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (51) = happyShift action_47
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (47) = happyShift action_46
action_36 (53) = happyReduce_63
action_36 (59) = happyShift action_42
action_36 _ = happyReduce_118

action_37 (59) = happyShift action_45
action_37 _ = happyReduce_117

action_38 _ = happyReduce_3

action_39 (45) = happyShift action_41
action_39 (46) = happyShift action_37
action_39 (18) = happyGoto action_44
action_39 (19) = happyGoto action_39
action_39 (44) = happyGoto action_40
action_39 _ = happyReduce_59

action_40 (51) = happyShift action_43
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (59) = happyShift action_42
action_41 _ = happyReduce_118

action_42 (45) = happyShift action_41
action_42 (46) = happyShift action_37
action_42 (44) = happyGoto action_82
action_42 _ = happyFail (happyExpListPerState 42)

action_43 (45) = happyShift action_74
action_43 (20) = happyGoto action_81
action_43 _ = happyFail (happyExpListPerState 43)

action_44 _ = happyReduce_60

action_45 (45) = happyShift action_41
action_45 (46) = happyShift action_37
action_45 (44) = happyGoto action_80
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (45) = happyShift action_74
action_46 (20) = happyGoto action_78
action_46 (21) = happyGoto action_79
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (45) = happyShift action_77
action_47 (17) = happyGoto action_75
action_47 (20) = happyGoto action_76
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (45) = happyShift action_74
action_48 (20) = happyGoto action_73
action_48 _ = happyFail (happyExpListPerState 48)

action_49 _ = happyReduce_50

action_50 _ = happyReduce_52

action_51 (47) = happyShift action_71
action_51 (54) = happyShift action_72
action_51 _ = happyFail (happyExpListPerState 51)

action_52 _ = happyReduce_21

action_53 (54) = happyShift action_70
action_53 _ = happyFail (happyExpListPerState 53)

action_54 _ = happyReduce_67

action_55 (47) = happyShift action_68
action_55 (54) = happyShift action_69
action_55 _ = happyFail (happyExpListPerState 55)

action_56 _ = happyReduce_70

action_57 (47) = happyShift action_66
action_57 (54) = happyShift action_67
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (47) = happyShift action_64
action_58 (54) = happyShift action_65
action_58 _ = happyFail (happyExpListPerState 58)

action_59 _ = happyReduce_80

action_60 (47) = happyShift action_62
action_60 (54) = happyShift action_63
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_12

action_62 (46) = happyShift action_90
action_62 (43) = happyGoto action_119
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (45) = happyShift action_98
action_63 (37) = happyGoto action_118
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (46) = happyShift action_90
action_64 (43) = happyGoto action_117
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (45) = happyShift action_110
action_65 (46) = happyShift action_111
action_65 (57) = happyShift action_112
action_65 (64) = happyShift action_113
action_65 (65) = happyShift action_114
action_65 (68) = happyShift action_115
action_65 (70) = happyShift action_116
action_65 (13) = happyGoto action_108
action_65 (37) = happyGoto action_109
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (46) = happyShift action_90
action_66 (43) = happyGoto action_107
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (45) = happyShift action_98
action_67 (46) = happyShift action_99
action_67 (68) = happyShift action_100
action_67 (69) = happyShift action_101
action_67 (70) = happyShift action_102
action_67 (88) = happyShift action_103
action_67 (31) = happyGoto action_106
action_67 (32) = happyGoto action_92
action_67 (34) = happyGoto action_93
action_67 (35) = happyGoto action_94
action_67 (36) = happyGoto action_95
action_67 (37) = happyGoto action_96
action_67 (42) = happyGoto action_97
action_67 _ = happyReduce_90

action_68 (46) = happyShift action_90
action_68 (43) = happyGoto action_105
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (45) = happyShift action_98
action_69 (46) = happyShift action_99
action_69 (68) = happyShift action_100
action_69 (69) = happyShift action_101
action_69 (70) = happyShift action_102
action_69 (88) = happyShift action_103
action_69 (31) = happyGoto action_104
action_69 (32) = happyGoto action_92
action_69 (34) = happyGoto action_93
action_69 (35) = happyGoto action_94
action_69 (36) = happyGoto action_95
action_69 (37) = happyGoto action_96
action_69 (42) = happyGoto action_97
action_69 _ = happyReduce_90

action_70 (45) = happyShift action_98
action_70 (46) = happyShift action_99
action_70 (68) = happyShift action_100
action_70 (69) = happyShift action_101
action_70 (70) = happyShift action_102
action_70 (88) = happyShift action_103
action_70 (31) = happyGoto action_91
action_70 (32) = happyGoto action_92
action_70 (34) = happyGoto action_93
action_70 (35) = happyGoto action_94
action_70 (36) = happyGoto action_95
action_70 (37) = happyGoto action_96
action_70 (42) = happyGoto action_97
action_70 _ = happyReduce_90

action_71 (46) = happyShift action_90
action_71 (43) = happyGoto action_89
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (84) = happyShift action_88
action_72 _ = happyFail (happyExpListPerState 72)

action_73 _ = happyReduce_53

action_74 (47) = happyShift action_46
action_74 _ = happyReduce_63

action_75 _ = happyReduce_54

action_76 (60) = happyShift action_86
action_76 (61) = happyShift action_87
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (47) = happyShift action_85
action_77 (60) = happyReduce_63
action_77 (61) = happyReduce_63
action_77 _ = happyReduce_56

action_78 (59) = happyShift action_84
action_78 _ = happyReduce_64

action_79 (48) = happyShift action_83
action_79 _ = happyFail (happyExpListPerState 79)

action_80 _ = happyReduce_119

action_81 _ = happyReduce_61

action_82 _ = happyReduce_120

action_83 _ = happyReduce_62

action_84 (45) = happyShift action_74
action_84 (20) = happyGoto action_78
action_84 (21) = happyGoto action_163
action_84 _ = happyFail (happyExpListPerState 84)

action_85 (45) = happyShift action_74
action_85 (20) = happyGoto action_78
action_85 (21) = happyGoto action_162
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (45) = happyShift action_77
action_86 (17) = happyGoto action_161
action_86 (20) = happyGoto action_76
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (45) = happyShift action_74
action_87 (20) = happyGoto action_160
action_87 _ = happyFail (happyExpListPerState 87)

action_88 (45) = happyShift action_151
action_88 (46) = happyShift action_152
action_88 (47) = happyShift action_153
action_88 (56) = happyShift action_154
action_88 (68) = happyShift action_100
action_88 (69) = happyShift action_101
action_88 (70) = happyShift action_155
action_88 (87) = happyShift action_156
action_88 (88) = happyShift action_157
action_88 (89) = happyShift action_158
action_88 (90) = happyShift action_159
action_88 (11) = happyGoto action_147
action_88 (37) = happyGoto action_148
action_88 (39) = happyGoto action_149
action_88 (42) = happyGoto action_150
action_88 _ = happyFail (happyExpListPerState 88)

action_89 (48) = happyShift action_146
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (59) = happyShift action_145
action_90 _ = happyReduce_115

action_91 _ = happyReduce_68

action_92 _ = happyReduce_83

action_93 (57) = happyShift action_143
action_93 (58) = happyShift action_144
action_93 _ = happyReduce_91

action_94 _ = happyReduce_87

action_95 _ = happyReduce_84

action_96 _ = happyReduce_86

action_97 (58) = happyShift action_142
action_97 _ = happyReduce_96

action_98 (47) = happyShift action_130
action_98 _ = happyReduce_98

action_99 (52) = happyShift action_140
action_99 (62) = happyShift action_141
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (47) = happyShift action_139
action_100 _ = happyFail (happyExpListPerState 100)

action_101 (47) = happyShift action_138
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (47) = happyShift action_137
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (47) = happyShift action_136
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (52) = happyShift action_135
action_104 (26) = happyGoto action_134
action_104 _ = happyReduce_73

action_105 (48) = happyShift action_133
action_105 _ = happyFail (happyExpListPerState 105)

action_106 _ = happyReduce_82

action_107 (48) = happyShift action_132
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (80) = happyShift action_20
action_108 (12) = happyGoto action_131
action_108 _ = happyReduce_39

action_109 _ = happyReduce_48

action_110 (46) = happyShift action_129
action_110 (47) = happyShift action_130
action_110 _ = happyReduce_98

action_111 (47) = happyShift action_128
action_111 _ = happyFail (happyExpListPerState 111)

action_112 (47) = happyShift action_127
action_112 _ = happyFail (happyExpListPerState 112)

action_113 (47) = happyShift action_126
action_113 _ = happyFail (happyExpListPerState 113)

action_114 (47) = happyShift action_125
action_114 _ = happyFail (happyExpListPerState 114)

action_115 (47) = happyShift action_124
action_115 _ = happyFail (happyExpListPerState 115)

action_116 (47) = happyShift action_123
action_116 _ = happyFail (happyExpListPerState 116)

action_117 (48) = happyShift action_122
action_117 _ = happyFail (happyExpListPerState 117)

action_118 (63) = happyShift action_121
action_118 _ = happyReduce_15

action_119 (48) = happyShift action_120
action_119 _ = happyFail (happyExpListPerState 119)

action_120 (54) = happyShift action_211
action_120 _ = happyFail (happyExpListPerState 120)

action_121 (45) = happyShift action_98
action_121 (8) = happyGoto action_209
action_121 (37) = happyGoto action_210
action_121 _ = happyReduce_16

action_122 (54) = happyShift action_208
action_122 _ = happyFail (happyExpListPerState 122)

action_123 (45) = happyShift action_110
action_123 (46) = happyShift action_111
action_123 (57) = happyShift action_112
action_123 (64) = happyShift action_113
action_123 (65) = happyShift action_114
action_123 (68) = happyShift action_115
action_123 (70) = happyShift action_116
action_123 (13) = happyGoto action_207
action_123 (37) = happyGoto action_109
action_123 _ = happyFail (happyExpListPerState 123)

action_124 (45) = happyShift action_185
action_124 (46) = happyShift action_186
action_124 (39) = happyGoto action_206
action_124 _ = happyFail (happyExpListPerState 124)

action_125 (45) = happyShift action_110
action_125 (46) = happyShift action_111
action_125 (57) = happyShift action_112
action_125 (64) = happyShift action_113
action_125 (65) = happyShift action_114
action_125 (68) = happyShift action_115
action_125 (70) = happyShift action_116
action_125 (13) = happyGoto action_205
action_125 (37) = happyGoto action_109
action_125 _ = happyFail (happyExpListPerState 125)

action_126 (45) = happyShift action_110
action_126 (46) = happyShift action_111
action_126 (57) = happyShift action_112
action_126 (64) = happyShift action_113
action_126 (65) = happyShift action_114
action_126 (68) = happyShift action_115
action_126 (70) = happyShift action_116
action_126 (13) = happyGoto action_204
action_126 (37) = happyGoto action_109
action_126 _ = happyFail (happyExpListPerState 126)

action_127 (45) = happyShift action_110
action_127 (46) = happyShift action_111
action_127 (57) = happyShift action_112
action_127 (64) = happyShift action_113
action_127 (65) = happyShift action_114
action_127 (68) = happyShift action_115
action_127 (70) = happyShift action_116
action_127 (13) = happyGoto action_203
action_127 (37) = happyGoto action_109
action_127 _ = happyFail (happyExpListPerState 127)

action_128 (45) = happyShift action_110
action_128 (46) = happyShift action_111
action_128 (57) = happyShift action_112
action_128 (64) = happyShift action_113
action_128 (65) = happyShift action_114
action_128 (68) = happyShift action_115
action_128 (70) = happyShift action_116
action_128 (13) = happyGoto action_202
action_128 (37) = happyGoto action_109
action_128 _ = happyFail (happyExpListPerState 128)

action_129 (58) = happyShift action_201
action_129 _ = happyFail (happyExpListPerState 129)

action_130 (45) = happyShift action_185
action_130 (46) = happyShift action_186
action_130 (39) = happyGoto action_199
action_130 (40) = happyGoto action_200
action_130 _ = happyFail (happyExpListPerState 130)

action_131 _ = happyReduce_38

action_132 (54) = happyShift action_198
action_132 _ = happyFail (happyExpListPerState 132)

action_133 (54) = happyShift action_197
action_133 _ = happyFail (happyExpListPerState 133)

action_134 (55) = happyShift action_196
action_134 _ = happyFail (happyExpListPerState 134)

action_135 (49) = happyShift action_195
action_135 _ = happyFail (happyExpListPerState 135)

action_136 (45) = happyShift action_98
action_136 (46) = happyShift action_99
action_136 (68) = happyShift action_100
action_136 (69) = happyShift action_101
action_136 (70) = happyShift action_155
action_136 (88) = happyShift action_192
action_136 (37) = happyGoto action_193
action_136 (42) = happyGoto action_194
action_136 _ = happyFail (happyExpListPerState 136)

action_137 (45) = happyShift action_98
action_137 (46) = happyShift action_99
action_137 (68) = happyShift action_100
action_137 (69) = happyShift action_101
action_137 (70) = happyShift action_155
action_137 (88) = happyShift action_192
action_137 (37) = happyGoto action_190
action_137 (42) = happyGoto action_191
action_137 _ = happyFail (happyExpListPerState 137)

action_138 (45) = happyShift action_185
action_138 (46) = happyShift action_186
action_138 (39) = happyGoto action_189
action_138 _ = happyFail (happyExpListPerState 138)

action_139 (45) = happyShift action_185
action_139 (46) = happyShift action_186
action_139 (39) = happyGoto action_188
action_139 _ = happyFail (happyExpListPerState 139)

action_140 (45) = happyShift action_185
action_140 (46) = happyShift action_186
action_140 (39) = happyGoto action_187
action_140 _ = happyFail (happyExpListPerState 140)

action_141 (45) = happyShift action_185
action_141 (46) = happyShift action_186
action_141 (39) = happyGoto action_184
action_141 _ = happyFail (happyExpListPerState 141)

action_142 (45) = happyShift action_98
action_142 (46) = happyShift action_99
action_142 (68) = happyShift action_100
action_142 (69) = happyShift action_101
action_142 (70) = happyShift action_102
action_142 (88) = happyShift action_103
action_142 (34) = happyGoto action_93
action_142 (35) = happyGoto action_94
action_142 (36) = happyGoto action_183
action_142 (37) = happyGoto action_96
action_142 (42) = happyGoto action_97
action_142 _ = happyReduce_90

action_143 (45) = happyShift action_98
action_143 (46) = happyShift action_99
action_143 (68) = happyShift action_100
action_143 (69) = happyShift action_101
action_143 (70) = happyShift action_102
action_143 (88) = happyShift action_103
action_143 (34) = happyGoto action_93
action_143 (35) = happyGoto action_94
action_143 (36) = happyGoto action_180
action_143 (37) = happyGoto action_96
action_143 (41) = happyGoto action_181
action_143 (42) = happyGoto action_182
action_143 _ = happyReduce_90

action_144 (45) = happyShift action_98
action_144 (46) = happyShift action_99
action_144 (68) = happyShift action_100
action_144 (69) = happyShift action_101
action_144 (70) = happyShift action_102
action_144 (88) = happyShift action_103
action_144 (34) = happyGoto action_93
action_144 (35) = happyGoto action_94
action_144 (36) = happyGoto action_179
action_144 (37) = happyGoto action_96
action_144 (42) = happyGoto action_97
action_144 _ = happyReduce_90

action_145 (46) = happyShift action_90
action_145 (43) = happyGoto action_178
action_145 _ = happyFail (happyExpListPerState 145)

action_146 (54) = happyShift action_177
action_146 _ = happyFail (happyExpListPerState 146)

action_147 (55) = happyShift action_174
action_147 (85) = happyShift action_175
action_147 (86) = happyShift action_176
action_147 _ = happyReduce_22

action_148 _ = happyReduce_26

action_149 _ = happyReduce_25

action_150 _ = happyReduce_27

action_151 (47) = happyShift action_173
action_151 (48) = happyReduce_104
action_151 (55) = happyReduce_104
action_151 (72) = happyReduce_104
action_151 (83) = happyReduce_104
action_151 (85) = happyReduce_104
action_151 (86) = happyReduce_104
action_151 (91) = happyReduce_104
action_151 _ = happyReduce_104

action_152 (52) = happyShift action_140
action_152 (62) = happyShift action_141
action_152 _ = happyReduce_103

action_153 (45) = happyShift action_151
action_153 (46) = happyShift action_152
action_153 (47) = happyShift action_153
action_153 (56) = happyShift action_154
action_153 (68) = happyShift action_100
action_153 (69) = happyShift action_101
action_153 (70) = happyShift action_155
action_153 (87) = happyShift action_156
action_153 (88) = happyShift action_157
action_153 (89) = happyShift action_158
action_153 (90) = happyShift action_159
action_153 (11) = happyGoto action_172
action_153 (37) = happyGoto action_148
action_153 (39) = happyGoto action_149
action_153 (42) = happyGoto action_150
action_153 _ = happyFail (happyExpListPerState 153)

action_154 (45) = happyShift action_151
action_154 (46) = happyShift action_152
action_154 (47) = happyShift action_153
action_154 (56) = happyShift action_154
action_154 (68) = happyShift action_100
action_154 (69) = happyShift action_101
action_154 (70) = happyShift action_155
action_154 (87) = happyShift action_156
action_154 (88) = happyShift action_157
action_154 (89) = happyShift action_158
action_154 (90) = happyShift action_159
action_154 (11) = happyGoto action_171
action_154 (37) = happyGoto action_148
action_154 (39) = happyGoto action_149
action_154 (42) = happyGoto action_150
action_154 _ = happyFail (happyExpListPerState 154)

action_155 (47) = happyShift action_170
action_155 _ = happyFail (happyExpListPerState 155)

action_156 (45) = happyShift action_151
action_156 (46) = happyShift action_152
action_156 (47) = happyShift action_153
action_156 (56) = happyShift action_154
action_156 (68) = happyShift action_100
action_156 (69) = happyShift action_101
action_156 (70) = happyShift action_155
action_156 (87) = happyShift action_156
action_156 (88) = happyShift action_157
action_156 (89) = happyShift action_158
action_156 (90) = happyShift action_159
action_156 (11) = happyGoto action_169
action_156 (37) = happyGoto action_148
action_156 (39) = happyGoto action_149
action_156 (42) = happyGoto action_150
action_156 _ = happyFail (happyExpListPerState 156)

action_157 (45) = happyShift action_151
action_157 (46) = happyShift action_152
action_157 (47) = happyShift action_168
action_157 (56) = happyShift action_154
action_157 (68) = happyShift action_100
action_157 (69) = happyShift action_101
action_157 (70) = happyShift action_155
action_157 (87) = happyShift action_156
action_157 (88) = happyShift action_157
action_157 (89) = happyShift action_158
action_157 (90) = happyShift action_159
action_157 (11) = happyGoto action_167
action_157 (37) = happyGoto action_148
action_157 (39) = happyGoto action_149
action_157 (42) = happyGoto action_150
action_157 _ = happyFail (happyExpListPerState 157)

action_158 (45) = happyShift action_151
action_158 (46) = happyShift action_152
action_158 (47) = happyShift action_153
action_158 (56) = happyShift action_154
action_158 (68) = happyShift action_100
action_158 (69) = happyShift action_101
action_158 (70) = happyShift action_155
action_158 (87) = happyShift action_156
action_158 (88) = happyShift action_157
action_158 (89) = happyShift action_158
action_158 (90) = happyShift action_159
action_158 (11) = happyGoto action_166
action_158 (37) = happyGoto action_148
action_158 (39) = happyGoto action_149
action_158 (42) = happyGoto action_150
action_158 _ = happyFail (happyExpListPerState 158)

action_159 (45) = happyShift action_151
action_159 (46) = happyShift action_152
action_159 (47) = happyShift action_153
action_159 (56) = happyShift action_154
action_159 (68) = happyShift action_100
action_159 (69) = happyShift action_101
action_159 (70) = happyShift action_155
action_159 (87) = happyShift action_156
action_159 (88) = happyShift action_157
action_159 (89) = happyShift action_158
action_159 (90) = happyShift action_159
action_159 (11) = happyGoto action_165
action_159 (37) = happyGoto action_148
action_159 (39) = happyGoto action_149
action_159 (42) = happyGoto action_150
action_159 _ = happyFail (happyExpListPerState 159)

action_160 _ = happyReduce_58

action_161 _ = happyReduce_57

action_162 (48) = happyShift action_164
action_162 _ = happyFail (happyExpListPerState 162)

action_163 _ = happyReduce_65

action_164 (60) = happyReduce_62
action_164 (61) = happyReduce_62
action_164 _ = happyReduce_55

action_165 (55) = happyShift action_174
action_165 (85) = happyShift action_175
action_165 (86) = happyShift action_176
action_165 _ = happyReduce_34

action_166 (55) = happyShift action_174
action_166 (85) = happyShift action_175
action_166 (86) = happyShift action_176
action_166 _ = happyReduce_33

action_167 (55) = happyShift action_174
action_167 (85) = happyShift action_175
action_167 (86) = happyShift action_176
action_167 _ = happyReduce_32

action_168 (45) = happyShift action_151
action_168 (46) = happyShift action_152
action_168 (47) = happyShift action_153
action_168 (56) = happyShift action_154
action_168 (68) = happyShift action_100
action_168 (69) = happyShift action_101
action_168 (70) = happyShift action_155
action_168 (87) = happyShift action_156
action_168 (88) = happyShift action_157
action_168 (89) = happyShift action_158
action_168 (90) = happyShift action_159
action_168 (11) = happyGoto action_172
action_168 (37) = happyGoto action_148
action_168 (39) = happyGoto action_149
action_168 (42) = happyGoto action_247
action_168 _ = happyFail (happyExpListPerState 168)

action_169 (55) = happyShift action_174
action_169 (85) = happyShift action_175
action_169 (86) = happyShift action_176
action_169 _ = happyReduce_31

action_170 (46) = happyShift action_99
action_170 (68) = happyShift action_100
action_170 (69) = happyShift action_101
action_170 (70) = happyShift action_155
action_170 (88) = happyShift action_192
action_170 (42) = happyGoto action_191
action_170 _ = happyFail (happyExpListPerState 170)

action_171 (55) = happyShift action_174
action_171 (85) = happyShift action_175
action_171 (86) = happyShift action_176
action_171 _ = happyReduce_35

action_172 (48) = happyShift action_246
action_172 (55) = happyShift action_174
action_172 (85) = happyShift action_175
action_172 (86) = happyShift action_176
action_172 _ = happyFail (happyExpListPerState 172)

action_173 (45) = happyShift action_185
action_173 (46) = happyShift action_186
action_173 (39) = happyGoto action_199
action_173 (40) = happyGoto action_245
action_173 _ = happyFail (happyExpListPerState 173)

action_174 (45) = happyShift action_151
action_174 (46) = happyShift action_152
action_174 (47) = happyShift action_153
action_174 (56) = happyShift action_154
action_174 (68) = happyShift action_100
action_174 (69) = happyShift action_101
action_174 (70) = happyShift action_155
action_174 (87) = happyShift action_156
action_174 (88) = happyShift action_157
action_174 (89) = happyShift action_158
action_174 (90) = happyShift action_159
action_174 (11) = happyGoto action_244
action_174 (37) = happyGoto action_148
action_174 (39) = happyGoto action_149
action_174 (42) = happyGoto action_150
action_174 _ = happyFail (happyExpListPerState 174)

action_175 (45) = happyShift action_151
action_175 (46) = happyShift action_152
action_175 (47) = happyShift action_153
action_175 (56) = happyShift action_154
action_175 (68) = happyShift action_100
action_175 (69) = happyShift action_101
action_175 (70) = happyShift action_155
action_175 (87) = happyShift action_156
action_175 (88) = happyShift action_157
action_175 (89) = happyShift action_158
action_175 (90) = happyShift action_159
action_175 (11) = happyGoto action_243
action_175 (37) = happyGoto action_148
action_175 (39) = happyGoto action_149
action_175 (42) = happyGoto action_150
action_175 _ = happyFail (happyExpListPerState 175)

action_176 (45) = happyShift action_151
action_176 (46) = happyShift action_152
action_176 (47) = happyShift action_153
action_176 (56) = happyShift action_154
action_176 (68) = happyShift action_100
action_176 (69) = happyShift action_101
action_176 (70) = happyShift action_155
action_176 (87) = happyShift action_156
action_176 (88) = happyShift action_157
action_176 (89) = happyShift action_158
action_176 (90) = happyShift action_159
action_176 (11) = happyGoto action_242
action_176 (37) = happyGoto action_148
action_176 (39) = happyGoto action_149
action_176 (42) = happyGoto action_150
action_176 _ = happyFail (happyExpListPerState 176)

action_177 (84) = happyShift action_241
action_177 _ = happyFail (happyExpListPerState 177)

action_178 _ = happyReduce_116

action_179 _ = happyReduce_92

action_180 _ = happyReduce_93

action_181 _ = happyReduce_94

action_182 (52) = happyReduce_107
action_182 (55) = happyReduce_107
action_182 (57) = happyShift action_240
action_182 (58) = happyShift action_142
action_182 (72) = happyReduce_107
action_182 (81) = happyReduce_107
action_182 (82) = happyReduce_107
action_182 (91) = happyReduce_107
action_182 _ = happyReduce_107

action_183 _ = happyReduce_95

action_184 _ = happyReduce_111

action_185 (47) = happyShift action_239
action_185 _ = happyReduce_104

action_186 _ = happyReduce_103

action_187 _ = happyReduce_110

action_188 (59) = happyShift action_238
action_188 _ = happyFail (happyExpListPerState 188)

action_189 (59) = happyShift action_237
action_189 _ = happyFail (happyExpListPerState 189)

action_190 (48) = happyShift action_236
action_190 _ = happyFail (happyExpListPerState 190)

action_191 (48) = happyShift action_235
action_191 _ = happyFail (happyExpListPerState 191)

action_192 (47) = happyShift action_234
action_192 _ = happyFail (happyExpListPerState 192)

action_193 (48) = happyShift action_233
action_193 _ = happyFail (happyExpListPerState 193)

action_194 (48) = happyShift action_232
action_194 _ = happyFail (happyExpListPerState 194)

action_195 (67) = happyShift action_231
action_195 _ = happyFail (happyExpListPerState 195)

action_196 (45) = happyShift action_98
action_196 (33) = happyGoto action_228
action_196 (37) = happyGoto action_229
action_196 (38) = happyGoto action_230
action_196 _ = happyReduce_99

action_197 (45) = happyShift action_98
action_197 (46) = happyShift action_99
action_197 (68) = happyShift action_100
action_197 (69) = happyShift action_101
action_197 (70) = happyShift action_102
action_197 (88) = happyShift action_103
action_197 (31) = happyGoto action_227
action_197 (32) = happyGoto action_92
action_197 (34) = happyGoto action_93
action_197 (35) = happyGoto action_94
action_197 (36) = happyGoto action_95
action_197 (37) = happyGoto action_96
action_197 (42) = happyGoto action_97
action_197 _ = happyReduce_90

action_198 (45) = happyShift action_98
action_198 (46) = happyShift action_99
action_198 (68) = happyShift action_100
action_198 (69) = happyShift action_101
action_198 (70) = happyShift action_102
action_198 (88) = happyShift action_103
action_198 (31) = happyGoto action_226
action_198 (32) = happyGoto action_92
action_198 (34) = happyGoto action_93
action_198 (35) = happyGoto action_94
action_198 (36) = happyGoto action_95
action_198 (37) = happyGoto action_96
action_198 (42) = happyGoto action_97
action_198 _ = happyReduce_90

action_199 (59) = happyShift action_225
action_199 _ = happyReduce_105

action_200 (48) = happyShift action_224
action_200 _ = happyFail (happyExpListPerState 200)

action_201 (45) = happyShift action_110
action_201 (46) = happyShift action_111
action_201 (57) = happyShift action_112
action_201 (64) = happyShift action_113
action_201 (65) = happyShift action_114
action_201 (68) = happyShift action_115
action_201 (70) = happyShift action_116
action_201 (13) = happyGoto action_223
action_201 (37) = happyGoto action_109
action_201 _ = happyFail (happyExpListPerState 201)

action_202 (48) = happyShift action_221
action_202 (59) = happyShift action_222
action_202 _ = happyFail (happyExpListPerState 202)

action_203 (59) = happyShift action_220
action_203 _ = happyFail (happyExpListPerState 203)

action_204 (59) = happyShift action_219
action_204 _ = happyFail (happyExpListPerState 204)

action_205 (59) = happyShift action_218
action_205 _ = happyFail (happyExpListPerState 205)

action_206 (59) = happyShift action_217
action_206 _ = happyFail (happyExpListPerState 206)

action_207 (48) = happyShift action_216
action_207 _ = happyFail (happyExpListPerState 207)

action_208 (45) = happyShift action_110
action_208 (46) = happyShift action_111
action_208 (57) = happyShift action_112
action_208 (64) = happyShift action_113
action_208 (65) = happyShift action_114
action_208 (68) = happyShift action_115
action_208 (70) = happyShift action_116
action_208 (13) = happyGoto action_215
action_208 (37) = happyGoto action_109
action_208 _ = happyFail (happyExpListPerState 208)

action_209 _ = happyReduce_14

action_210 (58) = happyShift action_213
action_210 (59) = happyShift action_214
action_210 _ = happyReduce_17

action_211 (45) = happyShift action_98
action_211 (37) = happyGoto action_212
action_211 _ = happyFail (happyExpListPerState 211)

action_212 (63) = happyShift action_269
action_212 _ = happyFail (happyExpListPerState 212)

action_213 (45) = happyShift action_98
action_213 (8) = happyGoto action_268
action_213 (37) = happyGoto action_210
action_213 _ = happyReduce_16

action_214 (45) = happyShift action_98
action_214 (8) = happyGoto action_267
action_214 (37) = happyGoto action_210
action_214 _ = happyReduce_16

action_215 (72) = happyReduce_39
action_215 (80) = happyShift action_20
action_215 (91) = happyReduce_39
action_215 (12) = happyGoto action_266
action_215 _ = happyReduce_39

action_216 _ = happyReduce_41

action_217 (45) = happyShift action_185
action_217 (46) = happyShift action_186
action_217 (39) = happyGoto action_265
action_217 _ = happyFail (happyExpListPerState 217)

action_218 (45) = happyShift action_110
action_218 (46) = happyShift action_111
action_218 (57) = happyShift action_112
action_218 (64) = happyShift action_113
action_218 (65) = happyShift action_114
action_218 (68) = happyShift action_115
action_218 (70) = happyShift action_116
action_218 (13) = happyGoto action_264
action_218 (37) = happyGoto action_109
action_218 _ = happyFail (happyExpListPerState 218)

action_219 (45) = happyShift action_110
action_219 (46) = happyShift action_111
action_219 (57) = happyShift action_112
action_219 (64) = happyShift action_113
action_219 (65) = happyShift action_114
action_219 (68) = happyShift action_115
action_219 (70) = happyShift action_116
action_219 (13) = happyGoto action_263
action_219 (37) = happyGoto action_109
action_219 _ = happyFail (happyExpListPerState 219)

action_220 (45) = happyShift action_110
action_220 (46) = happyShift action_111
action_220 (57) = happyShift action_112
action_220 (64) = happyShift action_113
action_220 (65) = happyShift action_114
action_220 (68) = happyShift action_115
action_220 (70) = happyShift action_116
action_220 (13) = happyGoto action_262
action_220 (37) = happyGoto action_109
action_220 _ = happyFail (happyExpListPerState 220)

action_221 _ = happyReduce_40

action_222 (45) = happyShift action_110
action_222 (46) = happyShift action_111
action_222 (57) = happyShift action_112
action_222 (64) = happyShift action_113
action_222 (65) = happyShift action_114
action_222 (68) = happyShift action_115
action_222 (70) = happyShift action_116
action_222 (13) = happyGoto action_261
action_222 (37) = happyGoto action_109
action_222 _ = happyFail (happyExpListPerState 222)

action_223 _ = happyReduce_46

action_224 _ = happyReduce_97

action_225 (45) = happyShift action_185
action_225 (46) = happyShift action_186
action_225 (39) = happyGoto action_199
action_225 (40) = happyGoto action_260
action_225 _ = happyFail (happyExpListPerState 225)

action_226 _ = happyReduce_81

action_227 (52) = happyShift action_135
action_227 (26) = happyGoto action_259
action_227 _ = happyReduce_73

action_228 _ = happyReduce_72

action_229 (58) = happyShift action_258
action_229 _ = happyReduce_100

action_230 _ = happyReduce_85

action_231 (46) = happyShift action_257
action_231 (27) = happyGoto action_255
action_231 (28) = happyGoto action_256
action_231 _ = happyFail (happyExpListPerState 231)

action_232 _ = happyReduce_114

action_233 _ = happyReduce_89

action_234 (46) = happyShift action_99
action_234 (68) = happyShift action_100
action_234 (69) = happyShift action_101
action_234 (70) = happyShift action_155
action_234 (88) = happyShift action_192
action_234 (42) = happyGoto action_194
action_234 _ = happyFail (happyExpListPerState 234)

action_235 _ = happyReduce_113

action_236 _ = happyReduce_88

action_237 (45) = happyShift action_185
action_237 (46) = happyShift action_186
action_237 (39) = happyGoto action_254
action_237 _ = happyFail (happyExpListPerState 237)

action_238 (45) = happyShift action_185
action_238 (46) = happyShift action_186
action_238 (39) = happyGoto action_253
action_238 _ = happyFail (happyExpListPerState 238)

action_239 (45) = happyShift action_185
action_239 (46) = happyShift action_186
action_239 (39) = happyGoto action_199
action_239 (40) = happyGoto action_252
action_239 _ = happyFail (happyExpListPerState 239)

action_240 (46) = happyShift action_99
action_240 (68) = happyShift action_100
action_240 (69) = happyShift action_101
action_240 (70) = happyShift action_155
action_240 (88) = happyShift action_192
action_240 (41) = happyGoto action_250
action_240 (42) = happyGoto action_251
action_240 _ = happyFail (happyExpListPerState 240)

action_241 (45) = happyShift action_151
action_241 (46) = happyShift action_152
action_241 (47) = happyShift action_153
action_241 (56) = happyShift action_154
action_241 (68) = happyShift action_100
action_241 (69) = happyShift action_101
action_241 (70) = happyShift action_155
action_241 (87) = happyShift action_156
action_241 (88) = happyShift action_157
action_241 (89) = happyShift action_158
action_241 (90) = happyShift action_159
action_241 (11) = happyGoto action_249
action_241 (37) = happyGoto action_148
action_241 (39) = happyGoto action_149
action_241 (42) = happyGoto action_150
action_241 _ = happyFail (happyExpListPerState 241)

action_242 (55) = happyShift action_174
action_242 (85) = happyShift action_175
action_242 (86) = happyShift action_176
action_242 _ = happyReduce_29

action_243 (55) = happyShift action_174
action_243 (85) = happyShift action_175
action_243 (86) = happyShift action_176
action_243 _ = happyReduce_28

action_244 (55) = happyShift action_174
action_244 (85) = happyShift action_175
action_244 (86) = happyShift action_176
action_244 _ = happyReduce_30

action_245 (48) = happyShift action_248
action_245 _ = happyFail (happyExpListPerState 245)

action_246 _ = happyReduce_24

action_247 (48) = happyShift action_232
action_247 _ = happyReduce_27

action_248 (48) = happyReduce_102
action_248 (55) = happyReduce_102
action_248 (72) = happyReduce_102
action_248 (83) = happyReduce_102
action_248 (85) = happyReduce_102
action_248 (86) = happyReduce_102
action_248 (91) = happyReduce_102
action_248 _ = happyReduce_102

action_249 (55) = happyShift action_174
action_249 (85) = happyShift action_175
action_249 (86) = happyShift action_176
action_249 _ = happyReduce_23

action_250 _ = happyReduce_108

action_251 (57) = happyShift action_240
action_251 _ = happyReduce_107

action_252 (48) = happyShift action_283
action_252 _ = happyFail (happyExpListPerState 252)

action_253 (48) = happyShift action_282
action_253 _ = happyFail (happyExpListPerState 253)

action_254 (48) = happyShift action_281
action_254 _ = happyFail (happyExpListPerState 254)

action_255 (50) = happyShift action_280
action_255 _ = happyFail (happyExpListPerState 255)

action_256 (59) = happyShift action_279
action_256 _ = happyReduce_75

action_257 (54) = happyShift action_278
action_257 _ = happyReduce_77

action_258 (45) = happyShift action_98
action_258 (37) = happyGoto action_229
action_258 (38) = happyGoto action_277
action_258 _ = happyReduce_99

action_259 (55) = happyShift action_276
action_259 _ = happyFail (happyExpListPerState 259)

action_260 _ = happyReduce_106

action_261 (48) = happyShift action_275
action_261 _ = happyFail (happyExpListPerState 261)

action_262 (48) = happyShift action_274
action_262 _ = happyFail (happyExpListPerState 262)

action_263 (48) = happyShift action_273
action_263 _ = happyFail (happyExpListPerState 263)

action_264 (48) = happyShift action_272
action_264 _ = happyFail (happyExpListPerState 264)

action_265 (48) = happyShift action_271
action_265 _ = happyFail (happyExpListPerState 265)

action_266 _ = happyReduce_37

action_267 _ = happyReduce_18

action_268 _ = happyReduce_19

action_269 (45) = happyShift action_98
action_269 (8) = happyGoto action_270
action_269 (37) = happyGoto action_210
action_269 _ = happyReduce_16

action_270 _ = happyReduce_13

action_271 _ = happyReduce_47

action_272 _ = happyReduce_44

action_273 _ = happyReduce_42

action_274 _ = happyReduce_43

action_275 _ = happyReduce_45

action_276 (45) = happyShift action_98
action_276 (33) = happyGoto action_286
action_276 (37) = happyGoto action_229
action_276 (38) = happyGoto action_230
action_276 _ = happyReduce_99

action_277 _ = happyReduce_101

action_278 (45) = happyShift action_185
action_278 (46) = happyShift action_186
action_278 (39) = happyGoto action_285
action_278 _ = happyFail (happyExpListPerState 278)

action_279 (46) = happyShift action_257
action_279 (27) = happyGoto action_284
action_279 (28) = happyGoto action_256
action_279 _ = happyFail (happyExpListPerState 279)

action_280 _ = happyReduce_74

action_281 _ = happyReduce_112

action_282 _ = happyReduce_109

action_283 _ = happyReduce_102

action_284 _ = happyReduce_76

action_285 _ = happyReduce_78

action_286 _ = happyReduce_71

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

happyReduce_3 = happySpecReduce_3  5 happyReduction_3
happyReduction_3 (HappyAbsSyn9  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PTypeSec happy_var_3
	)
happyReduction_3 _ _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  5 happyReduction_4
happyReduction_4 (HappyAbsSyn9  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PTypeSec happy_var_3
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  5 happyReduction_5
happyReduction_5 (HappyAbsSyn12  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PInitSec happy_var_3
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  5 happyReduction_6
happyReduction_6 (HappyAbsSyn24  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PRuleSec happy_var_3
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  5 happyReduction_7
happyReduction_7 (HappyAbsSyn29  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PGoalSec happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  5 happyReduction_8
happyReduction_8 (HappyAbsSyn12  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PGoalSec happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  5 happyReduction_9
happyReduction_9 (HappyAbsSyn9  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PTypeSec happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  5 happyReduction_10
happyReduction_10 (HappyAbsSyn6  happy_var_3)
	_
	_
	 =  HappyAbsSyn5
		 (PHornSec happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_0  6 happyReduction_11
happyReduction_11  =  HappyAbsSyn6
		 ([]
	)

happyReduce_12 = happySpecReduce_2  6 happyReduction_12
happyReduction_12 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 ((happy_var_1:happy_var_2)
	)
happyReduction_12 _ _  = notHappyAtAll 

happyReduce_13 = happyReduce 9 7 happyReduction_13
happyReduction_13 ((HappyAbsSyn8  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn37  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 ((happy_var_2,happy_var_7,happy_var_9)
	) `HappyStk` happyRest

happyReduce_14 = happyReduce 6 7 happyReduction_14
happyReduction_14 ((HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn37  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 ((happy_var_2,happy_var_4,happy_var_6)
	) `HappyStk` happyRest

happyReduce_15 = happyReduce 4 7 happyReduction_15
happyReduction_15 ((HappyAbsSyn37  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 ((happy_var_2,happy_var_4,[])
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_0  8 happyReduction_16
happyReduction_16  =  HappyAbsSyn8
		 ([]
	)

happyReduce_17 = happySpecReduce_1  8 happyReduction_17
happyReduction_17 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  8 happyReduction_18
happyReduction_18 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 : happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  8 happyReduction_19
happyReduction_19 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 : happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  9 happyReduction_20
happyReduction_20 _
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_21 = happySpecReduce_2  9 happyReduction_21
happyReduction_21 _
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_22 = happyReduce 5 10 happyReduction_22
happyReduction_22 (_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 ([]
	) `HappyStk` happyRest

happyReduce_23 = happyReduce 8 10 happyReduction_23
happyReduction_23 (_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 ([]
	) `HappyStk` happyRest

happyReduce_24 = happySpecReduce_3  11 happyReduction_24
happyReduction_24 _
	_
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_25 = happySpecReduce_1  11 happyReduction_25
happyReduction_25 _
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_26 = happySpecReduce_1  11 happyReduction_26
happyReduction_26 _
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_27 = happySpecReduce_1  11 happyReduction_27
happyReduction_27 _
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_28 = happySpecReduce_3  11 happyReduction_28
happyReduction_28 _
	_
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_29 = happySpecReduce_3  11 happyReduction_29
happyReduction_29 _
	_
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_30 = happySpecReduce_3  11 happyReduction_30
happyReduction_30 _
	_
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_31 = happySpecReduce_2  11 happyReduction_31
happyReduction_31 _
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_32 = happySpecReduce_2  11 happyReduction_32
happyReduction_32 _
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_33 = happySpecReduce_2  11 happyReduction_33
happyReduction_33 _
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_34 = happySpecReduce_2  11 happyReduction_34
happyReduction_34 _
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_35 = happySpecReduce_2  11 happyReduction_35
happyReduction_35 _
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_36 = happyReduce 7 12 happyReduction_36
happyReduction_36 ((HappyAbsSyn13  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (ltl2attack happy_var_7
	) `HappyStk` happyRest

happyReduce_37 = happyReduce 8 12 happyReduction_37
happyReduction_37 ((HappyAbsSyn12  happy_var_8) `HappyStk`
	(HappyAbsSyn13  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 ((ltl2attack happy_var_7)++happy_var_8
	) `HappyStk` happyRest

happyReduce_38 = happyReduce 5 12 happyReduction_38
happyReduction_38 ((HappyAbsSyn12  happy_var_5) `HappyStk`
	(HappyAbsSyn13  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 ((ltl2attack happy_var_4)++happy_var_5
	) `HappyStk` happyRest

happyReduce_39 = happySpecReduce_0  12 happyReduction_39
happyReduction_39  =  HappyAbsSyn12
		 (([])
	)

happyReduce_40 = happyReduce 4 13 happyReduction_40
happyReduction_40 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVAR _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (case happy_var_1 of 
     "X" -> UnTemp X happy_var_3
     "Y" -> UnTemp Y happy_var_3
     "F" -> UnTemp F happy_var_3
     "O" -> UnTemp O happy_var_3
     "G" -> UnTemp G happy_var_3
     "H" -> UnTemp H happy_var_3
     _ -> error $ "Unknown LTL operator "++happy_var_1
	) `HappyStk` happyRest

happyReduce_41 = happyReduce 4 13 happyReduction_41
happyReduction_41 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (NotLTL happy_var_3
	) `HappyStk` happyRest

happyReduce_42 = happyReduce 6 13 happyReduction_42
happyReduction_42 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (Implies happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_43 = happyReduce 6 13 happyReduction_43
happyReduction_43 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (And happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_44 = happyReduce 6 13 happyReduction_44
happyReduction_44 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (Or happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_45 = happyReduce 6 13 happyReduction_45
happyReduction_45 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVAR _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (case happy_var_1 of
     "U" -> BinTemp U happy_var_3 happy_var_5
     "R" -> BinTemp R happy_var_3 happy_var_5
     "S" -> BinTemp S happy_var_3 happy_var_5
     _ -> error $ "Unknown  operator "++happy_var_1
	) `HappyStk` happyRest

happyReduce_46 = happyReduce 4 13 happyReduction_46
happyReduction_46 ((HappyAbsSyn13  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVAR _ happy_var_2)) `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (case happy_var_1 of
          "forall" -> Forall happy_var_2 happy_var_4
          "exists" -> Exists happy_var_2 happy_var_4
          _ -> error $ "Unknown quantifier "++happy_var_1
	) `HappyStk` happyRest

happyReduce_47 = happyReduce 6 13 happyReduction_47
happyReduction_47 (_ `HappyStk`
	(HappyAbsSyn39  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn39  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (Equal happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_48 = happySpecReduce_1  13 happyReduction_48
happyReduction_48 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn13
		 (FactLTL happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  14 happyReduction_49
happyReduction_49 _
	 =  HappyAbsSyn9
		 ([] --- ignore this bs.
	)

happyReduce_50 = happySpecReduce_2  14 happyReduction_50
happyReduction_50 _
	_
	 =  HappyAbsSyn9
		 ([] --- ignore this bs.
	)

happyReduce_51 = happySpecReduce_1  14 happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_52 = happySpecReduce_2  14 happyReduction_52
happyReduction_52 _
	_
	 =  HappyAbsSyn9
		 ([]
	)

happyReduce_53 = happySpecReduce_3  15 happyReduction_53
happyReduction_53 _
	_
	_
	 =  HappyAbsSyn15
		 (()
	)

happyReduce_54 = happySpecReduce_3  16 happyReduction_54
happyReduction_54 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn43  happy_var_1)
	 =  HappyAbsSyn16
		 (Decl happy_var_3 happy_var_1
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happyReduce 4 17 happyReduction_55
happyReduction_55 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Comp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_56 = happySpecReduce_1  17 happyReduction_56
happyReduction_56 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn17
		 (Atomic happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  17 happyReduction_57
happyReduction_57 _
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  17 happyReduction_58
happyReduction_58 _
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  18 happyReduction_59
happyReduction_59 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn9
		 ([happy_var_1]
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_2  18 happyReduction_60
happyReduction_60 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 : happy_var_2
	)
happyReduction_60 _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  19 happyReduction_61
happyReduction_61 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn43  happy_var_1)
	 =  HappyAbsSyn16
		 (Decl happy_var_3 happy_var_1
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happyReduce 4 20 happyReduction_62
happyReduction_62 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Comp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_63 = happySpecReduce_1  20 happyReduction_63
happyReduction_63 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn17
		 (Atomic happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  21 happyReduction_64
happyReduction_64 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn21
		 ([happy_var_1]
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  21 happyReduction_65
happyReduction_65 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1 : happy_var_3
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  22 happyReduction_66
happyReduction_66 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn12
		 ([happy_var_1]
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_2  22 happyReduction_67
happyReduction_67 (HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 : happy_var_2
	)
happyReduction_67 _ _  = notHappyAtAll 

happyReduce_68 = happyReduce 4 23 happyReduction_68
happyReduction_68 ((HappyAbsSyn31  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 ((happy_var_2,happy_var_4)
	) `HappyStk` happyRest

happyReduce_69 = happySpecReduce_1  24 happyReduction_69
happyReduction_69 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 ([happy_var_1]
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_2  24 happyReduction_70
happyReduction_70 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1 : happy_var_2
	)
happyReduction_70 _ _  = notHappyAtAll 

happyReduce_71 = happyReduce 10 25 happyReduction_71
happyReduction_71 ((HappyAbsSyn33  happy_var_10) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn26  happy_var_8) `HappyStk`
	(HappyAbsSyn31  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 ((happy_var_2,(happy_var_7,happy_var_10,happy_var_8))
	) `HappyStk` happyRest

happyReduce_72 = happyReduce 7 25 happyReduction_72
happyReduction_72 ((HappyAbsSyn33  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn26  happy_var_5) `HappyStk`
	(HappyAbsSyn31  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 ((happy_var_2,(happy_var_4,happy_var_7,happy_var_5))
	) `HappyStk` happyRest

happyReduce_73 = happySpecReduce_0  26 happyReduction_73
happyReduction_73  =  HappyAbsSyn26
		 ([]
	)

happyReduce_74 = happyReduce 5 26 happyReduction_74
happyReduction_74 (_ `HappyStk`
	(HappyAbsSyn26  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (happy_var_4
	) `HappyStk` happyRest

happyReduce_75 = happySpecReduce_1  27 happyReduction_75
happyReduction_75 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_75 _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_3  27 happyReduction_76
happyReduction_76 (HappyAbsSyn26  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1 : happy_var_3
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_1  28 happyReduction_77
happyReduction_77 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn28
		 ((happy_var_1,Nothing)
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_3  28 happyReduction_78
happyReduction_78 (HappyAbsSyn39  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn28
		 ((happy_var_1,Just happy_var_3)
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_1  29 happyReduction_79
happyReduction_79 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 ([happy_var_1]
	)
happyReduction_79 _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_2  29 happyReduction_80
happyReduction_80 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (happy_var_1 : happy_var_2
	)
happyReduction_80 _ _  = notHappyAtAll 

happyReduce_81 = happyReduce 7 30 happyReduction_81
happyReduction_81 ((HappyAbsSyn31  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 ((happy_var_2,happy_var_7)
	) `HappyStk` happyRest

happyReduce_82 = happyReduce 4 30 happyReduction_82
happyReduction_82 ((HappyAbsSyn31  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 ((happy_var_2,happy_var_4)
	) `HappyStk` happyRest

happyReduce_83 = happySpecReduce_1  31 happyReduction_83
happyReduction_83 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1
	)
happyReduction_83 _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_1  32 happyReduction_84
happyReduction_84 (HappyAbsSyn36  happy_var_1)
	 =  HappyAbsSyn32
		 (happy_var_1
	)
happyReduction_84 _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_1  33 happyReduction_85
happyReduction_85 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn33
		 (happy_var_1
	)
happyReduction_85 _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_1  34 happyReduction_86
happyReduction_86 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn34
		 (Plain happy_var_1
	)
happyReduction_86 _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_1  34 happyReduction_87
happyReduction_87 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn34
		 (happy_var_1
	)
happyReduction_87 _  = notHappyAtAll 

happyReduce_88 = happyReduce 4 35 happyReduction_88
happyReduction_88 (_ `HappyStk`
	(HappyAbsSyn37  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn34
		 (Not happy_var_3
	) `HappyStk` happyRest

happyReduce_89 = happyReduce 4 35 happyReduction_89
happyReduction_89 (_ `HappyStk`
	(HappyAbsSyn37  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn34
		 (Not happy_var_3
	) `HappyStk` happyRest

happyReduce_90 = happySpecReduce_0  36 happyReduction_90
happyReduction_90  =  HappyAbsSyn36
		 (([],[])
	)

happyReduce_91 = happySpecReduce_1  36 happyReduction_91
happyReduction_91 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn36
		 (([happy_var_1],[])
	)
happyReduction_91 _  = notHappyAtAll 

happyReduce_92 = happySpecReduce_3  36 happyReduction_92
happyReduction_92 (HappyAbsSyn36  happy_var_3)
	_
	(HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn36
		 ((happy_var_1 : fst happy_var_3,snd happy_var_3)
	)
happyReduction_92 _ _ _  = notHappyAtAll 

happyReduce_93 = happySpecReduce_3  36 happyReduction_93
happyReduction_93 (HappyAbsSyn36  happy_var_3)
	_
	(HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn36
		 ((happy_var_1 : fst happy_var_3,snd happy_var_3)
	)
happyReduction_93 _ _ _  = notHappyAtAll 

happyReduce_94 = happySpecReduce_3  36 happyReduction_94
happyReduction_94 (HappyAbsSyn41  happy_var_3)
	_
	(HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn36
		 (([happy_var_1],happy_var_3)
	)
happyReduction_94 _ _ _  = notHappyAtAll 

happyReduce_95 = happySpecReduce_3  36 happyReduction_95
happyReduction_95 (HappyAbsSyn36  happy_var_3)
	_
	(HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn36
		 ((fst happy_var_3, happy_var_1:(snd happy_var_3))
	)
happyReduction_95 _ _ _  = notHappyAtAll 

happyReduce_96 = happySpecReduce_1  36 happyReduction_96
happyReduction_96 (HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn36
		 (([],[happy_var_1])
	)
happyReduction_96 _  = notHappyAtAll 

happyReduce_97 = happyReduce 4 37 happyReduction_97
happyReduction_97 (_ `HappyStk`
	(HappyAbsSyn40  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn37
		 ((happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_98 = happySpecReduce_1  37 happyReduction_98
happyReduction_98 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn37
		 ((happy_var_1,[PConst "i"])
	)
happyReduction_98 _  = notHappyAtAll 

happyReduce_99 = happySpecReduce_0  38 happyReduction_99
happyReduction_99  =  HappyAbsSyn8
		 ([]
	)

happyReduce_100 = happySpecReduce_1  38 happyReduction_100
happyReduction_100 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_100 _  = notHappyAtAll 

happyReduce_101 = happySpecReduce_3  38 happyReduction_101
happyReduction_101 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 : happy_var_3
	)
happyReduction_101 _ _ _  = notHappyAtAll 

happyReduce_102 = happyReduce 4 39 happyReduction_102
happyReduction_102 (_ `HappyStk`
	(HappyAbsSyn40  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCONST _ happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn39
		 (PCompT happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_103 = happySpecReduce_1  39 happyReduction_103
happyReduction_103 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn39
		 (PVar happy_var_1
	)
happyReduction_103 _  = notHappyAtAll 

happyReduce_104 = happySpecReduce_1  39 happyReduction_104
happyReduction_104 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn39
		 (PConst happy_var_1
	)
happyReduction_104 _  = notHappyAtAll 

happyReduce_105 = happySpecReduce_1  40 happyReduction_105
happyReduction_105 (HappyAbsSyn39  happy_var_1)
	 =  HappyAbsSyn40
		 ([happy_var_1]
	)
happyReduction_105 _  = notHappyAtAll 

happyReduce_106 = happySpecReduce_3  40 happyReduction_106
happyReduction_106 (HappyAbsSyn40  happy_var_3)
	_
	(HappyAbsSyn39  happy_var_1)
	 =  HappyAbsSyn40
		 (happy_var_1 : happy_var_3
	)
happyReduction_106 _ _ _  = notHappyAtAll 

happyReduce_107 = happySpecReduce_1  41 happyReduction_107
happyReduction_107 (HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn41
		 ([happy_var_1]
	)
happyReduction_107 _  = notHappyAtAll 

happyReduce_108 = happySpecReduce_3  41 happyReduction_108
happyReduction_108 (HappyAbsSyn41  happy_var_3)
	_
	(HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn41
		 (happy_var_1 : happy_var_3
	)
happyReduction_108 _ _ _  = notHappyAtAll 

happyReduce_109 = happyReduce 6 42 happyReduction_109
happyReduction_109 (_ `HappyStk`
	(HappyAbsSyn39  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn39  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn42
		 (PEq happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_110 = happySpecReduce_3  42 happyReduction_110
happyReduction_110 (HappyAbsSyn39  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn42
		 (PEq (PVar happy_var_1) happy_var_3
	)
happyReduction_110 _ _ _  = notHappyAtAll 

happyReduce_111 = happySpecReduce_3  42 happyReduction_111
happyReduction_111 (HappyAbsSyn39  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn42
		 (PNot (PEq (PVar happy_var_1) happy_var_3)
	)
happyReduction_111 _ _ _  = notHappyAtAll 

happyReduce_112 = happyReduce 6 42 happyReduction_112
happyReduction_112 (_ `HappyStk`
	(HappyAbsSyn39  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn39  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn42
		 (PLess happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_113 = happyReduce 4 42 happyReduction_113
happyReduction_113 (_ `HappyStk`
	(HappyAbsSyn42  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn42
		 (PNot happy_var_3
	) `HappyStk` happyRest

happyReduce_114 = happyReduce 4 42 happyReduction_114
happyReduction_114 (_ `HappyStk`
	(HappyAbsSyn42  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn42
		 (PNot happy_var_3
	) `HappyStk` happyRest

happyReduce_115 = happySpecReduce_1  43 happyReduction_115
happyReduction_115 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn43
		 ([happy_var_1]
	)
happyReduction_115 _  = notHappyAtAll 

happyReduce_116 = happySpecReduce_3  43 happyReduction_116
happyReduction_116 (HappyAbsSyn43  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn43
		 (happy_var_1 : happy_var_3
	)
happyReduction_116 _ _ _  = notHappyAtAll 

happyReduce_117 = happySpecReduce_1  44 happyReduction_117
happyReduction_117 (HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn43
		 ([happy_var_1]
	)
happyReduction_117 _  = notHappyAtAll 

happyReduce_118 = happySpecReduce_1  44 happyReduction_118
happyReduction_118 (HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn43
		 ([happy_var_1]
	)
happyReduction_118 _  = notHappyAtAll 

happyReduce_119 = happySpecReduce_3  44 happyReduction_119
happyReduction_119 (HappyAbsSyn43  happy_var_3)
	_
	(HappyTerminal (TVAR _ happy_var_1))
	 =  HappyAbsSyn43
		 (happy_var_1 : happy_var_3
	)
happyReduction_119 _ _ _  = notHappyAtAll 

happyReduce_120 = happySpecReduce_3  44 happyReduction_120
happyReduction_120 (HappyAbsSyn43  happy_var_3)
	_
	(HappyTerminal (TCONST _ happy_var_1))
	 =  HappyAbsSyn43
		 (happy_var_1 : happy_var_3
	)
happyReduction_120 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 91 91 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TCONST _ happy_dollar_dollar -> cont 45;
	TVAR _ happy_dollar_dollar -> cont 46;
	TOPENB _ -> cont 47;
	TCLOSEB _ -> cont 48;
	TOPENSQB _ -> cont 49;
	TCLOSESQB _ -> cont 50;
	TCOLON _ -> cont 51;
	TEQ _ -> cont 52;
	TGT _ -> cont 53;
	TDEF _ -> cont 54;
	TIMPL _ -> cont 55;
	TPREVIOUS _ -> cont 56;
	TAND _ -> cont 57;
	TDOT _ -> cont 58;
	TCOMMA _ -> cont 59;
	TSTAR _ -> cont 60;
	TARROW _ -> cont 61;
	TUNEQUAL _ -> cont 62;
	TIMPLIES _ -> cont 63;
	TIMPLIES2 _ -> cont 64;
	TOR _ -> cont 65;
	THC _ -> cont 66;
	TEXISTS _ -> cont 67;
	TEQUAL _ -> cont 68;
	TLESS _ -> cont 69;
	TNOT _ -> cont 70;
	TSTEP _ -> cont 71;
	TSECTION _ -> cont 72;
	TSECTYPES _ -> cont 73;
	TSECSIG _ -> cont 74;
	TSECPROP _ -> cont 75;
	TSECINITS _ -> cont 76;
	TSECRULES _ -> cont 77;
	TSECGOALS _ -> cont 78;
	THORNCLAUSES _ -> cont 79;
	TGOAL _ -> cont 80;
	TATTACK _ -> cont 81;
	TINIT _ -> cont 82;
	TPROP _ -> cont 83;
	TGLOBALLY _ -> cont 84;
	TCONJ _ -> cont 85;
	TDISJ _ -> cont 86;
	TNEG _ -> cont 87;
	TNEG _ -> cont 88;
	TBWEVENTUALLY _ -> cont 89;
	TBWGLOBALLY _ -> cont 90;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 91 tk tks = happyError' (tks, explist)
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
parser tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


happyError :: [Token] -> a
happyError tks = error ("IF Parse error at " ++ lcn ++ "\n" )
	where
	lcn = 	case tks of
		  [] -> "end of file"
		  tk:_ -> "line " ++ show l ++ ", column " ++ show c  ++ " - Token: " ++ show tk
			where
			AlexPn _ l c = token_posn tk


type PProt = [PSection]

data PSection= PTypeSec [PTypeDecl]
	      |PInitSec [(PIdent,PCNState)]  
	      |PRuleSec [(PIdent,PRule)]
              |PGoalSec [(PIdent,PCNState)]
              |PLTLSec [PLTL]
              |PHornSec [PHornclause]
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

data PLTL = FactLTL PFact 
          | Equal PTerm PTerm
          | NotLTL PLTL
          | And PLTL PLTL
          | Or PLTL PLTL
          | Implies PLTL PLTL
          | Forall PIdent PLTL
          | Exists PIdent PLTL
          | UnTemp LTLOp1 PLTL
          | BinTemp LTLOp2 PLTL PLTL
          deriving (Eq,Show)

data LTLOp1 = X | Y | F | O | G | H 
            deriving (Eq,Show)

data LTLOp2 = U | R | S deriving (Eq,Show)

---- Terms, Facts, NFacts & Conditions


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

type PHornclause = (PIdent,PFact,[PFact])

ltl2attack :: PLTL -> [(PIdent,PCNState)]
ltl2attack (NotLTL _)  = error "'Not' at root of LTL formula, probably you don't want that?"
ltl2attack (UnTemp G phi) =  (proposit2attack (NotLTL phi))
ltl2attack _ = error "Thank you for using LTL, however you are outside the supported fragment."

 
normalise (And phi psi) =
  let phi' = normalise phi
      psi' = normalise psi
  in [And phi0 psi0 | phi0 <- phi', psi0 <- psi'] 

normalise (Or phi psi) =
  concatMap normalise [phi,psi]

normalise (NotLTL (And phi psi)) = normalise (Or (NotLTL phi) (NotLTL psi))
normalise (NotLTL (Or phi psi)) = normalise (And (NotLTL phi) (NotLTL psi))
normalise (NotLTL (NotLTL phi)) = normalise phi
normalise (NotLTL (Implies phi psi)) = normalise (And phi (NotLTL psi))
normalise (NotLTL (FactLTL ( fact))) = [(NotLTL (FactLTL ( fact)))]

normalise (Implies phi psi) = normalise (And (NotLTL phi) psi)
normalise (FactLTL fact) = [FactLTL fact]
normalise (NotLTL (Equal t1 t2)) = [(NotLTL (Equal t1 t2))]
normalise ( (Equal t1 t2)) = [( (Equal t1 t2))]
normalise phi = error $ "Thank you for using LTL, however you are outside the supported fragment."++(show phi)

proposit2attack :: PLTL -> [(PIdent,PCNState)]
proposit2attack phi = 
 let phi0 = normalise phi
 in map (\ phi -> getfacts [phi] ([],[])) phi0

getfacts :: [PLTL] -> PCNState -> (PIdent,PCNState)
getfacts ((And phi psi):chi) (pnstate,cond) = getfacts (phi:psi:chi) (pnstate,cond)
getfacts ((NotLTL (FactLTL  f)):chi) (pnstate,cond) = getfacts chi ((Not f):pnstate,cond)
getfacts ((FactLTL ( f)):chi) (pnstate,cond) = getfacts chi ((Plain f):pnstate,cond)
getfacts ((NotLTL (Equal t1 t2):chi)) (pnstate,cond) = getfacts chi (pnstate,(PNot (PEq t1 t2)):cond)
getfacts (( (Equal t1 t2):chi)) (pnstate,cond) = getfacts chi (pnstate,( (PEq t1 t2)):cond) 
getfacts [] (pnstate,cond) = ("translatedgoal",(pnstate,cond))
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

