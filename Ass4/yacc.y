%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>

    // #define YYSTYPE double
    #define PI 3.1415926535
    #define to_radian(x) x * PI / 180

    int yylex();
    void yyerror(char const* s);
%}

%union {
    double dval;
};

%token <dval> NUMBER 
%token <dval> SIN COS TAN
%token <dval> LN LOG SQRT
%token END

%type <dval> expression functionCall trigonometric arithmetic

%left '+' '-'
%left '*' '/'
%left '^'

%nonassoc UNIMINUS

%%

statement: 
expression END                  {printf(" = %lf\n", $1); return 0;}
;

expression: 
  expression '+' expression             {$$ = $1 + $3;}
| expression '-' expression             {$$ = $1 - $3;}
| expression '*' expression             {$$ = $1 * $3;}
| expression '/' expression             {if($3 == 0) {printf("Denominator cannot be zero\n"); return 0;} $$ = $1 / $3;}
| expression '^' expression             {$$ = pow($1, $3);}
| expression '%' expression             {$$ = fmod($1, $3);}
| '-' expression %prec UNIMINUS         {$$ = -$2;}
| '(' expression ')'                    {$$ = $2;}
| functionCall                          {$$ = $1;}
| NUMBER                                {$$ = $1;}
;

functionCall:
trigonometric       {$$ = $1;}
| arithmetic        {$$ = $1;}

trigonometric:
SIN NUMBER          {$$ = sin(to_radian($2));}
| COS NUMBER        {$$ = cos(to_radian($2));}
| TAN NUMBER        {$$ = tan(to_radian($2));}
;

arithmetic:
LN NUMBER           {$$ = log($2);}
| LOG NUMBER        {$$ = log($2) / log(10);}
| SQRT NUMBER       {$$ = sqrt($2);}
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