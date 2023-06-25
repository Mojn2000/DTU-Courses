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


module NewIfParser where
---import Char
---import List
import NewIfLexer
}


%name parser
%tokentype {Token}

%token	    const		{TCONST _ $$}
	    var			{TVAR _ $$}
	    '('			{TOPENB _}
	    ')'			{TCLOSEB _}
            '['                 {TOPENSQB _}
            ']'                 {TCLOSESQB _}
	    ':'			{TCOLON _}
            '='                 {TEQ _}
            '>'                 {TGT _}
	    ":="		{TDEF _}
	    "=>"		{TIMPL _}
            "(-)" {TPREVIOUS _}
	    and			{TAND _}
	    '.'			{TDOT _}
	    ','			{TCOMMA _}
            '*'                 {TSTAR _}
            '->'                {TARROW _}
            '/='                {TUNEQUAL _}
            ':-'                {TIMPLIES _}
            implies {TIMPLIES2 _}
            or {TOR _}
            'hc'                {THC _}
            exists              {TEXISTS _}
	    equ			{TEQUAL _}
	    less		{TLESS _}
	    not			{TNOT _}
	    step		{TSTEP _}
	    sect		{TSECTION _}
	    sectypes		{TSECTYPES _}
	    secsig		{TSECSIG _}
	    secprop		{TSECPROP _}
	    secinits		{TSECINITS _}
	    secrules		{TSECRULES _}
	    secgoals		{TSECGOALS _}
            sechornclauses      {THORNCLAUSES _}
	    gol			{TGOAL _}
	    attack		{TATTACK _}
	    init		{TINIT _}
            property {TPROP _}
"[]" {TGLOBALLY _}
"/\\" {TCONJ _}
"\/" {TDISJ _}
'-' {TNEG _}
'~' {TNEG _}
"<->" {TBWEVENTUALLY _}
"[-]" {TBWGLOBALLY _}


%%



sections :: {PProt}
      : section					{[$1]}
      | section sections			{$1 : $2}

section :: {PSection}
       :  sect sectypes typedecs	{PTypeSec $3}
        | sect secsig sigdec            {PTypeSec $3}
	| sect secinits initials	{PInitSec $3}
        | sect secrules rulez		{PRuleSec $3}
	| sect secgoals goalz		{PGoalSec $3}
        | sect secgoals ltls            {PGoalSec $3} ---{PLTLSec $3}
	| sect secprop propdec		{PTypeSec $3}
        | sect sechornclauses hornclauses {PHornSec $3}

--------------- Section Hornclauses ------------------

hornclauses :: {[PHornclause]}
   :    {[]} 
   | hornclause hornclauses {($1:$2)}

hornclause :: {PHornclause}
   : 'hc' const '(' vars ')' ":=" fact ':-' body 
   { ($2,$7,$9)}
   | 'hc' const ":=" fact ':-' body 
   { ($2,$4,$6)}
   | 'hc' const ":=" fact 
   { ($2,$4,[])}

body::{[PFact]}
        :{--empty--}                            {[]}
        |fact					{[$1]}
	|fact ',' body				{$1 : $3}
	|fact '.' body				{$1 : $3}

--------------- Section Properties -------------------


propdec :: {[PTypeDecl]}
         : prop				{[]}
         | prop propdec			{[]}

prop :: {[PTypeDecl]}
: property const ":=" "[]" backwardsLTL {[]}
| property const '(' vars ')' ":=" "[]" backwardsLTL {[]}

backwardsLTL :: {[PTypeDecl]}
: '(' backwardsLTL ')' {[]}
| term                 {[]}
| fact                 {[]}
| condition            {[]}
| backwardsLTL "/\\" backwardsLTL                 {[]}
| backwardsLTL "\/" backwardsLTL                 {[]}
| backwardsLTL "=>" backwardsLTL                 {[]}
| '-' backwardsLTL     {[]}
| '~' backwardsLTL     {[]}
| "<->" backwardsLTL   {[]}
| "[-]" backwardsLTL   {[]}
| "(-)" backwardsLTL   {[]}


ltls :: {[(PIdent,PCNState)]} --- {[PLTL]}
ltls 
: gol const '(' vars ')' ":=" LTLGoal {ltl2attack $7}
| gol const '(' vars ')' ":=" LTLGoal ltls {(ltl2attack $7)++$8}
| gol const  ":=" LTLGoal ltls {(ltl2attack $4)++$5}
| {([])}

LTLGoal :: {PLTL}
:  var '(' LTLGoal ')'  
    {case $1 of 
     "X" -> UnTemp X $3
     "Y" -> UnTemp Y $3
     "F" -> UnTemp F $3
     "O" -> UnTemp O $3
     "G" -> UnTemp G $3
     "H" -> UnTemp H $3
     _ -> error $ "Unknown LTL operator "++$1
	}
| not '(' LTLGoal ')'  {NotLTL $3}
| implies '(' LTLGoal ',' LTLGoal ')'{Implies $3 $5}
| and '(' LTLGoal ',' LTLGoal ')'{And $3 $5}
| or '(' LTLGoal ',' LTLGoal ')'{Or $3 $5}
| var '(' LTLGoal ',' LTLGoal ')'
    {case $1 of
     "U" -> BinTemp U $3 $5
     "R" -> BinTemp R $3 $5
     "S" -> BinTemp S $3 $5
     _ -> error $ "Unknown  operator "++$1
	}
| const var '.' LTLGoal 
	{ case $1 of
          "forall" -> Forall $2 $4
          "exists" -> Exists $2 $4
          _ -> error $ "Unknown quantifier "++$1}
