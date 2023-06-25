{-

Open Source Fixedpoint Model-Checker version 2022

(C) Copyright Sebastian Moedersheim 2003,2022
(C) Copyright Paolo Modesti 2012
(C) Copyright Nicklas Bo Jensen 2012
(C) Copyright IBM Corp. 2009
(C) Copyright ETH Zurich (Swiss Federal Institute of Technology) 2003,2007

All Rights Reserved.

-}

import AnBmain
import AnBOnP
import System.CPUTime
import System.Environment
import System.IO
import Constants
import IntsOnly
import Decomposition
import Remola
import Symbolic
import NewIfParser
import PrettyUgly
import Search
import Data.Maybe
import Data.Char
import Data.List
import System.Exit
import TheoLoad
import Control.Concurrent
import If2Horn
import FPTranslator
import GHC.IO.Handle
import qualified Data.Map as Map

productname = "Open-Source Fixedpoint Model-Checker version 2022\n"

usage =    "usage: ofmc [<OPTIONS>] <INPUT FILE>\n"
	++ "Options:\n"
        ++ "  --numSess <INT>  specify the number of sessions (for an AnB spec)\n"
        ++ "  --of IF          (for AnB files only:) do not check, but produce AVISPA IF\n"
	    ++ "  --of Isa         (for AnB files only:) generate a fixedpoint proof for Isabelle-OFMC\n" 
	    ++ "  --of AVANTSSAR   print result in AVANTSSAR Output Format\n" 
	    ++ "  --fp             (for AnB files only:) check with fixedpoint module\n"
	    ++ "  --classic        (default) run in classic mode\n"
	    ++ "  -o <outputfile>  write result into <outputfile>\n"
        ++ "  --help, -h       display this help\n"
        ++ "  --version        display the version\n"
	    ++ "Options for classic mode:\n"
        ++ "  --numSess <INT>              (for AnB files only:) check for a given number of sessions\n"
        ++ "  --theory <TheoryFile>        use a custom algebraic theory\n"
---        ++ "  --sessco                     performs an executability check and session compilation\n"
        ++ "  --exec, -e       checks the executability of each rule (do not search for attacks)\n"
	    ++ "  --untyped, -u                ignores all type-declarations\n"
        ++ "  --depth <DEPTH>, -n <DEPTH>  specify maximum search depth/depth first search\n"
        ++ "  --trace <PATH>, -t <PATH>    (PATH is white-space separated list of ints)\n"
        ++ "                               specify a path in the search tree to visit\n"
        ++ "                               by the indices of the successors to follow.\n"
        ++ "  --noowngoal     (for AnB files only:) ignores attacks where an agent talks to itself\n"
        ++ "  --IF2CIF        (for AnB files only:) adds a rewriting step from IF/Annotated AnB to cryptIF\n"   
        ++ "  --attacktrace   If an attack is found, generate a graphic chart of it \n"

data Decision = NO_ATTACK_FOUND | ATTACK_FOUND | INCONCLUSIVE 
     	      deriving (Eq,Show)

data Result = Report { decision :: Decision,
     	      	       details  :: String,
		       protocol :: String,
		       goal     :: String,
		       comments :: String,
		       statistics::String,
		       attack   :: String }

dummyresult = Report {decision = INCONCLUSIVE, 
	      	      details = "",
		      protocol = "",
		      goal = "",
		      comments = "",
		      statistics = "",
		      attack = ""}

verified wauth protocolname
         = Report    {decision = NO_ATTACK_FOUND, 
	      	      details = "UNBOUNDED_NUMBER_OF_SESSIONS, TYPED_MODEL, FREE ALGEBRA",
		      protocol = protocolname,
		      goal = (if wauth then "" else "honest-")++
		      	      "weak authentication and secrecy",
		      comments = "It is recommended to run with --classic option as well (see manual).",
		      statistics = "",
		      attack = ""}


splitOn :: Eq a => [a] -> [a] -> [[a]]
splitOn key sentence = splitOn0 key sentence []
splitOn0 key word buffer = 
  if key `isPrefixOf` word then (reverse buffer):(splitOn key (drop (length key) word))
  else if null word then [reverse buffer] else splitOn0 key (tail word) ((head word):buffer)

--Evil hack by Nicklas - Prints attack trace to SVG

trim :: String -> String
trim = filter(/=' ')

findInMapping _ [] = Nothing
findInMapping den ((thiskey,thisval):rest) = if(trim den == trim thisval) then Just thiskey else findInMapping den rest

getNewIndex [] = 0
getNewIndex thismap = (fst (last thismap))+1

addMapping val thismap = if (isJust (findInMapping val thismap)) then thismap else thismap++[(getNewIndex thismap,trim val)]


