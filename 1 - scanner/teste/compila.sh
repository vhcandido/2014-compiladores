#!/bin/bash

flex scan.l			&&
echo "Flex -------------- OK"	&&

gcc lex.yy.c -o exec	   	&&
echo "GCC --------------- OK"
