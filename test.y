%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
typedef char* string;

int yylex(void);
void yyerror(char *);
static int depth = 1;
static char input[1024];
static int i = 0;
%}
%union{
    char* str;
}
%token IDENTIFIER 
%token CONSTANT 
%token INT  
%start translation_unit
%%
primary_expression:
 IDENTIFIER {
    sprintf(input+i, "%s ", $<str>1);
    i = strlen(input);
    printf("%s\n", input);
    printf("\t\t reduce IDENTIFIER -> primary_expression\n");
    }
| CONSTANT {
    sprintf(input+i, "%s ", $<str>1);
    i = strlen(input);
    printf("%s\n", input);
    printf("\t\t reduce CONSTANT -> primary_expression\n");
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
     printf("\t\t reduce declaration_specifiers init_declation_list ; -> declartion");}
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
     printf("\t\t reduce primary_expression = CONSTANT -> init_declartion");}
;

translation_unit:
 declaration 
 |
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
