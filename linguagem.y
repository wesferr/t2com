%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <assert.h>
    #include "node.h"
    #include "lista.h"
    #include "symbol_table.h"
    #include "linguagem.tab.h"

    #define INTEGER_SIZE  16
    #define REAL_SIZE     32

    extern int yylex();
    extern int yyerror();

    extern symbol_t symbol_table;

    char* gera_temp(int type) {
        int size = 32;
        char *ret = malloc(sizeof(char)*8);
        sprintf(ret, "%03d(Rx)", temps_size);
        temps_size += size;
        return ret;
    }

    void table_insert(Node* node){

        int tipo_idf, x, y, size;
        char* lexeme;

        if(node->type == escalar_node){
            tipo_idf = node->children[0]->type;
            lexeme = node->children[1]->lexeme;
            size = tipo_idf == TINT ? INTEGER_SIZE : REAL_SIZE;
        }

        if(node->type == vetorial_node){
            tipo_idf = node->children[0]->type;
            lexeme = node->children[1]->lexeme;
            x = atoi(node->children[2]->children[1]->lexeme);
            size = tipo_idf == TINT ? INTEGER_SIZE*x : REAL_SIZE*x;
        }

        if(node->type == matricial_node){
            tipo_idf = node->children[0]->type;
            lexeme = node->children[1]->lexeme;
            x = atoi(node->children[2]->children[1]->lexeme);
            y = atoi(node->children[3]->children[1]->lexeme);
            size = tipo_idf == TINT ? INTEGER_SIZE*x*y : REAL_SIZE*x*y;
        }

        entry_t* existente = lookup(symbol_table, lexeme);
        if(existente == NULL){

            entry_t* new_entry=(entry_t *) malloc(sizeof(entry_t));
            assert(new_entry != NULL);

            new_entry->name = lexeme;
            new_entry->type = tipo_idf;
            new_entry->desloc = vars_size;
            new_entry->size = size;
            vars_size += size;

            assert(!insert(&symbol_table, new_entry)!=0);

        }

    }

%}

%union {
  struct _node* token;
  struct _node* node;
}

%left SUM SUBTRACT MULTIPLY DIVIDE
%right POW

%token<node> PRINT IF ELSE ELIF WHILE FOR END TINT TREAL SEMICOLON
OPARENTHESIS CPARENTHESIS OBRACKET CBRACKET COLON NEGATION ATRIBUITION SUM
SUBTRACT MULTIPLY DIVIDE POW MODULUS CPRODUCT SPRODUCT TMATRIX IMATRIX EQ NE
GT GE LT LE INCREMENT DECREMENT NONE NLINE ID INTEGER REAL ERROR
OCBRACKET CCBRACKET TRUE FALSE AND OR

%type<node> code declaracao dimension literal literal_list vector_literal stmt
nlines escalar vetorial matrix_literal matricial type lit_none operacao stmts
declaracao_escalar declaracao_vetorial declaracao_matricial teste conta booleano
matematica exprecao estrutura lit_logical structureif structureelif structureelse
structurefor block structurewhile

%start code

%%

// ESTRUTURAS DE CONTROLE

code: stmts NLINE
        {
          $$ = create_node(code_node, NULL, $1, $2, NULL);
          syntax_tree = $$;
        };

stmts:stmt
        {
            $$ = $1;
        }
     |stmts stmt
        {
            $$ = create_node(stmts_node, NULL, $1, $2, NULL);
        }

     |stmts nlines stmt
        {
            $$ = create_node(stmts_node, NULL, $1, $2, $3, NULL);
        };

stmt: declaracao { $$ = $1; }
    | estrutura { $$ = $1; }
    | operacao { $$ = $1; }
    | PRINT OPARENTHESIS exprecao CPARENTHESIS
        {
            $$ = create_node(stmt_node, NULL, $1, $2, $3, $4, NULL);
            struct tac* new_tac = create_inst_tac("",$3->lexeme,"PRINT","");
            append_inst_tac(&($$->code),new_tac);
        };

nlines: NLINE { $$ = $1; }
      | nlines NLINE
          { $$ = create_node(nlines_node, NULL, $1, $2, NULL); };

// ESTRUTURAS DECLARACAO

declaracao: declaracao_escalar { $$ = $1; }
          | declaracao_vetorial { $$ = $1; }
          | declaracao_matricial { $$ = $1; };

declaracao_escalar: escalar { $$ = $1; };

declaracao_vetorial: vetorial { $$ = $1; };

declaracao_matricial: matricial { $$ = $1; };

// ESTRUTURA DAS OPERACOES

operacao: declaracao_escalar ATRIBUITION literal
            { $$ = create_node(operacao_node, NULL, $1, $2, $3, NULL); }
        | declaracao_escalar ATRIBUITION exprecao
            { $$ = create_node(operacao_node, NULL, $1, $2, $3, NULL); }
        | declaracao_vetorial ATRIBUITION vector_literal
            { $$ = create_node(operacao_node, NULL, $1, $2, $3, NULL); }
        | declaracao_matricial ATRIBUITION matrix_literal
            { $$ = create_node(operacao_node, NULL, $1, $2, $3, NULL); };
        | ID INCREMENT
            {
                $$ = create_node(operacao_node, NULL, $1, $2, NULL);
            };
        | ID DECREMENT
            { $$ = create_node(operacao_node, NULL, $1, $2, NULL); };
        | ID IMATRIX
            { $$ = create_node(operacao_node, NULL, $1, $2, NULL); };
        | ID TMATRIX
            { $$ = create_node(operacao_node, NULL, $1, $2, NULL); };
        | teste
            { $$ = create_node(operacao_node, NULL, $1, NULL); };
        | conta
            { $$ = create_node(operacao_node, NULL, $1, NULL); };

