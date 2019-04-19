all: compiler clean
	./compiler teste.m

debug: compiler clean
	gdb ./compiler

compiler: main.c y.tab.o lex.yy.o node.o
	gcc -g -Wall -o compiler main.c y.tab.o lex.yy.o node.o

lex.yy.o: linguagem.l
	lex linguagem.l
	gcc -c lex.yy.c -lfl

y.tab.o: linguagem.y
	yacc -v -d linguagem.y
	gcc -c y.tab.c -lfl

node.o: node.c
	gcc -c node.c

clean:
	rm y.tab.? lex.yy.? node.o
