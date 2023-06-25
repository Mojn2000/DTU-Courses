{
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

module Lexer (Token(..), 
              Ident, 
	      AlexPosn(..), alexScanTokens, 
	      token_posn) where
import Ast
import Msg


}

%wrapper "posn"

$digit   = 0-9
$alpha   = [a-zA-Z]
$alphaL  = [a-z]
$alphaU  = [A-Z]
$identChar   = [a-zA-Z0-9_]

tokens :-

  $white+	;
  "#".*		;
  "("		{ (\ p s -> TOPENP p)  }
  ")"		{ (\ p s -> TCLOSEP p) }
  "{|"          { (\ p s -> TOPENSCRYPT p)}
  "|}"          { (\ p s -> TCLOSESCRYPT p)}
  "{"           { (\ p s -> TOPENB p)  }
  "}"		{ (\ p s -> TCLOSEB p) }
  ":"		{ (\ p s -> TCOLON p)  }
  ";"           { (\ p s -> TSEMICOLON p) }
  "*->*"        { (\ p s -> TSECCH p)  }
  "*->"		{ (\ p s -> TAUTHCH p) }
  "->*"         { (\ p s -> TCONFCH p) }
  "->"		{ (\ p s -> TINSECCH p)}
  "*->>"        { (\ p s -> TFAUTHCH p) }
  "*->>*"       { (\ p s -> TFSECCH p) }
  "%"		{ (\ p s -> TPERCENT p)}
  "!="          { (\ p s -> TUNEQUAL p)}
  "!"           { (\ p s -> TEXCLAM  p)}
  "."		{ (\ p s -> TDOT p) }
  ","		{ (\ p s -> TCOMMA p) }
  "["		{ (\ p s -> TOPENSQB p) } 
  "]"		{ (\ p s -> TCLOSESQB p) }
  "Protocol"    { (\ p s -> TPROTOCOL p) }
  "Knowledge"   { (\ p s -> TKNOWLEDGE p)}
  "Types"	{ (\ p s -> TTYPES p)}
  "Actions"	{ (\ p s -> TACTIONS p)}
  "Abstraction" { (\ p s -> TABSTRACTION p)}
  "Goals"	{ (\ p s -> TGOALS p)}
  "where"       { (\ p s -> TWHERE p) }
  "authenticates" { (\ p s -> TAUTHENTICATES p)}
  "on" { (\p s -> TON p)}
  "weakly" { (\p s -> TWEAKLY p)}
  "secret"  { (\p s -> TSECRET p)}
  "between" { (\p s -> TBETWEEN p)}
  "guessable" { (\p s -> TGUESS p)}
  $alpha $identChar* { (\ p s -> TATOM p s) }
  $digit+       { (\ p s -> TATOM p s) }

{

--- type Ident=String

data Token= 
   TATOM AlexPosn Ident	
   | TOPENP AlexPosn
   | TCLOSEP AlexPosn
   | TOPENSCRYPT AlexPosn
   | TCLOSESCRYPT AlexPosn
   | TOPENB AlexPosn
   | TCLOSEB AlexPosn
   | TCOLON AlexPosn
   | TSEMICOLON AlexPosn
   | TSECCH AlexPosn
   | TAUTHCH AlexPosn
   | TCONFCH AlexPosn
   | TINSECCH AlexPosn
   | TPERCENT AlexPosn
   | TEXCLAM AlexPosn
   | TDOT AlexPosn
   | TCOMMA AlexPosn
   | TOPENSQB AlexPosn
   | TCLOSESQB AlexPosn
   | TPROTOCOL AlexPosn
   | TKNOWLEDGE AlexPosn
   | TTYPES AlexPosn
   | TACTIONS AlexPosn
   | TABSTRACTION AlexPosn
   | TGOALS AlexPosn
   | TFSECCH AlexPosn
   | TFAUTHCH AlexPosn
   | TAUTHENTICATES AlexPosn
   | TON AlexPosn
   | TWEAKLY AlexPosn
   | TSECRET AlexPosn
   | TBETWEEN AlexPosn
   | TUNEQUAL AlexPosn
   | TWHERE AlexPosn
   | TGUESS AlexPosn
   deriving (Eq,Show)

token_posn (TATOM p _)=p
token_posn (TOPENP p)=p
token_posn (TCLOSEP p)=p
token_posn (TOPENSCRYPT p)=p
token_posn (TCLOSESCRYPT p)=p
token_posn (TOPENB p)=p
token_posn (TCLOSEB p)=p
token_posn (TCOLON p)=p
token_posn (TSEMICOLON p)=p
token_posn (TSECCH p)=p
token_posn (TAUTHCH p)=p
token_posn (TCONFCH p)=p
token_posn (TINSECCH p)=p
token_posn (TPERCENT p)=p
token_posn (TEXCLAM p)=p
token_posn (TDOT p)=p
token_posn (TCOMMA p)=p
token_posn (TOPENSQB p)=p
token_posn (TCLOSESQB p)=p
token_posn (TPROTOCOL p)=p
token_posn (TKNOWLEDGE p)=p
token_posn (TTYPES p)=p
token_posn (TACTIONS p)=p
token_posn (TABSTRACTION p)=p
token_posn (TGOALS p)=p
token_posn (TFSECCH p)=p
token_posn (TFAUTHCH p)=p
token_posn (TAUTHENTICATES p)=p
token_posn (TWEAKLY p)=p
token_posn (TON p)=p
token_posn (TSECRET p)=p
token_posn (TBETWEEN p)=p
token_posn (TWHERE p)=p
token_posn (TUNEQUAL p)=p
token_posn (TGUESS p)=p
}

