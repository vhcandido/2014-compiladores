%{	
	#include <stdio.h>
	#include "symboltable.h"

	extern int errors, lines;

	// Target file for the symbol table
	#define TABLE_FILE "symboltable.txt"

	FILE *yyin;

	int yylex();
	void yyerror();
	void install(const char *lexeme);
	void install_keywords(char* keywords[], int n);
	void print_table(table_t table);

	#define YYDEBUG 1
%}



%start program
%token MAIN
%token IF ELSE DO WHILE FOR BREAK PRINT RETURN
%token DTYPE
%token STRING NUMBER
%token ID
%token UNLOP BINLOP MATHOP ATTR

%union {
	char * lexeme;
}

%type<lexeme> ID program_end1 error

%right '='
%right UNLOP
%left BINLOP
%left MATHOP

%glr-parser

%%

 /*******************************************
 PROGRAM BODY
 *******************************************/
program : MAIN '('')' '{' commands '}' program_end
        | error {yyerror("formato do corpo incorreto (main)", lines);} ;

program_end : %empty 
            | program_end1;

program_end1 : ID '('')' '{' commands '}' program_end1
             | error {yyerror("formato do corpo incorreto", lines);};


 /*******************************************
 COMMANDS
 *******************************************/
commands: %empty
        | commands1;

commands1: '{' commands '}'
          | commands1 command
          | command
          | ';';

command: cmd ';'
       | DTYPE declarations ';'
       | if_stmt
       | for_stmt
       | while_stmt 
       | dowhile_stmt ;

cmd: PRINT STRING
   | BREAK
   | RETURN
   | attribution
   | error {yyerror("command", lines);} ;


 /*******************************************
 IF ELSE
 *******************************************/
if_stmt: IF '(' fsecond ')' '{' commands '}' else_stmt;

else_stmt: %empty
         | ELSE '{' commands '}';


/*******************************************
 FOR
 *******************************************/
for_stmt: FOR '(' ffirst ';' fsecond ';' fthird ')' '{' commands '}';

ffirst: %empty
      | declarations;

fsecond: %empty
       | binlop;

fthird: %empty
      | fthird_body;

fthird_body: cmd ',' fthird_body
           | cmd;


 /*******************************************
 WHILE
 *******************************************/
while_stmt: WHILE '(' fsecond ')' '{' commands '}';


 /*******************************************
 DO WHILE
 *******************************************/
dowhile_stmt: DO '{' commands '}' WHILE '(' fsecond ')' ';';


 /*******************************************
 DECLARATION
 *******************************************/
declarations: declarations ',' decl
            | decl;

decl: ID
    | attribution
    | error {yyerror("Expressão esperada", lines);} ;


 /*******************************************
 ATTRIBUTION
 *******************************************/
attribution: ID '=' expr;


 /*******************************************
 MATH AND LOGICAL EXPRESSIONS
 *******************************************/
expr: binlop 
    | binmop
    | '(' expr ')'
    | UNLOP expr
    | ID
    | NUMBER
    | error {yyerror("erro de expressão", lines);} ;

binlop: expr BINLOP expr;

binmop: expr MATHOP expr;


%%

int main( int argc, char **argv )
{
	char* keywords[] = {"main", "if", "else", "do", "while", "for", "break", "print",
						"return", "int", "float"};

	// Checks if there are more files to be read 
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

	// Initializes the symbol table
	//init_table();

	// Install keywords to the first entries of the symbol table
	//install_keywords(keywords, 11);

	// Executes the parser
	yyparse();

	if(errors==0) {
		printf("Análise concluída com sucesso.\n");
	}
	else {
		printf("Total de %d erros\n", errors);
	}

	// Prints the generated symbol table
	//print_table(table);

	return 0;
}

// Inserts entry at the end of the symbol table
// 	-if it's already installed does nothing
void install(const char *lexeme) {
	entry_t *e;

	e = (entry_t *)get_entry(lexeme);
	if(e == 0) {
		// Puts the lexeme at the head of the table
		put_entry(lexeme);
	}
	else {
		// It's already in the table
	}
}

// Inserts all keywords at the beginning of the symbol table
void install_keywords(char* keywords[], int n) {
	int i;
	for( i = 0;
		 i < n;
		 i++) {
		install(keywords[i]);
	}
}

// Prints the symbol table on a file
void print_table(table_t table) {
	FILE *f = fopen (TABLE_FILE, "w");
	int i;
	entry_t *cur;
	
	fprintf(f, "TABELA DE SÍMBOLOS\n"
		"%d registros\n\n", table.t_size);

	fprintf(f, "+---------------------------+\n"); 
	fprintf(f, "|  -   |       TOKEN        |\n");
	fprintf(f, "+---------------------------+\n");

	for( i = 1, cur = table.t_head;
		 cur != NULL;
		 cur = cur->next, i++) {
		fprintf(f, "| %-4d | %s\n", i, cur->lexeme);
	}

	fprintf(f, "+---------------------------+\n"); 
}

void yyerror(char *str, int num_linha) {
	if(strcmp(str,"syntax error") == 0) {
		errors++;
		printf("Erro sintático\n");//Exibe mensagem de erro

	}

	else {
		//Exibe a linha do erro
		printf("Próximo à linha %d : %s\n", num_linha, str);

	}
}