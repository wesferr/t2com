all: compiler clear
	./compiler teste.m

saida: compiler clear
	./compiler teste.m teste.out

debug: compiler clear
	gdb ./compiler

compiler: main.c linguagem.tab.o lex.yy.o node.o lista.o symbol_table.o
	gcc -g -Wall -o compiler main.c linguagem.tab.o lex.yy.o node.o lista.o symbol_table.o

lex.yy.o: linguagem.l
	flex linguagem.l
	gcc -c lex.yy.c -lfl

linguagem.tab.o: linguagem.y
	bison -v -d linguagem.y
	gcc -c linguagem.tab.c -lfl

node.o: node.c
	gcc -c node.c

lista.o: lista.c
	gcc -c lista.c

symbol_table.o: symbol_table.c
	gcc -c symbol_table.c

clear:
	rm linguagem.tab.? lex.yy.? node.o linguagem.output lista.o symbol_table.o
