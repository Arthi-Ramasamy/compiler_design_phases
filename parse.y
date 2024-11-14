%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "intermediate_code.h"
extern FILE* yyin;
// Node types for AST
typedef enum {
    NODE_PROGRAM,
    NODE_FUNCTION,
    NODE_DECLARATION,
    NODE_IF,
    NODE_WHILE,
    NODE_FOR,
    NODE_RETURN,
    NODE_COMPOUND,
    NODE_EXPRESSION,
    NODE_OPERATOR,
    NODE_IDENTIFIER,
    NODE_CONSTANT,
    NODE_TYPE
} NodeType;

typedef struct Node {
    NodeType type;
    char* value;
    struct Node* left;
    struct Node* right;
    struct Node* next;
    struct Node* children;
} Node;

// Add this declaration at the top of parse.y
Node* create_node(NodeType type, char *value) {
    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->type = type;
    new_node->value = strdup(value);
    new_node->left = new_node->right = new_node->next = NULL;
    return new_node;
}

void print_ast(Node *node, int depth) {
    if (!node) return;
    for (int i = 0; i < depth; ++i) {
        printf("  ");  // Indentation for depth
    }
    printf("%s\n", node->value);  // Print node value
    print_ast(node->left, depth + 1);
    print_ast(node->right, depth + 1);
}



void print_ast_dot(Node* node, FILE *output) {
    static int node_counter = 0;
    int current_id = node_counter++;
    if (node == NULL) return;

    // Print current node in DOT format
    fprintf(output, "  node%d [label=\"", current_id);
    switch (node->type) {
        case NODE_PROGRAM: fprintf(output, "Program"); break;
        case NODE_FUNCTION: fprintf(output, "Function: %s", node->value); break;
        case NODE_DECLARATION: fprintf(output, "Declaration: %s", node->value); break;
        case NODE_IF: fprintf(output, "If"); break;
        case NODE_WHILE: fprintf(output, "While"); break;
        case NODE_FOR: fprintf(output, "For"); break;
        case NODE_RETURN: fprintf(output, "Return"); break;
        case NODE_COMPOUND: fprintf(output, "Compound"); break;
        case NODE_EXPRESSION: fprintf(output, "Expression"); break;
        case NODE_OPERATOR: fprintf(output, "Operator: %s", node->value); break;
        case NODE_IDENTIFIER: fprintf(output, "Identifier: %s", node->value); break;
        case NODE_CONSTANT: fprintf(output, "Constant: %s", node->value); break;
        case NODE_TYPE: fprintf(output, "Type: %s", node->value); break;
    }
    fprintf(output, "\"];\n");

    // Print edges in DOT format
    if (node->children) {
        fprintf(output, "  node%d -> node%d;\n", current_id, node_counter);
        print_ast_dot(node->children, output);
    }
    if (node->left) {
        fprintf(output, "  node%d -> node%d;\n", current_id, node_counter);
        print_ast_dot(node->left, output);
    }
    if (node->right) {
        fprintf(output, "  node%d -> node%d;\n", current_id, node_counter);
        print_ast_dot(node->right, output);
    }
    if (node->next) {
        fprintf(output, "  node%d -> node%d;\n", current_id, node_counter);
        print_ast_dot(node->next, output);
    }
}

void generate_dot_file(Node* root, const char* filename) {
    FILE *output = fopen(filename, "w");
    if (!output) {
        fprintf(stderr, "Error opening file for writing.\n");
        return;
    }

    fprintf(output, "digraph AST {\n");
    print_ast_dot(root, output);
    fprintf(output, "}\n");

    fclose(output);
    printf("DOT file '%s' generated.\n", filename);
}

void yyerror(const char *s);
int yylex(void);
Node* ast_root = NULL;

%}

%union {
    int integer;
    float float_val;
    char *string;
    char character;
    struct Node* node;
}

/* Token declarations */
%token <string> IDENTIFIER
%token <integer> INTEGER
%token <float_val> FLOAT_CONST
%token <character> CHAR_CONST
%token <string> STRING_LITERAL

/* Keywords */
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE
%token ENUM EXTERN FLOAT_TYPE FOR GOTO IF INT LONG REGISTER RETURN
%token SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION
%token UNSIGNED VOID VOLATILE WHILE

/* Operators */
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token INCREMENT DECREMENT
%token ASSIGN PLUS_ASSIGN MINUS_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN
%token LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token EQUAL NOT_EQUAL GREATER LESS GREATER_EQUAL LESS_EQUAL
%token LOGICAL_AND LOGICAL_OR LOGICAL_NOT
%token BIT_AND BIT_OR BIT_XOR LEFT_SHIFT RIGHT_SHIFT BIT_NOT
%token QUESTION COLON ARROW DOT

/* Delimiters */
%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token COMMA SEMICOLON ELLIPSIS

