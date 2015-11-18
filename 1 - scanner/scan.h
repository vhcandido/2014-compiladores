#ifndef SCAN_H
#define SCAN_H

// Structure to store a symbol table entry
struct entry_s {
        int token;              // Type of token
        char lexeme[50];        // String representing the lexeme
        struct entry_s *next;   // Pointer to the next entry
};
typedef struct entry_s entry_t;

// Structure to store the symbol table
struct table_s {
        int t_size;             // Size of the table
        entry_t *t_head;        // Pointer to the first entry
};
typedef struct table_s table_t;

// Symbol table 
table_t table;

// Initializes the symbol table
void init_table();

// Creates a new entry and returns a pointer thereto
entry_t *create_entry(const char *lexeme);

// Inserts entry at the end of the symbol table
//      -used for manual insertion of keywords
void insert_entry(const char *lexeme);

// Searches the symbol table for a lexeme
// Returns
//      -NULL if searched entry exists
//      -pointer to the last entry if searched entry does not exist
//              (used for insertion at the end of the symbol table)
entry_t *search_entry(const char *lexeme);

// Inserts entry at the end of the symbol table
//      -if it already exists then it does nothing
//      -used during scanning
void installID(const char *lexeme);

// Inserts all keywords at the beginning of the symbol table
void install_keywords();

// Prints the symbol table on a file
void print_table();

// Counts string lines and characters
void count_lb(char *str, int leng, int *c, int *l);

#endif
