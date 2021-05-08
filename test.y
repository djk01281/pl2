%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
typedef char* string;
#define YYSTYPE string

int yylex(void);
void yyerror(char *);
static int depth = 1;
static char input[1024];
static int i = 0;
%}

%token IDENTIFIER 
%token CONSTANT 
%token INT  
%start translation_unit
%%
primary_expression:
 IDENTIFIER {
    printf("%s \t\t shift %s", $1, $1);
    sprintf(input+i, "%s ", $1);
    i = strlen(input);
    $$ = $1;
    printf("\t\t %s\n", input);
    printf("%s \t\t reduce IDENTIFIER -> primary_expression", $1);
    printf("\t\t %s\n", input);
    }
| CONSTANT {
    printf("%s \t\t shift %s", $1, $1);
    sprintf(input+i, "%s ", $1);
    i = strlen(input);
    $$ = $1;
    printf("\t\t %s\n", input);
    printf("%s \t\t reduce CONSTANT -> primary_expression", $1);
    printf("\t\t %s\n", input);
    }
;

expression:
 primary_expression{
    printf("%s \t\t reduce assignment_expression -> expression \t\t %s \n", $1, input);
    $$ = $1;
}
;

declaration:
 INT{
     printf(" \t\t reduce declaration_specifiers init_declation_list ; -> declartion");
 } 
 init_declarator{
     printf(" \t\t reduce init_declator -> init_declaration_list");
 } 
 ';'{
     printf(" \t\t shift ;");
     printf(" \t\t reduce declaration_specifiers init_declation_list ; -> declartion");
     
 }
;

init_declarator:
 expression
| expression '=' CONSTANT
;

translation_unit:
 declaration {
    printf("\n=== start ===\n");
    $$ = $1;
 }
;

%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}
void initializeInputBuffer(){
    for(int i = 0; i < sizeof(input); i++) input[i] = 0;
    i = 0;
}
int main(int argc, char *argv){

    initializeInputBuffer();
    yyparse();
    return 0;
}
