%{
	// TODO Onde está o segfault? deu logo no começo essa joça hahahaha 
	#include <math.h>
	#include <string.h>
	#include "scan.h"

	#define ID 		1
	#define IF 		2
	#define DO		3
	#define WHILE 		4
	#define FOR		5
	#define BREAK		6
	#define CONTINUE	7
	#define INT		7
	#define FLOAT		8
	#define RETURN		9

	#define TABLE_FILE "symbol_table.txt"
	
	int lines=1, chars=0, errors=0, yylval=0;
//operator	[\+\-\*\/\=\<\>\!\%\&\|]
%}

 /* Digits and numbers */
digit 		[0-9]
num		{digit}+
real		{digit}+\.{digit}+

 /* Letters and identifiers */
letter 		[a-zA-Z]
id     		("_"|{letter})("_"|{letter}|{digit})*

 /* Logical and mathematical operators */
logicop		("<"|">"|"<="|">="|"=="|"&&"|"=="|"||")
mathop		("+"|"-"|"*"|"/"|"%"|"&"|"|"|"=")

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
dtype		int|float

%option noyywrap
%option noinput
%option nounput
%%

if	|
do	|
while	|
for	|
break	|
return	{
	yylval=0;
	printf("( %3d : %-3d ) Palavra reservada: %s\n", lines, chars, yytext);
	chars += yyleng;
}

{comment} {
	yylval = 0;
	printf("( %3d : %-3d ) Comentário\n", lines, chars);
	chars += yyleng;
	lines++;
}

int	|
float	{
	printf("( %3d : %-3d ) Tipo: %s\n", lines, chars, yytext);
	chars += yyleng;
}

({num}|{real}){id} {
	printf("( %3d : %-3d ) Id inválido: %s\n", lines, chars, yytext);
	chars += yyleng;
	errors++;
}

{num} {
	yylval = 0;
	printf("( %3d : %-3d ) Inteiro: %s\n", lines, chars, yytext);
	chars += yyleng;
}


{real} {
	yylval = 0;
	printf("( %3d : %-3d ) Real: %s\n", lines, chars, yytext);
	chars += yyleng;
}

{id} {
	yylval = ID;
	printf("( %3d : %-3d ) Identificador: %s\n", lines, chars, yytext);
	chars += yyleng;

	// Grava token na tabela de símbolos (se não existir)
	installID(yytext);
}

({logicop}|{mathop}) {
	yylval = 0;
	printf("( %3d : %-3d ) Operador: %s\n", lines, chars, yytext);
	chars += yyleng;
}

({dscope}|{dstmt}) {
	yylval = 0;
	printf("( %3d : %-3d ) Delimitador: %s\n", lines, chars, yytext);
	chars += yyleng;
}

{string} {
	yylval = 0;
	printf("( %3d : %-3d ) String: %s\n", lines, chars, yytext);
	count_lb(yytext, yyleng, &chars, &lines);
}

{horizontal} {
	yylval = 0;
	chars++;
}

{linebreak} {
	yylval = 0;
	chars = 0;
	lines++;
}

. {
	yylval = 0;
	printf("( %3d : %-3d ) Erro\n", lines, chars);
	chars++;
	errors++;
}

%%


int main( int argc, char **argv )
{
/*	printf("argv b: %s | argc b: %d\n", *argv, argc);
//	do{
	// Checks if there are more files to be read 
	++argv, --argc;
	printf("argv a: %s | argc a: %d\n", *argv, argc);
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;
*/
	// Initializes the symbol table
	init_table();

	// Install keywords to the first entries of the symbol table
	install_keywords();

	// Executes the scanner
	yylex();

	// Prints the generated symbol table
	print_table();

	// More info
	printf("Resultado da análise léxica\n"
		"\tErros encontrados: %d\n", errors);
	return 0;
}

void count_lb(char *str, int leng, int *c, int *l) {
	int count, i;

	for(count=0, i=0; i<leng; i++) {
		(*c)++;
		if(str[i] == '\n') {
			(*l)++;
			*c = 0;
		}
	}
}

void init_table() {
	table.t_size = 0;
	table.t_head = NULL;
}

entry_t *create_entry(const char *lexeme) {
	entry_t *new_entry = (entry_t *)malloc(sizeof(entry_t));

	new_entry->token = yylval;
	strcpy(new_entry->lexeme, lexeme);
	new_entry->next = NULL;

	return new_entry;
}

void insert_entry(const char *lexeme) {
	entry_t *cur = table.t_head;
	if(!table.t_head) {
		table.t_head = create_entry(lexeme);
	} 
	else {
		// Finds the last entry
		for(; cur->next != NULL; cur = cur->next);
		cur->next = create_entry(lexeme);
	}

	table.t_size++;
}

entry_t *search_entry(const char *lexeme) {
	/* return:
	   NULL - found
	   pointer to the last entry - not found */
	int found = 0;

	entry_t *cur = table.t_head;
	entry_t *prev = NULL;

	for(; cur != NULL; prev=cur, cur=cur->next) {
		if(strcmp(cur->lexeme, lexeme) == 0) {
			found = 1;
			break;
		}
	}

	return found==1 ? NULL : prev;
}

void installID(const char *lexeme) {
	entry_t *last = search_entry(lexeme);
	if(last != NULL) {
		last->next = create_entry(lexeme);
		table.t_size++;
	}
}

void install_keywords() {
	// if
	yylval = IF;
	insert_entry("if");

	// do
	yylval = DO;
	insert_entry("do");

	// while
	yylval = WHILE;
	insert_entry("while");

	// for
	yylval = FOR;
	insert_entry("for");

	// break
	yylval = BREAK;
	insert_entry("break");

	// continue
	yylval = CONTINUE;
	insert_entry("continue");

	// int
	yylval = INT;
	insert_entry("int");

	// float
	yylval = FLOAT;
	insert_entry("float");

	// return
	yylval = RETURN;
	insert_entry("return");
}

void print_table() {
	FILE *f = fopen (TABLE_FILE, "w");
	int i;
	char *tokens[] = {"ID", "IF", "DO", "WHILE", "FOR", "BREAK", "CONTINUE", "INT", "FLOAT", "RETURN"};
	entry_t *cur = table.t_head;
	
	fprintf(f, "TABELA DE SÍMBOLOS\n"
		"Registros: %d\n\n", table.t_size);

	fprintf(f, "+---------------------------\n"); 
	fprintf(f, "|  -   | TOKEN      | LEXEME\n");
	fprintf(f, "+---------------------------\n");
	for(i=1; cur!=NULL; cur=cur->next, i++) {
		fprintf(f, "| %-4d | %-10s | %s\n", i, tokens[cur->token-1], cur->lexeme);
	}
	fprintf(f, "+---------------------------\n"); 
}
