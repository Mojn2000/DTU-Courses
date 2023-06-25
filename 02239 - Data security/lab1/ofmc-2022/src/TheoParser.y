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

module TheoParser where
import TheoLexer
}


%name theoparser
%tokentype {Token}

%token      const               {TCONST _ $$}
            var                 {TVAR _ $$}
            num                 {TNUM _ $$}
            '('                 {TOPENB _}
            ')'                 {TCLOSEB _}
            '['                 {TOPENSQB _}
            '|'                 {TBAR _}
            ']'                 {TCLOSESQB _}
            ':'                 {TCOLON _}
            '='                 {TEQ _}
            if                  {TIF _}
            '{' {TLBRACE _}
            '}' {TRBRACE _}
            ":="                {TDEF _}
            "=>"                {TIMPL _}
            "(-)" {TPREVIOUS _}
            '/' {TSLASH _}
            '&'                 {TAND _}
            '.'                 {TDOT _}
            ','                 {TCOMMA _}
            '*'                 {TSTAR _}
            '->'                {TARROW _}
"/=" {TNEQ _}
decana {TDECANA _}
analysis {TANALYSIS _}
cancellation {TCANCELLATION _}
fec {TFEC _}
            '==' {TCOMP _}
            theory {TTHEO _}
            topdec {TTOPDEC _}
            topdecU {TTOPDECU _}
            signature           {TSECSIG _}
            exists              {TEXISTS _}
            equ                 {TEQUAL _}
            less                {TLESS _}
            not                 {TNOT _}
            step                {TSTEP _}
            sect                {TSECTION _}
            sectypes            {TSECTYPES _}
            secprop             {TSECPROP _}
            secinits            {TSECINITS _}
            secrules            {TSECRULES _}
            secgoals            {TSECGOALS _}
            gol                 {TGOAL _}
            init                {TINIT _}
            property {TPROP _}
"[]" {TGLOBALLY _}
"/\\" {TCONJ _}
"\/" {TDISJ _}
'-' {TNEG _}
'~' {TNEG _}
"<->" {TBWEVENTUALLY _}
"[-]" {TBWGLOBALLY _}


%%

-------------Theory-File parser---------------------------

theoryFile::{[PTheo]}
 : subtheory {[$1]}  
 | subtheory theoryFile { $1 : $2 }

subtheory::{PTheo}
     : theory var ':' 
     signaturesec 
     --- intrudersec 
     --- fecsec 
     cancelsec 
     topdecsec 
     anasec 
                                {($4,$5,$6,$7)}

signaturesec::{PSigSec}
: signature ':' oparitys {$3}

oparitys::{PSigSec}
: const '/' num                          {[($1,$3)]}
| const '/' num ',' oparitys {($1,$3):$5}

topdecsec::{[PTopdec]}
: {-- empty --} {[]}
| topdecU ':' 
topdeclarations {$3}

topdeclarations::{[PTopdec]}
: topdec '(' const ',' term ')' '=' topdecCases {[($3,$5,$8)]}
| topdec '(' const ',' term ')' '=' topdecCases topdeclarations {($3,$5,$8):$9}

topdecCases::{[PTopdecCase]}
: if var '==' term '{' topdecCases '}' {[PCond ($2,$4) $6]}
| if var '==' term '{' topdecCases '}' topdecCases {(PCond ($2,$4) $6):$8}
| topdecUncond {[PUncond $1]}
| topdecUncond topdecCases {(PUncond $1):$2}

topdecUncond ::{[PUncond]}
: '['terms']' {[$2]}
| '['terms']' topdecUncond {$2:$4}

------------------ rest is just dummy for now 

intrudersec::{[Int]}
: {--empty--} {[]}

fecsec::{[Int]}
: {--empty--} {[]}
| fec ':' equations {[]}

cancelsec::{[(PTerm,PTerm)]}
: {--empty--} {[]}
| cancellation ':' equations {$3}

equations::{[(PTerm,PTerm)]}
: {--empty--} {[]}
| term '=' term equations {($1,$3):$4}


anasec::{[PDecana]}
: {--empty--} {[]}
| analysis ':' decanas {$3}

decanas :: {[PDecana]}
: decana '(' term ')' decanaCases decanas {($3,$5):$6}
| {--empty--} {[]}

decanaCases :: {[(PIneq,[PTerm],[PTerm])]}
: '|' term "/=" term '=' decanaCases2 {map (\ (x,y) -> ([($2,$4)],x,y)) $6}
| '=' decanaCases2 {map (\ (x,y) -> ([],x,y)) $2}

decanaCases2 :: {[([PTerm],[PTerm])]}
: '[' terms ']' '->' '[' terms ']' decanaCases2 {($2,$6):$8}
| '[' ']' '->' '[' terms ']' decanaCases2 {([],$5):$7}
| {--empty--} {[]}

-----------------------------------

sections :: {PProt}
      : section                                 {[$1]}
      | section sections                        {$1 : $2}

