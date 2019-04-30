all: compiler clear
	./compiler teste.m

debug: compiler clean
	gdb ./compiler

compiler: main.c linguagem.tab.o lex.yy.o node.o
	gcc -g -Wall -o compiler main.c linguagem.tab.o lex.yy.o node.o

lex.yy.o: linguagem.l
	flex linguagem.l
	gcc -c lex.yy.c -lfl

linguagem.tab.o: linguagem.y
	bison -v -d linguagem.y
	gcc -c linguagem.tab.c -lfl

node.o: node.c
	gcc -c node.c

clear:
	rm linguagem.tab.? lex.yy.? node.o linguagem.output
