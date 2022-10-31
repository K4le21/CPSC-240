#!/bin/bash
#Program name: Pure Assembly Example
#Author: Kyle
#Title: BASH compile for ASM

rm *.o
rm *.lis
rm *.out

echo " " #Blank line


echo "Assemble the X86 files."
nasm -f elf64 -l manager.lis -o manager.o manager.asm -g -gdwarf
nasm -f elf64 -l strlen.lis -o strlen.o strlen.asm -g -gdwarf
nasm -f elf64 -l cosine.lis -o cosine.o cosine.asm -g -gdwarf
nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm -g -gdwarf
nasm -f elf64 -l itoa.lis -o itoa.o itoa.asm -g -gdwarf
nasm -f elf64 -l stringtof.lis -o stringtof.o stringtof.asm -g -gdwarf

echo "Link the X86 assembled code."
ld  -o final.out manager.o strlen.o cosine.o ftoa.o itoa.o stringtof.o -g

echo "Run the program final.out"
gdb ./final.out

echo "This bash script file will now terminate. Bye."

rm *.o
rm *.lis
rm *.out
