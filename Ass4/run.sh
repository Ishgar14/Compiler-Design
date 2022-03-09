clear
bison -d $1

if [ $? -ne 0 ]; then
    echo "Could not bison"
    exit
fi

flex $2

if [ $? -ne 0 ]; then
    echo "Could not flex the lexer"
    exit
fi

gcc ./lex.yy.c yacc.tab.c -lm

if [ $? -ne 0 ]; then
    echo "Could not compile the code"
    exit
fi

echo "Start typing boi"
./a.out