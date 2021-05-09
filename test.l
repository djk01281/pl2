
%{
    //only excepts test file example
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include <string.h>

void yyerror(char *);
%}

%%
"int" { return INT; }
"float" {   return FLOAT; }
"void" {   return VOID; }
"return" {return RETURN;}
[A-Za-z][A-Za-z0-9]* {yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+ {yylval.num = atoi(yytext); return CONSTANT; }
\"([^\\\"]|\\.)*\" {yylval.str = strdup(yytext); return STRING_LITERAL; }
"\n"   {return *yytext;}
";"    {return *yytext;}
"="    {return *yytext;}
"*" {return *yytext;}
"(" {return *yytext;}
")" {return *yytext;}
"<" {return *yytext;}
">" {return *yytext;}
"+=" {return ADD_ASSIGN; }
"++" {return INC_OP; }
"{" {return *yytext;}
"}" {return *yytext;}
"[" {return *yytext;}
"]" {return *yytext;}
[\t\v\n\f] ; /* skip whitespace */
. yyerror("invalid character");

%%
int yywrap(void)
{
return 1;
}

//end of file
