#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int temp_count = 0;
const char *input;
int pos = 0;

// Define structure for AST nodes
typedef struct ASTNode {
    char op;
    struct ASTNode *left;
    struct ASTNode *right;
    char *value;
} ASTNode;

// Create a new AST node
ASTNode* create_node(char op, ASTNode *left, ASTNode *right, char *value) {
    ASTNode *node = (ASTNode*) malloc(sizeof(ASTNode));
    node->op = op;
    node->left = left;
    node->right = right;
    node->value = value ? strdup(value) : NULL;
    return node;
}

// Generate a unique temporary variable name
char* generate_temp() {
    char *temp = (char*) malloc(8);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

// Generate code for AST nodes
char* generate_code(ASTNode *node) {
    if (!node) return NULL;

    if (node->op == 0) {
        return node->value;
    } else {
        char *left_val = generate_code(node->left);
        char *right_val = generate_code(node->right);

        char *temp = generate_temp();
        printf("%s = %s %c %s\n", temp, left_val, node->op, right_val);
        return temp;
    }
}

// Parsing functions for handling different precedence levels
ASTNode* parse_expression();
ASTNode* parse_term();
ASTNode* parse_factor();

ASTNode* parse_expression() {
    ASTNode *node = parse_term();
    while (input[pos] == '+' || input[pos] == '-') {
        char op = input[pos++];
        ASTNode *right = parse_term();
        node = create_node(op, node, right, NULL);
    }
    return node;
}

ASTNode* parse_term() {
    ASTNode *node = parse_factor();
    while (input[pos] == '*' || input[pos] == '/') {
        char op = input[pos++];
        ASTNode *right = parse_factor();
        node = create_node(op, node, right, NULL);
    }
    return node;
}

ASTNode* parse_factor() {
    if (input[pos] == '(') {
        pos++; // Skip '('
        ASTNode *node = parse_expression();
        pos++; // Skip ')'
        return node;
    } else if (isalpha(input[pos])) {
        char var[2] = {input[pos++], '\0'};
        return create_node(0, NULL, NULL, var);
    }
    return NULL;
}

int main() {
    // Get the user input
    char buffer[100];
    printf("Enter an expression: ");
    scanf("%99s", buffer);

    // Set input to the buffer and initialize position
    input = buffer;
    pos = 0;

    // Parse the user input expression
    ASTNode *root = parse_expression();

    // Generate the three-address code
    printf("Three-Address Code:\n");
    generate_code(root);

    return 0;
}


