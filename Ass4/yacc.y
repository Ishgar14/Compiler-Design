%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>

    // #define YYSTYPE double

    int yylex();
    void yyerror(char const* s);
%}

%token NUMBER 
%token SIN COS TAN
%token END

%left '+' '-'
%left '*' '/'

%%

statement: 
expression END                  {printf(" = %d\n", $1); return 0;}
;

expression: 
  expression '+' expression             {$$ = $1 + $3;}
| expression '-' expression             {$$ = $1 - $3;}
| expression '*' expression             {$$ = $1 * $3;}
| expression '/' expression             {$$ = $1 / $3;}
| expression '^' expression             {$$ = pow($1, $3);}
| expression '%' expression             {$$ = fmod($1, $3);}
| '(' expression ')'                    {$$ = $2;}
| functionCall                          {$$ = $1;}
| NUMBER                                {$$ = $1;}
;

functionCall:
SIN NUMBER          {$$ = sin(to_radian($2));}
| COS NUMBER        {$$ = cos(to_radian($2));}
| TAN NUMBER        {$$ = tan(to_radian($2));}
;

%%

int yywrap() {
    return 0;
}

void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}

void main() {
    yyparse();
}