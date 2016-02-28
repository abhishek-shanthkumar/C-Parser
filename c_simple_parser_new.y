%{

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "mytable.h"

int yyerror(char *);
int yylex(void);
int yylineno;
extern FILE *yyin;
extern FILE *fopen(const char *filename, const char *mode);
char *target, source;
static int tempnum;

char *newtemp();

int istemp(char *c);

void removetemp();
void emitln(char *s);
void emit(char *s);
static int label = 0;

char *openlabel();
char *closelabelmin();
char *closelabel();

char *stack [100]; 
static int top = 0;
char *stack_pop();
char *stack_get_top_element() ;
void stack_push(char *c);
static int stack_get_top();

char *current_type;
void print_symbol_table();

%}

%token    PAR_OPEN  PAR_CLOSE COMMA SEMICOLON  WHILE RETURN  
%token    IF ELSE CB_OPEN CB_CLOSE PLUS MINUS ASTERISK SLASH ASSIGNMENT
%token    OR AND NOT LESS LESS_EQUAL MORE_EQUAL MORE EQUAL NOT_EQUAL QUOT

%union { 
    char *intval;
    char  charval;
    char *stringval;
    struct symtab *symp;
}

%token <intval> NUMBER
%token <charval> LITERAL_C
%token <symp> ID
%token <intval> CHAR
%token <intval> INT
%token <stringval> STRING_LITERAL

%type <intval> expression
%type <charval> char_expression   
%type <intval> conditions   
%type <intval> types

%left PLUS MINUS
%left ASTERISK SLASH

%%

program
    : program funcdef 
    | funcdef                                                       
    ;

funcdef
    : types ID args block_statement                                 { $2->type = strdup($1); }
    ;

args
    : PAR_OPEN var_def_list PAR_CLOSE
    ;

var_def_list
    : var_def COMMA var_def
    | var_def 
    |
    ;

var_def
    : types ID
    ;

types
    : INT
    | CHAR
    ;

block_statement
    : CB_OPEN statements CB_CLOSE
    ;

statements
    : statements statement 
    | statement 
    |
    ;

statement
    : block_statement
    | conditional_statement
    | while_st
    | assignment_statement SEMICOLON
    | declaration_statement SEMICOLON
    | function_call SEMICOLON
    | ret_statement SEMICOLON
    ;

id_list
    : id_list COMMA ID                                              { $3->type = current_type; } 
    | ID                                                            { current_type = (char *) malloc(5); $1->type = current_type; }
    ;
    
declaration_statement
    : types id_list                                                 { strcpy(current_type, $1); }
    ;
    
function_call
    : ID PAR_OPEN expression_list PAR_CLOSE
    ;
    
conditional_statement
    : IF PAR_OPEN conditions PAR_CLOSE block_statement elsest
    ;

elsest
    : ELSE block_statement
    |
    ;

while_st 
    : WHILE PAR_OPEN conditions PAR_CLOSE block_statement
    ;

conditions 
    : conditions LESS expression
    | conditions LESS_EQUAL expression
    | conditions MORE_EQUAL expression
    | conditions MORE expression
    | conditions NOT_EQUAL expression
    | conditions EQUAL expression
    | expression
    ;


assignment_statement
    : types ID ASSIGNMENT expression                                { $2->type = strdup($1); }
    | ID ASSIGNMENT expression
    | types ID ASSIGNMENT char_expression                           { $2->type = strdup($1); }
    | ID ASSIGNMENT char_expression 
    | types ID ASSIGNMENT {  }
    | error 
    ;

ret_statement
    : RETURN expression {  } 
    ;

expression
    : NUMBER { $$ = $1; }
    | ID { $$ = $1 -> name ;}
    | expression PLUS expression { $$ = $1; }
    | expression MINUS expression { $$ = $1; }
    | expression ASTERISK expression { $$ = $1; }
    | expression SLASH expression { $$ = $1; }
    | PAR_OPEN expression PAR_CLOSE { $$ = $2; }
    ;

char_expression
    : QUOT LITERAL_C QUOT { }
    ;

expression_list
    : expression_list COMMA expression
    | expression_list COMMA STRING_LITERAL
    | expression
    | STRING_LITERAL;

%%

struct symtab * symlook(char *s)
{
    char *p;
    struct symtab *sp;
    for(sp = symtab ; sp < &symtab[NSYMS] ; sp++) {
        if (sp -> name && ! strcmp(sp->name, s)) {
            return sp;
        }
        if (!sp -> name) {
            sp->name = strdup(s);
            return sp;
        }

    }
    yyerror("too many symbols ");
    exit(1);
} 

/*char * openlabel (){
    label = label + 1;

    char integer_string[4] = "";

    sprintf(integer_string, "%d", label);
    char * temp ;
    temp = strdup("L");
    return  strcat(temp, integer_string); 

}

char * closelabelmin() {
    label = label -1 ;
    char integer_string[4] = "";

    sprintf(integer_string, "%d", label);
    char * temp ;
    temp = strdup("L");
    return  strcat(temp, integer_string); 
}

char * closelabel() {

    char integer_string[4] = "";

    sprintf(integer_string, "%d", label);
    char * temp ;
    temp = strdup("L");
    return  strcat(temp, integer_string); 
}*/

void removetemp(int n) {
    tempnum = tempnum - n;
}


void emitln(char *s) {
    printf("%s\n", s );
}

void emit(char *s) {
    printf("%s", s );
}

/*char * newtemp(){
    tempnum = tempnum + 1;

    char integer_string[4] = "";

    sprintf(integer_string, "%d", tempnum);
    char * temp ;
    temp = strdup("T");
    return  strcat(temp, integer_string); 
}

int istemp(char *s){
    char *temp = "T";
    if(s[0] == temp[0]){
        return 1;
    }

    else{
        return 0;
    }
}

void stack_push(char * c){
    stack[top++] = c;
}

char * stack_pop(){
    return stack[--top];
}

static int stack_get_top(){
    return top;
}

char * stack_get_top_element(){
    return stack[top - 1];
}*/

int yyerror(char *s) {
    fprintf(stderr , "%s line %i \n", s, yylineno);
    exit(0);
}

void print_symbol_table() {
    char *p;
    struct symtab *sp;
    for(sp = symtab ; sp < &symtab[NSYMS] ; sp++) {
        if(!sp->name)
            break;
        printf("%s\t%s\n", sp->name, sp->type);
    }
}

int main(int argc ,char *argv[]) {
    yyin = fopen(argv[1], "r");

    yyparse();
    
    printf("Program parsed successfully.\n");
    print_symbol_table();

    fclose(yyin);
    return 0;
}