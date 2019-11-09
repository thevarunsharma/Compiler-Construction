%{
#include "calchdr.h"
#include <string.h>
%}

%union {
        double dval;
        struct symtab *symp;
}

%token <symp> NAME
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <dval> expression

%%
statement_list: statement '\n'
        |       statement_list statement '\n'
        ;
statement: NAME '=' expression  { $1->value = $3; }
        |   expression      { printf("= %g\n", $1); }
        ;
expression: expression '+' expression   { $$ = $1 + $3; }
        |   expression '-' expression   { $$ = $1 - $3; }
        |   expression '*' expression   { $$ = $1 * $3; }
        |   expression '/' expression
                        {if ($3 == 0.0)
                                yyerror("Math Error: division by zero");
                        else
                                $$ = $1 / $3;
                        }
        |   '-' expression %prec UMINUS { $$ = -$2; }
        |   '(' expression ')'          { $$ = $2; }
        |   NUMBER
        |   NAME                { $$ = $1->value; }
        ;
%%
struct symtab *
symlook(s)
char *s;
{
    char *p;
    struct symtab *sp;
    for(sp = symtab; sp < &symtab[NSYMS]; sp++){
        if (sp->name && !strcmp(sp->name, s))
            return sp;
        if (!sp->name){
            sp->name = strdup(s);
            return sp;
        }
    }
    yyerror("Too many symbols");
    exit(1);
}
