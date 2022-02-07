from typing import List, Tuple

KEYWORDS = set()
DELIMITERS = set(r"(){}[],;")
OPERATOR = set(r'=<>+-*/&|.!')
TWO_LEN_OPERATORS = ['++', '--', '+=', '-=', '*=', '/=', '<=', '>=', '==', '&&', '||']
# list of (line number, identifier name)
SYMBOL_TABLE: List[Tuple[int, str]] = []


def classify(word: str) -> str:
    if not word or len(word) == 0:
        return None

    if word in DELIMITERS:
        return 'delimiter'
    elif word in KEYWORDS:
        return 'keyword'
    elif word in OPERATOR:
        return 'operator'
    elif word.isnumeric():
        return 'constant'
    elif word.isalnum() and word[0].isalpha():
        return 'identifier'
    else:
        return None


def get_token_value(lexeme: str, classification: str) -> str:
    delimiter_list, keyword_list, operator_list = list(DELIMITERS), sorted(list(KEYWORDS)), list(OPERATOR)
    if classification == 'delimiter':
        return '(DL, {})'.format(delimiter_list.index(lexeme) + 1)
    if classification == 'keyword':
        return '(KW, {})'.format(keyword_list.index(lexeme) + 1)
    if classification == 'operator':
        if len(lexeme) > 1:
            return '(OP, {})'.format(len(operator_list) + TWO_LEN_OPERATORS.index(lexeme) + 1)
        else:
            return '(OP, {})'.format(operator_list.index(lexeme) + 1)
    if classification == 'constant':
        return '(C, {})'.format(lexeme)
    if classification == 'identifier':
        identifiers = [id[1] for id in SYMBOL_TABLE]
        return '(ID, {})'.format(identifiers.index(lexeme) + 1)
    return None


# This function parses one line and returns list of tuple of (line number, lexeme, token type)
def parse_line(line: str, linenumber: int) -> List[Tuple[int, str, str]]:
    token_list = []
    prev, now = 0, 0
    i = 0
    while i < len(line):
        if line[i].isalnum():
            now += 1

        elif line[i] == ' ':
            if line[prev] == ' ':
                prev += 1
            word = line[prev:i]

            if not word:
                prev = now = i
                i += 1
                continue

            classification = classify(word)
            if not classification:
                print(f"Unknown token: '{word}' on line {linenumber}")
            else:
                if classification == 'identifier':
                    identifiers = set(id[1] for id in SYMBOL_TABLE)
                    if word not in identifiers:
                        SYMBOL_TABLE.append((linenumber, word))
                token_list.append(
                    (linenumber, word, classification, get_token_value(word, classification)))

            prev = now = i + 1

        elif line[i] in DELIMITERS:
            if prev < now:
                if line[prev] == ' ':
                    prev += 1
                word = line[prev:i]

                if word:
                    classification = classify(word)

                    if not classification:
                        print(f"Unknown token: '{word}' on line {linenumber}")
                    else:
                        if classification == 'identifier':
                            identifiers = set(id[1] for id in SYMBOL_TABLE)
                            if word not in identifiers:
                                SYMBOL_TABLE.append((linenumber, word))
                        token_list.append(
                            (linenumber, word, classification, get_token_value(word, classification)))

            token_list.append(
                (linenumber, line[i], 'delimiter', get_token_value(line[i], 'delimiter')))
            prev, now = i + 1, i + 2

        elif line[i] in OPERATOR:
            if (i + 1) < len(line) and line[i+1] in OPERATOR:
                word = line[prev:i].strip()
                if classification := classify(word):
                    if classification == 'identifier':
                        identifiers = set(id[1] for id in SYMBOL_TABLE)
                        if word not in identifiers:
                            SYMBOL_TABLE.append((linenumber, word))
                    token_list.append((linenumber, word, classify(
                        word), get_token_value(word, classify(word))))
                token_list.append(
                    (linenumber, line[i:i+2], 'operator', get_token_value(line[i:i+2], 'operator')))
                i += 1
            else:
                if (word := line[prev:i]) and classify(word):
                    classification = classify(word)
                    if classification == 'identifier':
                        identifiers = set(id[1] for id in SYMBOL_TABLE)
                        if word not in identifiers:
                            SYMBOL_TABLE.append((linenumber, word))
                    token_list.append((linenumber, word, classify(
                        word), get_token_value(word, classification)))
                token_list.append(
                    (linenumber, line[i], 'operator', get_token_value(line[i], 'operator')))
            prev = now = i + 1

        elif line[i] in '\'"':
            prev = i
            i += 1

            if line[i-1] == '"' and line.find('"', i) == -1 or line[i-1] == '\'' and line.find('\"', i) == -1:
                print(f"Error: Unclosed string on line {linenumber}")
                return token_list

            while line[i] not in '\'"':
                i += 1

            token_list.append(
                (linenumber, line[prev:i+1], 'constant', get_token_value(line[prev:i+1], 'constant')))
            prev = now = i + 1

        i += 1

    if len(token_list) == 0 and classify(line):
        classification = classify(line)
        if classification == 'identifier':
            identifiers = set(id[1] for id in SYMBOL_TABLE)
            if line not in identifiers:
                SYMBOL_TABLE.append((linenumber, line))
        token_list.append((linenumber, line, classify(
            line), get_token_value(line, classify(line))))

    return token_list


# This function initializes some of the global variables
def setup():
    global KWLIST
    with open(r'C:\VS_Workshop\Sem 6\Compiler Design\Assignments\Ass1\keywords_java.txt', 'r') as keys:
        for keyword in keys:
            KEYWORDS.add(keyword.lower().strip())
    KWLIST = sorted(list(KEYWORDS))


def main(filename: str):
    all_tokens = []

    with open(filename, 'r') as f:
        linenumber = 1
        inside_comment, comment_line = False, -1
        for line in f.readlines():
            if inside_comment:
                if '*/' in line:
                    line = line[line.index('*/') + 3:]
                    inside_comment = False
                else:
                    linenumber += 1
                    continue

            if '//' in line:
                line = line[:line.index('//')]

            if '/*' in line:
                if '*/' in line:
                    start = line.index('/*')
                    end = line.index('*/')
                    line = line[:start] + line[end+3:]
                else:
                    line = line[:line.index('/*')]
                    inside_comment = True
                    comment_line = linenumber

            tokens = parse_line(line.strip(), linenumber)

            all_tokens.extend(tokens)
            linenumber += 1

        if inside_comment:
            print(
                f"\nError: The comment on line {comment_line} was not closed\n")

    lexeme_padding = max([len(t[1]) for t in all_tokens])
    print("\nLine Number", "Lexeme".ljust(lexeme_padding),
          "Token".ljust(15), "Token Value")
    for (ln, lexeme, ttype, tval) in all_tokens:
        print(str(ln).center(11), lexeme.ljust(
            lexeme_padding), ttype.ljust(15), tval)

    print("\n\n", " Symbol Table ".center(30, '='), sep='')
    print("Index".ljust(10), "Identifier")
    for index, (linenumber, identifier) in enumerate(SYMBOL_TABLE):
        print("{} {}".format(str(index + 1).ljust(11), identifier.ljust(10)))


if __name__ == '__main__':
    setup()
    main(r'C:\VS_Workshop\Sem 6\Compiler Design\Assignments\Ass1\ass1.java')
