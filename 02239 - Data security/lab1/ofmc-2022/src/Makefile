DIRS = cj/6.1-Sym-Key-no-TTP cj/6.2-Auth-CCF cj/6.3-Sym-Key-TTp cj/6.6-Pub-Key-no-TTP cj/6.7-6.9-Pub-Key-TTP classic/

SRCFILES = AnBmain.hs FPTranslator.hs AnBOnP.hs Msg.hs LMsg.hs MsgPat.hs AnBParser.y Lexer.x Ast.hs NewIfLexer.x TheoLexer.x TheoParser.y Constants.hs IntsOnly.hs Decomposition.hs MsgTree.hs Remola.hs Symbolic.hs NewIfParser.y Search.hs TheoLoad.hs PrettyUgly.hs Main.hs Translator.hs StateMonad.hs StateMonad.hs If2Horn.hs

GENERATED = NewIfLexer.hs NewIfParser.hs TheoLexer.hs TheoParser.hs Lexer.hs AnBParser.hs

########################

all:	
	make ofmc

########################

ofmc:	$(SRCFILES) $(GENERATED)
	ghc -XNoMonomorphismRestriction -XScopedTypeVariables -fspec-constr-count=5 -static -package base -threaded -rtsopts -with-rtsopts=-N --make -O2 -Wno-tabs Main.hs -o ofmc

########################

NewIfLexer.hs:	NewIfLexer.x
	alex NewIfLexer.x

########################

NewIfParser.hs:	NewIfParser.y
	happy -ioutput  NewIfParser.y

########################

TheoLexer.hs:	TheoLexer.x
	alex TheoLexer.x

########################

TheoParser.hs:	TheoParser.y
	happy -ioutput  TheoParser.y

########################

Lexer.hs:	Lexer.x
	alex Lexer.x

########################

AnBParser.hs:	AnBParser.y
	happy -ioutput  AnBParser.y

########################

install:
	cp ofmc release/bin.`uname`/

########################

test:	
	pushd ../examples ; time ./runall ; popd

#########################

clean: 
	rm -f *\.hi *\.o ofmc 
	rm $(GENERATED)

release:	$(SRCFILES)
	mkdir release
	mkdir release/src
	cp $(SRCFILES)	release/src
	cp Makefile release/src
	cp "BSD License.txt" release/src
	cp "BSD License.txt" release
	mkdir release/AnB-tutorial
	cp ../AnB-tutorial/anb-tutorial.pdf release/AnB-tutorial
	cp ../AnB-tutorial/KeyEx*AnB	release/AnB-tutorial
	cp ../manual.pdf release
#cp ../README.txt release
	cp -r ../examples release
	cd release
	find . -name ".svn" -exec echo {} \; #rm -rf {} \;
