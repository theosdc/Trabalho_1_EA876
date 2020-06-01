

all: lex.yy.c y.tab.c
	gcc -omain lex.yy.c y.tab.c -ll

lex.yy.c:calc.l y.tab.c
	flex calc.l

y.tab.c:calc.y
	bison -dy calc.y

clean:
	rm y.tab.c lex.yy.c y.tab.h main
