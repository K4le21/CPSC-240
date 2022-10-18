# Name: Kyle Chan
# Email: kchan21@csu.fullerton.edu
# Date: October 12, 2022
# Section ID: Section 3
# Program: Euclidean Length

#Purpose: script file to run the program files together.
#Clear any previously compiled outputs
rm *.o
rm *.lis
rm *.out

echo "compile driver.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp

echo "compile isFloat.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o isFloat.o isFloat.cpp

echo "compile displayArray.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o displayArray.o displayArray.cpp

echo "Assemble manager.asm"
nasm -f elf64 -l compare.lis -o manager.o manager.asm

echo "Assemble fillArray.asm"
nasm -f elf64 -l compare.lis -o fillArray.o fillArray.asm

echo "Assemble sumArray.asm"
nasm -f elf64 -l compare.lis -o sumArray.o sumArray.asm

echo "Link object files using the gcc Linker standard 2017"
g++ -m64 -no-pie -o final.out manager.o driver.o fillArray.o isFloat.o displayArray.o sumArray.o -std=c++17

echo "Run the Array Midterm:"
./final.out

echo "Script file has terminated."

rm *.o
rm *.lis
rm *.out