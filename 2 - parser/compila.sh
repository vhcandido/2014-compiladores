#!/bin/bash

rm *.tab.* *.yy.* exec 

flex scanner.l                                          &&
echo "Flex --------------- OK"                          &&

bison -d -v parser.y                                      &&
echo "Bison -------------- OK"                          &&

gcc symboltable.c parser.tab.c lex.yy.c -lfl -ggdb -o exec -Wall -Wextra   &&
echo "GCC ---------------- OK"
