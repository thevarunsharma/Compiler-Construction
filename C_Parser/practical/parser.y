%{
	#include<stdio.h>
    #include "y.tab.h"  
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
%}

%token IF ELSE DO WHILE SWITCH CASE DEFAULT CMP TYPE CHAR CONTINUE BREAK ID NUMBER
%left CMP
%left '+' '-'
%left '*' '/'
%nonassoc "then"
%nonassoc ELSE
%nonassoc NEGATE
%nonassoc UMINUS

%%
start           : stat_list 
                ;
stat_list       : statement
                | stat_list statement
                ;
statement       : exp_stat
                | label_stat
                | compound_stat
                | condition_stat
                | loop_stat
                | jump_stat
                ;
exp_stat        : expression ';'
                | ';'
                ;
compound_stat   : '{' stat_list '}'
                | '{' '}'
                ;
condition_stat  : IF '(' eval_exp ')' statement                     %prec "then"
                | IF '(' eval_exp ')' statement ELSE statement
                | SWITCH '(' eval_exp ')' statement
                ;
loop_stat       : DO statement WHILE '(' eval_exp ')' ';'
                ;
label_stat      : CASE eval_exp ':' statement
                | DEFAULT ':' statement
                ;
jump_stat       : CONTINUE
                | BREAK
                ;
expression      : assign_exp    
                | declaration 
                | eval_exp
                ;
assign_exp      : ID '=' eval_exp
                | declaration '=' eval_exp
                ;
declaration     : TYPE ID
                ;
eval_exp        : eval_exp '+' eval_exp
                | eval_exp '-' eval_exp
                | eval_exp '*' eval_exp
                | eval_exp '/' eval_exp
                | '(' eval_exp ')'     
                | unary_exp
                | cmp_exp
                | CHAR
                | NUMBER
                | ID
                ;
unary_exp       : '!' eval_exp %prec NEGATE
                | '-' eval_exp %prec UMINUS
                ; 
cmp_exp         : eval_exp CMP eval_exp
                ;

%%

int main()
{
    yyparse();
    if(success)
    	printf("Parsing Successful\n");
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}
