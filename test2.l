

%{

#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include <string.h>

void yyerror(char *);
%}
%%

"auto" {   return(AUTO); }
"break" {   return(BREAK); }
"case" {   return(CASE); }
"char" {   return(CHAR); }
"const" {   return(CONST); }
"continue" {   return(CONTINUE); }
"default" {   return(DEFAULT); }
"do" {   return(DO); }
"double" {   return(DOUBLE); }
"else" {   return(ELSE); }
"enum" {   return(ENUM); }
"extern" {   return(EXTERN); }
"float" {   return(FLOAT); }
"for" {   return(FOR); }
"goto" {   return(GOTO); }
"if" {   return(IF); }
"int" {   return(INT); }
"long" {   return(LONG); }
"register" {   return(REGISTER); }"return" {   return(RETURN); }
"short" {   return(SHORT); }
"signed" {   return(SIGNED); }
"sizeof" {   return(SIZEOF); }
"static" {   return(STATIC); }
"struct" {   return(STRUCT); }
"switch" {   return(SWITCH); }
"typedef" {   return(TYPEDEF); }
"union" {   return(UNION); }
"unsigned" {   return(UNSIGNED); }
"void" {   return(VOID); }
"volatile" {   return(VOLATILE); }
"while" {   return(WHILE); }
[a-z]+ {yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+ {yylval.num = atoi(yytext); return CONSTANT; }
"..." {   return(ELLIPSIS); }
">>=" {   return(RIGHT_ASSIGN); }
"<<=" {   return(LEFT_ASSIGN); }
"+=" {   return(ADD_ASSIGN); }
"-=" {   return(SUB_ASSIGN); }
"*=" {   return(MUL_ASSIGN); }
"/=" {   return(DIV_ASSIGN); }
"%=" {   return(MOD_ASSIGN); }
"&=" {   return(AND_ASSIGN); }
"^=" {   return(XOR_ASSIGN); }
"|=" {   return(OR_ASSIGN); }
">>" {   return(RIGHT_OP); }
"<<" {   return(LEFT_OP); }
"++" {   return(INC_OP); }
"--" {   return(DEC_OP); }
"->" {   return(PTR_OP); }
"&&" {   return(AND_OP); }
"||" {   return(OR_OP); }
"<=" {   return(LE_OP); }
">=" {   return(GE_OP); }
"==" {   return(EQ_OP); }
"!=" {   return(NE_OP); }
";" {   return(';'); }
("{"|"<%") {   return('{'); }
("}"|"%>") {   return('}'); }
"," {   return(','); }
":" {   return(':'); }
"=" {   return('='); }
"(" {   return('('); }
")" {   return(')'); }
("["|"<:") {   return('['); }
("]"|":>") {   return(']'); }
"." {   return('.'); }
"&" {   return('&'); }
"!" {   return('!'); }
"~" {   return('~'); }
"-" {   return('-'); }
"+" {   return('+'); }
"*" {   return('*'); }
"/" {   return('/'); }
"%" {   return('%'); }
"<" {   return('<'); }
">" {   return('>'); }
"^" {   return('^'); }
"|" {   return('|'); }
"?" {   return('?'); }


[ \t] ; /* skip whitespace */
. yyerror("invalid character");

%%
int yywrap(void)
{
return 1;
}
//end of file