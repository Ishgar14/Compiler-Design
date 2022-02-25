%{
    #include "token.h"

    TokenList *list;
    int state = LOOKUP;
%}


%%
\n              {state = LOOKUP;}
^keyword        {state = KEYWORD;}
^operator       {state = OPERATOR;}
^identifier     {state = IDENTIFIER;}
^delimiter      {state = DELIMITER;}
^constant       {state = CONSTANT;}


[a-zA-Z0-9]+|[=;\(\){}<>\+\-] {
    if (state != LOOKUP)
        append(list, yytext, state);
    else {
        // printf("Looking up \"%s\"\n", yytext);
        switch (lookup(list, yytext)) {
            case OPERATOR:
                printf("%-10s operator\n", yytext);
                break;
            case IDENTIFIER:
                printf("%-10s identifier\n", yytext);
                break;
            case KEYWORD:
                printf("%-10s keyword\n", yytext);
                break;
            case DELIMITER:
                printf("%-10s delimiter\n", yytext);
                break;
            case CONSTANT:
                printf("%-10s constant\n", yytext);
                break;
            default:
                printf("%-10s unknown\n", yytext);
        }
    }
}

.   {;}

%%

int yywrap(){
    return 1;
}

int main(int argc, char **argv) {
    list = new_token_list();
    if (argc == 1)      
        printf("Start typing boy\n");
    else if (argc == 2) {
        FILE* f = fopen(argv[1], "r");
        if (f != NULL)
            yyin = f;
        else 
            fprintf(stderr, "Error: Could not open file %s\n", argv[1]);
    }

    yylex();
    printf("\n");
}