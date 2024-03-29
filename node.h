/** @file node.h
 *  @version 1.2
 */

#ifndef _NODE_H_
#define _NODE_H_

#ifdef __GNUC__
    /* If using gcc, warn about missing sentinel NULLs */
    #define NULL_TERMINATED __attribute__((sentinel))
#else
    #define NULL_TERMINATED
#endif

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>


#define code_node 100
#define declaracao_node 101
#define type_node 102
#define dimension_node 103
#define vector_literal_node 104
#define matrix_literal_node 105
#define nlines_node 106
#define literal_list_node 107
#define vetorial_node 108
#define matricial_node 109
#define escalar_node 110
#define stmt_node 111
#define stmts_node 112
#define declaracao_escalar_node 113
#define declaracao_vetorial_node 114
#define declaracao_matricial_node 115
#define operacao_node 116
#define exprecao_node 117
#define conta_node 118
#define teste_node 119
#define estrutura_node 120
#define structureif_node 121
#define structurefor_node 122
#define structureelse_node 123
#define structureelif_node 124
#define structurewhile_node 125
#define block_node 126


typedef int Node_type;


/** Estrutura de dados parcial para o no da arvore. */
typedef struct _node {
   int line_num;   /**< numero de linha. */
   char* lexeme;   /**< o lexema retornado pelo analizador lexical. */
   Node_type type; /**< Um dos valores definidos*/
   struct node_tac * code;

   struct _node** children;
   unsigned int n_child;

} Node;

extern Node* syntax_tree;


/**
 *  * Node constructor.
 *
 * @param nl: line number where this token was found in the source code.
 * @param t: node type (one of the values #define'd above). Must abort
 *             the program if the type is not correct.
 * @param lexeme: whatever string you want associated to this node.
 * @param attr: a semantical attribute.
 * @param children: NULL-terminated list of pointers to children Node*'s.
 *     See the extra file 'exemplo_func_var_arg.c' for an example.
 *     Callers are expected to pass *only Node pointers* as arguments.
 *     To create a leaf, use just NULL.
 * @return a pointer to a new Node.
 */
NULL_TERMINATED
Node* create_node(Node_type t,
        char* lexeme,  /* Node* children */ ...);

/** Accessor to the number of children of a Node.
 *  Must abort the program if 'n' is NULL.
 */
int nb_of_children(Node* n);

/** Tests if a Node is a leaf.
 *  Must abort the program if 'n' is NULL.
 *  @return 1 if n is a leaf, 0 else.
 */
int is_leaf(Node* n);

/** accessor to the i'th child of a Node.
 * @param n : the node to be consulted. Must abort the program if 'n' is NULL.
 * @param i : the number of the child that one wants. Given a node degree d,
 *       valid values for i are: 0 <= i < d.
 *       Must abort the program if i is not correct.
 * @return a pointer to a Node.
 */
Node* child(Node* n, int i) ;

/** Destructor of a Node. Deallocates
 * (recursively) all of the tree rooted at 'n'.
 */
int deep_free_node(Node* n) ;

/** returns the height of the tree rooted by 'n'.
 *  The height of a leaf is 1.
 */
int height(Node *n) ;

/** Prints into a file the lexemes contained in the node rooted by 'n'.
 *  Lexemes must be printed in a depth-first order.
 *  @param outfile : the file to which the lexemes are printed.
 *  @param n : the root node of the tree. Must abort the program if 'n' is NULL.
 *
 */
void uncompile(FILE* outfile, Node *n) ;


#endif
