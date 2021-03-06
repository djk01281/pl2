%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 extern FILE *yyin;
typedef char* string;

int yylex(void);
void yyerror(char *);
static int depth = 1;
static char input[1024];
static int i = 0;
%}
%union{
    char* str;
    int num;
}
%token IDENTIFIER 
%token CONSTANT STIRNG_LITERAL
%token INT FLOAT VOID CHAR
%token RETURN
%token IF FOR WHILE
%token ADD_ASSIGN INC_OP
%start translation_unit

%%
primary_expression:
 IDENTIFIER {
    i += sprintf(input+i, "%s ", $<str>1);
    printf("%s", input);
    printf("\t\t shift %s\n", $<str>1);
    printf("%s", input);
    printf("\t\t reduce IDENTIFIER -> primary_expression\n");
    }
| CONSTANT {
    i += sprintf(input+i, "%d ", $<num>1);
    printf("%s", input);
    printf("\t\t shift %d\n", $<num>1);
    printf("%s", input);
    printf("\t\t reduce CONSTANT -> primary_expression\n");
    }
 | STIRNG_LITERAL{

 }
;

declaration:
 INT{
     i += sprintf(input+i, "int ");
     printf("int\t\t shift INT\n");
     printf("%s", input);
     printf("\t\t reduce INT -> INT\n");} 
 init_declarator{
     printf("%s", input);
     printf("\t\t reduce init_declator -> declaration\n");} 
 ';'{
     i += sprintf(input+i, " ; ");
     printf("%s", input);
     printf("\t\t shift ;\n");
     printf("%s", input);
     printf("\t\t reduce declaration_specifiers init_declation_list ; -> declartion\n");}
;

init_declarator:
 primary_expression{
     printf("%s", input);
     printf("\t\t reduce blah blah\n");} 
 '=' {
     i += sprintf(input+i, " = ");
     printf("%s", input);
     printf("\t\t shift =\n");}
 primary_expression{
     printf("%s", input);
     printf("\t\t reduce primary_expression = primary_expression -> init_declartion\n");}
;

translation_unit:
 declaration{
     printf("%s", input);
     printf("\t\t reduce declaration -> translation_unit\n");}
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

int main(int argc, char* *argv){
FILE *fp; int i;
   fp=fopen("sample.txt","r");
   yyin=fp;
yyparse();
return 0;
}
