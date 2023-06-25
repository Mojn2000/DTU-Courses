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

module AnBParser where
import Lexer
import Ast
import Msg
}


%name anbparser
%tokentype {Token}

%token	    
  ident		{ TATOM _ $$}
  "("		{ TOPENP _  }
  ")"		{ TCLOSEP _ }
  "{"           { TOPENB _  }
  "}"		{ TCLOSEB _ }
  "{|"          { TOPENSCRYPT _}
  "|}"          { TCLOSESCRYPT _}
  ":"		{ TCOLON _  }
  ";"           { TSEMICOLON _ }
  "*->*"        { TSECCH _  }
  "*->"		{ TAUTHCH _ }
  "->*"         { TCONFCH _ }
  "->"		{ TINSECCH _}
  "*->>"        { TFAUTHCH _}
  "*->>*"       { TFSECCH _}
  "%"		{ TPERCENT _}
  "!="          { TUNEQUAL _}
  "!"           { TEXCLAM  _}
  "."		{ TDOT _ }
  ","		{ TCOMMA _ }
  "["		{ TOPENSQB _ }
  "]"		{ TCLOSESQB _ }
  "Protocol"    { TPROTOCOL _ }
  "Knowledge"   { TKNOWLEDGE _}
  "where"       { TWHERE _}
  "Types"	{ TTYPES _}
  "Actions"	{ TACTIONS _}
  "Abstraction" { TABSTRACTION _}
  "Goals"	{ TGOALS _}
  "guessable"   { TGUESS _ }
  "authenticates" { TAUTHENTICATES _}
  "weakly" {TWEAKLY _}
  "on" {TON _}
  "secret"  { TSECRET _}
  "between"  { TBETWEEN _}

%%

protocol :: {Protocol}
  : "Protocol" ":" ident
    "Types" ":" typedec
    "Knowledge" ":" knowdec
    "Actions" ":" actionsdec
    "Goals" ":" goalsdec  
    absdec         {($3,$6,$9,$16,$12,$15)}

absdec :: {Abstraction}
: {[]}
| "Abstraction" ":" abslist {$3}

optSemicolon :: {()}
: ";"  {()}
|      {()}

abslist :: {Abstraction}
: ident "->" msgNOP optSemicolon {[($1,$3)]}
| ident "->" msgNOP ";" abslist {(($1,$3):$5)}

typedec :: {Types} 
  : type identlist optSemicolon {[($1,$2)]}
  | type identlist ";" typedec {($1,$2):$4}

type :: {Type}
  : ident {case $1 of
	       "Agent" -> Agent False False
	       "Number" -> Number
               "SeqNumber" -> SeqNumber
	       "PublicKey" -> PublicKey
	       "Symmetric_key" -> SymmetricKey 
	       "Function" -> Function
	       "Untyped" -> Untyped
	       _ -> Custom $1
	}

identlist :: {[Ident]}
  : ident {[$1]}
  | ident "," identlist {$1:$3}

knowdec :: {Knowledge}
: knowspec "where" wheredec {($1,$3)}
| knowspec {($1,[])}

knowspec :: {[(Ident,[Msg])]}
  : ident ":" msglist ";" knowspec {(($1,$3):$5)}
  | ident ":" msglist optSemicolon {[($1,$3)]} 

wheredec :: {[(Msg,Msg)]}
: msg "!=" msg {[($1,$3)]}
| msg "!=" msg "," wheredec {(($1,$3):$5)}

msglist :: {[Msg]}
  : msgNOP "," msglist {$1:$3}
  | msgNOP {[$1]}

msg :: {Msg}
 : msgNOP                {$1}
 | msg "," msg           {Comp Cat [$1,$3]}

msgNOP :: {Msg}
  : ident                {Atom $1}
  | "{" msg "}" msgNOP   {Comp Crypt [$4,$2]}
  | "{|" msg "|}" msgNOP {Comp Scrypt [$4,$2]}
  | ident "(" msglist ")"{if $1=="inv" then Comp Inv $3
			  else if $1=="exp" then Comp Exp $3
			  else if $1=="xor" then Comp Xor $3
			  else case $3 of
				 [x] -> Comp Apply ((Atom $1):[x])
				 _ -> Comp Apply ((Atom $1):[Comp Cat $3])}
  | "("msg")"            {$2}

actionsdec :: {Actions}
  : action {[$1]}
  | action actionsdec {($1:$2)}

action :: {Action}
  : channel ":" msg "%" msg "!" msg 
     {($1,$3,Just $5,Just $7)}
  | channel ":" msg "%" msg 
     {($1,$3,Just $5,Nothing)}
  | channel ":" msg 
     {($1,$3,Nothing,Nothing)}

channeltype :: {ChannelType}
  : "*->*" {Secure}
  | "*->" {Authentic}
  | "->*" {Confidential}
  | "->" {Insecure}

channeltypeG :: {ChannelType}
  : "*->*" {FreshSecure}
  | "*->" {FreshAuthentic}
  | "->*" {Confidential}
  | "->" {Insecure}

channel :: {Channel} 
  : peer channeltype peer {($1,$2,$3)} 
 
channelG :: {Channel} 
  : peer channeltypeG peer {($1,$2,$3)} 
 
peer :: {Peer}
  : ident {($1,False,Nothing)}
  | "[" ident "]" {($2,True,Nothing)}
  | "[" ident ":" msg "]" {($2,True, Just $4)}

goalsdec :: {Goals}
  : goal {[$1]}
  | goal goalsdec {$1:$2}

goal :: {Goal}
  : channelG ":" msg      
  {(ChGoal $1 $3)}
  | peer "authenticates" peer "on" msg 
  --- {(Authentication $1 $3 $5)}
  {(ChGoal ($3,FreshAuthentic,$1) $5)}
  | peer "weakly" "authenticates" peer "on" msg 
  {(ChGoal ($4,Authentic,$1) $6)}
  --- {(WAuthentication $1 $4 $6)}
  | msg "secret" "between" peers 
  {(Secret $1 $4 False)}
  | msg "guessable" "secret" "between" peers 
  {(Secret $1 $5 True)}

peers :: {[Peer]}
peers : peer {[$1]}
| peer "," peers {($1:$3)}

---------------------------------

{
happyError :: [Token] -> a
happyError tks = error ("AnB Parse error at " ++ lcn ++ "\n" )
	where
	lcn = 	case tks of
		  [] -> "end of file"
		  tk:_ -> "line " ++ show l ++ ", column " ++ show c ++ " - Token: " ++ show tk
			where
			AlexPn _ l c = token_posn tk
}
