%{
    #include "yacc.tab.h"
    #include <math.h>
    #include <stdlib.h>

    // #define YYSTYPE double
    // extern double yylval;
%}

%%

[0-9]+(\.[0-9]+)?       {yylval = atof(yytext); /*printf("Num: %d\n", yylval);*/ return NUMBER;}
[0-9]+                  {yylval = atoi(yytext); /*printf("Num: %d\n", yylval);*/ return NUMBER;}
[a-zA-Z]+               {return FUNCTION;}
[\t ]+                  {;}
\n                      {return END;}
.                       {return yytext[0];}

%%