%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>

    // #define YYSTYPE double

    int yylex();
    void yyerror(char const* s);

    /*
    #define ITERATIONS 10

    int power(int base, int power){
        int result = 1;
        for(int i = 0; i < power; i++)
            result *= base;
        return result;
    }

    int factorial(int val){
        int result = 1;

        for(int i = 1; i <= val; i++)
            result *= i;
        
        return result;
    }
    
    double sin(double x) {
        double result = 0;
        for(int i = 0; i < ITERATIONS; i++){
            // x - x^3/3! + x^5/5!
            result += power(-1, i) * power(x, 2 * i + 1) / factorial(2 * i + 1);
        }
        return result;
    }
    */
%}

%token NUMBER 
%token FUNCTION
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
| expression '%' expression             {$$ = fmod($1, $3);}
| functionCall                          {$$ = $1;}
| NUMBER                                {$$ = $1;}
;

functionCall:
FUNCTION expression    {$$ = cos($2);}
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