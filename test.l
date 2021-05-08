

%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include <string.h>

void count(void);
void yyerror(char *);
%}

%%
"int" { return INT; }
[a-z]+ {yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+ {yylval.str = strdup(yytext); return CONSTANT; }
[\n]   {return ('\n');}
[;]    {return (';');}
[=]    {return ('=');}

[ \t] ; /* skip whitespace */
. yyerror("invalid character");

%%
int yywrap(void)
{
return 1;
}
//end of file
