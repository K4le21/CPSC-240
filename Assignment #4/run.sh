#!/bin/bash
#Program name: Pure Assembly Example
#Author: Kyle Chan
#Title: BASH compile for ASM
#Execute command: "sh run.sh"

#Remove .o .lis .out files
rm *.o
rm *.lis
rm *.out

echo " " #Blank line

echo "Assemble the X86 files."
nasm -f elf64 -l manager.lis -o manager.o manager.asm
nasm -f elf64 -l strlen.lis -o strlen.o strlen.asm
nasm -f elf64 -l cosine.lis -o cosine.o cosine.asm
nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm
nasm -f elf64 -l itoa.lis -o itoa.o itoa.asm
nasm -f elf64 -l stringtof.lis -o stringtof.o stringtof.asm

echo "Link the X86 assembled code."
ld  -o final.out manager.o strlen.o cosine.o ftoa.o itoa.o stringtof.o

echo "Run the program final.out"
./final.out

echo "This bash script file will now terminate. Bye."

#Remove .o .lis .out files
rm *.o
rm *.lis
rm *.out
