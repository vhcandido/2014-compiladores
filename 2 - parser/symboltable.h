#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

// Structure to store a symbol table entry
struct entry_s {
        char *lexeme;        // String representing the lexeme
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

// Puts entry at the beginning of the symbol table
void put_entry(const char *lexeme);

// Searches the symbol table for a lexeme
// Returns
// 	-NULL if searched entry doesn't exists
//	-Pointer to the entry found
entry_t *get_entry(const char *lexeme);

#endif
