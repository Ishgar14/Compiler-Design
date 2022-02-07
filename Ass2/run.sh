
flex $1

if [ $? -eq 0 ]; then
    # echo "Flexed successfully"
    echo "Generated the lexer"
    gcc ./lex.yy.c
    
    if [ $? -eq 0 ]; then
        echo "Compiled the lexer"
        file=$2
        flen=${#file}
        echo ""
        echo ""
        
        if [ $flen -ne 0 ]; then
            ./a.out test.c
        else
            ./a.out
        fi
    fi
fi