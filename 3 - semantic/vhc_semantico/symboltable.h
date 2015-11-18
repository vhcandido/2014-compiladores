#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

// Structure to store a symbol table entry
struct entry_s {
	int type;		// Type of the lexeme
        char *lexeme;		// String representing the lexeme
	float value;		// numeric value of the entry
        struct entry_s *next;	// Pointer to the next entry
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
entry_t *create_entry(int type, const char *lexeme, float value);

// Puts entry at the beginning of the symbol table
void put_entry(entry_t *new_entry);

// Searches the symbol table for a lexeme
// Returns
// 	-NULL if searched entry doesn't exists
//	-Pointer to the entry found
entry_t *get_entry(const char *lexeme);

// Returns the numeric value of the entry
float get_value(const char *lexeme);

// Sets a new numeric value for the entry
void set_value(const char *lexeme, float value);

// Returns the type of the entry
int get_type(const char *lexeme);

#endif
