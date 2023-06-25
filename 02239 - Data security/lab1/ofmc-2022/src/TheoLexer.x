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

module TheoLexer (Token(..), PIdent, AlexPosn(..), alexScanTokens
                  , token_posn
                  ) where
}

%wrapper "posn"

$digit = 0-9			-- digits
$alpha = [a-zA-Z]		-- alphabetic characters
$alphaL  = [a-z]
$alphaU  = [A-Z]
$identChar = [a-zA-Z0-9_]
tokens :-

  $white+				;
  "%".*				        ;
  "/="                                  { (\ p s -> TNEQ p)}
  "|"                                   { (\ p s -> TBAR p)}
  "/\"                                  { (\ p s -> TCONJ p)}
  "\/"                                  { (\ p s -> TDISJ p)}
  "-"                                   { (\ p s -> TNEG p)}
  "~"                                   { (\ p s -> TNEG p)}
  "[-]"                                 { (\ p s -> TBWGLOBALLY p)}
  "<->"                                 { (\ p s -> TBWEVENTUALLY p)}
  "(-)"                                 { (\ p s -> TPREVIOUS p)}
  "("					{ (\ p s -> TOPENB p) }
  ")"					{ (\ p s -> TCLOSEB p) }
  ":="					{ (\ p s -> TDEF p) }
  ":"					{ (\ p s -> TCOLON p) }
  "=>"					{ (\ p s -> TIMPL p) }
  "="					{ (\ p s -> TEQ p) }
  "=="					{ (\ p s -> TCOMP p) }
  "->"					{ (\ p s -> TARROW p) }
  "*"					{ (\ p s -> TSTAR p) }
  "&"					{ (\ p s -> TAND p) }
  "."					{ (\ p s -> TDOT p) }
  ","					{ (\ p s -> TCOMMA p) }
  "["					{ (\ p s -> TOPENSQB p) }
  "]"					{ (\ p s -> TCLOSESQB p) }
  if                                    { (\ p s -> TIF p)}
  "{"                                   { (\ p s -> TLBRACE p)}
  "}"                                   { (\ p s -> TRBRACE p)}
  "/"                                   { (\ p s -> TSLASH p)}
  Theory                                { (\ p s -> TTHEO p)}
  Analysis                              { (\ p s -> TANALYSIS p)}
  Cancellation                          { (\ p s -> TCANCELLATION p)}
  FEC                                   { (\ p s -> TFEC p)}
  topdec                                { (\ p s -> TTOPDEC p)}
  Topdec                                { (\ p s -> TTOPDECU p)}
  decana                                { (\ p s -> TDECANA p)}
  exists                                { (\ p s -> TEXISTS p) }
  equal                                 { (\ p s -> TEQUAL p) }
  less                                  { (\ p s -> TLESS p) }
  not                                   { (\ p s -> TNOT p) }
  step                                  { (\ p s -> TSTEP p) }
  section                               { (\ p s -> TSECTION p) }
  "Signature"                           { (\ p s -> TSECSIG p) }
  $alphaL $identChar*                   { (\ p s -> TCONST p s) }
  $alphaU $identChar*                   { (\ p s -> TVAR p s) }
  $digit+                               { (\ p s -> TNUM p (read s)) }

{

type PIdent=String

data Token= 
            TCONST AlexPosn PIdent	-- 
            |TNUM AlexPosn Int     	-- 
	    |TVAR AlexPosn PIdent	-- 
	    |TOPENB AlexPosn		-- (
	    |TCLOSEB AlexPosn		-- )
            |TCANCELLATION AlexPosn
            |TFEC AlexPosn
	    |TOPENSQB AlexPosn		-- (
            |TBAR AlexPosn
	    |TCLOSESQB AlexPosn		-- )
	    |TEQ AlexPosn		-- =
            |TNEQ AlexPosn              -- /=
            |TDECANA AlexPosn
            |TANALYSIS AlexPosn
	    |TCOMP AlexPosn		-- ==
            |TIF AlexPosn 
            |TLBRACE AlexPosn
            |TRBRACE AlexPosn
            |TSLASH AlexPosn
            |TTHEO AlexPosn
            |TTOPDEC AlexPosn
            |TTOPDECU AlexPosn
            |TDEF   AlexPosn             -- :=
	    |TCOLON AlexPosn		-- :
	    |TIMPL AlexPosn		-- =>
            |TSTAR AlexPosn             -- star
	    |TARROW AlexPosn            --  ->
	    |TAND AlexPosn		-- &
	    |TDOT AlexPosn		-- .
	    |TCOMMA AlexPosn		-- ,
	    |TEQUAL AlexPosn		-- equal
	    |TLESS AlexPosn		-- less
	    |TNOT AlexPosn		-- not
	    |TSTEP AlexPosn		-- step
	    |TSECTION AlexPosn		-- section
            |TEXISTS AlexPosn
            |TSECTYPES AlexPosn
            |TSECSIG AlexPosn
	    |TSECINITS AlexPosn
	    |TSECPROP AlexPosn
	    |TSECRULES AlexPosn
	    |TSECGOALS AlexPosn
	    |TGOAL AlexPosn	  	--
	    |TINIT  AlexPosn		-- initial_state
            |TGLOBALLY AlexPosn
	    |TCONJ AlexPosn
	    |TDISJ AlexPosn
	    |TNEG AlexPosn
	    |TBWGLOBALLY AlexPosn
	    |TBWEVENTUALLY AlexPosn
            |TPROP AlexPosn
	    |TPREVIOUS AlexPosn
           deriving (Eq,Show)

token_posn (TCONST p _  )= p 
token_posn (TVAR p _	)= p
token_posn (TOPENB p	)= p
token_posn (TCLOSEB p	)= p
token_posn (TOPENSQB p	)= p
token_posn (TCLOSESQB p	)= p
token_posn (TEQ p	)= p
token_posn (TDEF   p    )= p
token_posn (TCOLON p	)= p
token_posn (TIMPL p	)= p
token_posn (TSTAR p     )= p
token_posn (TARROW p    )= p
token_posn (TAND p	)= p
token_posn (TDOT p	)= p
token_posn (TCOMMA p	)= p
token_posn (TEQUAL p	)= p
token_posn (TLESS p	)= p
token_posn (TNOT p	)= p
token_posn (TSTEP p	)= p
token_posn (TSECTION p	)= p
token_posn (TEXISTS p	)= p
token_posn (TSECTYPES p	)= p
token_posn (TSECSIG p	)= p
token_posn (TSECINITS p	)= p
token_posn (TSECPROP p	)= p
token_posn (TBAR p ) =p
token_posn (TSECRULES p	)= p
token_posn (TSECGOALS p	)= p
token_posn (TGOAL p	)= p
token_posn (TINIT  p	)= p
token_posn (TGLOBALLY p ) = p
token_posn (TCONJ p ) = p
token_posn (TDISJ p ) = p
token_posn (TNEG p ) = p
token_posn (TBWGLOBALLY p ) = p
token_posn (TBWEVENTUALLY p ) = p
token_posn (TPROP p ) = p
token_posn (TPREVIOUS p) = p  
token_posn (TNUM p s) = p
token_posn (TCOMP p) = p
token_posn (TIF p) = p
token_posn (TLBRACE p) = p
token_posn (TRBRACE p) = p
token_posn (TSLASH p) = p
token_posn (TTHEO p) = p
token_posn (TTOPDEC p) =p
token_posn (TTOPDECU p) =p
token_posn (TNEQ p) =p
token_posn (TANALYSIS p) =p
token_posn (TCANCELLATION p) =p
token_posn (TFEC p) =p
}