--- | const '(' term ',' term ')'
---      { case $1 of
---        "equal" -> Equal $3 $5
---	_ -> FactLTL ($1,[$3,$5])
---	  }
| equ  '(' term ',' term ')' {Equal $3 $5}
| fact {FactLTL $1}

--------------- Section Signature --------------------

sigdec::{[PTypeDecl]}
         : ftypedec				{[] --- ignore this bs.}
       | ftypedec sigdec			{[] --- ignore this bs.}
       | typeinclusion                          {[]}
       | typeinclusion sigdec                   {[]}

typeinclusion :: {()}
   : mytype '>' mytype  {()}

ftypedec::{PTypeDecl}
	: varcos ':' myftype			{Decl $3 $1}

myftype :: {PType}
	 : const '(' mytypes ')'		{Comp $1 $3}
	 | const				{Atomic $1}
         | mytype '*' myftype                   {$1}
         | mytype '->' mytype                   {$1}
         


--------------- Section Types ------------------------

typedecs::{[PTypeDecl]}
       : typedec				{[$1]}
       | typedec typedecs			{$1 : $2}

typedec::{PTypeDecl}
	: varcos ':' mytype			{Decl $3 $1}


mytype:: {PType}
	 : const '(' mytypes ')'		{Comp $1 $3}
	 | const				{Atomic $1}

mytypes::{[PType]}
	: mytype				{[$1]}
	| mytype ','  mytypes			{$1 : $3}



--------------- Section Init ------------------------

initials::{[(PIdent,PCNState)]}
	: initial				{[$1]}
	| initial initials			{$1 : $2}


initial::{(PIdent,PCNState)}
	: init const ":=" cnstate			{($2,$4)}


--------------- Section Rulez ------------------------

rulez::{[(PIdent,PRule)]}
	: rule					{[$1]}
	| rule rulez				{$1 : $2}

rule::{(PIdent,PRule)}
 : step const '(' vars ')' ":=" cnstate freshvar "=>" state  
						 {($2,($7,$10,$8))} 
 | step const  ":=" cnstate freshvar "=>" state  
						 {($2,($4,$7,$5))} 


freshvar::{[PSubst]}
	: {--empty--}				{[]}
	| '=' '[' exists substs ']'		{$4}


substs::{[PSubst]}
        : subst				{[$1]}
	| subst ',' substs              {$1 : $3}

subst::{PSubst}
     : var					{($1,Nothing)}
     | var ":=" term				{($1,Just $3)}


--------------- Section Goalz ------------------------


goalz::{[(PIdent, PCNState)]}
	: goal					{[$1]}
	| goal goalz				{$1 : $2}

goal::{(PIdent, PCNState)}
	: attack const '(' vars ')' ":=" cnstate	{($2,$7)}
	| attack const ":=" cnstate	{($2,$4)}


---------------- Facts, States, Conditions, etc  -----------------



cnstate::{PCNState}
--	: nstate conditions	                {($1 , $2)}
	: nstate  	                        {$1}

nstate::{(PNState,[PCondition])}
	:nfacts					{$1}
--        :nfacts negfacts                        {$1 ++ $2}

state::{PState}
       :facts					{$1}

nfact::{PNFact}
 	: fact					{Plain $1}
	| negfact			        {$1}

negfact::{PNFact}
          : not '(' fact ')'			{Not $3}
          | '~' '(' fact ')'			{Not $3}

--negfacts::{[PNFact]}
--          :{--empty--}                            {[]}
--	  | negfacts and negfact                  {$3 : $1}

nfacts::{([PNFact],[PCondition])}
        :{--empty--}                            {([],[])}
         |nfact					{([$1],[])}
         |nfact '.' nfacts			{($1 : fst $3,snd $3)}
         |nfact and nfacts			{($1 : fst $3,snd $3)}
         |nfact and conditions                  {([$1],$3)}
|condition '.' nfacts  {(fst $3, $1:(snd $3))}
|condition {([],[$1])}
fact :: {PFact}
     : const '(' terms ')'			{($1, $3)}
     | const {($1,[PConst "i"])}

facts::{[PFact]}
        :{--empty--}                            {[]}
        |fact					{[$1]}
	|fact '.' facts				{$1 : $3}

term :: {PTerm}
     :	const '(' terms ')'			{PCompT $1 $3}
     |	var					{PVar $1}
     |	const					{PConst $1}

terms :: {[PTerm]}
	 :term					{[$1]}
	 |term ',' terms			{$1 : $3}


conditions::{[PCondition]}
        : condition                             {[$1]}
        | condition and conditions		{$1 : $3}

--conditions::{[PCondition]}
--        : {--empty--}                         {[]}
--        | conditions and condition		{$3 : $1}

condition::{PCondition}
        : equ '(' term ',' term ')'		{PEq $3 $5}
        | var '=' term                          {PEq (PVar $1) $3}
        | var '/=' term                         {PNot (PEq (PVar $1) $3)}
	| less '(' term ',' term ')'		{PLess $3 $5}
	| not '(' condition ')'			{PNot $3}
	| '~' '(' condition ')'			{PNot $3}




--------------Contants, Variables, Lists of both--------------


vars::{[PIdent]}
	: var					{[$1]}
	| var ',' vars				{$1 : $3}


varcos::{[PIdent]}
         : var                          {[$1]}
	 | const                        {[$1]}
	 | var ',' varcos 		{$1 : $3}
	 | const ',' varcos		{$1 : $3}




---------------------------------------------
------- data for parsed expressions  --------
---------------------------------------------

{
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

 }
