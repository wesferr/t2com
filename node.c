#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "node.h"

int max(int x,int y) {
	if(x>y)
		return x;
	else
		return y;
}

Node* syntax_tree;
int root_height;

Node* create_node(Node_type t, char* lexeme,  /* Node* children */ ...){

	int n_children = 0, a = 0, k = 0;
	va_list ap;

	Node* new_node = (Node *)malloc(sizeof(Node));
	assert(new_node != NULL);

	// new_node->line_num = nl;
	new_node->type = t;

	if(lexeme != NULL){
		while(lexeme[a] != '\0') a++;
		new_node->lexeme = (char*) malloc( (a+1) * sizeof(char) );
		assert(new_node->lexeme != NULL);
		memcpy(new_node->lexeme, lexeme, a);
	}


	va_start(ap, lexeme);
	Node* arg = va_arg(ap, Node*);
	while (arg != NULL) {
			n_children ++;
			arg = va_arg(ap, Node*);
	};
	va_end(ap);

	new_node->n_child = n_children;

	new_node->children = (Node**)malloc(n_children*sizeof(Node*));
	assert(new_node->children != NULL);


	va_start(ap, lexeme);
	arg = va_arg(ap, Node*);
	while (arg != NULL) {
			new_node->children[k] = arg;
			arg = va_arg(ap, Node*);
			k++;
	};
	va_end(ap);

	return new_node;
}


int nb_of_children(Node* n) {

	assert(n != NULL);
	return n->n_child;

}


int is_leaf(Node* n) {

	assert(n != NULL);
	return n->n_child == 0;

}


Node* child(Node* n, int i){

	assert(n != NULL);
	assert((0 <= i) && ((unsigned int)i < n->n_child));
	return n->children[i];

}


int deep_free_node(Node* n){
	if(n != NULL) {

		int m = n->n_child;
		if( m != 0 )
			for(int i = 0; i < m; i++) deep_free_node(n->children[i]);
		free(n->children);
		free(n);

	}
	return 0;
}


int height(Node* n){
	int maior = 0;

	if(n->n_child != 0)
		for(int i = 0; i < n->n_child; i++)
			maior = max(maior, height(n->children[i]));

	return maior + 1;
}

void uncompile(FILE* outfile, Node *n){

	if( n!=NULL ) {
		if(n->n_child>0) {
			for( int i=0; i < n->n_child; i++ ){
				if(n->children[i]->n_child == 0)
					fprintf(outfile, "%s\n", n->children[i]->lexeme);
				uncompile(outfile,n->children[i]);
			}
		}
	}

}
