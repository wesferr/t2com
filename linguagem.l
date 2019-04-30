	/** DEFINITION sec*/


%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "linguagem.tab.h"
	#include "node.h"

%}


letter 				[a-zA-Z]
digit 				[0-9]
space 				[ \t]
nline 				[\n]

pownotation		({digit}+(E|e){digit})+
fraction			("."{digit}+)|("."{pownotation})
real 					{integer}{fraction}
id 						({letter}|\_)({letter}|{digit}|\_)*
integer 			{digit}+


%%
	/** RULES sec (mand.) */

"print"				{
								yylval.token = create_node(PRINT, yytext, NULL);
								return PRINT;
							}
"if"					{
								yylval.token = create_node(IF, yytext, NULL);
								return IF;
							}
"else"				{
								yylval.token = create_node(ELSE, yytext, NULL);
								return ELSE;
							}
"elif"				{
								yylval.token = create_node(ELIF, yytext, NULL);
								return ELIF;
							}
"while"				{
								yylval.token = create_node(WHILE, yytext, NULL);
								return WHILE;
							}
"for"					{
								yylval.token = create_node(FOR, yytext, NULL);
								return FOR;
							}
"end"					{
								yylval.token = create_node(END, yytext, NULL);
								return END;
							}
"int"					{
								yylval.token = create_node(TINT, yytext, NULL);
								return TINT;
							}
"real"				{
								yylval.token = create_node(TREAL, yytext, NULL);
								return TREAL;
							}
";"						{
								yylval.token = create_node(SEMICOLON, yytext, NULL);
								return SEMICOLON;
							}
"("						{
								yylval.token = create_node(OPARENTHESIS, yytext, NULL);
								return OPARENTHESIS;
							}
")"						{
								yylval.token = create_node(CPARENTHESIS, yytext, NULL);
								return CPARENTHESIS;
							}
"["						{
								yylval.token = create_node(OBRACKET, yytext, NULL);
								return OBRACKET;
							}
"]"						{
								yylval.token = create_node(CBRACKET, yytext, NULL);
								return CBRACKET;
							}
"{"						{
								yylval.token = create_node(OCBRACKET, yytext, NULL);
								return OCBRACKET;
							}
"}"						{
								yylval.token = create_node(CCBRACKET, yytext, NULL);
								return CCBRACKET;
							}
","						{
								yylval.token = create_node(COLON, yytext, NULL);
								return COLON;
							}
"!"						{
								yylval.token = create_node(NEGATION, yytext, NULL);
								return NEGATION;
							}
"="						{
								yylval.token = create_node(ATRIBUITION, yytext, NULL);
								return ATRIBUITION;
							}
"+"						{
								yylval.token = create_node(SUM, yytext, NULL);
								return SUM;
							}
"-"						{
								yylval.token = create_node(SUBTRACT, yytext, NULL);
								return SUBTRACT;
							}
"*"						{
								yylval.token = create_node(MULTIPLY, yytext, NULL);
								return MULTIPLY;
							}
"/"						{
								yylval.token = create_node(DIVIDE, yytext, NULL);
								return DIVIDE;
							}
"^"						{
								yylval.token = create_node(POW, yytext, NULL);
								return POW;
							}
"%"						{
								yylval.token = create_node(MODULUS, yytext, NULL);
								return MODULUS;
							}
"**"					{
								yylval.token = create_node(CPRODUCT, yytext, NULL);
								return	CPRODUCT;
							}
"*."					{
								yylval.token = create_node(SPRODUCT, yytext, NULL);
								return SPRODUCT;
							}
"^T"					{
								yylval.token = create_node(TMATRIX, yytext, NULL);
								return TMATRIX;
							}
"^I"					{
								yylval.token = create_node(IMATRIX, yytext, NULL);
								return IMATRIX;
							}
"=="					{
								yylval.token = create_node(EQ, yytext, NULL);
								return EQ;
							}
"!="					{
								yylval.token = create_node(NE, yytext, NULL);
								return NE;
							}
">"						{
								yylval.token = create_node(GT, yytext, NULL);
								return GT;
							}
">="					{
								yylval.token = create_node(GE, yytext, NULL);
								return GE;
							}
"<"						{
								yylval.token = create_node(LT, yytext, NULL);
								return LT;
							}
"<="					{
								yylval.token = create_node(LE, yytext, NULL);
								return LE;
							}
"++"					{
								yylval.token = create_node(INCREMENT, yytext, NULL);
								return INCREMENT;
							}
"--"					{
								yylval.token = create_node(DECREMENT, yytext, NULL);
								return DECREMENT;
							}
"none"				{
								yylval.token = create_node(NONE, yytext, NULL);
								return NONE;
							}
"true"				{
								yylval.token = create_node(TRUE, yytext, NULL);
								return TRUE;
							}
"false"				{
								yylval.token = create_node(FALSE, yytext, NULL);
								return FALSE;
							}
{space}				{}
{nline}				{
								yylval.token = create_node(NLINE, yytext, NULL);
								return NLINE;}
{id}					{
								yylval.token = create_node(ID, yytext, NULL);
								return ID;
							}
{real}				{
								yylval.token = create_node(REAL, yytext, NULL);
								return REAL;
							}
{integer}  		{
								yylval.token = create_node(INTEGER, yytext, NULL);
								return INTEGER;
							}
.      				{return ERROR;}