exprecao: literal { $$ = $1; }
        | lit_logical { $$ = $1; }
        | operacao { $$ = $1; }
        | ID { $$ = $1; };

teste:exprecao booleano exprecao
        { $$ = create_node(teste_node, NULL, $1, $2, $3, NULL); };
     | OPARENTHESIS exprecao booleano exprecao CPARENTHESIS
        { $$ = create_node(teste_node, NULL, $1, $2, $3, $4, $5, NULL); };

conta:exprecao matematica exprecao
        { $$ = create_node(conta_node, NULL, $1, $2, $3, NULL); };
     | OPARENTHESIS exprecao matematica exprecao CPARENTHESIS
        { $$ = create_node(conta_node, NULL, $1, $2, $3, $4, $5, NULL); };

booleano: EQ { $$ = $1; }
        | NE { $$ = $1; }
        | GT { $$ = $1; }
        | GE { $$ = $1; }
        | LT { $$ = $1; }
        | LE { $$ = $1; }
        | AND { $$ = $1; }
        | OR { $$ = $1; }

matematica: SUM { $$ = $1; }
          | SUBTRACT { $$ = $1; }
          | MULTIPLY { $$ = $1; }
          | DIVIDE { $$ = $1; }
          | POW { $$ = $1; }
          | MODULUS { $$ = $1; }
          | CPRODUCT { $$ = $1; }
          | SPRODUCT{ $$ = $1; };


// ESTRUTURA DAS ESTRUTURAS(CONTROLE E REPETIÇÃO)

estrutura:structureif END
            { $$ = create_node(estrutura_node, NULL, $1, $2, NULL); }
         |structureif structureelif END
            { $$ = create_node(estrutura_node, NULL, $1, $2, $3, NULL); }
         |structureif structureelif structureelse END
            { $$ = create_node(estrutura_node, NULL, $1, $2, $3, $4, NULL); }
         |structurefor END
            { $$ = create_node(estrutura_node, NULL, $1, $2, NULL); }
         |structurewhile END
            { $$ = create_node(estrutura_node, NULL, $1, $2, NULL); }

structureif:IF OPARENTHESIS exprecao CPARENTHESIS block
              { $$ = create_node(structureif_node, NULL, $1, $2, $3, $4, $5, NULL); };

structureelif:ELIF OPARENTHESIS exprecao CPARENTHESIS block
                { $$ = create_node(structureelif_node, NULL, $1, $2, $3, $4, $5, NULL); };

structureelse: ELSE block
                { $$ = create_node(structureelse_node, NULL, $1, $2, NULL); };

structurefor: FOR OPARENTHESIS exprecao SEMICOLON exprecao SEMICOLON exprecao CPARENTHESIS block
                { $$ = create_node(structurefor_node, NULL, $1, $2, $3, $4, $5, $6, $7, $8, $9, NULL); };

structurewhile: WHILE OPARENTHESIS exprecao CPARENTHESIS block
                { $$ = create_node(structurewhile_node, NULL, $1, $2, $3, $4, $5, NULL); };

block:nlines stmts nlines
        { $$ = create_node(block_node, NULL, $1, $2, $3, NULL); };


//ESTRUTURA DOS LITERAIS E TIPOS

dimension:  OBRACKET INTEGER CBRACKET
              { $$ = create_node(dimension_node, NULL, $1, $2, $3, NULL); };

escalar:  type ID
            {
                $$ = create_node(escalar_node, NULL, $1, $2, NULL);
                table_insert($$);
             };

vetorial: type ID dimension
            {
                $$ = create_node(vetorial_node, NULL, $1, $2, $3, NULL);
                table_insert($$);
            };

matricial:  type ID dimension dimension
              {
                  $$ = create_node(matricial_node, NULL, $1, $2, $3, $4, NULL);
                  table_insert($$);
              };


literal_list: literal { $$ = $1; }
            | literal_list COLON literal
                { $$ = create_node(literal_list_node, NULL, $1, $2, $3, NULL); };


vector_literal: OCBRACKET literal_list CCBRACKET
                  { $$ = create_node(vector_literal_node, NULL, $1, $2, $3, NULL); }
              | lit_none
                  { $$ = create_node(vector_literal_node, NULL, $1, NULL); };

matrix_literal: vector_literal
                  { $$ = $1; }
              | OCBRACKET matrix_literal CCBRACKET
                  { $$ = create_node(matrix_literal_node, NULL, $1, $2, $3, NULL); }
              | matrix_literal COLON vector_literal
                  { $$ = create_node(matrix_literal_node, NULL, $1, $2, $3, NULL); };

lit_none: NONE { $$ = $1; };

lit_logical: TRUE { $$ = $1; }
           | FALSE { $$ = $1; }

literal: INTEGER { $$ = $1; }
       | REAL { $$ = $1; };

type: TINT { $$ = $1; }
    | TREAL { $$ = $1; };

%%
