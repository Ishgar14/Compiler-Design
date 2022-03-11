%{
    #include "yacc.tab.h"
    #include <math.h>
    #include <stdlib.h>

    // extern double yylval;
%}

%%


[0-9]+(\.[0-9]+)?       {yylval.dval = atof(yytext); return NUMBER;}

sin                     {return SIN;}
cos                     {return COS;}
tan                     {return TAN;}

log                     {return LOG;}
ln                      {return LN;}
sqrt                    {return SQRT;}

\n                      {return END;}

[\t ]+                  {;}
.                       {return yytext[0];}

%%