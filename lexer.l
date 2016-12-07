%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cstring>
    #include "ast.hpp"
    #include "parser.hpp"

    /* void yyerror(const char *); */
%}
NUM [0-9]
ALPHA [a-zA-Z]
HEX [0-9A-F]
OCTAL [0-7]
BINARY [01]

/** WRITE ME:
 *  Put any definitions you need here. Add your own regular expressions
 *  below for ALL tokens defined in the manual. You can choose not to use
 *  definitions here.
 */

/* HERE */

/** The example below is very simple, but it shows almost everything you will
 *  need to do for this first part. The syntax is as follows:
 *
 *  regular_expression      {  c code  }
 *
 * The lexer will try to match each regular expression. When it does it will
 * execute the corresponding C code.
*/

%%

"boolean" 	{return BOOLEAN;}
"char"	  	{return CHAR;}
"integer" 	{return INTEGER;}
"intptr" 	{return INTPTR;}
"charptr" 	{return CHARPTR;}
"string"	{return STRING;}
"if" 		{return IF;}
"else" 		{return ELSE;}
"while" 	{return WHILE;}
"var" 		{return VAR;}
"procedure" {return PROCEDURE;}
"return" 	{return RETURN;}
"null"	 	{return NULL_;}

"+"		{return ADD;}
"-"		{return SUB;}
"!" 	{return NOT;} 
"^"		{return DEREF;} 
"&"		{return ADDR;}
"*"		{return MUL;} 
"/"		{return DIV;}
">"		{return LRG;}
">="	{return LRGEQL;}
"<"		{return SML;}
"<="	{return SMLEQL;}
"=="	{return EQL;} 
"!="	{return NOTEQL;}
"&&"	{return AND;}
"||"	{return OR;}
"="		{return ASSIGN;}

";"		{return ';'; }
"{"		{return '{'; }
"}"		{return '}'; }
","		{return ','; }
":"		{return ':'; }
"("		{return '('; }
")"		{return ')'; }
"["		{return '['; }
"]"		{return ']'; }

"|"		{return '|'; }

"true"|"false"			{if (strcmp (yytext,"true")==0) yylval.u_base_int=1;else yylval.u_base_int=0;	return TF;}
[1-9]{NUM}*|0			{yylval.u_base_int = (int)strtol(yytext,0,10);									return INTEGER_LITERAL;}
0[xX]{HEX}+				{yylval.u_base_int = (int)strtol(yytext,0,16);									return INTEGER_LITERAL;}
0{OCTAL}+				{yylval.u_base_int = (int)strtol(yytext,0,8);									return INTEGER_LITERAL;}
{BINARY}+b				{yylval.u_base_int = (int)strtol(yytext,0,2);									return INTEGER_LITERAL;}
"'"."'" 				{yylval.u_base_int = yytext[1];													return CHAR_LITERAL;}
{ALPHA}({NUM}|{ALPHA}|"_")*	{yylval.u_base_charptr = strdup(yytext); 									return IDENTIFIER;}
"\"".*"\""				{
							//get rid of "" but add a '\0'
							char temp[yyleng-1]; 
							strncpy(temp,yytext+1,yyleng-1);
							temp[yyleng-2]='\0';
							yylval.u_base_charptr = strdup(temp);
							return STRING_LITERAL;
						}
"/%"					{
	int c; 
	while(true){//special case:/%xxx%xxx%/
		while((c=yyinput()) !='%'&& c!=EOF)
			;

		if (c=='%'){
			while ((c=yyinput()) =='%')
				;

			if (c=='/'){
				break;//break the loop of while(true)
			}

		}
		if (c==EOF){
			fprintf(stderr,"scan error: dangling  comment in %d\t",yylineno);
			exit(1);
		}
	}
}
 [ \t\n\r\v\f]          ; /* skip whitespace */

.                   {fprintf(stderr,"scan error: invalid character %s\n",yytext); exit(-1);}

%%

/** You shall not pass!
 *  You should not  have to do or edit anything past this.
 */

int yywrap(void) {
    return 1;
}
