%{
    #include "yacc.tab.h"
    #include <math.h>
    #include <stdlib.h>

    // extern double yylval;
    // int yywrap();
%}

%option noyywrap

%%

"if"                    {return IF;}
"else"                  {return ELSE;}
"||"                    {return OR;}
"&&"                    {return AND;}
">"                     {return GT;}
">="                    {return GE;}
"<"                     {return LT;}
"<="                    {return LE;}
"=="                    {return EQ;}
"!="                    {return NE;}

"print"                 {return PRINT;}
\".*\"                  {return STRING;}

[0-9]+(\.[0-9]+)?       {return NUMBER;}

[a-zA-Z_][a-zA-Z_0-9]*  {return IDENTIFIER;}

;                       {return SEMICOLON;}
\n                      {;}
[\t ]+                  {;}
.                       {return yytext[0];}

%%

/* int yywrap() {
    return 0;
} */