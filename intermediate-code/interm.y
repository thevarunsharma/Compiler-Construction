%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "hdr.h"
#define NSYMS 1000
#define NTEMP 1000

int yylex(void);
int yyerror(const char *s);
int success = 1;

struct symbol *dummy;

int line = 0, symcnt = 0, tempcnt = 0;
int temp[NTEMP];
struct symbol *symtable[NSYMS];

struct codeline{
    char *op;
    char *arg1;
    char *arg2;
    char *arg3;
};

struct codeline *code[1000];

char *itoa(int num){
    char *result;
    sprintf(result, "%d", num);
    return result;
}

struct symbol *get_sym(char *name){
    char *p;
    struct symbol *sp;
    int i = 0;
    for (i=0; i<NSYMS; i++){
        sp = symtable[i];
        if (sp->name && !strcmp(sp->name, name))
            return sp;
    }
    yyerror("Undefined symbol");
    exit(1);
}

void add_line(char *op, char *arg1, char *arg2, char *arg3){
    code[++line] = (struct codeline*)malloc(sizeof(struct codeline));
    strcpy(code[line]->op, op);
    strcpy(code[line]->arg1, arg1);
    strcmp(code[line]->arg2, arg2);
    strcmp(code[line]->arg3, arg3);
}

char *do_op(char *op, struct symbol *sp1, struct symbol *sp2, int val){
    temp[++tempcnt] = val;
    char *name = strcat("TEMP", itoa(tempcnt));
    add_line(op, sp1->name, sp2->name, name);
    return name;
}
void assign_val(char *name, int val){
    struct symbol *sp = get_sym(name);
    sp->val = val;
    add_line("ASSIGN", name, itoa(val), " ");
}

void add_symbol(char *name){
    symtable[++symcnt] = (struct symbol*)malloc(sizeof(struct symbol));
    strcpy(symtable[symcnt]->name, name);
}

int get_symval(char *name){
    struct symbol *sp = get_sym(name);
    return sp->val;
}

%}

%union {
    struct symbol *sym;
}

%token WHILE BREAK CONTINUE TYPE IF EQ_CMP NOT_EQ
%token <sym> ID
%token <sym> NUMBER
%left '>' '<' NOT_EQ EQ_CMP
%left '+' '-'
%left '*' '/'
%nonassoc NEGATE
%nonassoc ELSE
%nonassoc UMINUS
%type <sym> eval_exp declaration identifier cmp_exp unary_exp

%%
start           : stat_list ;
stat_list       : statement
                | stat_list statement
                ;
statement       : exp_stat
                | compound_stat
                | condition_stat
                | while_stat
                | jump_stat
                ;
exp_stat        : expression ';'
                | ';'
                ;
cmp_exp         : eval_exp EQ_CMP eval_exp  { $$->val = $1->val == $3->val;
                                             strcpy($$->name, do_op("EQUAL", $1, $3, $$->val)); }
                | eval_exp '>' eval_exp     { $$->val = $1->val > $3->val;
                                             strcpy($$->name, do_op("GREATER", $1, $3, $$->val)); }
                | eval_exp '<' eval_exp     { $$->val = $1->val < $3->val;
                                             strcpy($$->name, do_op("LESS", $1, $3, $$->val)); }
                | eval_exp NOT_EQ eval_exp  { $$->val = $1->val != $3->val;
                                             strcpy($$->name, do_op("NOT_EQ", $1, $3, $$->val)); }
                ;
eval_exp        : eval_exp '+' eval_exp     { $$->val = $1->val + $3->val;
                                             strcpy($$->name, do_op("ADD", $1, $3, $$->val)); }
                | eval_exp '-' eval_exp     { $$->val = $1->val - $3->val;
                                             strcpy($$->name, do_op("SUBTRACT", $1, $3, $$->val)); }
                | eval_exp '*' eval_exp     { $$->val = $1->val * $3->val;
                                             strcpy($$->name, do_op("MULTIPLY", $1, $3, $$->val)); }
                | eval_exp '/' eval_exp     { $$->val = $1->val / $3->val;
                                             strcpy($$->name, do_op("DIVIDE", $1, $3, $$->val)); }
                | '(' eval_exp ')'          { $$->val = $2->val; }
                | unary_exp
                | cmp_exp
                | NUMBER                     { $$ = $1; }
                | ID                         { $$ = $1; }
                ;
unary_exp       : '!' eval_exp %prec NEGATE { $$->val = ! $2->val;
                                             strcpy($$->name, do_op("NOT", $2, dummy, $$->val)); }
                | '-' eval_exp %prec UMINUS { $$->val = -1 * $2->val;
                                             strcpy($$->name, do_op("UMINUS", $2, dummy, $$->val)); }
                ; 
identifier      : ID        { $$ = $1; }
                ;
compound_stat   : '{' stat_list '}'
                | '{' '}'
                ;
condition_stat  : IF '(' eval_exp ')' statement
                ;
while_stat      : WHILE '(' eval_exp ')' statement ;
jump_stat       : CONTINUE ';' 
                | BREAK ';' 
                ;
expression      : assign_exp    |   declaration
                ;
declaration     : TYPE identifier       { add_symbol($2->name);
                                          strcpy($$->name, $2->name); }
                ;
assign_exp      : identifier '=' eval_exp       { assign_val($1->name, $3->val); }
                | declaration '=' eval_exp      { assign_val($1->name, $3->val); }
                ;

%%



int main(){
    yyparse();
    dummy = (struct symbol*)malloc(sizeof(struct symbol));
    strcpy(dummy->name, " ");
    int i;
    for (i=0; i<line; i++){
        struct codeline *c = code[i];
        printf("%s\t%s\t%s\t%s\n", c->op, c->arg1, c->arg2, c->arg3);
    }
    return 0;
}
