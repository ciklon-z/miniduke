#ifndef SYMTAB_H
#define SYMTAB_H

#include "ast.h"

struct symtab_class;
struct symtab_method;

typedef struct symtab_var
{
	ast_type type;
	const char *id;

	enum {
		SYM_METHOD,
		SYM_CLASS,
	} var_location;

	union {
		struct symtab_class *class;
		struct symtab_method *method;
	};

	struct symtab_var *next;
} symtab_var;

typedef struct symtab_method {
	ast_type type;
	const char *id;

	symtab_var *params;
	symtab_var *locals;

	struct symtab_class *class;
	struct symtab_method *next;
} symtab_method;

typedef struct symtab_class {
	const char *id;
	symtab_var *fields;
	symtab_method *methods;
	
	struct symtab_class *next;
} symtab_class;

typedef struct
{
	const char *main_class;
	symtab_method *main_method;

	symtab_class *classes;
} symtab_program;

void symtab_init();
void symtab_print(FILE *file);

#endif

