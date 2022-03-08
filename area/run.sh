#!/bin/bash

#Auth Luis Alvarado
#Program name: Triangle Area

#clear any previously complied outputs
#rm *.o
#rm *.out

echo "Assemble area.asm"
#compiles the assembely code
nasm -f elf64 -l area.lis -o area.o area.asm

echo "Assemble c++ file driver.cpp"
#compiles the c++ code
g++ -c -m64 -Wall -fno-pie -no-pie -o driver.o driver.cpp -std=c++17

echo "Link the two .o files driver.o area.o"
#Link the o files together
g++ -m64 -fno-pie -no-pie -std=c++17 -o final.out driver.o area.o

echo "Next the program ""driver"" will run"
./final.out

echo "The bash script file is now closing"
