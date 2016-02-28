digit		[0-9]
letter		[a-zA-Z]
operator	[=*+/%^&|!?]|"-"|"++"|"--"
logical_op	"=="|"<"|">"|"<="|">="|"!"|"!="|"&&"|"||"
int_literal	{digit}+
float_literal	{digit}+.{digit}+

%{
        enum
        {
            IDENTIFIER,
            CONSTANT
        };
        
        int check_present(int type, char *word);
	void add_to_table(int type, char *word);
	void print_symbol_table();
	
%}

%%

#.*							printf("PRE_PROCESSOR_INSTRUCTION: %s\n", yytext);
";" 							printf("SEMICOLON\n");
":" 							printf("COLON\n");
","							printf("COMMA\n");
"'"							printf("QUOTES\n");
"//"(.*)						printf("SINGLE_LINE COMMENT: %s\n", yytext);
"/*"([^*]*"*"+[^*/])*[^*]*"*"+"/"			printf("MULTI_LINE COMMENT: %s\n", yytext);
"/*"([^*/]|("*"+[^/]))*					printf("ERR_UNMATCHED_COMMENT: %s\n", yytext);
"("							printf("ROUND_BRACKET_OPEN\n");
")"							printf("ROUND_BRACKET_CLOSE\n");
"[" 							printf("SQUARE_BRACKET_OPEN\n");
"]"							printf("SQUARE_BRACKET_CLOSE\n");
"{"							printf("CURLY_BRACKET_OPEN\n");
"}"							printf("CURLY_BRACKET_CLOSE\n");
({operator}|{logical_op})				printf("OPERATOR: %s\n", yytext);
{int_literal}({letter}|"_")({letter}|{digit}|"_")*	printf("ERR_UNCLEAN_INTEGER: %s\n", yytext);
{int_literal}						printf("INTEGER: %s\n", yytext); add_to_table(CONSTANT, yytext);
{float_literal}({letter}|"_")({letter}|{digit}|"_")* 	printf("ERR_UNCLEAN_FLOAT: %s\n", yytext);
{float_literal}						printf("FLOAT: %s\n", yytext); add_to_table(CONSTANT, yytext);
\".*\"							printf("STRING: %s\n", yytext); add_to_table(CONSTANT, yytext);
\"[^"\n]* 						printf("ERR_INCOMPLETE_STRING: %s\n", yytext);
auto		|
break		|
case		|
char		|
const		|
continue	|
default		|
do		|
double		|
else		|
enum		|
extern		|
float		|
for		|
goto		|
if		|
int		|
long		|
register	|
return		|
short		|
signed		|
sizeof		|
static		|
struct		|
switch		|
typedef		|
union		|
unsigned	|
void		|
volatile	|
while 							printf("KEYWORD: %s\n", yytext);
({letter}|_)({letter}|{digit}|_)* 		      	printf("IDENTIFIER: %s\n", yytext); add_to_table(IDENTIFIER, yytext);
.							; //printf("ERR_FOREIGN_CHARACTER: %s\n", yytext);
%%

int main(int argc, char **argv)
{	
    if(argc == 2)
        yyin = fopen(argv[1], "r");
    yylex();
    print_symbol_table();
}

struct word
{
    char *word_name;
    struct word *next;
};

struct word *identifier_list=NULL, *constant_list=NULL;

int check_present(int type, char *word)
{
    struct word *current_list = (type == IDENTIFIER ? identifier_list : constant_list);
    while(current_list)
    {
        //printf("Comparing %s with %s\n", word, current_list->word_name);
        if(strcmp(current_list->word_name, word)==0)
        {
            //printf("Word already present in table.\n");
            return 1;
        }
        current_list = current_list->next;
    }
    //printf("Adding word %s to symbol table.\n", word);
    return 0;
}

void add_to_table(int type, char *word)
{
    if(check_present(type, word))
        return;
        
    struct word *current_list;
    struct word *new_word = (struct word *) malloc(sizeof(struct word));
    new_word->word_name = (char *) malloc(strlen(word)+1);
    strcpy(new_word->word_name, word);
    new_word->next = NULL;
    
    switch(type)
    {
        case IDENTIFIER:
            if(!identifier_list)
            {
                identifier_list = new_word;
                return;
            }
            current_list = identifier_list;
            break;
            
        case CONSTANT:
            if(!constant_list)
            {
                constant_list = new_word;
                return;
            }
            current_list = constant_list;
            break;
    }
    
    while(current_list->next)
        current_list = current_list->next;
    
    current_list->next = new_word;
}

void print_symbol_table()
{
    printf("\n----- Begin Symbol Table -----\n");
    
    printf("\n--- IDENTIFIERS ---\n");
    struct word *list = identifier_list;
    while(list)
    {
        printf("%s\n", list->word_name);
        list = list->next;
    }
    
    printf("\n--- CONSTANTS ---\n");
    list = constant_list;
    while(list)
    {
        printf("%s\n", list->word_name);
        list = list->next;
    }
    
    printf("\n----- End Symbol Table -----\n\n");
}