%{
char caps[100], lower[100];
int cp=0, lw=0, oth=0, lines = 0;
%}

%%
[A-Z]	{caps[cp++] = *yytext;}
[a-z]	{lower[lw++] = *yytext;}
.	{oth++;}
\n	{lines++;}
%%

int yywrap(){}
int main(){
	yylex();
	printf("Number of capital letters: %d\n", cp);
	int i=0;
	while (i < cp)
		printf("%c", caps[i++]);
	printf("\nNumber of lowercase letters: %d\n", lw);
	i = 0;
	while (i < lw)
		printf("%c", lower[i++]);
	printf("\nOther characters: %d\n", oth);
	printf("Number of lines: %d\n", lines); 
	return 0;
}
