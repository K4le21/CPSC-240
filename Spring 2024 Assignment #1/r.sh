#Program: Float Comparison
#Author: Kyle Chan
#Execute command: "sh run.sh"

#Purpose: script file to run the program files together.
#Clear any previously compiled outputs
rm *.o
rm *.lis
rm *.out

echo "compile driver.cpp using the g++ compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o driver.o driver.c -std=c11

echo "Assemble average.asm"
nasm -f elf64 -l compare.lis -o average.o average.asm

echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o final.out average.o driver.o -std=c11

echo "Run the Float Comparison:"
./final.out

echo "Script file has terminated."

rm *.o
rm *.lis
rm *.out
