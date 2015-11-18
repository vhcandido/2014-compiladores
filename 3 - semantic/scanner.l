%{
	#include <string.h>	// for strdup (tries to allocate and copies the string if ok)
	#include <stdlib.h>	// for atoi and atof
	#include "parser.tab.h"
	
	int lines=1, chars=0, errors=0;

	void count_lb(char *str, int leng, int *c, int *l);
%}

 /* Digits and numbers */
digit 		[0-9]
num		{digit}+
real		{digit}+\.{digit}+

 /* Letters and identifiers */
letter 		[a-zA-Z]
id     		("_"|{letter})("_"|{letter}|{digit})*

 /* Logical and mathematical operators */
logicop		("!"|"<"|">"|"=="|"&&"|"||")
mathop		("+"|"-"|"*"|"/"|"++"|"--")
attribution	("=")

 /* White character and white space */
horizontal	[" "\t]
linebreak	\n|\v\r

 /* Scope and statement delimiters */
dscope		"{"|"}"|"("|")"|"["|"]"
dstmt		[,;]

 /* Comment and string [.\n]* no comment  */
comment		("//".*\n)
string		(\"[^\"]*\")

 /* Basic data type */
 /*dtype		"int"|"float"*/

%option noyywrap
%option noinput
%option nounput


%%

 /*	KEYWORDS	*/
main	{ chars += yyleng; return (MAIN); }
if	{ chars += yyleng; return (IF); }
else	{ chars += yyleng; return (ELSE); }
do	{ chars += yyleng; return (DO); }
while	{ chars += yyleng; return (WHILE); }
for	{ chars += yyleng; return (FOR); }
break	{ chars += yyleng; return (BREAK); }
print 	{ chars += yyleng; return (PRINT); }
return	{ chars += yyleng; return (RETURN); }


 /*	COMMENT	*/
{comment} { lines++; }


 /*	DATA TYPES	*/
int {
	chars += yyleng;
	return (INT_TYPE);
}

float {
	chars += yyleng;
	return (FLOAT_TYPE);
}


 /*	INVALID	*/
({num}|{real}){id} {
	printf("( %3d : %-3d ) id inválido: %s\n", lines, chars, yytext);
	chars += yyleng;
	errors++;
}


 /*	NUMBERS	*/
{num} {
	yylval.integer = (int)atoi(yytext);
	chars += yyleng;
	return (INTEGER);
}

{real} {
	yylval.real = (float)atof(yytext);
	chars += yyleng;
	return (REAL);
}


 /*	IDENTIFIER	*/
{id} {
	yylval.lexeme = (char *)strdup(yytext);
	chars += yyleng;
	return (ID);
}


 /*	OPERATORS	*/
"+" |
"-" |
"*" |
"/" { chars++; return yytext[0]; }

"++" { chars+=yyleng; return MATH_INC; }
"--" { chars+=yyleng; return MATH_DEC; }

"<"  { chars+=yyleng; return LOG_LT; } /* less than */
">"  { chars+=yyleng; return LOG_GT; } /* greater than */
"==" { chars+=yyleng; return LOG_EQL; } /* equals to */
"&&" { chars+=yyleng; return LOG_AND; } /* and */
"||" { chars+=yyleng; return LOG_OR; } /* or */
"!"  { chars+=yyleng; return LOG_NOT; } /* not */

{attribution} { chars++; return (yytext[0]); }

 /*	DELIMITERS	*/
({dscope}|{dstmt}) { chars++; return (yytext[0]); }


 /*	OTHERS	*/
{string} { count_lb(yytext, yyleng, &chars, &lines); return (STRING); }

{horizontal} { chars++; }

{linebreak} {
	chars = 0;
	lines++;
}


 /*	UNKNOWN ERRORS	*/
. {
	printf("( %3d : %-3d ) token não reconhecido\n", lines, chars);
	chars++;
	errors++;
}

%%

// Counts linebreaks
void count_lb(char *str, int leng, int *c, int *l) {
	int i;

	for(i=0; i<leng; i++) {
		(*c)++;
		if(str[i] == '\n') {
			(*l)++;
			*c = 0;
		}
	}
}