section :: {PSection}
       :  sect sectypes typedecs        {PTypeSec $3}
        | sect signature sigdec            {PTypeSec $3}
        | sect secinits initials        {PInitSec $3}
        | sect secrules rulez           {PRuleSec $3}
        | sect secgoals goalz           {PGoalSec $3}
        | sect secprop propdec          {PTypeSec $3}

--------------- Section Properties -------------------


propdec :: {[PTypeDecl]}
         : prop                         {[]}
         | prop propdec                 {[]}

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

--------------- Section Signature --------------------

sigdec::{[PTypeDecl]}
         : ftypedec                             {[] --- ignore this bs.}
       | ftypedec sigdec                        {[] --- ignore this bs.}

ftypedec::{PTypeDecl}
        : varcos ':' myftype                    {Decl $3 $1}

myftype :: {PType}
         : const '(' mytypes ')'                {Comp $1 $3}
         | const                                {Atomic $1}
         | mytype '*' myftype                   {$1}
         | mytype '->' mytype                   {$1}
         


--------------- Section Types ------------------------

typedecs::{[PTypeDecl]}
       : typedec                                {[$1]}
       | typedec typedecs                       {$1 : $2}

typedec::{PTypeDecl}
        : varcos ':' mytype                     {Decl $3 $1}


mytype:: {PType}
         : const '(' mytypes ')'                {Comp $1 $3}
         | const                                {Atomic $1}

mytypes::{[PType]}
        : mytype                                {[$1]}
        | mytype ','  mytypes                   {$1 : $3}



--------------- Section Init ------------------------

initials::{[(PIdent,PState)]}
        : initial                               {[$1]}
        | initial initials                      {$1 : $2}


initial::{(PIdent,PState)}
        : init const ":=" state                 {($2,$4)}


--------------- Section Rulez ------------------------

rulez::{[(PIdent,PRule)]}
        : rule                                  {[$1]}
        | rule rulez                            {$1 : $2}

rule::{(PIdent,PRule)}
 : step const '(' vars ')' ":=" cnstate freshvar "=>" state  
                                                 {($2,($7,$10,$8))} 


freshvar::{[PSubst]}
        : {--empty--}                           {[]}
        | '=' '[' exists substs ']'             {$4}


substs::{[PSubst]}
        : subst                         {[$1]}
        | subst ',' substs              {$1 : $3}

subst::{PSubst}
     : var                                      {($1,Nothing)}
     | var ":=" term                            {($1,Just $3)}


--------------- Section Goalz ------------------------


goalz::{[(PIdent, PCNState)]}
        : goal                                  {[$1]}
        | goal goalz                            {$1 : $2}

goal::{(PIdent, PCNState)}
        : gol const '(' vars ')' ":=" cnstate   {($2,$7)}


---------------- Facts, States, Conditions, etc  -----------------



cnstate::{PCNState}
--      : nstate conditions                     {($1 , $2)}
        : nstate                                {$1}

nstate::{(PNState,[PCondition])}
        :nfacts                                 {$1}
--        :nfacts negfacts                        {$1 ++ $2}

state::{PState}
       :facts                                   {$1}

nfact::{PNFact}
        : fact                                  {Plain $1}
        | negfact                               {$1}

negfact::{PNFact}
          : not '(' fact ')'                    {Not $3}
          | '~' '(' fact ')'                    {Not $3}

--negfacts::{[PNFact]}
--          :{--empty--}                            {[]}
--        | negfacts '&' negfact                  {$3 : $1}

nfacts::{([PNFact],[PCondition])}
        :{--empty--}                            {([],[])}
         |nfact                                 {([$1],[])}
         |nfact '.' nfacts                      {($1 : fst $3,snd $3)}
         |nfact '&' nfacts                      {($1 : fst $3,snd $3)}
         |nfact '&' conditions                  {([$1],$3)}


fact :: {PFact}
     : const '(' terms ')'                      {($1, $3)}

facts::{[PFact]}
        :{--empty--}                            {[]}
        |fact                                   {[$1]}
        |fact '.' facts                         {$1 : $3}

term :: {PTerm}
     :  const '(' terms ')'                     {PCompT $1 $3}
     |  var                                     {PVar $1}
     |  const                                   {PConst $1}

terms :: {[PTerm]}
         :term                                  {[$1]}
         |term ',' terms                        {$1 : $3}


conditions::{[PCondition]}
        : condition                             {[$1]}
        | condition '&' conditions              {$1 : $3}

--conditions::{[PCondition]}
--        : {--empty--}                         {[]}
--        | conditions '&' condition            {$3 : $1}

condition::{PCondition}
       : equ '(' term ',' term ')'              {PEq $3 $5}
        | less '(' term ',' term ')'            {PLess $3 $5}
        | not '(' condition ')'                 {PNot $3}
        | '~' '(' condition ')'                 {PNot $3}




--------------Contants, Variables, Lists of both--------------


vars::{[PIdent]}
        : var                                   {[$1]}
        | var ',' vars                          {$1 : $3}


varcos::{[PIdent]}
         : var                          {[$1]}
         | const                        {[$1]}
         | var ',' varcos               {$1 : $3}
         | const ',' varcos             {$1 : $3}








---------------------------------------------
------- data for parsed expressions  --------
---------------------------------------------

{
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



 }
