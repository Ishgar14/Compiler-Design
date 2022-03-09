%{
    #include "yacc.tab.h"
    #include <math.h>
    #include <stdlib.h>

    // extern double yylval;
%}

%%


[0-9]+                  {yylval = atoi(yytext); return NUMBER;}

sin                     {return SIN;}
cos                     {return COS;}
tan                     {return TAN;}

\n                      {return END;}

[\t ]+                  {;}
.                       {return yytext[0];}

%%