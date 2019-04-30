#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "node.h"

/* Programa principal. */
char* progname;
int lineno;

extern FILE* yyin;
extern int yyparse();
extern Node * syntax_tree;
extern int root_height;

int main(int argc, char* argv[])
{
	if (argc < 2) {
		printf("uso: %s <input_file>. Try again!\n", argv[0]);
		exit(-1);
	}
	yyin = fopen(argv[1], "r");
	if (!yyin) {
		printf("Uso: %s <input_file>. Could not find %s. Try again!\n", argv[0], argv[1]);
		exit(-1);
	}

	progname = argv[0];

	int result = yyparse();


	if(argc == 3) {

		FILE* output = fopen(argv[2], "w+");
		assert(output != NULL);
		if(!result){
			root_height = height(syntax_tree);
			uncompile(output, syntax_tree);
			fprintf(output,"OKAY.\n");
		}
		else
			fprintf(output, "ERROR.\n");
		fclose(output);

	}
	else
	{
		uncompile(stdout, syntax_tree);
		if(!result){
			root_height = height(syntax_tree);
			uncompile(stdout, syntax_tree);
			printf("OKAY.\n");
		}
		else
			printf("ERROR.\n");

	}

	return 0;
}

int yywrap () { return 1; };
int yyerror(char* s) { return 2; }
