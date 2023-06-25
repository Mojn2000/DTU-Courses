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


module NewIfLexer (Token(..), PIdent, AlexPosn(..), alexScanTokens
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
  "[]"                                  { (\ p s -> TGLOBALLY p)}
  "/\"                                  { (\ p s -> TCONJ p)}
  "\/"                                  { (\ p s -> TDISJ p)}
  "-"                                   { (\ p s -> TNEG p)}
  "~"                                   { (\ p s -> TNEG p)}
  ">"					{ (\ p s -> TGT p)}
  "[-]"                                 { (\ p s -> TBWGLOBALLY p)}
  "<->"                                 { (\ p s -> TBWEVENTUALLY p)}
  "(-)"                                 { (\ p s -> TPREVIOUS p)}
  "("					{ (\ p s -> TOPENB p) }
  ")"					{ (\ p s -> TCLOSEB p) }
  ":="					{ (\ p s -> TDEF p) }
  ":"					{ (\ p s -> TCOLON p) }
  "=>"					{ (\ p s -> TIMPL p) }
  "="					{ (\ p s -> TEQ p) }
  "->"					{ (\ p s -> TARROW p) }
  "*"					{ (\ p s -> TSTAR p) }
  "&"					{ (\ p s -> TAND p) }
  "."					{ (\ p s -> TDOT p) }
  ","					{ (\ p s -> TCOMMA p) }
  "["					{ (\ p s -> TOPENSQB p) }
  "]"					{ (\ p s -> TCLOSESQB p) }
  "/="                                  { (\ p s -> TUNEQUAL p)}
  exists                                { (\ p s -> TEXISTS p) }
  equal                                 { (\ p s -> TEQUAL p) }
  less                                  { (\ p s -> TLESS p) }
  not                                   { (\ p s -> TNOT p) }
  or                                    { (\ p s -> TOR p) }
  implies                               { (\ p s -> TIMPLIES2 p) }
  and                                   { (\ p s -> TAND p) }
  step                                  { (\ p s -> TSTEP p) }
  section                               { (\ p s -> TSECTION p) }
  "properties:"				{ (\ p s -> TSECPROP p) }
  "property"				{ (\ p s -> TPROP p) }
  "types:"                              { (\ p s -> TSECTYPES p) }
  "signature:"                          { (\ p s -> TSECSIG p) }
  "inits:"                              { (\ p s -> TSECINITS p) }
  "rules:"                              { (\ p s -> TSECRULES p) }
  "goals:"                              { (\ p s -> TSECGOALS p) }
  "attack_states:"                      { (\ p s -> TSECGOALS p) }
  goal                                  { (\ p s -> TGOAL p) }
  "attack_state"                        { (\ p s -> TATTACK p) }
  "initial_state"                       { (\ p s -> TINIT p) }
  "hornClauses:" 			{ (\ p s -> THORNCLAUSES p)}
  "hc"                                  { (\ p s -> THC p)}
  ":-"                                  { (\ p s -> TIMPLIES p)}
  $alphaL $identChar*                   { (\ p s -> TCONST p s) }
  $alphaU $identChar*                   { (\ p s -> TVAR p s) }
  $digit+                               { (\ p s -> TCONST p s) }

{

type PIdent=String

data Token= 
            TCONST AlexPosn PIdent	-- 
	    |TVAR AlexPosn PIdent	-- 
	    |TOPENB AlexPosn		-- (
	    |TCLOSEB AlexPosn		-- )
	    |TOPENSQB AlexPosn		-- (
	    |TCLOSESQB AlexPosn		-- )
	    |TEQ AlexPosn		-- =
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
	    |TOR AlexPosn		-- or
	    |TIMPLIES AlexPosn		-- implies
	    |TIMPLIES2 AlexPosn		-- another implies
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
	    |TATTACK AlexPosn	  	--
	    |TINIT  AlexPosn		-- initial_state
            |TGLOBALLY AlexPosn
	    |TGT AlexPosn
	    |TCONJ AlexPosn
	    |TDISJ AlexPosn
	    |TNEG AlexPosn
	    |TBWGLOBALLY AlexPosn
	    |TBWEVENTUALLY AlexPosn
            |TPROP AlexPosn
	    |TPREVIOUS AlexPosn
            |TUNEQUAL AlexPosn
	    |THORNCLAUSES AlexPosn
	    | THC AlexPosn
           deriving (Eq,Show)

token_posn (TUNEQUAL p  )= p
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
token_posn (TGT p)       = p
token_posn (TCOMMA p	)= p
token_posn (TEQUAL p	)= p
token_posn (TLESS p	)= p
token_posn (TNOT p	)= p
token_posn (TOR p	)= p
token_posn (TSTEP p	)= p
token_posn (TSECTION p	)= p
token_posn (TEXISTS p	)= p
token_posn (TSECTYPES p	)= p
token_posn (TSECSIG p	)= p
token_posn (TSECINITS p	)= p
token_posn (TSECPROP p	)= p
token_posn (TSECRULES p	)= p
token_posn (TSECGOALS p	)= p
token_posn (TGOAL p	)= p
token_posn (TATTACK p	)= p
token_posn (TINIT  p	)= p
token_posn (TGLOBALLY p ) = p
token_posn (TCONJ p ) = p
token_posn (TDISJ p ) = p
token_posn (TNEG p ) = p
token_posn (TBWGLOBALLY p ) = p
token_posn (TBWEVENTUALLY p ) = p
token_posn (TPROP p ) = p
token_posn (TPREVIOUS p) = p  
token_posn (THORNCLAUSES p) = p
token_posn (THC p)=p
token_posn (TIMPLIES p)=p
token_posn (TIMPLIES2 p)=p

}