processLine [] mapping = mapping
processLine (line:rest) mapping = if line == "" then mapping else let 
						newMapping = (addMapping (last(splitOn "->" (head(splitOn ":" line)))) (addMapping (head(splitOn "->" (head(splitOn ":" line)))) mapping)) 
			in processLine rest newMapping

createMapping str = let lines = splitOn "\n" str
			sheight = ((length lines)-1)*50;
			in (processLine lines [],sheight)

printStrands [] _ swidth = ""
printStrands ((thiskey,thisval):rest) sheight swidth = "<rect x=\""++(show (swidth*thiskey))++"\" y=\"0\" width=\"100\" height=\"20\" style=\"fill:white;stroke:black;stroke-width:2\"/>\n"++"<text x=\""++(show(swidth*thiskey+50))++"\" y=\"15\" text-anchor=\"middle\" style=\"font-family: Arial, Helvetica, sans-serif\">\n"++thisval++"</text>\n"++"<line x1=\""++(show(swidth*thiskey+50))++"\" y1=\"20\" x2=\""++(show(swidth*thiskey+50))++"\" y2=\""++(show sheight)++"\" style=\"stroke:black;stroke-width:2\" />\n"++"<rect x=\""++(show (swidth*thiskey+25))++"\" y=\""++(show sheight)++"\" width=\"50\" height=\"10\" style=\"fill:black;stroke:black;stroke-width:2\"/>\n" ++(printStrands rest sheight swidth )

printMessage [] _ _ _ = ""
printMessage (line:rest) mapping cnt swidth = if line == "" then "" else let 
				fromIndex = fromJust(findInMapping (head(splitOn "->" (head(splitOn ":" line)))) mapping)
				toIndex = fromJust(findInMapping (last(splitOn "->" (head(splitOn ":" line)))) mapping)
				direction = if(fromIndex > toIndex) then toIndex else fromIndex
				message = last(splitOn ":" line)
			in (if fromIndex < toIndex then "<line x1=\""++(show(swidth*fromIndex+50))++"\" y1=\""++(show(cnt*50))++"\" x2=\""++(show(swidth*toIndex+50))++"\" y2=\""++(show(cnt*50))++"\" style=\"stroke:black;stroke-width:2\" />\n"++"<line x1=\""++(show(swidth*toIndex+40))++"\" y1=\""++(show(cnt*50-10))++"\" x2=\""++(show(swidth*toIndex+50))++"\" y2=\""++(show(cnt*50))++"\" style=\"stroke:black;stroke-width:2\" />\n"++"<line x1=\""++(show(swidth*toIndex+40))++"\" y1=\""++(show(cnt*50+10))++"\" x2=\""++(show(swidth*toIndex+50))++"\" y2=\""++(show(cnt*50))++"\" style=\"stroke:black;stroke-width:2\" />\n"++"<text x=\""++(show((swidth*fromIndex+(swidth*toIndex-swidth*fromIndex)/2+50)))++"\" y=\""++(show(cnt*50-5))++"\" text-anchor=\"middle\" style=\"font-family: Arial, Helvetica, sans-serif\">"++message++"</text>\n" else "<line x1=\""++(show(swidth*toIndex+50))++"\" y1=\""++(show(cnt*50))++"\" x2=\""++(show(swidth*fromIndex+50))++"\" y2=\""++(show(cnt*50))++"\" style=\"stroke:black;stroke-width:2\" />\n"++"<line x1=\""++(show(swidth*toIndex+60))++"\" y1=\""++(show(cnt*50-10))++"\" x2=\""++(show(swidth*toIndex+50))++"\" y2=\""++(show(cnt*50))++"\" style=\"stroke:black;stroke-width:2\" />\n"++"<line x1=\""++(show(swidth*toIndex+60))++"\" y1=\""++(show(cnt*50+10))++"\" x2=\""++(show(swidth*toIndex+50))++"\" y2=\""++(show(cnt*50))++"\" style=\"stroke:black;stroke-width:2\" />\n"++"<text x=\""++(show((swidth*toIndex+(swidth*fromIndex-swidth*toIndex)/2+50)))++"\" y=\""++(show(cnt*50-5))++"\" text-anchor=\"middle\" style=\"font-family: Arial, Helvetica, sans-serif\">"++message++"</text>\n")++(printMessage rest mapping (cnt+1) swidth)

printMessages str mapping swidth = (printMessage (splitOn "\n" str) mapping 1 swidth)

messageLength [] = 0
messageLength (line:rest) =  let	myLength = (length(last(splitOn ":" line)))
					otherLengths = (messageLength rest)
			in if myLength > otherLengths then myLength else otherLengths

findMaxMessageLength str = messageLength (splitOn "\n" str)

printAT str = let 	(mapping, sheight) = createMapping str
			swidth = fromIntegral(findMaxMessageLength str)*6
		in (printStrands mapping sheight swidth)++(printMessages str mapping swidth)

