# lab2/Makefile

## Add your own test cases to this list
TEST = gcd notInitialised array pascal binary storeTest nestedSubscript checkBounds constantIndex lastIndex

all: ppc

ppc: keiko.cmo lexer.cmo dict.cmo tree.cmo parser.cmo check.cmo \
		peepopt.cmo kgen.cmo main.cmo
	ocamlc ../lib/common.cma $^ -o $@

parser.mli parser.ml: parser.mly
	ocamlyacc parser.mly

lexer.ml: lexer.mll
	ocamllex lexer.mll

KEIKO = ../keiko

test: force
	$(MAKE) $(TEST:%=test-%)

test-%: force
	@echo "*** Test $*.p"
	./ppc $*.p >a.k
	$(KEIKO)/pplink -nostdlib $(KEIKO)/lib.k a.k -o a.x >/dev/null
	-$(KEIKO)/ppx ./a.x >a.test 2>&1
	sed -n -e '1,/^(\*<</d' -e '/^>>\*)/q' -e p $*.p | diff - a.test
	@echo "*** Passed"; echo

realclean: clean

clean: force
	rm -f ppc ppx ppxj *.cma *.cmo *.cmi *.o
	rm -f parser.mli parser.ml lexer.ml 
	rm -f a.k a.out a.x a.test

ML = check.ml check.mli dict.ml dict.mli keiko.ml keiko.mli kgen.ml \
	kgen.mli lexer.ml lexer.mli main.ml parser.ml \
	parser.mli tree.ml tree.mli peepopt.mli peepopt.ml

depend : $(ML) force
	(sed '/^###/q' Makefile; echo; ocamldep $(ML)) >new
	mv new Makefile

%.cmi : %.mli
	ocamlc $(MLFLAGS) -c $<

%.cmo : %.ml
	ocamlc $(MLFLAGS) -c $<

force:

MLFLAGS = -I ../lib

###

check.cmo : tree.cmi keiko.cmi dict.cmi check.cmi
check.cmx : tree.cmx keiko.cmx dict.cmx check.cmi
check.cmi : tree.cmi
dict.cmo : dict.cmi
dict.cmx : dict.cmi
dict.cmi :
keiko.cmo : tree.cmi keiko.cmi
keiko.cmx : tree.cmx keiko.cmi
keiko.cmi :
kgen.cmo : tree.cmi peepopt.cmi keiko.cmi dict.cmi kgen.cmi
kgen.cmx : tree.cmx peepopt.cmx keiko.cmx dict.cmx kgen.cmi
kgen.cmi : tree.cmi
lexer.cmo : tree.cmi parser.cmi keiko.cmi lexer.cmi
lexer.cmx : tree.cmx parser.cmx keiko.cmx lexer.cmi
lexer.cmi : parser.cmi
main.cmo : tree.cmi parser.cmi lexer.cmi kgen.cmi dict.cmi check.cmi
main.cmx : tree.cmx parser.cmx lexer.cmx kgen.cmx dict.cmx check.cmx
parser.cmo : tree.cmi lexer.cmi keiko.cmi dict.cmi parser.cmi
parser.cmx : tree.cmx lexer.cmx keiko.cmx dict.cmx parser.cmi
parser.cmi : tree.cmi keiko.cmi dict.cmi
peepopt.cmo : keiko.cmi peepopt.cmi
peepopt.cmx : keiko.cmx peepopt.cmi
peepopt.cmi : keiko.cmi
tree.cmo : keiko.cmi dict.cmi tree.cmi
tree.cmx : keiko.cmx dict.cmx tree.cmi
tree.cmi : keiko.cmi dict.cmi
