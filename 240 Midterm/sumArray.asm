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
;  Date of reorganization of comments: 2022 October 18
;  Files in this program: driver.cpp, manager.asm, displayArray.cpp, sumArray.asm, fillArray.asm, run.sh
;  Status: Finished.  The program was tested extensively with no errors in WSL 2022 Edition.
;
;This file
;   File name: sumArray.asm
;   Language: x86 ASM
;   Max page width: 132 columns
;   Compile: nasm -f elf64 -l compare.lis -o sumArray.o sumArray.asm
;   Link: g++ -m64 -no-pie -o final.out manager.o driver.o fillArray.o isFloat.o displayArray.o sumArray.o -std=c++17
;   Purpose: This is the file is called by the manager. This takes the array and performs the Euclid Length formula.
;========================================================================================================

global sumArray

segment .data

segment .bss  ;Reserved for uninitialized data

segment .text ;Reserved for executing instructions.

sumArray:
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

;Taking information from parameters
;This holds the first parameter (the array)
mov r15, rdi
;This holds the second parameter (the number of elements in the array, not size)
mov r14, rsi


;Put 0 in xmm15
mov rax, 0
cvtsi2sd xmm15, rax

mov r13, 0 ;For loop counter goes up to r14, starting at 0

beginLoop:
cmp r13, r14  ;Comparing increment with 6 (the size of array)
je outOfLoop
movsd xmm10, [r15 + 8*r13] ;Move from array to xmm10

;xmm15 += (xmm10^2)
mulsd xmm10, xmm10
addsd xmm15, xmm10
inc r13  ;Increment loop counter
jmp beginLoop

outOfLoop:

sqrtsd xmm13, xmm15

movsd xmm0, xmm13 ;Returning sum to caller
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
