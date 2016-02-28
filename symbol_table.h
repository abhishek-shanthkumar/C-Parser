#define NSYMS 100

struct symtab {
    char *name;
    char *value;
    char *type;
    int is_function;
} symtab[NSYMS];

struct symtab *symlook();
