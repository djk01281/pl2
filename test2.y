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
    int num;
}

%token IDENTIFIER CONSTANT SIZEOF
%token PTR_OP INC_OP DEC_OP 
%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME
%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token ELLIPSIS
%start translation_unit
%%
primary_expression
: IDENTIFIER{
    i += sprintf(input+i, "%s ", $<str>1);
    printf("%s", input);
    printf("\t\t shift %s\n", $<str>1);
    printf("%s", input);
    printf("\t\t reduce IDENTIFIER -> primary_expression\n");
    }
| CONSTANT{
    i += sprintf(input+i, "%d ", $<num>1);
    printf("%s", input);
    printf("\t\t shift %d\n", $<num>1);
    printf("%s", input);
    printf("\t\t reduce CONSTANT -> primary_expression\n");
    }
| '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 expression{
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce (expression) -> primary_expression\n");}

;
postfix_expression
: primary_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
| postfix_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
 '[' {
     i += sprintf(input+i, " [ ");
     printf("%s", input);
     printf("\t\t shift [\n");}
  expression {
     printf("%s", input);
     printf("\t\t shift [%s\n", input);}
 
 ']'{
     i += sprintf(input+i, " ] ");
     printf("%s", input);
     printf("\t\t shift ]\n");
     printf("%s", input);
     printf("\t\t reduce postfix_expression [expression] -> postfix_expression\n");}
| postfix_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
 '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce postfix_expression () -> postfix_expression\n");}
