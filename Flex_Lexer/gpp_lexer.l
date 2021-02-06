
%{ //******************************DEFINATION PART*******************************
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
%} 

%% //*******************RULES PART********************
"\"" {
static int control = 0;// to control OP_OC
if(control == 0){fprintf(yyout,"OP_OC\n"); control = 1;}else{fprintf(yyout,"OP_CC\n");control = 0;}}

and|or|not|equal|less|nil|list|append|concat|set|deffun|for|if|exit|load|disp|true|false {  

int temp = 0;
while(yytext[temp]){ yytext[temp] = (toupper(yytext[temp])); temp++;}
fprintf(yyout,"KW_%s\n",yytext);}

\+ {fprintf(yyout,"OP_PLUS\n");}
\- {fprintf(yyout,"OP_MINUS\n");}
\/ {fprintf(yyout,"OP_DIV\n");}
\* {fprintf(yyout,"OP_MULT\n");}
\( {fprintf(yyout,"OP_OP\n");}
\) {fprintf(yyout,"OP_CP\n");}
\*\* {fprintf(yyout,"OP_DBLMULT\n");}

, {fprintf(yyout,"OP_COMMA\n");}


;;(.*)                  { fprintf(yyout,"COMMENT\n"); }
(0)|([1-9][0-9]*)       { fprintf(yyout,"VALUE\n"); }
[a-zA-Z][0-9a-zA-Z]*    { fprintf(yyout,"IDENTIFIER\n"); }
[0-9][0-9a-zA-Z]*       { fprintf(yyout,"ERROR\n"); } 
[ \t\r]                 {}

.                       { fprintf(yyout,"ERROR\n"); } 

^\n                     {exit(1);}
"\n"        			{printf("\n>_ ");}

%% 

int yywrap(){} 

void gppLanguage(int argc_value,char **argv_name){
	
	FILE *fp;
	extern FILE *yyout;

	yyout = fopen("parsed_cpp.txt","w");

	if(argc_value < 1){//if interpreter takes inpur from terminal
			printf("\n>_ ");
			yylex();
			fclose(yyout);
	}
	else{//input from .txt files
			
			printf("\n>_ ");
			fp = fopen(argv_name[1],"r");
			yyin = fp;
			yylex();			

		}
	 	
		fclose(fp);
		fclose(yyout);
		exit(1);

}
int main(int argc, char **argv){ 

	gppLanguage(argc,argv);
	return 0; 
}