/* Non-terminal type declarations */
%type <node> program translation_unit external_declaration function_definition
%type <node> declaration compound_statement statement expression
%type <node> statement_list declaration_list init_declarator_list
%type <node> init_declarator type_specifier expression_statement
%type <node> selection_statement iteration_statement jump_statement
%type <node> assignment_expression conditional_expression
%type <node> logical_or_expression logical_and_expression
%type <node> equality_expression relational_expression
%type <node> additive_expression multiplicative_expression
%type <node> unary_expression primary_expression
%type <node> parameter_list parameter_list_opt parameter_declaration

/* Operator precedence */
%right ASSIGN
%left LOGICAL_OR
%left LOGICAL_AND
%left BIT_OR
%left BIT_XOR
%left BIT_AND
%left EQUAL NOT_EQUAL
%left GREATER LESS GREATER_EQUAL LESS_EQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO

%%

program
    : translation_unit
    { 
        $$ = create_node(NODE_PROGRAM, "program");
        $$->children = $1;
        ast_root = $$;
        printf("\nAbstract Syntax Tree:\n");
        print_ast(ast_root, 0);
    }
    ;

translation_unit
    : external_declaration
    { $$ = $1; }
    | translation_unit external_declaration
    { 
        $$ = $1;
        $$->next = $2;
    }
    ;

external_declaration
    : function_definition
    { $$ = $1; }
    | declaration
    { $$ = $1; }
    ;

function_definition
    : type_specifier IDENTIFIER LPAREN parameter_list_opt RPAREN compound_statement
    {
        $$ = create_node(NODE_FUNCTION, $2);
        $$->left = $1;
        $$->right = $6;
        printf("PARSER: Function definition found: %s\n", $2);
    }
    ;

parameter_list_opt
    : /* empty */
    { $$ = NULL; }
    | parameter_list
    { $$ = $1; }
    ;

parameter_list
    : parameter_declaration
    { $$ = $1; }
    | parameter_list COMMA parameter_declaration
    {
        $$ = $1;
        $$->next = $3;
    }
    ;

parameter_declaration
    : type_specifier IDENTIFIER
    {
        $$ = create_node(NODE_DECLARATION, $2);
        $$->left = $1;
    }
    ;

declaration
    : type_specifier init_declarator_list SEMICOLON
    {
        $$ = create_node(NODE_DECLARATION, "var_decl");
        $$->left = $1;
        $$->right = $2;
        printf("PARSER: Variable declaration processed\n");
    }
    ;

type_specifier
    : INT { $$ = create_node(NODE_TYPE, "int"); }
    | CHAR { $$ = create_node(NODE_TYPE, "char"); }
    | VOID { $$ = create_node(NODE_TYPE, "void"); }
    | FLOAT_TYPE { $$ = create_node(NODE_TYPE, "float"); }
    ;

init_declarator_list
    : init_declarator
    { $$ = $1; }
    | init_declarator_list COMMA init_declarator
    {
        $$ = $1;
        $$->next = $3;
    }
    ;

init_declarator
    : IDENTIFIER
    { $$ = create_node(NODE_IDENTIFIER, $1); }
    | IDENTIFIER ASSIGN expression
    {
        $$ = create_node(NODE_OPERATOR, "=");
        $$->left = create_node(NODE_IDENTIFIER, $1);
        $$->right = $3;
        printf("PARSER: Variable initialization processed\n");
    }
    ;

compound_statement
    : LBRACE declaration_list statement_list RBRACE
    {
        $$ = create_node(NODE_COMPOUND, "compound");
        $$->left = $2;
        $$->right = $3;
        printf("PARSER: Compound statement processed\n");
    }
    | LBRACE statement_list RBRACE
    {
        $$ = create_node(NODE_COMPOUND, "compound");
        $$->children = $2;
        printf("PARSER: Compound statement processed\n");
    }
    | LBRACE RBRACE
    {
        $$ = create_node(NODE_COMPOUND, "compound");
        printf("PARSER: Empty compound statement processed\n");
    }
    ;

declaration_list
    : declaration
    { $$ = $1; }
    | declaration_list declaration
    {
        $$ = $1;
        $$->next = $2;
    }
    ;

statement_list
    : statement
    { $$ = $1; }
    | statement_list statement
    {
        $$ = $1;
        $$->next = $2;
    }
    ;

statement
    : compound_statement
    { $$ = $1; }
    | expression_statement
    { $$ = $1; }
    | selection_statement
    { $$ = $1; }
    | iteration_statement
    { $$ = $1; }
    | jump_statement
    { $$ = $1; }
    ;

expression_statement
    : expression SEMICOLON
    { $$ = $1; }
    | SEMICOLON
    { $$ = NULL; }
    ;

selection_statement
    : IF LPAREN expression RPAREN statement
    {
        $$ = create_node(NODE_IF, "if");
        $$->left = $3;
        $$->right = $5;
        printf("PARSER: IF statement processed\n");
    }
    | IF LPAREN expression RPAREN statement ELSE statement
    {
        $$ = create_node(NODE_IF, "if_else");
        $$->left = $3;
        $$->right = $5;
        $$->next = $7;
        printf("PARSER: IF-ELSE statement processed\n");
    }
    ;

