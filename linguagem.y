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
matricial type acoes acao mate_expr lit_none matematical

%start code

%%

code: declaracoes nlines acoes nlines
        {
          $$ = create_node(code_node, NULL, $1, $2, $3, NULL);
          syntax_tree = $$;
        }
    | declaracoes nlines
        {
         $$ = create_node(code_node, NULL, $1, $2, NULL);
         syntax_tree = $$;
        } ;

nlines: NLINE { $$ = create_node(NLINE, NULL, $1, NULL); }
      | nlines NLINE { $$ = create_node(nlines_node, NULL, $1, $2, NULL); };

// ESTRUTURA DAS DECLARAÇÕES

declaracoes : declaracao
                { $$ = create_node(declaracoes_node, NULL, $1, NULL); }
            | declaracoes nlines declaracao
                { $$ = create_node(declaracoes_node, NULL, $1, $2, $3, NULL); }

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

// ESTRUTURA DAS ACOES

atribuition:  SPACE ATRIBUITION SPACE
                { $$ = create_node(atribuition_node, NULL, $1,$2, $3, NULL); };

acoes:  acao
          {$$ = create_node(acoes_node, NULL, $1, NULL);}
     |  acoes nlines acao
          {$$ = create_node(acoes_node, NULL, $1, $2, $3, NULL);}

acao: ID atribuition expr
        {$$ = create_node(acao_node, NULL, $1, $2, $3, NULL);}
    | expr
        {$$ = create_node(acao_node, NULL, $1, NULL);}

expr: OPARENTHESIS SPACE expr SPACE CPARENTHESIS {$$ = create_node(expr_node, NULL, $1, $2, $3, $4, $5, NULL);}
    | mate_expr {$$ = create_node(expr_node, NULL, $1, NULL);}

mate_expr : literal SPACE matematical SPACE literal {$$ = create_node(mate_expr_node, NULL, $1, $2, $3, $4, $5, NULL);}
          | ID SPACE matematical SPACE ID {$$ = create_node(mate_expr_node, NULL, $1, $2, $3, $4, $5, NULL);}
          | literal SPACE matematical SPACE ID {$$ = create_node(mate_expr_node, NULL, $1, $2, $3, $4, $5, NULL);}
          | ID SPACE matematical SPACE literal {$$ = create_node(mate_expr_node, NULL, $1, $2, $3, $4, $5, NULL);}

//ESTRUTURA DOS LITERAIS E TIPOS

dimension:  OBRACKET INTEGER CBRACKET
              { $$ = create_node(dimension_node, NULL, $1, $2, $3, NULL); };

escalar: type SPACE ID
          { $$ = create_node(escalar_node, NULL, $1, $2, $3, NULL); };

vetorial: type SPACE ID dimension
            { $$ = create_node(vetorial_node, NULL, $1, $2, $3, $4, NULL); };

matricial: type SPACE ID dimension dimension
            { $$ = create_node(vetorial_node, NULL, $1, $2, $3, $4, NULL); };

vector_literal: OCBRACKET literals CCBRACKET
              { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); }
              | lit_none { $$ = create_node(vect_literal_node, NULL, $1, NULL); }

matrix_literal: OCBRACKET matrix_literal CCBRACKET
              { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); }
            | matrix_literal COLON vector_literal
              { $$ = create_node(vect_literal_node, NULL, $1, $2, $3, NULL); };
            | vector_literal
              { $$ = create_node(vect_literal_node, NULL, $1, NULL); };

literals: literal
          { $$ = create_node(literals_node, NULL, $1, NULL); }
        | literals COLON literal
          { $$ = create_node(literals_node, NULL, $1, $2, $3, NULL); };

matematical: SUM { $$ = $1; }
           | SUBTRACT { $$ = $1; }
           | MULTIPLY { $$ = $1; }
           | DIVIDE { $$ = $1; }
           | POW { $$ = $1; }
           | MODULUS { $$ = $1; };

literal: INTEGER  { $$ = $1; }
       | REAL     { $$ = $1; };

lit_none: NONE    { $$ = $1; };

type: TINT  { $$ = $1; }
    | TREAL { $$ = $1; };

%%
