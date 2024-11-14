%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXLEN 100

typedef struct {
    char result[MAXLEN];
    char arg1[MAXLEN];
    char op[MAXLEN];
    char arg2[MAXLEN];
} TAC;

TAC code[MAXLEN];
int code_index = 0;

void add_code(char *result, char *arg1, char *op, char *arg2);
void optimize_and_print_code();
%}

%union {
    char *str;
}

%token <str> ID NUM
%token PLUS MINUS MULT DIV ASSIGN
%type <str> expr op
%left PLUS MINUS
%left MULT DIV

%%

program:
    code_list { optimize_and_print_code(); }
    ;

code_list:
    code_list code_line
    | code_line
    ;

code_line:
    ID ASSIGN expr
    { add_code($1, $3, "", ""); free($1); free($3); }
    |
    ID ASSIGN expr op expr
    { add_code($1, $3, $4, $5); free($1); free($3); free($5); }
    ;

expr:
    NUM { $$ = strdup($1); }
    | ID { $$ = strdup($1); }
    ;

op:
    PLUS { $$ = strdup("+"); }
    | MINUS { $$ = strdup("-"); }
    | MULT { $$ = strdup("*"); }
    | DIV { $$ = strdup("/"); }
    ;

%%

void add_code(char *result, char *arg1, char *op, char *arg2) {
    strcpy(code[code_index].result, result);
    strcpy(code[code_index].arg1, arg1);
    strcpy(code[code_index].op, op);
    strcpy(code[code_index].arg2, arg2);
    code_index++;
}

void optimize_and_print_code() {
    printf("\nOptimized Three Address Code:\n");
    for (int i = 0; i < code_index; i++) {
        if (strcmp(code[i].op, "+") == 0 && strcmp(code[i].arg2, "0") == 0) {
            printf("%s = %s\n", code[i].result, code[i].arg1);  // Remove addition of 0
        } else if (strcmp(code[i].op, "*") == 0 && strcmp(code[i].arg2, "1") == 0) {
            printf("%s = %s\n", code[i].result, code[i].arg1);  // Remove multiplication by 1
        } else {
            printf("%s = %s %s %s\n", code[i].result, code[i].arg1, code[i].op, code[i].arg2);
        }
    }
}

int main() {
    printf("Enter three address code (end input with Ctrl+D):\n");
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Syntax Error: Invalid input detected. Please enter valid three-address code expressions.\n");
    return 0;
}

