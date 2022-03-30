%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <stdbool.h>

    #define PI 3.1415926535
    #define to_radian(x) x * PI / 180

    extern char* yytext;
    extern FILE* yyin;

    int yylex();
    void yyerror(char const* s);
%}

%token IF ELSE
%token AND OR 
%token EQ NE GT GE LT LE
%token PRINT SEMICOLON
%token IDENTIFIER STRING

%token NUMBER 


%left '+' '-'
%left '*' '/'
%left '^'

%%

BLOCK: 
    IF '(' CONDITION ')' '{' STATEMENT '}'                        {printf("Parsed successfully!\n");}
|   IF '(' CONDITION ')' '{' STATEMENT '}' ELSE '{' STATEMENT '}' {printf("Parsed successfully!\n");}

|   IF CONDITION ')' '{' STATEMENT '}'                            {printf("Put '(' before condition\n");}
|   IF CONDITION ')' '{' STATEMENT '}' ELSE '{' STATEMENT '}'     {printf("Put '(' before condition\n");}

|   IF '(' CONDITION '{' STATEMENT '}'                            {printf("Put ')' after condition\n");}
|   IF '(' CONDITION '{' STATEMENT '}' ELSE '{' STATEMENT '}'     {printf("Put ')' after condition\n");}

|   IF CONDITION '{' STATEMENT '}'                                {printf("Put '(' before condition and ')' after condition\n");}
;

STATEMENT:
  ASSIGNMENT | PRINTER
;

ASSIGNMENT:
  IDENTIFIER '=' VALUE SEMICOLON             {/*printf("Assigning value\n");*/}
;

PRINTER:
 PRINT VALUE SEMICOLON        {/*printf("Printing identifier\n");*/}
;

VALUE: IDENTIFIER | NUMBER;

CONDITION:
  VALUE AND VALUE             {;}
| VALUE OR VALUE              {;}
| VALUE LE VALUE              {;}
| VALUE LT VALUE              {;}
| VALUE GE VALUE              {;}
| VALUE GT VALUE              {;}
| VALUE NE VALUE              {;}
| VALUE EQ VALUE              {;}
;

%%

int yywrap() {
    return 0;
}

void yyerror (char const *s) {
    /* fprintf(stderr, "%s: Unknown character '%s'\n", s, yytext); */
}

void main() {
  #if YYDEBUG
  yydebug = 1;
  #endif
  yyin = fopen("input.txt", "r");
  yyparse();
  fclose(yyin);
}