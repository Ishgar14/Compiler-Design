#include <string.h>

#define streq(a, b) (strcmp(a, b) == 0)

typedef enum {
    CONSTANT,
    IDENTIFIER,
    KEYWORD,
    OPERATOR,
    DELIMITER
} TokenType;

const char* str_token(TokenType token) {
    switch (token) {
        case CONSTANT:
            return "CONSTANT";
        case IDENTIFIER:
            return "IDENTIFIER";
        case KEYWORD:
            return "KEYWORD";
        case OPERATOR:
            return "OPERATOR";
        case DELIMITER:
            return "DELIMITER";
        default:
            return NULL;
    }
}

typedef struct TokenNode {
    unsigned int lineno;
    char* lexeme;
    TokenType type;
    struct TokenNode* next;
} TokenNode;

typedef struct {
    TokenNode *head, *tail;
    int len;
} TokenList;

static char* strclone(char* string) {
    int len = 0;
    while (string[len]) len++;
    char* buffer = malloc(sizeof(char) * (len + 1));
    buffer[len] = 0;

    for (int i = 0; i < len; i++)
        buffer[i] = string[i];

    return buffer;
}

static TokenNode* new_token(int lineno, char* lexeme, TokenType type) {
    TokenNode* node = malloc(sizeof(TokenNode));
    node->lineno = lineno;
    node->lexeme = strclone(lexeme);
    node->type = type;
    return node;
}

TokenList* new_token_list() {
    TokenList* lst = malloc(sizeof(TokenList));
    lst->head = lst->tail = NULL;
    lst->len = 0;
    return lst;
}

void append(TokenList* self, int lineno, char* lexeme, TokenType type) {
    // printf("%-10s %-10s\n", lexeme, str_token(type));
    TokenNode* node = new_token(lineno, lexeme, type);
    if (!self) {
        fprintf(stderr, "Cannot append to empty token list\n");
        return;
    }

    if (!self->head) {
        self->head = node;
        self->tail = node;
        self->len = 1;
        return;
    }

    self->tail->next = node;
    self->tail = node;
    self->len++;
}

void clear(TokenList *self){
    TokenNode *node = self->head;
    while (node){
        TokenNode* next = node->next;
        free(node->lexeme);
        free(node);
        node = next;
    }
    self->head = self->tail = NULL;
}


int token_index(TokenList* self, char* lexeme){
    if(!self) return -1;
    TokenNode *node = self->head;
    for(int i = 0; node; node = node->next, i++){
        if (node->lexeme == lexeme || streq(node->lexeme, lexeme))
            return i;
    }
    return -1;
}

char contains(TokenList *self, char *lexeme){
    return token_index(self, lexeme) != -1;
}

// This function takes in a TokenList and TokenType and returns all tokens which match `type`
TokenList* filter(TokenList *self, TokenType type){
    TokenList* result = new_token_list();
    TokenNode* node = self->head;
 
    while(node){
        if (node->type == type)
            append(result, node->lineno, strclone(node->lexeme), type);
        node = node->next;
    }

    return result;
}

// This function accepts a list and returns a new list with no duplicate values
TokenList* unique(TokenList *self) {
    TokenList *result = new_token_list();
    TokenNode *node = self->head;
    while(node){
        if (!contains(result, node->lexeme))
            append(result, node->lineno, node->lexeme, node->type);
        node = node->next;
    }
    return result;
}