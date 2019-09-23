%{
    int count = 0;
    int lines = 0;    
%}
%%
\n          {lines++;}   
[^ \t\n]+   {count++;
            printf("\b%s\t", yytext);}
%%

int yywrap(){}
int main(){
    yylex();
    printf("\nNumber of tokens: %d\n", count);
    printf("Number of lines: %d\n", lines);
    return 0;
}
