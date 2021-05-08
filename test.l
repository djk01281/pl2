

%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
void count(void);
%}

%%
"int" { count(); return INT; }

[a-z]+ { count(); yylval = yytext; return IDENTIFIER; }
[0-9]+ { count(); yylval = atoi(yytext); return CONSTANT; }

[ \t] ; /* skip whitespace */
. yyerror("invalid character");

%%
int yywrap(void)
{
return 1;
}

int column = 0;
void count(void)
{
    int i;
    for (i = 0; yytext[i] != '\0'; i++){
        if (yytext[i] == '\n'){
            column = 0;
        }
        else if (yytext[i] == '\t'){
            column += 8 - (column % 8);
        }
        else{
            column++;
        }
    }
    ECHO;
}
//end of file
