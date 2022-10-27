#Program: Float Comparison
#Author: Kyle Chan
#Execute command: "sh run.sh"

#Purpose: script file to run the program files together.
#Clear any previously compiled outputs
rm *.o
rm *.lis
rm *.out

echo "compile driver.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp

echo "compile isFloat.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o isFloat.o isFloat.cpp

echo "Assemble floatComparison.asm"
nasm -f elf64 -l compare.lis -o floatComparison.o floatComparison.asm

echo "Link object files using the gcc Linker standard 2017"
g++ -m64 -no-pie -o final.out driver.o isFloat.o floatComparison.o -std=c++17

echo "Run the Float Comparison:"
./final.out

echo "Script file has terminated."

rm *.o
rm *.lis
rm *.out
