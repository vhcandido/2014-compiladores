#include "symboltable.h"
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>

void init_table() {
	table.t_size = 0;
	table.t_head = (entry_t *)0;
}

entry_t *create_entry(const char *lexeme) {
	entry_t *new_entry = (entry_t *)malloc(sizeof(entry_t));

	new_entry->lexeme = (char *)malloc(strlen(lexeme)*sizeof(char));
	strcpy(new_entry->lexeme, lexeme);
	new_entry->next = NULL;

	return new_entry;
}

void put_entry(const char *lexeme) {
	entry_t *new_entry;

	new_entry = (entry_t *)create_entry(lexeme);

	new_entry->next = table.t_head;
	table.t_head = new_entry;

	table.t_size++;
}

entry_t *get_entry(const char *lexeme) {
	/* return:
	   NULL - not found
	   pointer to the entry found */

	entry_t *cur;
	for( cur = table.t_head;
		 cur != (entry_t *)0;
		 cur=cur->next) {

		if(strcmp(cur->lexeme, lexeme) == 0) {
			return cur;
		}
	}
	return 0;
}