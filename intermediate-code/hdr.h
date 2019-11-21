#define NSYMS 1000    /* maximum number of symbols */

struct symbol {
    char *name;
    double val;
};

struct symbol *symtab[NSYMS];