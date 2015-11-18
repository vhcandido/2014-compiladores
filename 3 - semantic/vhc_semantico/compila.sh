#!/bin/bash

echo "Gerando lex.yy.c"                                 &&
flex scanner.l                                          &&
echo "Flex -------------------------------- OK"         &&

echo ""                                                 &&
echo "Gerando parser.tab.h e parser.tab.c"              &&
bison -d -v parser.y                                    &&
echo "Bison ------------------------------- OK"         &&

echo ""                                                 &&
echo "Compilando os arquivos"                           &&
gcc symboltable.c parser.tab.c lex.yy.c -lfl -ggdb -o exec -Wall -Wextra   &&
echo "GCC --------------------------------- OK"         &&

echo ""
echo "Para ler de um arquivo específico digite:"
echo "	./exec <nome_do_arquivo>"
echo "	ex: ./exec input_scanner"
echo "ou apenas ./exec para que leia do stdin"
