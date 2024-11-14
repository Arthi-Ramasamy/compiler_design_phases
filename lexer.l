%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int line_number = 1;
%}

%%

    /* Keywords */
"auto"          { printf("LEX: Keyword: %s\n", yytext); return AUTO; }
"break"         { printf("LEX: Keyword: %s\n", yytext); return BREAK; }
"case"          { printf("LEX: Keyword: %s\n", yytext); return CASE; }
"char"          { printf("LEX: Keyword: %s\n", yytext); return CHAR; }
"const"         { printf("LEX: Keyword: %s\n", yytext); return CONST; }
"continue"      { printf("LEX: Keyword: %s\n", yytext); return CONTINUE; }
"default"       { printf("LEX: Keyword: %s\n", yytext); return DEFAULT; }
"do"            { printf("LEX: Keyword: %s\n", yytext); return DO; }
"double"        { printf("LEX: Keyword: %s\n", yytext); return DOUBLE; }
"else"          { printf("LEX: Keyword: %s\n", yytext); return ELSE; }
"enum"          { printf("LEX: Keyword: %s\n", yytext); return ENUM; }
"extern"        { printf("LEX: Keyword: %s\n", yytext); return EXTERN; }
"float"         { printf("LEX: Keyword: %s\n", yytext); return FLOAT_TYPE; }
"for"           { printf("LEX: Keyword: %s\n", yytext); return FOR; }
"goto"          { printf("LEX: Keyword: %s\n", yytext); return GOTO; }
"if"            { printf("LEX: Keyword: %s\n", yytext); return IF; }
"int"           { printf("LEX: Keyword: %s\n", yytext); return INT; }
"long"          { printf("LEX: Keyword: %s\n", yytext); return LONG; }
"register"      { printf("LEX: Keyword: %s\n", yytext); return REGISTER; }
"return"        { printf("LEX: Keyword: %s\n", yytext); return RETURN; }
"short"         { printf("LEX: Keyword: %s\n", yytext); return SHORT; }
"signed"        { printf("LEX: Keyword: %s\n", yytext); return SIGNED; }
"sizeof"        { printf("LEX: Keyword: %s\n", yytext); return SIZEOF; }
"static"        { printf("LEX: Keyword: %s\n", yytext); return STATIC; }
"struct"        { printf("LEX: Keyword: %s\n", yytext); return STRUCT; }
"switch"        { printf("LEX: Keyword: %s\n", yytext); return SWITCH; }
"typedef"       { printf("LEX: Keyword: %s\n", yytext); return TYPEDEF; }
"union"         { printf("LEX: Keyword: %s\n", yytext); return UNION; }
"unsigned"      { printf("LEX: Keyword: %s\n", yytext); return UNSIGNED; }
"void"          { printf("LEX: Keyword: %s\n", yytext); return VOID; }
"volatile"      { printf("LEX: Keyword: %s\n", yytext); return VOLATILE; }
"while"         { printf("LEX: Keyword: %s\n", yytext); return WHILE; }

    /* Constants */
[0-9]+          { printf("LEX: Integer constant: %s\n", yytext); 
                  yylval.integer = atoi(yytext); return INTEGER; }
[0-9]+\.[0-9]+  { printf("LEX: Float constant: %s\n", yytext);
                  yylval.float_val = atof(yytext); return FLOAT_CONST; }
\'[^\']\'       { printf("LEX: Character constant: %s\n", yytext);
                  yylval.character = yytext[1]; return CHAR_CONST; }
\"[^\"]*\"      { printf("LEX: String literal: %s\n", yytext);
                  yylval.string = strdup(yytext); return STRING_LITERAL; }

    /* Identifiers */
[a-zA-Z_][a-zA-Z0-9_]* { printf("LEX: Identifier: %s\n", yytext);
                         yylval.string = strdup(yytext); return IDENTIFIER; }

    /* Assignment Operators */
