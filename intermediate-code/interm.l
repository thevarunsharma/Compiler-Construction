%{
#include <stdlib.h>
#include <string.h> 
#include "y.tab.h"  
#include "hdr.h" 

struct symbol *get_symbol(char* name){
    struct symbol *sp;
    sp = (struct symbol*)malloc(sizeof(struct symbol)); 
    strcpy(sp->name, name);
    return sp;
}

%}
ALPHA [A-Za-z]
DIGIT [0-9]
%%
"while"                         { return WHILE; }
"break"                         { return BREAK; }
"continue"                      { return CONTINUE; }
"if"                            { return IF; }
"int"                           { return TYPE; }
{ALPHA}({ALPHA}|{DIGIT})*       { yylval.sym = get_symbol(yytext);
                                  return ID; }
{DIGIT}+                        { yylval.sym = get_symbol(yytext);
                                  yylval.sym->val = atoi(yytext);
                                  return NUMBER; }
[ \t\n]                         ;
"=="                            { return EQ_CMP; }
"!="                            { return NOT_EQ; }
.                               { return yytext[0]; }
%%