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

-- | This module defines some types for the parameters and options that the AnB translators use
module AnBOnP
where

-- | The output type of the AnB translators
data OutputType = Internal -- ^ Do we use this?
                | Pretty  -- ^ Do we use this?
                | AST  -- ^ Just give the abstract syntax tree (for debugging)
                | IF -- ^ standard translation to AVISPA Intermediate Format
                | FP  -- ^ output for fixedpoint computation
                | FPI -- ^ iterative version of FP (for debugging)
     		| Isa -- ^ output for Isabelle
                | HLPSL -- ^ not implemented
                | Amphibian -- ^ do we use this?
                | AVANTSSAR -- ^ AVANTSSAR output format
                deriving (Eq,Show)

-- | The version of authentication considered in fixedpoint computation
data Authlevel = Strong -- ^ injective agreement: actually not supported for FP
               | Weak  -- ^ standard non-injective agreement
               | HWeak  -- ^ default; like Weak, but ignore if there are confusions between honest agents
     	       	 deriving (Eq,Show)

-- | The set of options and parameters that are passed to the AnB translators
data AnBOptsAndPars = 
                AnBOnP { anbfilename  :: String, -- ^ AnB file to translate 
		     theory    :: Maybe String, -- ^ Algebraic theory file (not supported now)
			 anboutput :: Maybe String, -- ^ Output filename
			 numSess   :: Maybe Int, -- ^ Number of sessions (for translation to IF)
			 outt      :: OutputType, -- ^ Output type
			 typed     :: Bool, -- ^ flag for typed protocol model
			 iterateFP :: Int, -- ^ used?
			 authlevel :: Authlevel, -- ^ authentication model level (for FP/Isa)
             noowngoal :: Bool, -- ^ whether authentication on oneself is checked
             if2cif    :: Bool -- ^ rewriting step from IF/Annotated AnB to cryptIF          
                       }