"="             { printf("LEX: Assignment: %s\n", yytext); return ASSIGN; }
"+="            { printf("LEX: Assignment: %s\n", yytext); return PLUS_ASSIGN; }
"-="            { printf("LEX: Assignment: %s\n", yytext); return MINUS_ASSIGN; }
"*="            { printf("LEX: Assignment: %s\n", yytext); return MUL_ASSIGN; }
"/="            { printf("LEX: Assignment: %s\n", yytext); return DIV_ASSIGN; }
"%="            { printf("LEX: Assignment: %s\n", yytext); return MOD_ASSIGN; }
"<<="           { printf("LEX: Assignment: %s\n", yytext); return LEFT_SHIFT_ASSIGN; }
">>="           { printf("LEX: Assignment: %s\n", yytext); return RIGHT_SHIFT_ASSIGN; }
"&="            { printf("LEX: Assignment: %s\n", yytext); return AND_ASSIGN; }
"|="            { printf("LEX: Assignment: %s\n", yytext); return OR_ASSIGN; }
"^="            { printf("LEX: Assignment: %s\n", yytext); return XOR_ASSIGN; }

    /* Arithmetic Operators */
"+"             { printf("LEX: Arithmetic: %s\n", yytext); return PLUS; }
"-"             { printf("LEX: Arithmetic: %s\n", yytext); return MINUS; }
"*"             { printf("LEX: Arithmetic: %s\n", yytext); return MULTIPLY; }
"/"             { printf("LEX: Arithmetic: %s\n", yytext); return DIVIDE; }
"%"             { printf("LEX: Arithmetic: %s\n", yytext); return MODULO; }
"++"            { printf("LEX: Arithmetic: %s\n", yytext); return INCREMENT; }
"--"            { printf("LEX: Arithmetic: %s\n", yytext); return DECREMENT; }

    /* Relational Operators */
"=="            { printf("LEX: Relational: %s\n", yytext); return EQUAL; }
"!="            { printf("LEX: Relational: %s\n", yytext); return NOT_EQUAL; }
">"             { printf("LEX: Relational: %s\n", yytext); return GREATER; }
"<"             { printf("LEX: Relational: %s\n", yytext); return LESS; }
">="            { printf("LEX: Relational: %s\n", yytext); return GREATER_EQUAL; }
"<="            { printf("LEX: Relational: %s\n", yytext); return LESS_EQUAL; }

    /* Logical Operators */
"&&"            { printf("LEX: Logical: %s\n", yytext); return LOGICAL_AND; }
"||"            { printf("LEX: Logical: %s\n", yytext); return LOGICAL_OR; }
"!"             { printf("LEX: Logical: %s\n", yytext); return LOGICAL_NOT; }

    /* Bitwise Operators */
"&"             { printf("LEX: Bitwise: %s\n", yytext); return BIT_AND; }
"|"             { printf("LEX: Bitwise: %s\n", yytext); return BIT_OR; }
"^"             { printf("LEX: Bitwise: %s\n", yytext); return BIT_XOR; }
"<<"            { printf("LEX: Bitwise: %s\n", yytext); return LEFT_SHIFT; }
">>"            { printf("LEX: Bitwise: %s\n", yytext); return RIGHT_SHIFT; }
"~"             { printf("LEX: Bitwise: %s\n", yytext); return BIT_NOT; }

    /* Special Operators */
"?"             { printf("LEX: Special: Conditional\n"); return QUESTION; }
":"             { printf("LEX: Special: Colon\n"); return COLON; }
"->"            { printf("LEX: Special: Arrow\n"); return ARROW; }
"."             { printf("LEX: Special: Dot\n"); return DOT; }

    /* Delimiters */
"("             { printf("LEX: Delimiter: (\n"); return LPAREN; }
")"             { printf("LEX: Delimiter: )\n"); return RPAREN; }
"{"             { printf("LEX: Delimiter: {\n"); return LBRACE; }
"}"             { printf("LEX: Delimiter: }\n"); return RBRACE; }
"["             { printf("LEX: Delimiter: [\n"); return LBRACKET; }
"]"             { printf("LEX: Delimiter: ]\n"); return RBRACKET; }
","             { printf("LEX: Delimiter: ,\n"); return COMMA; }
";"             { printf("LEX: Delimiter: ;\n"); return SEMICOLON; }
"..."           { printf("LEX: Delimiter: ...\n"); return ELLIPSIS; }

    /* Comments */
"//".*          { printf("LEX: Single-line comment\n"); }
"/*"([^*]|\*+[^*/])*\*+"/"  { printf("LEX: Multi-line comment\n"); }

    /* Whitespace */
[ \t\r]         ; /* Skip whitespace */
\n              { line_number++; }

    /* Catch errors */
.               { printf("LEX Error: Unexpected character '%s' at line %d\n", yytext, line_number); }

%%

int yywrap(void) {
    return 1;
} 
