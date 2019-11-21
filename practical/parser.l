%option yylineno
%{
#include "y.tab.h"      
%}

ALPHA [A-Za-z_]
DIGIT [0-9]

%%
"if"                                                            { return IF; }
"else"                                                          { return ELSE; }
"do"                                                            { return DO; }
"while"                                                         { return WHILE; }
"switch"                                                        { return SWITCH; }
"case"                                                          { return CASE; }
"default"                                                       { return DEFAULT; }
"continue"                                                      { return CONTINUE; }
"break"                                                         { return BREAK; }
"=="|">="|"<="|"<"|">"|"!="                                     { return CMP; }
"int"|"float"|"char"|"void"|"long"|"double"|"signed"|"unsigned" { return TYPE; }
{ALPHA}({ALPHA}|{DIGIT})*                                       { return ID; }
({DIGIT}+|({DIGIT}*\.{DIGIT}+)([eE][-+]?{DIGIT}+)?)             { return NUMBER; }
"'"."'"                                                         { return CHAR; }
[\t\n ]                                                         ;
.                                                               { return yytext[0]; }
%%