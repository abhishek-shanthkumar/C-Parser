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
    : types ID args block_statement                                 { $2->type = strdup($1); $2->is_function = 1; }
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
    : NUMBER
    | ID { $$ = $1->value; }
    | expression PLUS expression
    | expression MINUS expression
    | expression ASTERISK expression
    | expression SLASH expression
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

struct symtab *symlook(char *s)
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
    yyerror("Too many symbols");
    exit(1);
} 

int yyerror(char *s) {
    fprintf(stderr , "%s on line %i.\n", s, yylineno);
    exit(0);
}

void print_symbol_table() {
    char *p;
    struct symtab *sp;
    printf("\n----- SYMBOL TABLE -----\n\n");
    printf("Identifier\tType\t\tFunction?\n");
    printf("----------\t----\t\t---------\n");
    for(sp = symtab ; sp < &symtab[NSYMS] ; sp++) {
        if(!sp->name)
            break;
        printf("%s\t\t%s\t\t%s\n", sp->name, sp->type, sp->is_function ? "Yes" : "" );
    }
    printf("\n----- END OF SYMBOL TABLE -----\n\n");
}

int main(int argc ,char *argv[]) {
    yyin = fopen(argv[1], "r");

    yyparse();
    
    printf("\nProgram parsed successfully.\n");
    print_symbol_table();

    fclose(yyin);
    return 0;
}