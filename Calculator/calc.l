%{
#include "y.tab.h"
#include "calchdr.h"
#include <math.h>
%}

%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)   {
        yylval.dval = atof(yytext);
        return NUMBER; 
    }
[\t]    ;       /* ignore whitespace */
[A-Za-z][A-Za-z0-9]*   { 
            yylval.symp = symlook(yytext);
            return NAME;
    }
"$"     { return 0; /* end of input */ }
\n      |
.   return yytext[0];
%%

/* run as follows:
$ yacc -d calc.y
$ lex calc.l
$ cc -o calc y.tab.h lec.yy.c -ly -ll
$ ./calc
*/