createString str = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n"++(printAT str)++"</svg>"
showattack result = let attacks = (head (splitOn "% Reached State:" (attack result)))
		in writeFile "attacktrace.svg" (createString attacks)



showresult result printbackend =
  let optional str f = if (f result)=="" then "" else str++"  "++(f result)++"\n" in
  (optional "INPUT:\n " protocol)++
  "SUMMARY:\n  "++(show (decision result))++"\n"++
  (optional "GOAL:\n" goal)++
  (optional "DETAILS:\n" details)++
  (if not printbackend then "BACKEND:\n  "++productname else "")++
  (optional "COMMENTS:" comments)++
  (optional "STATISTICS:\n" statistics)++
  (if (decision result)==ATTACK_FOUND 
   then "ATTACK TRACE:\n"++
   	(attack result)++"\n"
   else "")


data OptsAndPars = OnP { filename :: String,
			 output   :: Maybe String,
			 depth    :: Maybe Int,
			 sesrep   :: Int,
			 path     :: Maybe [Int],
			 typing   :: Typing,
			 sessco   :: Bool,
			 por      :: Bool, 
			 must_step :: Bool,
			 normalize :: Bool,
			 showrules :: Bool,
                         theofile :: Maybe String,
                         isAnB :: Bool,
			 exec     :: Bool,
			 fileout :: Maybe String,
                         attacktrace :: Bool
                       }

parseArgs  :: [String] -> (OptsAndPars,AnBOptsAndPars)
parseArgs [] = error ("No input file specified.\n"++usage)
parseArgs ("--help":xs) = error usage
parseArgs ("-h":xs) = error usage --equal to help
parseArgs (x:xs) = 
  parseArgs0 (x:xs) (OnP { filename = "" , 
		       output   = Nothing,
		       depth    = Nothing, 
		       sesrep   = 1,
		       path     = Nothing, 
		       sessco   = False,
		       typing   = AsGiven,
		       must_step = False,
		       por      = True,
		       normalize = True,
                       showrules = False,
                       theofile  = Nothing,
                       isAnB = False,
		       exec = False,
		       fileout = Nothing,
                       attacktrace = False},
                 AnBOnP{ 
                          anbfilename = "", -- actually not used at all (use filename of main options set)
                          theory   = Nothing,
                          anboutput   = Nothing,
                          numSess  = Nothing,
                          outt     = Internal,
                          typed    = True,
                          iterateFP = 0,
                          authlevel = HWeak,
                          noowngoal = True,
                          if2cif = False
                      })

