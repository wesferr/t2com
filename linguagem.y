%{
      #include <stdio.h>
      #include <stdlib.h>
      #include "node.h"
      #include "y.tab.h"

      extern int yylex();
      extern int yyerror();
%}

%union {
  struct _node* token;
  struct _node* node;
}

%left SUM
%left SUBTRACT

%token<node> PRINT IF ELSE ELIF WHILE FOR END TINT TREAL SEMICOLON
OPARENTHESIS CPARENTHESIS OBRACKET CBRACKET COLON NEGATION ATRIBUITION SUM
SUBTRACT MULTIPLY DIVIDE POW MODULUS CPRODUCT SPRODUCT TMATRIX IMATRIX EQ NE
GT GE LT LE INCREMENT DECREMENT NONE NLINE ID INTEGER REAL ERROR
OCBRACKET CCBRACKET TRUE FALSE AND OR

%type<node> code declaracao dimension literal
literal_list vector_literal nlines escalar vetorial matrix_literal
matricial type lit_none operacao stmts stmt declaracao_escalar
declaracao_vetorial declaracao_matricial teste conta booleano matematica exprecao

%start code

%%

// ESTRUTURAS DE CONTROLE

code: stmts NLINE
        {
          $$ = create_node(literals_node, NULL, $1, $2, NULL);
          syntax_tree = $$;
        };

stmts:stmt
        { $$ = create_node(literals_node, NULL, $1, NULL); }
     |stmts stmt
        { $$ = create_node(literals_node, NULL, $1, $2, NULL); }
     |stmts nlines stmt
        { $$ = create_node(literals_node, NULL, $1, $2, $3, NULL); };

stmt: declaracao
        { $$ = create_node(literals_node, NULL, $1, NULL); }
    | operacao
        { $$ = create_node(literals_node, NULL, $1, NULL); };

nlines: NLINE
          { $$ = $1; }
      | nlines NLINE
          { $$ = create_node(literals_node, NULL, $1, $2, NULL); };

// ESTRUTURAS DECLARACAO

declaracao: declaracao_escalar
              { $$ = create_node(literals_node, NULL, $1, NULL); }
          | declaracao_vetorial
              { $$ = create_node(literals_node, NULL, $1, NULL); }
          | declaracao_matricial
              { $$ = create_node(literals_node, NULL, $1, NULL); };

declaracao_escalar: escalar
                      { $$ = create_node(literals_node, NULL, $1, NULL); };

declaracao_vetorial:vetorial
                      { $$ = create_node(literals_node, NULL, $1, NULL); };

declaracao_matricial: matricial
                        { $$ = create_node(literals_node, NULL, $1, NULL); };

// ESTRUTURA DAS OPERACOES

operacao: declaracao_escalar ATRIBUITION literal
            { $$ = create_node(escalar_node, NULL, $1, $2, $3, NULL); }
        | declaracao_vetorial ATRIBUITION vector_literal
            { $$ = create_node(escalar_node, NULL, $1, $2, $3, NULL); }
        | declaracao_matricial ATRIBUITION matrix_literal
            { $$ = create_node(escalar_node, NULL, $1, $2, $3, NULL); };
        | teste
            { $$ = create_node(literals_node, NULL, $1, NULL); };
        | conta
            { $$ = create_node(literals_node, NULL, $1, NULL); };

exprecao: literal
            { $$ = create_node(literals_node, NULL, $1, NULL); }
        | operacao
            { $$ = create_node(literals_node, NULL, $1, NULL); }
        | ID
            { $$ = $1; };

teste:exprecao booleano exprecao
        { $$ = create_node(escalar_node, NULL, $1, $2, $3, NULL); };
     | OPARENTHESIS exprecao booleano exprecao CPARENTHESIS
        { $$ = create_node(escalar_node, NULL, $1, $2, $3, $4, $5, NULL); };

conta:exprecao matematica exprecao
        { $$ = create_node(escalar_node, NULL, $1, $2, $3, NULL); };
     | OPARENTHESIS exprecao matematica exprecao CPARENTHESIS
        { $$ = create_node(escalar_node, NULL, $1, $2, $3, $4, $5, NULL); };

booleano: EQ { $$ = $1; }
        | NE { $$ = $1; }
        | GT { $$ = $1; }
        | GE { $$ = $1; }
        | LT { $$ = $1; }
        | LE { $$ = $1; }

matematica: SUM { $$ = $1; }
          | SUBTRACT { $$ = $1; }
          | MULTIPLY { $$ = $1; }
          | DIVIDE { $$ = $1; }
          | POW { $$ = $1; }
          | MODULUS { $$ = $1; };

//ESTRUTURA DOS LITERAIS E TIPOS

dimension:  OBRACKET INTEGER CBRACKET
              { $$ = create_node(dimension_node, NULL, $1, $2, $3, NULL); };

escalar:  type ID
            { $$ = create_node(escalar_node, NULL, $1, $2, NULL); };

vetorial: type ID dimension
            { $$ = create_node(vetorial_node, NULL, $1, $2, $3, NULL); };

matricial:  type ID dimension dimension
              { $$ = create_node(vetorial_node, NULL, $1, $2, $3, $4, NULL); };


literal_list: literal
                { $$ = create_node(literals_node, NULL, $1, NULL); }
            | literal_list COLON literal
                { $$ = create_node(literals_node, NULL, $1, $2, $3, NULL); };


vector_literal: OCBRACKET literal_list CCBRACKET
                  { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); }
              | lit_none
                  { $$ = create_node(vect_literal_node, NULL, $1, NULL); };

matrix_literal: vector_literal
                  { $$ = create_node(vect_literal_node, NULL, $1, NULL); }
              | OCBRACKET matrix_literal CCBRACKET
                  { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); }
              | matrix_literal COLON vector_literal
                  { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); };

lit_none: NONE { $$ = $1; };

literal: INTEGER { $$ = $1; }
       | REAL { $$ = $1; };

type: TINT { $$ = $1; }
    | TREAL { $$ = $1; };

%%