| postfix_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
 '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
      argument_expression_list {
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce (expression) -> primary_expression\n");}
| postfix_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
 '.'{
     i += sprintf(input+i, " . ");
     printf("%s", input);
     printf("\t\t shift .\n");}
 IDENTIFIER{
     printf("%s", input);
     printf("\t\t reduce postfix_expression.IDENTIFIER -> postfix_expression\n");}
| postfix_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
 PTR_OP{
     i += sprintf(input+i, " -> ");
     printf("%s", input);
     printf("\t\t shift ->\n");}
 IDENTIFIER{
     printf("%s", input);
     printf("\t\t reduce postfix_expression PTR_OP IDENTIFIER -> postfix_expression\n");}
| postfix_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
 INC_OP{
     i += sprintf(input+i, " ++ ");
     printf("%s", input);
     printf("\t\t shift ++\n");
     printf("%s", input);
     printf("\t\t reduce postfix_expression INC_OP -> postfix_expression\n");}
| postfix_expression{
    printf("%s", input);
    printf("\t\t reduce primary_expression -> postfix_expression\n");}
 DEC_OP{
     i += sprintf(input+i, " -- ");
     printf("%s", input);
     printf("\t\t shift --\n");
     printf("%s", input);
     printf("\t\t reduce postfix_expression DEC_OP -> postfix_expression\n");}
;
argument_expression_list
: assignment_expression{
     printf("%s", input);
     printf("\t\t reduce assignment_expression -> argument_expression_list\n");}
| argument_expression_list{
    printf("%s", input);
    printf("\t\t reduce assignment_expression -> argument_expression_list\n");}
 ','{
     i += sprintf(input+i, " . ");
     printf("%s", input);
     printf("\t\t shift .\n");}
 assignment_expression{
     printf("%s", input);
     printf("\t\t reduce argument_expression_list . assignment_expression -> argument_expression_list\n");}
;
unary_expression
: postfix_expression{
    printf("%s", input);
    printf("\t\t reduce postfix_expression -> unary_expression\n");}
| INC_OP{
     i += sprintf(input+i, " ++ ");
     printf("%s", input);
     printf("\t\t shift ++\n");}
 unary_expression{
    printf("%s", input);
    printf("\t\t reduce INC_OP unary_expression-> unary_expression\n");}
| DEC_OP{
     i += sprintf(input+i, " -- ");
     printf("%s", input);
     printf("\t\t shift --\n");} 
 unary_expression{
    printf("%s", input);
    printf("\t\t reduce DEC_OP unary_expression-> unary_expression\n");}
| unary_operator{
    printf("%s", input);
    printf("\t\t reduce postfix_expression -> unary_expression\n");}
 cast_expression{
    printf("%s", input);
    printf("\t\t reduce unary_operator cast_expression-> unary_expression\n");}
| SIZEOF{
     i += sprintf(input+i, " sizeof ");
     printf("%s", input);
     printf("\t\t shift sizeof\n");} 
 unary_expression{
    printf("%s", input);
    printf("\t\t reduce SIZEOF unary_expression-> unary_expression\n");}
| SIZEOF{
     i += sprintf(input+i, " sizeof ");
     printf("%s", input);
     printf("\t\t shift sizeof\n");} 
 '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 type_name{
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce SIZEOF(type_name) -> unary_expression\n");}
;
unary_operator
: '&'{
     i += sprintf(input+i, " & ");
     printf("%s", input);
     printf("\t\t shift &\n");
     printf("%s", input);
     printf("\t\t reduce & -> unary_operator\n");}
| '*'{
     i += sprintf(input+i, " * ");
     printf("%s", input);
     printf("\t\t shift *\n");
     printf("%s", input);
     printf("\t\t reduce * -> unary_operator\n");}
| '+'{
     i += sprintf(input+i, " + ");
     printf("%s", input);
     printf("\t\t shift +\n");
     printf("%s", input);
     printf("\t\t reduce + -> unary_operator\n");}
| '-'{
     i += sprintf(input+i, " - ");
     printf("%s", input);
     printf("\t\t shift -\n");
     printf("%s", input);
     printf("\t\t reduce - -> unary_operator\n");}
| '~'{
     i += sprintf(input+i, " ~ ");
     printf("%s", input);
     printf("\t\t shift ~\n");
     printf("%s", input);
     printf("\t\t reduce ~ -> unary_operator\n");}
| '!'{
     i += sprintf(input+i, " ! ");
     printf("%s", input);
     printf("\t\t shift !\n");
     printf("%s", input);
     printf("\t\t reduce ! -> unary_operator\n");}
;
cast_expression
: unary_expression{
    printf("%s", input);
    printf("\t\t reduce unary_expression -> cast_expression\n");}
| '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 type_name{
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");}
 cast_expression{
    printf("%s", input);
    printf("\t\t reduce unary_expression (type_name) cast_expression-> cast_expression\n");}
;
multiplicative_expression
: cast_expression{
    printf("%s", input);
    printf("\t\t reduce cast_expression -> multiplicative_expression\n");}
| multiplicative_expression{
    printf("%s", input);
    printf("\t\t reduce cast_expression -> multiplicative_expression\n");}
 '*'{
     i += sprintf(input+i, " * ");
     printf("%s", input);
     printf("\t\t shift *\n");}
 cast_expression{
    printf("%s", input);
    printf("\t\t reduce multiplicative_expression '*' cast_expression-> multiplicative_expression\n");}
| multiplicative_expression{
    printf("%s", input);
    printf("\t\t reduce cast_expression -> multiplicative_expression\n");}
 '/'{
     i += sprintf(input+i, " / ");
     printf("%s", input);
     printf("\t\t shift /\n");}
 cast_expression{
    printf("%s", input);
    printf("\t\t reduce multiplicative_expression '/' cast_expression-> multiplicative_expression\n");}
| multiplicative_expression{
    printf("%s", input);
    printf("\t\t reduce cast_expression -> multiplicative_expression\n");}
 '%'{
     i += sprintf(input+i, " % ");
     printf("%s", input);
     printf("\t\t shift %\n");}
 cast_expression{
    printf("%s", input);
    printf("\t\t reduce multiplicative_expression '%' cast_expression-> multiplicative_expression\n");}
;
additive_expression
: multiplicative_expression{
    printf("%s", input);
    printf("\t\t reduce multiplicative_expression -> additive_expression\n");}
| additive_expression{
    printf("%s", input);
    printf("\t\t reduce multiplicative_expression -> additive_expression\n");}
 '+'{
     i += sprintf(input+i, " + ");
     printf("%s", input);
     printf("\t\t shift +\n");}
 multiplicative_expression{
    printf("%s", input);
    printf("\t\t reduce additive_expression '+' multiplicative_expression-> additive_expression\n");}
| additive_expression{
    printf("%s", input);
    printf("\t\t reduce multiplicative_expression -> additive_expression\n");}
 '-'{
     i += sprintf(input+i, " - ");
     printf("%s", input);
     printf("\t\t shift -\n");}
 multiplicative_expression{
    printf("%s", input);
    printf("\t\t reduce additive_expression '-' multiplicative_expression-> additive_expression\n");}
;

assignment_expression
: additive_expression{
    printf("%s", input);
    printf("\t\t reduce additive_expression -> assignment_expression\n");}
| unary_expression{
    printf("%s", input);
    printf("\t\t reduce unary_expression -> assignment_expression\n");}
 assignment_operator{
    printf("%s", input);
    printf("\t\t reduce assignment_operator -> assignment_expression\n");}
  assignment_expression{
    printf("%s", input);
    printf("\t\t reduce unary_expression assignment_operator assignment_expression -> assignment_expression\n");}
;
assignment_operator
: '='
| MUL_ASSIGN{
     i += sprintf(input+i, " *= ");
     printf("%s", input);
     printf("\t\t shift *=\n");
     printf("%s", input);
     printf("\t\t reduce *= -> unary_operator\n");}
| DIV_ASSIGN{
     i += sprintf(input+i, " /= ");
     printf("%s", input);
     printf("\t\t shift /=\n");
     printf("%s", input);
     printf("\t\t reduce /= -> unary_operator\n");}
| MOD_ASSIGN{
     i += sprintf(input+i, " %= ");
     printf("%s", input);
     printf("\t\t shift %=\n");
     printf("%s", input);
     printf("\t\t reduce %= -> unary_operator\n");}
| ADD_ASSIGN{
     i += sprintf(input+i, " += ");
     printf("%s", input);
     printf("\t\t shift +=\n");
     printf("%s", input);
     printf("\t\t reduce += -> unary_operator\n");}
| SUB_ASSIGN{
     i += sprintf(input+i, " -= ");
     printf("%s", input);
     printf("\t\t shift -=\n");
     printf("%s", input);
     printf("\t\t reduce -= -> unary_operator\n");}
| LEFT_ASSIGN{
     i += sprintf(input+i, " <<= ");
     printf("%s", input);
     printf("\t\t shift <<=\n");
     printf("%s", input);
     printf("\t\t reduce <<= -> unary_operator\n");}
| RIGHT_ASSIGN{
     i += sprintf(input+i, " >>= ");
     printf("%s", input);
     printf("\t\t shift >>=\n");
     printf("%s", input);
     printf("\t\t reduce >>= -> unary_operator\n");}
| AND_ASSIGN{
     i += sprintf(input+i, " &= ");
     printf("%s", input);
     printf("\t\t shift &=\n");
     printf("%s", input);
     printf("\t\t reduce &= -> unary_operator\n");}
| XOR_ASSIGN{
     i += sprintf(input+i, " ^= ");
     printf("%s", input);
     printf("\t\t shift ^=\n");
     printf("%s", input);
     printf("\t\t reduce ^= -> unary_operator\n");}
| OR_ASSIGN{
     i += sprintf(input+i, " |= ");
     printf("%s", input);
     printf("\t\t shift |=\n");
     printf("%s", input);
     printf("\t\t reduce |= -> unary_operator\n");}
;
expression
: assignment_expression{
    printf("%s", input);
    printf("\t\t reduce assignment_expression -> expression\n");}
| expression{
    printf("%s", input);
    printf("\t\t reduce assignment_expression -> expression\n");}
 ','{
     i += sprintf(input+i, " , ");
     printf("%s", input);
     printf("\t\t shift ,\n");}
 assignment_expression{
    printf("%s", input);
    printf("\t\t reduce expression ',' assignment_expression -> expression\n");}
;
constant_expression
: additive_expression{
    printf("%s", input);
    printf("\t\t reduce additive_expression -> constant_expression\n");}
;
declaration
: declaration_specifiers{
    printf("%s", input);
    printf("\t\t reduce declaration_specifiers -> declaration\n");}

 ';'{
     i += sprintf(input+i, " ; ");
     printf("%s", input);
     printf("\t\t shift ;\n");
     printf("%s", input);
     printf("\t\t reduce declaration_specifiers ; -> declartion\n");}
| declaration_specifiers{
    printf("%s", input);
    printf("\t\t reduce declaration_specifiers -> declaration\n");}
  init_declarator_list{
    printf("%s", input);
    printf("\t\t reduce init_declarator_list -> declaration_specifiers\n");}
  ';'{
     i += sprintf(input+i, " ; ");
     printf("%s", input);
     printf("\t\t shift ;\n");
     printf("%s", input);
     printf("\t\t reduce declaration_specifiers init_declarator_list ; -> declartion\n");}
;
declaration_specifiers
: storage_class_specifier{
     printf("%s", input);
     printf("\t\t reduce storage_class_specifier -> declaration_specifiers\n");} 
| storage_class_specifier{
     printf("%s", input);
     printf("\t\t reduce storage_class_specifier -> declaration_specifiers\n");} 
 declaration_specifiers{
     printf("%s", input);
     printf("\t\t reduce storage_class_specifier declaration_specifiers -> declaration_specifiers\n");} 
| type_specifier{
     printf("%s", input);
     printf("\t\t reduce type_specifier -> declaration_specifiers\n");} 
| type_specifier{
     printf("%s", input);
     printf("\t\t reduce type_specifier -> declaration_specifiers\n");}
 declaration_specifiers{
     printf("%s", input);
     printf("\t\t reduce type_specifier declaration_specifiers -> declaration_specifiers\n");} 
| type_qualifier{
     printf("%s", input);
     printf("\t\t reduce type_qualifier -> declaration_specifiers\n");} 
| type_qualifier{
     printf("%s", input);
     printf("\t\t reduce type_qualifier -> declaration_specifiers\n");} 
  declaration_specifiers{
     printf("%s", input);
     printf("\t\t reduce type_qualifier declaration_specifiers -> declaration_specifiers\n");} 
;
init_declarator_list
: init_declarator{
     printf("%s", input);
     printf("\t\t reduce init_declarator -> init_declarator_list\n");} 
| init_declarator_list{
     printf("%s", input);
     printf("\t\t reduce init_declarator_list -> init_declarator_list\n");} 
 ',' {
     i += sprintf(input+i, " , ");
     printf("%s", input);
     printf("\t\t shift ,\n");}
 init_declarator{
     printf("%s", input);
     printf("\t\t reduce init_declarator_list ',' init_declarator -> init_declarator_list\n");} 
;
init_declarator
: declarator{
     printf("%s", input);
     printf("\t\t reduce declarator -> init_declarator\n");} 
| declarator{
     printf("%s", input);
     printf("\t\t reduce declarator -> init_declarator\n");} 
 '='{
     i += sprintf(input+i, " = ");
     printf("%s", input);
     printf("\t\t shift =\n");}
 initializer{
     printf("%s", input);
     printf("\t\t reduce declarator '=' initializer -> init_declarator\n");} 
;
storage_class_specifier
: TYPEDEF{
     i += sprintf(input+i, " typedef ");
     printf("%s", input);
     printf("\t\t shift typedef \n");
     printf("%s", input);
     printf("\t\t reduce typedef -> storage_class_specifier\n");}
| EXTERN{
     i += sprintf(input+i, " extern ");
     printf("%s", input);
     printf("\t\t shift extern \n");
     printf("%s", input);
     printf("\t\t reduce extern -> storage_class_specifier\n");}
| STATIC{
     i += sprintf(input+i, " static ");
     printf("%s", input);
     printf("\t\t shift static \n");
     printf("%s", input);
     printf("\t\t reduce static -> storage_class_specifier\n");}
| AUTO{
     i += sprintf(input+i, " auto ");
     printf("%s", input);
     printf("\t\t shift auto \n");
     printf("%s", input);
     printf("\t\t reduce auto -> storage_class_specifier\n");}
| REGISTER{
     i += sprintf(input+i, " register ");
     printf("%s", input);
     printf("\t\t shift register \n");
     printf("%s", input);
     printf("\t\t reduce register -> storage_class_specifier\n");}
;
type_specifier
: VOID{
     i += sprintf(input+i, " void ");
     printf("%s", input);
     printf("\t\t shift void \n");
     printf("%s", input);
     printf("\t\t reduce void -> type_specifier\n");}
| CHAR{
     i += sprintf(input+i, " CHAR ");
     printf("%s", input);
     printf("\t\t shift CHAR \n");
     printf("%s", input);
     printf("\t\t reduce CHAR -> type_specifier\n");}
| SHORT{
     i += sprintf(input+i, " SHORT ");
     printf("%s", input);
     printf("\t\t shift SHORT \n");
     printf("%s", input);
     printf("\t\t reduce SHORT -> type_specifier\n");}
| INT{
     i += sprintf(input+i, " INT ");
     printf("%s", input);
     printf("\t\t shift INT \n");
     printf("%s", input);
     printf("\t\t reduce INT -> type_specifier\n");}
| LONG{
     i += sprintf(input+i, " LONG ");
     printf("%s", input);
     printf("\t\t shift LONG \n");
     printf("%s", input);
     printf("\t\t reduce LONG -> type_specifier\n");}
| FLOAT{
     i += sprintf(input+i, " FLOAT ");
     printf("%s", input);
     printf("\t\t shift FLOAT \n");
     printf("%s", input);
     printf("\t\t reduce FLOAT -> type_specifier\n");}
| DOUBLE{
     i += sprintf(input+i, " DOUBLE ");
     printf("%s", input);
     printf("\t\t shift DOUBLE \n");
     printf("%s", input);
     printf("\t\t reduce DOUBLE -> type_specifier\n");}
| SIGNED{
     i += sprintf(input+i, " SIGNED ");
     printf("%s", input);
     printf("\t\t shift SIGNED \n");
     printf("%s", input);
     printf("\t\t reduce SIGNED -> type_specifier\n");}
| UNSIGNED{
     i += sprintf(input+i, " UNSIGNED ");
     printf("%s", input);
     printf("\t\t shift UNSIGNED \n");
     printf("%s", input);
     printf("\t\t reduce UNSIGNED -> type_specifier\n");}
| TYPE_NAME{
     i += sprintf(input+i, " TYPE_NAME ");
     printf("%s", input);
     printf("\t\t shift TYPE_NAME \n");
     printf("%s", input);
     printf("\t\t reduce TYPE_NAME -> type_specifier\n");}
;

specifier_qualifier_list
: type_specifier{
     printf("%s", input);
     printf("\t\t reduce type_specifier -> specifier_qualifier_list\n");}
 specifier_qualifier_list{
     printf("%s", input);
     printf("\t\t reduce type_specifier specifier_qualifier_list -> specifier_qualifier_list\n");}
| type_specifier{
     printf("%s", input);
     printf("\t\t reduce type_specifier -> specifier_qualifier_list\n");}
| type_qualifier{
     printf("%s", input);
     printf("\t\t reduce type_qualifier -> specifier_qualifier_list\n");}
 specifier_qualifier_list{
     printf("%s", input);
     printf("\t\t reduce type_qualifier specifier_qualifier_list -> specifier_qualifier_list\n");}
| type_qualifier{
     printf("%s", input);
     printf("\t\t reduce type_qualifier -> specifier_qualifier_list\n");}
;

type_qualifier
: CONST{
     i += sprintf(input+i, " CONST ");
     printf("%s", input);
     printf("\t\t shift CONST \n");
     printf("%s", input);
     printf("\t\t reduce CONST -> type_qualifier\n");}
| VOLATILE{
     i += sprintf(input+i, " VOLATILE ");
     printf("%s", input);
     printf("\t\t shift VOLATILE \n");
     printf("%s", input);
     printf("\t\t reduce VOLATILE -> type_qualifier\n");}
;
declarator
: pointer direct_declarator{
     printf("%s", input);
     printf("\t\t reduce direct_declarator -> declarator\n");}
| direct_declarator{
     printf("%s", input);
     printf("\t\t reduce direct_declarator -> declarator\n");}
;
direct_declarator
: IDENTIFIER{
     printf("%s", input);
     printf("\t\t reduce IDENTIFIER -> direct_declarator\n");}
| '(' {
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 declarator{
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce '('declarator ')' -> direct_declarator\n");}
| direct_declarator{
    printf("%s", input);
    printf("\t\t reduce direct_declarator -> direct_declarator\n");}
 '[' {
     i += sprintf(input+i, " [ ");
     printf("%s", input);
     printf("\t\t shift [\n");}
 constant_expression {
     printf("%s", input);
     printf("\t\t shift [%s\n", input);}
 
 ']'{
     i += sprintf(input+i, " ] ");
     printf("%s", input);
     printf("\t\t shift ]\n");
     printf("%s", input);
     printf("\t\t reduce direct_declarator '[' constant_expression ']' -> direct_declarator\n");}
| direct_declarator{
    printf("%s", input);
    printf("\t\t reduce direct_declarator -> direct_declarator\n");}
    '['{
     i += sprintf(input+i, " [ ");
     printf("%s", input);
     printf("\t\t shift [\n");}
    ']'{
     i += sprintf(input+i, " ] ");
     printf("%s", input);
     printf("\t\t shift ]\n");
     printf("%s", input);
     printf("\t\t reduce direct_declarator '[' ']' -> direct_declarator\n");}
| direct_declarator{
    printf("%s", input);
    printf("\t\t reduce direct_declarator -> direct_declarator\n");}
     '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
     parameter_type_list {
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
      ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce direct_declarator '(' parameter_type_list ')' -> direct_declarator\n");}
| direct_declarator{
    printf("%s", input);
    printf("\t\t reduce direct_declarator -> direct_declarator\n");}
     '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
     identifier_list {
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
      ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce direct_declarator '(' identifier_list ')' -> direct_declarator\n");}
| direct_declarator{
    printf("%s", input);
    printf("\t\t reduce direct_declarator -> direct_declarator\n");}
  '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
  ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce direct_declarator '(' ')' -> direct_declarator\n");}
;
pointer
: '*'{
     i += sprintf(input+i, " * ");
     printf("%s", input);
     printf("\t\t shift *\n");}
| '*'{
     i += sprintf(input+i, " * ");
     printf("%s", input);
     printf("\t\t shift *\n");}
 type_qualifier_list{
    printf("%s", input);
    printf("\t\t reduce * type_qualifier_list -> pointer\n");}
| '*'{
     i += sprintf(input+i, " * ");
     printf("%s", input);
     printf("\t\t shift *\n");}
      pointer{
    printf("%s", input);
    printf("\t\t reduce * pointer -> pointer\n");}
| '*'{
     i += sprintf(input+i, " * ");
     printf("%s", input);
     printf("\t\t shift *\n");}
  type_qualifier_list{
    printf("%s", input);
    printf("\t\t reduce * type_qualifier_list -> pointer\n");}
  pointer{
    printf("%s", input);
    printf("\t\t reduce * type_qualifier_list pointer -> pointer\n");}

;
type_qualifier_list
: type_qualifier{
    printf("%s", input);
    printf("\t\t reduce type_qualifier -> type_qualifier_list\n");}
| type_qualifier_list{
    printf("%s", input);
    printf("\t\t reduce type_qualifier -> type_qualifier_list\n");}
  type_qualifier{
    printf("%s", input);
    printf("\t\t reduce type_qualifier_list type_qualifier -> type_qualifier_list\n");}
;
parameter_type_list
: parameter_list{
    printf("%s", input);
    printf("\t\t reduce parameter_list -> parameter_type_list\n");}
| parameter_list{
    printf("%s", input);
    printf("\t\t reduce parameter_list -> parameter_type_list\n");}
    ','{
     i += sprintf(input+i, " , ");
     printf("%s", input);
     printf("\t\t shift ,\n");}
    ELLIPSIS{
    printf("%s", input);
    printf("\t\t reduce parameter_list ',' ELLIPSIS -> parameter_type_list\n");}
;
parameter_list
: parameter_declaration{
    printf("%s", input);
    printf("\t\t reduce parameter_declaration -> parameter_list\n");}
| parameter_list{
    printf("%s", input);
    printf("\t\t reduce parameter_declaration -> parameter_list\n");}
     ','{
     i += sprintf(input+i, " , ");
     printf("%s", input);
     printf("\t\t shift ,\n");}
 parameter_declaration{
    printf("%s", input);
    printf("\t\t reduce parameter_list ',' parameter_declaration -> parameter_list\n");}
;
parameter_declaration
: declaration_specifiers{
    printf("%s", input);
    printf("\t\t reduce declaration_specifiers -> parameter_declaration\n");}
 declarator{
    printf("%s", input);
    printf("\t\t reduce declaration_specifiers declarator -> parameter_declaration\n");}
| declaration_specifiers{
    printf("%s", input);
    printf("\t\t reduce declaration_specifiers -> parameter_declaration\n");} 
 abstract_declarator{
    printf("%s", input);
    printf("\t\t reduce declaration_specifiers abstract_declarator -> parameter_declaration\n");}
| declaration_specifiers{
    printf("%s", input);
    printf("\t\t reduce declaration_specifiers -> parameter_declaration\n");}
;
identifier_list
: IDENTIFIER{
    printf("%s", input);
    printf("\t\t reduce IDENTIFIER -> identifier_list\n");}
| identifier_list{
    printf("%s", input);
    printf("\t\t reduce IDENTIFIER -> identifier_list\n");}
 ','{
     i += sprintf(input+i, " , ");
     printf("%s", input);
     printf("\t\t shift ,\n");}
  IDENTIFIER{
    printf("%s", input);
    printf("\t\t reduce identifier_list ',' IDENTIFIER -> identifier_list\n");}
;
type_name
: specifier_qualifier_list{
    printf("%s", input);
    printf("\t\t reduce specifier_qualifier_list -> type_name\n");}
| specifier_qualifier_list{
    printf("%s", input);
    printf("\t\t reduce specifier_qualifier_list -> type_name\n");}
 abstract_declarator{
    printf("%s", input);
    printf("\t\t reduce abstract_declarator specifier_qualifier_list -> type_name\n");}
;
abstract_declarator
: pointer{
    printf("%s", input);
    printf("\t\t reduce pointer -> abstract_declarator\n");}
| direct_abstract_declarator{
    printf("%s", input);
    printf("\t\t reduce direct_abstract_declarator -> abstract_declarator\n");}
| pointer{
    printf("%s", input);
    printf("\t\t reduce pointer -> abstract_declarator\n");}
 direct_abstract_declarator{
    printf("%s", input);
    printf("\t\t reduce pointer direct_abstract_declarator -> abstract_declarator\n");}
;
direct_abstract_declarator
: '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 abstract_declarator {
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce '(' abstract_declarator ')' -> direct_abstract_declarator\n");}
| '['{
     i += sprintf(input+i, " [ ");
     printf("%s", input);
     printf("\t\t shift [\n");}
 ']'{
     i += sprintf(input+i, " ] ");
     printf("%s", input);
     printf("\t\t shift ]\n");
     printf("%s", input);
     printf("\t\t reduce '[' ']' -> direct_abstract_declarator\n");}
| '['{
     i += sprintf(input+i, " [ ");
     printf("%s", input);
     printf("\t\t shift [\n");}
 constant_expression{
     printf("%s", input);
     printf("\t\t shift [%s\n", input);}
 ']'{
     i += sprintf(input+i, " ] ");
     printf("%s", input);
     printf("\t\t shift ]\n");
     printf("%s", input);
     printf("\t\t reduce '[' constant_expression ']' -> direct_abstract_declarator\n");}
| direct_abstract_declarator
 '['{
     i += sprintf(input+i, " [ ");
     printf("%s", input);
     printf("\t\t shift [\n");}
  ']'{
     i += sprintf(input+i, " ] ");
     printf("%s", input);
     printf("\t\t shift ]\n");
     printf("%s", input);
     printf("\t\t reduce direct_abstract_declarator '[' ']' -> direct_abstract_declarator\n");}
| direct_abstract_declarator
 '[' {
     i += sprintf(input+i, " [ ");
     printf("%s", input);
     printf("\t\t shift [\n");}
 constant_expression {
     printf("%s", input);
     printf("\t\t shift [%s\n", input);}
 ']'{
     i += sprintf(input+i, " ] ");
     printf("%s", input);
     printf("\t\t shift ]\n");
     printf("%s", input);
     printf("\t\t reduce direct_abstract_declarator '[' constant_expression ']' -> direct_abstract_declarator\n");}
| '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce '(' ')' -> direct_abstract_declarator\n");}
| '('{
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 parameter_type_list {
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce '(' parameter_type_list ')' -> direct_abstract_declarator\n");}
| direct_abstract_declarator 
'(' {
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce direct_abstract_declarator '(' ')' -> direct_abstract_declarator\n");}
| direct_abstract_declarator
 '(' {
     i += sprintf(input+i, " ( ");
     printf("%s", input);
     printf("\t\t shift (\n");}
 parameter_type_list {
     printf("%s", input);
     printf("\t\t shift (%s\n", input);}
 ')'{
     i += sprintf(input+i, " ) ");
     printf("%s", input);
     printf("\t\t shift )\n");
     printf("%s", input);
     printf("\t\t reduce direct_abstract_declarator'(' parameter_type_list ')' -> direct_abstract_declarator\n");}
;
initializer
: assignment_expression{
    printf("%s", input);
    printf("\t\t reduce assignment_expression -> initializer\n");}
| '{'{
     i += sprintf(input+i, " { ");
     printf("%s", input);
     printf("\t\t shift {\n");}
 initializer_list{
     printf("%s", input);
     printf("\t\t shift {%s\n", input);}
 '}'{
     i += sprintf(input+i, " } ");
     printf("%s", input);
     printf("\t\t shift }\n");
     printf("%s", input);
     printf("\t\t reduce '{' initializer_list '}' -> initializer\n");}

| '{'{
     i += sprintf(input+i, " { ");
     printf("%s", input);
     printf("\t\t shift {\n");}
 initializer_list {
     printf("%s", input);
     printf("\t\t shift {%s\n", input);}
 ','{
     i += sprintf(input+i, " , ");
     printf("%s", input);
     printf("\t\t shift ,\n");}
 '}'{
     i += sprintf(input+i, " } ");
     printf("%s", input);
     printf("\t\t shift }\n");
     printf("%s", input);
     printf("\t\t reduce '{' initializer_list ',' '}' -> initializer\n");}
;
initializer_list
: initializer{
    printf("%s", input);
    printf("\t\t reduce initializer -> initializer_list\n");}
| initializer_list{
    printf("%s", input);
    printf("\t\t reduce initializer -> initializer_list\n");}
    ','{
     i += sprintf(input+i, " , ");
     printf("%s", input);
     printf("\t\t shift ,\n");}
   initializer {
       printf("%s", input);
     printf("\t\t reduce initializer_list ',' initializer -> initializer_list\n");}
;
//start with labled statement
statement 
: 
    expression_statement{
    printf("%s", input);
    printf("\t\t reduce expression_statement -> statement\n");}
;

expression_statement
: ';'{
     i += sprintf(input+i, " ; ");
     printf("%s", input);
     printf("\t\t shift ;\n");}
| expression{
    printf("%s", input);
    printf("\t\t reduce expression -> expression_statement\n");}
 ';'{
     i += sprintf(input+i, " ; ");
     printf("%s", input);
     printf("\t\t shift ;\n");
     printf("%s", input);
     printf("\t\t reduce expression ';' -> expression_statement\n");}
;

translation_unit
: expression_statement

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