parseArgs0 :: [String] -> (OptsAndPars,AnBOptsAndPars) -> (OptsAndPars,AnBOptsAndPars)
parseArgs0 [] (onp,anbonp) = if (filename onp)=="" then error "No input file specified" else (onp,anbonp)
parseArgs0 ("-f":xs) (onp,anbonp) = parseArgs0 (tail xs) (onp {filename = (head xs), isAnB=isSuffixOf ".ANB" (map toUpper $ head xs)},anbonp)
parseArgs0 ("-o":xs) (onp,anbonp) = parseArgs0 (tail xs) (onp {fileout = Just (head xs)},anbonp)
parseArgs0 ("--version":xs) (onp,anbonp) = error $ "You are using "++productname --- parseArgs0 xs (onp {version = True},anbonp)
parseArgs0 ("--nonorm":xs) (onp,anbonp) = parseArgs0 xs (onp {normalize = False},anbonp)
parseArgs0 ("--theory":xs) (onp,anbonp) = parseArgs0 (tail xs) (onp {theofile = Just (head xs)},anbonp)
parseArgs0 ("--showrules":xs) (onp,anbonp) = parseArgs0 xs (onp {showrules = True},anbonp)
parseArgs0 ("--nocd":xs) (onp,anbonp) = parseArgs0 xs (onp { por = False },anbonp )
parseArgs0 ("--typed_model=yes":xs) (onp,anbonp) = parseArgs0 xs (onp { typing= AsGiven },anbonp )
parseArgs0 ("--typed_model=no":xs) (onp,anbonp) = parseArgs0 xs (onp { typing= Untyped },anbonp)
parseArgs0 ("--typed_model=strongly":xs) (onp,anbonp) = error ("  The strongly typed model is currently not supported\n")
parseArgs0 ("-r":v:xs) (onp,anbonp) = parseArgs0 xs (onp { sesrep = (0+(read v)) },anbonp)
parseArgs0 ("--trace":xs) (onp,anbonp) = 
  let (xs',xs'') = span (\ x -> (x/="") && (isDigit (head x))) xs
  in parseArgs0 xs'' (onp { path = Just (map read xs'), por = True },anbonp)
parseArgs0 ("-t":xs) (onp,anbonp) = --equal to trace
  let (xs',xs'') = span (\ x -> (x/="") && (isDigit (head x))) xs
  in parseArgs0 xs'' (onp { path = Just (map read xs'), por = True },anbonp)
parseArgs0 ("--depth":v:xs) (onp,anbonp) = parseArgs0 xs (onp { depth = Just (read v)},anbonp)
parseArgs0 ("-n":v:xs) (onp,anbonp) = parseArgs0 xs (onp { depth = Just (read v)},anbonp) --equal to --depth
parseArgs0 ("--sessco":xs) (onp,anbonp) = parseArgs0 xs (onp { sessco = True },anbonp)
parseArgs0 ("--untyped":xs) (onp,anbonp) = if (typing onp) /= AsGiven 
			         then error ("Error parsing typing arguments.")
				 else parseArgs0 xs (onp { typing=Untyped},anbonp)
parseArgs0 ("-u":xs) (onp,anbonp) = if (typing onp) /= AsGiven --equal to untyped 
			         then error ("Error parsing typing arguments.")
				 else parseArgs0 xs (onp { typing=Untyped},anbonp)
parseArgs0 ("-strongly-typed":xs) (onp,anbonp) = if (typing onp) /= AsGiven 
			         then error ("Error parsing typing arguments.")
				 else parseArgs0 xs (onp { typing=StronglyTyped},anbonp)
parseArgs0 ("--attacktrace":xs) (onp,anbonp) = parseArgs0 xs (onp {attacktrace=True},anbonp)
---- AnB options:
parseArgs0 ("--numSess":n:xs) (onp,anbonp) =
  ---if not (isAnB onp) then error "option --numSess only supported for .AnB input files\n" else
  if (numSess anbonp)==Nothing 
  then parseArgs0 xs (onp,anbonp {numSess=Just (read n)})
  else error "Multiple Declarations of \"numSess\" on command line"
parseArgs0 ("-typed":xs) (onp,anbonp) = 
  parseArgs0 xs (onp,anbonp{typed=True})
parseArgs0 ("--of":"FP":xs) (onp,anbonp) =
  parseArgs0 xs (onp,anbonp{outt=FP})
parseArgs0 ("--of":"FPI":file:xs) (onp,anbonp) = --- for debugging: iterative
  parseArgs0 xs (onp,anbonp{outt=FPI,anboutput=Just file})
parseArgs0 ("--of":"IF":xs) (onp,anbonp)=
  ---if not (isAnB onp) then error "option '--of IF' only supported for .AnB input files\n" 
  ---else 
  parseArgs0 xs (onp,anbonp{outt=IF})
parseArgs0 ("--of":"Isa":xs) (onp,anbonp)=
  parseArgs0 xs (onp,anbonp{outt=Isa})
parseArgs0 ("--of":"AMPHI":xs) (onp,anbonp) = 
  parseArgs0 xs (onp,anbonp{outt=Amphibian})
parseArgs0 ("--of":"AVANTSSAR":xs) (onp,anbonp) = 
  parseArgs0 xs (onp,anbonp{outt=AVANTSSAR})
parseArgs0 ("--of":other:xs) (onp,anbonp)  = error ("Unknown output format: "++other)
parseArgs0 ("--fp":xs) (onp,anbonp) =   
  parseArgs0 xs (onp,anbonp{outt=FP})
parseArgs0 ("--classic":xs) (onp,anbonp) = parseArgs0 xs (onp,anbonp{outt=Internal})
parseArgs0 ("--noowngoal":xs) (onp,anbonp) = parseArgs0 xs (onp,anbonp{noowngoal=True})
parseArgs0 ("--IF2CIF":xs) (onp,anbonp) = parseArgs0 xs (onp,anbonp{if2cif=True})
parseArgs0 ("--dfs":xs) (onp,anbonp) = parseArgs0 xs (onp{depth=Just (fromMaybe 10000000  (depth onp))},anbonp)
parseArgs0 ("--bfs":xs) (onp,anbonp) = parseArgs0 xs (onp{depth=Nothing},anbonp)
parseArgs0 ("--ids":xs) (onp,anbonp) = parseArgs0 xs (onp{depth=Nothing},anbonp)
parseArgs0 ("--wauth":xs) (onp,anbonp) = parseArgs0 xs (onp,anbonp{authlevel=Weak})
parseArgs0 ("--exec":xs) (onp,anbonp) = parseArgs0 xs (onp{exec=True},anbonp)
parseArgs0 ("-e":xs) (onp,anbonp) = parseArgs0 xs (onp{exec=True},anbonp) --equal to --exec
parseArgs0 (('-':'-':opt):xs) (onp,anbonp) = 
  if (isPrefixOf "output" opt) then 
    parseArgs0 xs (onp,anbonp)
  else if (isPrefixOf "redirect" opt) then
    parseArgs0 xs (onp {output = Just (drop 9 opt)},anbonp)
  else error ("unrecognized option '"++('-':'-':opt)++"'")
parseArgs0 (f:xs) (onp,anbonp) = if (filename onp)=="" && (head f)/='-'
                                 then parseArgs0 xs (onp {filename = f, isAnB = isSuffixOf ".ANB" (map toUpper f)},anbonp)
                                 else error ("Illegal filename or unrecognized option: "++f)
---parseArgs0 str (onp,anbonp) = error ("Error parsing arguments: "++(foldr (++) "" str))


main 
 = do args <- getArgs
      (onp,anbonp) <- return (parseArgs args)
      ---
      putStr $ if (outt anbonp)/=IF && (outt anbonp/=Isa)  && (outt anbonp/=AVANTSSAR) then productname else "" --- or ASLan
      putStr $ if (outt anbonp)==IF then "% Generated by "++productname else "" --- what the ... ? 
      putStr $ if (outt anbonp)==Isa then "Backend: Open-Source Fixedpoint Model-Checker version 2022 \n" else ""
      ---
      (case fileout onp of
	    Nothing -> return ()
	    Just f  -> do   h <- openFile f WriteMode
			    hDuplicateTo h stdout)
      if ((outt anbonp)==Amphibian) 
       then do mtid <- myThreadId
       	       classicResult <- newEmptyMVar
	       fpResult <- newEmptyMVar
	       forkIO (mainWithArgs (onp,anbonp{outt=FP}) (Just (classicResult,fpResult)) False)
	       forkIO (mainWithArgs (onp,anbonp{outt=Internal, numSess=(Just 1)}) (Just (classicResult,fpResult)) (isAnB onp))
	       classicresult <- takeMVar classicResult
	       fpresult <- takeMVar fpResult
	       (case (decision classicresult, decision fpresult) of
	        (ATTACK_FOUND,_) -> do 	(putStr (showresult classicresult (outt anbonp==AVANTSSAR))) 
					(if (attacktrace onp) then showattack classicresult else return ())
		(_,NO_ATTACK_FOUND) -> do putStr (showresult fpresult (outt anbonp==AVANTSSAR))
		_ -> do  classicresult2 <- takeMVar classicResult
	       		 fpresult2 <- takeMVar fpResult
			 (case (decision classicresult2, decision fpresult2) of
			  (_,NO_ATTACK_FOUND) -> do putStr (showresult fpresult2  (outt anbonp==AVANTSSAR))
	        	  _ -> do putStr (showresult classicresult2  (outt anbonp==AVANTSSAR))
                                  (if (attacktrace onp) then showattack classicresult2 else return ())))
       else 
        if (outt anbonp)==Isa then 
	  if (isAnB onp) then 
	    do str <- readFile (filename onp)
	       putStr (newanbmain str anbonp)
	  else do str <- readFile (filename onp)
	          putStr (hornFP [] True anbonp 
       	    	           (aslan2horn str))
	else
	    if (isAnB onp) && ((outt anbonp)==FPI)
       	    then do iterativeFP (onp,anbonp{iterateFP=7})
	    else if (isAnB onp) && ((numSess anbonp)==Nothing)
	    	 then do mainWithArgs (onp,anbonp{numSess=(Just 1)}) Nothing True
		 else do mainWithArgs (onp,anbonp) Nothing False

iterativeFP (onp,anbonp)  =
 	    do str <- readFile (filename onp)
	       writeFile ((fromJust (anboutput anbonp))++(show (iterateFP anbonp)))
       	       		 (newanbmain str anbonp)
       	       iterativeFP (onp,anbonp{iterateFP=((iterateFP anbonp)+1)})


mainWithArgs (onp,anbonp) (brothers::Maybe ((MVar Result,MVar Result))) iterative =
   do file <- if isAnB onp then 
              	 if (outt anbonp)==Internal then
		    do str <- readFile (filename onp)
		       return (newanbmain str (anbonp {outt=IF}))
		 else
		    do str <- readFile (filename onp)
		       verify <- return(newanbmain str anbonp)
		       (if isSafe verify
		        then let result = verified ((authlevel anbonp)==Weak) (filename onp)
			     in if isJust brothers then
			     	do putMVar (fst (fromJust brothers)) dummyresult
			     	   putMVar (snd (fromJust brothers)) result
				   x <- newEmptyMVar
				   takeMVar x
				   return ""
				else do putStr (showresult result  (outt anbonp==AVANTSSAR))
				     	exitWith ExitSuccess
					return ""
		        else if (outt anbonp)==IF then do putStr verify
			     	      		       	  exitWith ExitSuccess
			     else if (outt anbonp)==Isa then error "??"
			     	  else error ("***"++verify++"***\n"))
               else
	         readFile (filename onp)
      t0 <- getCPUTime 
      tfile <-  case theofile onp of 
                   Nothing -> return ""
                   Just f  -> readFile f
      (algTheo,tab) 
           <- if tfile == "" then return ((fecStd,(decanaStd,cancellationStd)),Map.empty)
                 else return (theoparse tfile)
      (case file of
       'P':'r':'o':'t':'o':'c':'o':'l':_ -> 
         error "Appears to be AnB file, please use filename with extension .AnB\n"
       _ -> return ())
      (if ((outt anbonp)==FP) || ((outt anbonp)==FPI) || ((outt anbonp)==Isa) 
       then let verify = ( (hornFP [] True anbonp 
       	    	           (aslan2horn file))) 
	        result = verified ((authlevel anbonp)==Weak) (filename onp)
	    in 
            if isSafe verify
	     then
	       if isJust brothers
	        then do putMVar (fst (fromJust brothers)) dummyresult
			putMVar (snd (fromJust brothers)) result
			x <- newEmptyMVar
			takeMVar x
	        else do putStr (showresult result  (outt anbonp==AVANTSSAR)) 
		     	exitWith ExitSuccess
             else
	      if isJust brothers then
	       do putMVar (fst (fromJust brothers)) dummyresult
		  putMVar (snd (fromJust brothers)) dummyresult
		  x <- newEmptyMVar
		  takeMVar x
              else do putStr  verify
	      	      exitWith ExitSuccess
       else return ())
      trans_sys <- (return . (ifparser (algTheo,tab) (typing onp) (por onp) (normalize onp))) file
      _ <- case trans_sys of
           (_,rules,_,_,_,_) ->
            if (showrules onp) then 
             error ((show (length rules))++
                    (concatMap 
                     (\ (lhs,neg,cond,rhs,rtype) ->
                      ((show lhs)++"\n"++
                       (show neg)++"\n"++
                       (concatMap show_inequality cond)++"\n"++
                       (show rhs)++"\n--------\n")) (map (\ x -> x 17) rules)))
            else return ()
      t1 <- getCPUTime
      if exec onp then execore algTheo onp trans_sys True else return ()
      (str,stats) <- return ( (core algTheo onp trans_sys) True)
      a <- return (($!) (\x -> if 0<(length x) then x else "") str)
      t2 <- if a/="" then getCPUTime else error "lazy eval"
      if iterative && str==nothing_found 
       then let cns = fromJust (numSess anbonp) in
       	    do putStr ("Verified for "++(show cns)++" sessions\n")
	       mainWithArgs (onp,anbonp{numSess=Just (cns+1)}) brothers iterative 
	       exitWith ExitSuccess
       else do return ()
      (let result=
            (case (path onp) of
	     Just p -> dummyresult
	     	       { comments=str }
             Nothing ->   
	      (if str==nothing_found then
		   dummyresult
		   {decision=NO_ATTACK_FOUND,
		    details="BOUNDED_NUMBER_OF_SESSIONS",
		    protocol=filename onp,
		    goal="as specified",
--		    statistics="parseTime: "++(showtime t0 t1)++"\n  searchTime: "++(showtime t1 t2)++"\n"++(show_stats stats)}
		    statistics="TIME "++(showtime t1 t2)++"\n  parseTime "++(showtime t0 t1)++"\n"++(show_stats stats)}
       	       else
	           dummyresult
		   {decision=ATTACK_FOUND,
		    protocol=filename onp,
		    goal=(takeWhile ((/=) '*') str),
--		    statistics="parseTime: "++(showtime t0 t1)++"\n  searchTime: "++(showtime t1 t2)++"\n"++(show_stats stats),
		    statistics="TIME "++(showtime t1 t2)++"\n  parseTime "++(showtime t0 t1)++"\n"++(show_stats stats),

		    attack=(tail . (dropWhile ((/=) '*'))) str}))
       in case output onp of
	  Nothing ->  if isJust brothers 
	   	       then do putMVar (fst (fromJust brothers)) result
			       putMVar (snd (fromJust brothers)) dummyresult
			       return ()
	  	      else do 	putStr (showresult result  (outt anbonp==AVANTSSAR))
				(if (attacktrace onp) then showattack result else return ())
          Just outfile -> writeFile 
				(outfile++"/"++(reverse (takeWhile ((/=) '/') 
						    (reverse (filename onp))))++".of")
                                (showresult result  (outt anbonp==AVANTSSAR)))    



--showtime t1 t2 
-- = let cents = (div (t2-t1) (10^10)) --(100))
--   in (show (div (t2-t1) (10^12)))++"."
--      ++(if cents<10 then "0" else "")++(show cents)++"s"

showtime t1 t2
  = let mils = (div (t2 - t1) (10^9))
    in (show mils)++" ms"


execore algTheo onp 
          (init,rules,secr,goals,Just execG,hcs) isNewIF
 = let fname = filename onp
       sfb   = sesrep onp
       pth   = path onp
       depthb = depth onp
       cd    = por onp
       must  = must_step onp
       (i,bool) = getmaxstep rules [] False 
       newstate= init_init algTheo init 
   in 
   if must then error "MUST currently not supported" else
     let check n = (wrids2 depthbound (general_attack_check algTheo cd [(\i->execG n)]) (treeconstruct hcs algTheo must cd sfb (depthbound+n) (newstate, rules))) 
---
         res n = let rstr = fst $ check n in
	         if rstr == nothing_found then False else
                 if rstr== nothing_found_bound || rstr==reached_balance then error $ "Executability check exceeded depth restriction for rule "++(show n)++":\n"++(showrule (head (drop (n-1) rules)))++"\n" else True
         unexec = filter (not . res) [1..(length rules)]
         mona n = if n<=(length rules) then
	      	   do putStr (if res n then "Rule "++(show n)++" is OK.\n"
	      	      	      else "Rule "++(show n)++" can never be taken:\n"++
	      	      	           (showrule (head (drop (n-1) rules)))++"\n\n")
                      mona (n+1)
                  else return ()                 
                     
      in do mona 1
      	    error "\n"

core algTheo onp 
          (init,rules,secr,goals,execCR,horntheo) isNewIF
 = let fname = filename onp
       sfb   = sesrep onp
       pth   = path onp
       depthb = depth onp
       cd    = por onp
       must  = must_step onp
       (i,bool) = getmaxstep rules [] False 
       newstate=
 	     if sessco onp then
	       if horntheo/=[] then error "hcs not yet supported by sessco" else
	       let (bool,mfacts) = xexec_check algTheo cd rules i (varstart,init_init algTheo init) in 
	       if not bool then 
	          error ("Cannot see how the protocol can be executed.\nSee manual for more information.")
               else 
		let (mfacts',newfacts) = partition isMTerm (map uniquizef ( mfacts))
		    newmsg = map (\ (M _ _ _ _ m _) -> m) mfacts' 
                    uniquizing (Var i) = Var (-i) 
                    uniquizing m = m
                    uniquize = mapmsg uniquizing
                    uniquizef = mapfact uniquize 
                    (cs',sub',ik') 
                      = head (analz algTheo (cs init) (getallIK (ik init)) newmsg)
		    davars = map (\ i -> Var i) (concatMap msg_vars newmsg)
	            constraint0 = mkDFromState davars ik' 
                    cs'' = if davars==[] then cs' else ((fst cs')++[constraint0], snd cs') in
                (init{facts=(facts init)++newfacts,
		      ik=undiffIKstate ik', 
		      cs=cs''})
             else init_init algTheo init 
   in 
   if must then error "MUST currently not supported" else
   if isNewIF && bool && (sessco onp) then error "The protocol description has loops.\nPlease try without option --sessco\n"
   else
   (if isNewIF && bool then (\ (x,y) -> ("% ********************************************\n% Warning: The protocol description has loops.\n% ********************************************\n"++x,y))
    else (\ x -> x))
   (case (pth,depthb) of
      (Nothing,Nothing) -> 
	  let (str,stats) =
	         (neusuch algTheo must cd rules horntheo (general_attack_check algTheo cd goals) 
                  nodemax depthbound 
	          sfb ([(varstart,newstate)],[]) init_stats) in
          if (str==reached_balance) then  
	      let maxdepth = if isJust depthb then fromJust depthb else depthbound
	          (a,b) = core algTheo (onp {depth=Just maxdepth}) (init,rules,secr,goals,execCR,horntheo) isNewIF in
                (a,b)
          else (str,stats)
      (Just list,Nothing) 
          -> (shn2 (general_attack_check algTheo cd goals)
		   (\ depth -> treeconstruct horntheo algTheo must cd sfb depth (newstate,rules)) list
              ,init_stats)
      (Just [], Just ply) ->
         (sprintTree (treeconstruct horntheo algTheo must cd sfb ply (newstate,rules)),init_stats)
      (_,Just ply) -> let (c,n)=(wrids2 ply (general_attack_check algTheo cd goals) 
		  	      (treeconstruct horntheo algTheo must cd sfb ply (newstate, rules)))
                      in case c of
	                  '*':c' -> (c',(n,ply) )
                          _      -> (nothing_found,(n,ply)))


showrule r=
 let (lhs,neg,cond,rhs,rtype) = r 0  in
                      ((show lhs)++"\n"++
                       (show neg)++"\n"++
                       (concatMap show_inequality cond)++"\n"++
                       (show rhs)++"\n--------\n")
	         

-------------------------
--- The standard algebraic theory. Note that defining it here 
--- underlines the independence of all algos from this example theory.

algStd = (fecStd,(decanaStd,cancellationStd))

ttXOR::TopdecTheo
ttXOR op 
 | op == opXor =
  [((opXor,[0,1]),
   [Unconditional [[Var 0,Var 1],
	 	   [Var 1,Var 0]],
    Conditional (0,(opXor,[2,3]))
                [Unconditional [[Var 2,BinOp opXor (Var 3) (Var 1)],
                                [BinOp opXor (Var 2) (Var 1),Var 3]],
                 Conditional (1,(opXor,[4,5]))
                             [Unconditional [[BinOp opXor (Var 2) (Var 4), BinOp opXor (Var 3) (Var 5)]]]],
    Conditional (1,(opXor,[2,3]))
                [Unconditional [[BinOp opXor (Var 0) (Var 2),Var 3],
                                [Var 2,BinOp opXor (Var 0) (Var 3)]]]])]
 | otherwise = []

ttEXP::TopdecTheo
ttEXP op 
 | op == opExp =
   [((opExp,[0,1]),
     [Unconditional [[Var 0,Var 1]],
      Conditional (0,(opExp,[2,3]))
                  [Unconditional [[BinOp opExp (Var 2) (Var 1),Var 3]]]])]
 | otherwise = []

fecStd :: FECTheo
fecStd = (topdecSubtheory,subtheory)
  where topdecSubtheory op
          | op == opExp = ttEXP
          | op == opXor = ttXOR
          | otherwise   = error ("No theory for "++(show op))
        subtheory op
          | op == opExp = [opExp]
          | op == opXor = [opXor]
          | otherwise   = []

x1 = -1001
x2 = -1002

decanaStd :: DecanaTheo
decanaStd = 
 [ ---Extend  
   (BinOp opCrypt (UnOp opInv (Var x1)) (Var x2), [Tauto],
    (Var x1), (Var x2)),
   ---Extend  
   (BinOp opCrypt (Var x1) (Var x2), [Negsub [(-1)] [(Var x1,UnOp opInv (Var (-1)))]],
    UnOp opInv (Var x1), (Var x2)),
   --- Replace 
   (BinOp opScrypt (Var x1) (Var x2),[Tauto],(Var x1),(Var x2)),
   --- Replace 
   (BinOp opExp (Var x1) (Var x2),[Tauto],(Var x2),(Var x1)),
   --- Replace 
   (BinOp opXor (Var x1) (Var x2),[Tauto],(Var x1),(Var x2)) ]

cancellationStd :: NormalizationRules
cancellationStd = 
  (concatMap ((\ (Just x) -> x) . f) [opInv,opCrypt,opScrypt,opExp,opXor],f)
 where
   f x |  x==opInv = 
            Just [(UnOp opInv (UnOp opInv (Var x1)),(Var x1))]
       |  x==opCrypt = 
            Just [(BinOp opCrypt (UnOp opInv (Var x1)) (BinOp opCrypt (Var x1) (Var x2)),(Var x2)),
                  (BinOp opCrypt (Var x1) (BinOp opCrypt (UnOp opInv (Var x1)) (Var x2)),(Var x2))]
       |  x==opScrypt = 
            Just [(BinOp opScrypt (Var x1) (BinOp opScrypt (Var x1) (Var x2)),(Var x2))]
       |  x==opExp =
            Just [(BinOp opExp (BinOp opExp (Var x1) (Var x2)) (UnOp opInv (Var x2)), (Var x1))]
       |  x==opXor = 
            Just [(BinOp opXor (Var x1) (Var x1), Atom 0 "e"),
                  (BinOp opXor (Var x1) (Atom 0 "e"), Var x1),
                  (BinOp opXor (BinOp opXor (Var x1) (Var x2)) (Var x2), (Var x1))]
       | otherwise = Nothing


theoryOf :: BinOp -- or UnOp
         -> Maybe Equations
theoryOf = snd cancellationStd

irreduc op t = 
 case theoryOf op of
 Just theo -> 
  map (\ (lhs,_) -> 
         let lhs'=rename (-30) lhs in 
         Negsub (msg_vars lhs') [(t, lhs')]) theo
 Nothing -> []

isSafe str =
  let skipcomment = (drop 1) . 
	            (dropWhile ((/=) '\n')) in
  if "(*" `isPrefixOf` str then isSafe (skipcomment str)
  else "SAFE" `isPrefixOf` str 


para = 10
meter = 10
ik0 = [UnOp 0 (Atom i "ha") | i<-[1..para]]
mitestconstraint = mkStdFromState [UnOp 0 (Var i) | i<-[1..meter]] $ mkinitialIKstate ik0
gentest = gencheck fecStd ([ mitestconstraint],[]) Map.empty
eagerly = null gentest

gentest2 = gencheck0 fecStd [] mitestconstraint ([],[]) Map.empty
