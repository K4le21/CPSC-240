;****************************************************************************************************************************
;Program name: "Euclidean Length".
; This program will allow a user to input float numbers in an array of size 7, and display the contents. It will also
; perform the Euclid function called length.
; Copyright (C) 2022 Kyle Chan.                                                                           *
;                                                                                                                           *
;This file is part of the software program "Euclidean Length".
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY// without even the implied          *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Kyle Chan
;  Author email: kchan21@csu.fullerton.edu
;
;Program information
;  Program name: Euclidean Length
;  Programming languages: Assembly, C++, bash
;  Date program began: 2022 October 12
;  Date of last update: 2022 October 12
;  Date of reorganization of comments: 2022 October 17
;  Files in this program: driver.cpp, manager.asm, displayArray.cpp, sumArray.asm, fillArray.asm, run.sh
;  Status: Finished.  The program was tested extensively with no errors in WSL 2022 Edition.
;
;This file
;   File name: fillArray.asm
;   Language: x86 ASM
;   Max page width: 132 columns
;   Compile: nasm -f elf64 -l compare.lis -o fillArray.o fillArray.asm
;   Link: g++ -m64 -no-pie -o final.out manager.o driver.o fillArray.o isFloat.o displayArray.o sumArray.o -std=c++17
;   Purpose: This is the file is called by the manager. This takes the user's inputs, validates them, and stores them into an array.
;========================================================================================================


;Allows you to print and scan
extern printf
extern scanf

;Converts string to float
extern atof

;External function calls
extern isFloat

global fillArray

segment .data

array_prompt_one db "Please enter floating point numbers separated by ws to be stored in a array of size 6 cells.", 10, 0
array_prompt_two db "After the last input press <enter> followed by <control+d>.", 10, 0
one_string_format db "%s", 0

segment .bss

segment .text

fillArray:
push rbp
mov  rbp,rsp
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

push qword 0 ;staying on the boundary

;Taking information from parameters
mov r15, rdi  ; This holds the first parameter (the array)
mov r14, rsi  ; This holds the second parameter (the size of array)

;Print array_prompt_one
push qword 0
mov rax, 0
mov rdi, array_prompt_one
call printf
pop rax

;Print array_prompt_two
push qword 0
mov rax, 0
mov rdi, array_prompt_two
call printf
pop rax

;User inputs number until their size = 6 or ctrl+d is pressed
mov r13, 0 ;Put 0 in r13 for loop counter

beginLoop:

cmp r14, r13 ;We want to exit loop when we hit the size of array
je outOfLoop

mov rax, 0
mov rdi, one_string_format
mov rsi, rsp
call scanf
cdqe
cmp rax, -1  ;Loop termination condition: user enters ctrl+d.
je outOfLoop

;Call isFloat
mov rax, 0
mov rdi, rsp
call isFloat	;After this the boolean answer will be in rax
cmp rax, 0    ;Check if rax = 0
je beginLoop

mov rax, 0
mov rdi, rsp    
call atof     ;atof will look here to find the string to convert
movsd xmm14, xmm0

je outOfLoop
movsd [r15 + 8*r13], xmm14  ;At array[counter], place the input number
inc r13  ;Increment loop counter
jmp beginLoop


outOfLoop:

pop rax
mov rax, r13  ;Store the number of things in the aray from the counter of for loop

;===== Restore original values to integer registers ===================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret