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

int main() {
    char icode[10][30];
    char result[MAXLEN], arg1[MAXLEN], op[MAXLEN], arg2[MAXLEN];
    int i = 0;

    printf("Enter the set of intermediate code (terminated by exit):\n");
    do {
        fgets(icode[i], 30, stdin);
        icode[i][strcspn(icode[i], "\n")] = '\0'; // Remove newline character
    } while (strcmp(icode[i++], "exit") != 0);

    printf("\nTarget Code Generation:\n");
    printf("**********\n");

    i = 0;
    while (strcmp(icode[i], "exit") != 0) {
        // Parse each line of intermediate code
        if (sscanf(icode[i], "%s = %s %s %s", result, arg1, op, arg2) == 4) {
            add_code(result, arg1, op, arg2);
        } else if (sscanf(icode[i], "%s = %s", result, arg1) == 2) {
            add_code(result, arg1, "", "");
        }
        i++;
    }

    optimize_and_print_code();

    return 0;
}

void add_code(char *result, char *arg1, char *op, char *arg2) {
    strcpy(code[code_index].result, result);
    strcpy(code[code_index].arg1, arg1);
    strcpy(code[code_index].op, op);
    strcpy(code[code_index].arg2, arg2);
    code_index++;
}

void optimize_and_print_code() {
	int i=0;
    for ( i = 0; i < code_index; i++) {
        char *operation;

        // Map the operator symbols to assembly instructions
        if (strcmp(code[i].op, "+") == 0) {
            operation = "ADD";
        } else if (strcmp(code[i].op, "-") == 0) {
            operation = "SUB";
        } else if (strcmp(code[i].op, "*") == 0) {
            operation = "MUL";
        } else if (strcmp(code[i].op, "/") == 0) {
            operation = "DIV";
        } else {
            operation = "";
        }

        if (strcmp(code[i].op, "") == 0) {
            // Direct assignment
            printf("\tMov %s, %s\n", code[i].arg1, code[i].result);
        } else {
            // Operation with two operands
            printf("\tMov %s, R%d\n", code[i].arg1, i);
            printf("\t%s %s, R%d\n", operation, code[i].arg2, i);
            printf("\tMov R%d, %s\n", i, code[i].result);
        }
    }
}
