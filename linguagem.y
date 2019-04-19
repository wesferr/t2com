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

%token<token> PRINT IF ELSE ELIF WHILE FOR END TINT TREAL SEMICOLON
OPARENTHESIS CPARENTHESIS OBRACKET CBRACKET COLON NEGATION ATRIBUITION SUM
SUBTRACT MULTIPLY DIVIDE POW MODULUS CPRODUCT SPRODUCT TMATRIX IMATRIX EQ NE
GT GE LT LE INCREMENT DECREMENT NONE SPACE NLINE ID INTEGER REAL ERROR
OCBRACKET CCBRACKET TRUE FALSE AND OR

%type<node> code declaracao declaracoes dimension literal atribuition
literals vector_literal nlines escalar vetorial matrix_literal expr
matricial type

%start code

%%

code: declaracoes NLINE
      {
        $$ = create_node(code_node, NULL, $1, $2, NULL);
        syntax_tree = $$;
      };

nlines: NLINE { $$ = create_node(NLINE, NULL, $1, NULL); }
      | nlines NLINE { $$ = create_node(nlines_node, NULL, $1, $2, NULL); };

// ESTRUTURA DAS DECLARAÇÕES

declaracoes : declaracao
                { $$ = create_node(declaracoes_node, NULL, $1, NULL); }
            | declaracoes nlines declaracao
                { $$ = create_node(declaracoes_node, NULL, $1, $2, $3, NULL); }
            ;

declaracao: escalar
              {$$ = create_node(declaracao_node, NULL, $1, NULL);}
          | vetorial
              {$$ = create_node(declaracao_node, NULL, $1, NULL);}
          | matricial
              {$$ = create_node(declaracao_node, NULL, $1, NULL);}
          | escalar atribuition literal
              {$$ = create_node(declaracao_node, NULL, $1, $2, $3, NULL);}
          | vetorial atribuition vector_literal
              {$$ = create_node(declaracao_node, NULL, $1, $2, $3, NULL);}
          | matricial atribuition matrix_literal
              {$$ = create_node(declaracao_node, NULL, $1, $2, $3, NULL);};

dimension:  OBRACKET INTEGER CBRACKET
              { $$ = create_node(dimension_node, NULL, $1, $2, $3, NULL); };

// ESTRUTURA DAS ACOES

atribuition:  SPACE ATRIBUITION SPACE
                { $$ = create_node(atribuition_node, NULL, $1,$2, $3, NULL); };

expr: expr SUM expr {$$ = create_node(expr_node, NULL, $1, $2, $3, NULL);}
    | expr SUBTRACT  expr {$$ = create_node(sexpr_node, NULL, $1, $2, $3, NULL);}
    | expr MULTIPLY expr {$$ = create_node(expr_node, NULL, $1, $2, $3, NULL);}
    | expr DIVIDE expr {$$ = create_node(expr_node, NULL, $1, $2, $3, NULL);}
    | expr POW expr {$$ = create_node(expr_node, NULL, $1, $2, $3, NULL);}
    | expr MODULUS expr {$$ = create_node(expr_node, NULL, $1, $2, $3, NULL);}
    | OPARENTHESIS expr CPARENTHESIS { $$ = create_node(expr_node, NULL, $1, NULL); }
    | literal {$$ = create_node(expr_node, NULL, $1, NULL);}
    ;

//ESTRUTURA DOS LITERAIS E TIPOS

escalar:type SPACE ID atribuition literal
          { $$ = create_node(escalar_node, NULL, $1, $2, $3, $4, $5, NULL); }
       |type SPACE ID
          { $$ = create_node(escalar_node, NULL, $1, $2, $3, NULL); };

vetorial: type SPACE ID dimension
            { $$ = create_node(vetorial_node, NULL, $1, $2, $3, $4, NULL); };

matricial: type SPACE ID dimension dimension
            { $$ = create_node(vetorial_node, NULL, $1, $2, $3, $4, NULL); };

vector_literal: OCBRACKET literals CCBRACKET
              { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); }
            | literal
              { $$ = create_node(vect_literal_node, NULL, $1, NULL); };

matrix_literal: OCBRACKET matrix_literal CCBRACKET
              { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); }
            | matrix_literal COLON matrix_literal
              { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); };
            | vector_literal
              { $$ = create_node(vect_literal_node, NULL, $1, NULL); };


literals: literal
          { $$ = create_node(literals_node, NULL, $1, NULL); }
        | literals COLON literal
          { $$ = create_node(literals_node, NULL, $1, $2, $3, NULL); };

literal: INTEGER  { $$ = $1; }
       | REAL     { $$ = $1; }
       | NONE     { $$ = $1; };

type: TINT  { $$ = $1; }
    | TREAL { $$ = $1; };

%%
