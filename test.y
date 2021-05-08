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
    sprintf(input+i, "%s ", $1);
    i = strlen(input);
    $$ = $1;
    printf("%s\n", input);
    printf("\t\t reduce IDENTIFIER -> primary_expression\n", $1);
    }
| CONSTANT {
    sprintf(input+i, "%s ", $1);
    i = strlen(input);
    $$ = $1;
    printf("%s\n", input);
    printf("\t\t reduce CONSTANT -> primary_expression\n", $1);
    }
;

declaration:
 INT{
     sprintf(input+i, "int");
     i += 3;
     printf("int\t\t shift INT\n");
     printf("%s", input);
     printf("\t\t reduce INT -> INT);");} 
 init_declarator{
     printf("\t\t reduce init_declator -> declaration");} 
 ';'{
     sprintf(input+i, ";");
     i += 1;
     printf("%s", input);
     printf("\t\t shift ;\n");
     printf("%s", input);
     printf("\t\t reduce declaration_specifiers init_declation_list ; -> declartion");
     $$=$1+$2+$3;}
;

init_declarator:
 primary_expression{
     printf("%s", input);
     printf("\t\t reduce blah blah");} 
 '='{sprintf(input+i, "=");
     i++;
     printf("%s", input);
     printf("\t\t shift =\n");}
 CONSTANT{
     printf("%s", input);
     printf("\t\t reduce primary_expression = CONSTANT -> init_declartion");
     $$=$1+$2+$3;}
;

translation_unit:
 translation_unit {
     printf("\n=== start ===\n");}
 declaration 
 '\n' {printf("\n end of parsing : %s \n\n\n", input);
       $$=$1+$2+$3;}
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
