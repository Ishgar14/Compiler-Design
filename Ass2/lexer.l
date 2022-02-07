%{
    #include "token.h"

    #define COMMENT_CHECK if(!(inside_comment_block || single_line_comment))

    TokenList *list = NULL;
    int lineno = 1;
    char inside_comment_block = 0;
    int comment_block_index = -1;
    char single_line_comment = 0;

    char* trimquotes(char* string){
        char* result = strclone(string + 1);
        result[strlen(result) - 1] = 0;
        return result;
    }
%}

digit      [0-9]
letter     [a-zA-Z]
identifier {letter}({letter}|{digit})*
operator   [\+\-<>=\.\*&\|]
delimiter  [\(\)\[\]{},;]

%%

"auto"     |
"break"    |
"case"     |
"char"     |
"const"    |
"continue" |
"default"  |
"do"       |
"double"   |
"else"     |
"enum"     |
"extern"   |
"float"    |
"for"      |
"goto"     |
"if"       |
"int"      |
"long"     |
"register" |
"return"   |
"short"    |
"sizeof"   |
"static"   |
"struct"   |
"switch"   |
"typeof"   |
"union"    |
"unsigned" |
"void"     |
"volatile" |
"while"                      {COMMENT_CHECK{append(list, lineno, yytext, KEYWORD);}}
[\t ]+                       {;}
"//"                         {single_line_comment  = 1;}
"/*"                         {inside_comment_block = 1; comment_block_index = lineno;}
"*/"                         {inside_comment_block = 0; comment_block_index = -1;}
\".*\"                       {COMMENT_CHECK{append(list, lineno, "\"", DELIMITER); append(list, lineno, trimquotes(yytext), CONSTANT); append(list, lineno, "\"", DELIMITER);}}
\"                           {COMMENT_CHECK{printf("Error: String on line %d has to end on same line\n", lineno);}}
{digit}+                     {COMMENT_CHECK{append(list, lineno, yytext, CONSTANT);}}
{identifier}                 {COMMENT_CHECK{append(list, lineno, yytext, IDENTIFIER);}}
{delimiter}                  {COMMENT_CHECK{append(list, lineno, yytext, DELIMITER);}}
">=" | 
"<=" | 
"==" | 
"!=" |
"++" | 
"--" | 
"||" | 
"&&"                         {COMMENT_CHECK{append(list, lineno, yytext, OPERATOR);} }
{operator}                   {COMMENT_CHECK{append(list, lineno, yytext, OPERATOR);}}
\n                           {if(single_line_comment) single_line_comment = 0; lineno++;}
.                            {;}

%%

int main(int argc, char* argv[]){
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
    
    yylex(); // Start tokenising
    
    // Error checking for unclosed comment blocks
    if (inside_comment_block){
        printf("Error: Comment block on line %d was not closed!\n", comment_block_index);
        /* return 0; */
    }
    printf("\n\n");

    TokenNode *node = list->head;

    printf("%s %-25s %s\n", "Line no", "Lexeme", "Token");
    
    while(node){
        printf("%-7d %-25s %-5s\n", node->lineno, node->lexeme, str_token(node->type));
        node = node->next;
    }

    // Symbol Table
    TokenList *_ids = filter(list, IDENTIFIER);
    TokenList *identifiers = unique(_ids);
    clear(_ids);
    node = identifiers->head;
    printf("\n\n======= Symbol Table =======\n");
    printf("%-7s %s\n", "Index", "Identifier");
    for(int i = 1; node; node = node->next, i++) {
        printf("%-7d %-25s\n", i, node->lexeme);
    }

    clear(list);
    clear(identifiers);
    return 0;
}

int yywrap() {
    return 1;
}