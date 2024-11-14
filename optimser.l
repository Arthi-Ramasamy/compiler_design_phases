%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

[0-9]+             { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]* { yylval.str = strdup(yytext); return ID; }
"="                { return ASSIGN; }
"+"                { return PLUS; }
"-"                { return MINUS; }
"*"                { return MULT; }
"/"                { return DIV; }
[ \t\n]+           ; // Ignore whitespace and newlines
.                  { return yytext[0]; }

%%

int yywrap() {
    return 1;
}