iteration_statement
    : WHILE LPAREN expression RPAREN statement
    {
        $$ = create_node(NODE_WHILE, "while");
        $$->left = $3;
        $$->right = $5;
        printf("PARSER: WHILE statement processed\n");
    }
    ;

jump_statement
    : RETURN expression SEMICOLON
    {
        $$ = create_node(NODE_RETURN, "return");
        $$->left = $2;
        printf("PARSER: RETURN statement processed\n");
    }
    ;

expression
    : assignment_expression
    { $$ = $1; }
    ;

assignment_expression
    : IDENTIFIER ASSIGN expression
    {
        $$ = create_node(NODE_OPERATOR, "=");
        $$->left = create_node(NODE_IDENTIFIER, $1);
        $$->right = $3;
        printf("PARSER: Assignment expression processed\n");
    }
    | conditional_expression
    { $$ = $1; }
    ;

conditional_expression
    : logical_or_expression
    { $$ = $1; }
    ;

logical_or_expression
    : logical_and_expression
    { $$ = $1; }
    | logical_or_expression LOGICAL_OR logical_and_expression
    {
        $$ = create_node(NODE_OPERATOR, "||");
        $$->left = $1;
        $$->right = $3;
    }
    ;

logical_and_expression
    : equality_expression
    { $$ = $1; }
    | logical_and_expression LOGICAL_AND equality_expression
    {
        $$ = create_node(NODE_OPERATOR, "&&");
        $$->left = $1;
        $$->right = $3;
    }
    ;

equality_expression
    : relational_expression
    { $$ = $1; }
    | equality_expression EQUAL relational_expression
    {
        $$ = create_node(NODE_OPERATOR, "==");
        $$->left = $1;
        $$->right = $3;
    }
    | equality_expression NOT_EQUAL relational_expression
    {
        $$ = create_node(NODE_OPERATOR, "!=");
        $$->left = $1;
        $$->right = $3;
    }
    ;

relational_expression
    : additive_expression
    { $$ = $1; }
    | relational_expression LESS additive_expression
    {
        $$ = create_node(NODE_OPERATOR, "<");
        $$->left = $1;
        $$->right = $3;
    }
    | relational_expression GREATER additive_expression
    {
        $$ = create_node(NODE_OPERATOR, ">");
        $$->left = $1;
        $$->right = $3;
    }
    | relational_expression LESS_EQUAL additive_expression
    {
        $$ = create_node(NODE_OPERATOR, "<=");
        $$->left = $1;
        $$->right = $3;
    }
    | relational_expression GREATER_EQUAL additive_expression
    {
        $$ = create_node(NODE_OPERATOR, ">=");
        $$->left = $1;
        $$->right = $3;
    }
    ;

additive_expression
    : multiplicative_expression
    { $$ = $1; }
    | additive_expression PLUS multiplicative_expression
    {
        $$ = create_node(NODE_OPERATOR, "+");
        $$->left = $1;
        $$->right = $3;
    }
    | additive_expression MINUS multiplicative_expression
    {
        $$ = create_node(NODE_OPERATOR, "-");
        $$->left = $1;
        $$->right = $3;
    }
    ;

multiplicative_expression
    : unary_expression
    { $$ = $1; }
    | multiplicative_expression MULTIPLY unary_expression
    {
        $$ = create_node(NODE_OPERATOR, "*");
        $$->left = $1;
        $$->right = $3;
    }
    | multiplicative_expression DIVIDE unary_expression
    {
        $$ = create_node(NODE_OPERATOR, "/");
        $$->left = $1;
        $$->right = $3;
    }
    | multiplicative_expression MODULO unary_expression
    {
        $$ = create_node(NODE_OPERATOR, "%");
        $$->left = $1;
        $$->right = $3;
    }
    ;

unary_expression
    : primary_expression
    { $$ = $1; }
    | PLUS unary_expression
    { $$ = create_node(NODE_OPERATOR, "+"); $$->left = $2; }
    | MINUS unary_expression
    { $$ = create_node(NODE_OPERATOR, "-"); $$->left = $2; }
    ;

primary_expression
    : IDENTIFIER
    { $$ = create_node(NODE_IDENTIFIER, $1); }
    | INTEGER
    {
        // Convert the integer to a string to pass as `char *` to `create_node`
        char value_str[20];
        sprintf(value_str, "%d", $1);
        $$ = create_node(NODE_CONSTANT, value_str);
    }
    | LPAREN expression RPAREN
    { $$ = $2; }
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        printf("Error: Cannot open file '%s'\n", argv[1]);
        return 1;
    }
    printf("\n====== LEXICAL ANALYSIS ======\n");
    yyin = input_file;
    int result = yyparse();
    fclose(input_file);

    if (result == 0) {
        printf("\n====== SYNTAX ANALYSIS======\n");
        generate_dot_file(ast_root, "ast_tree.dot");
        printf("You can view the AST tree by running:\n");
        printf("dot -Tpng ast_tree.dot -o ast_tree.png\n");
    } else {
        printf("\n=== Syntax Analysis Failed ===\n");
    }
    printf("Generating Three-Address Code:\n");
    generate_code(ast_root);
    return result;

}

