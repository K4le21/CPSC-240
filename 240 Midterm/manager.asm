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
;   File name: manager.asm
;   Language: x86 ASM
;   Max page width: 132 columns
;   Compile: nasm -f elf64 -l compare.lis -o manager.o manager.asm
;   Link: g++ -m64 -no-pie -o final.out manager.o driver.o fillArray.o isFloat.o displayArray.o sumArray.o -std=c++17
;   Purpose: This is the manager file that calls fillArray, displayArray, and sumArray.
;========================================================================================================

;Allows you to print and scan
extern printf
extern scanf

;fgets
extern fgets
extern stdin
extern strlen

;External function calls
extern fillArray
extern displayArray
extern sumArray

INPUT_LEN equ 256

global manager

segment .data

name_prompt db "Please enter your name: ", 0
array_display_output db "These numbers are stored in the array:", 10, 0
array_length_output db "The length of the array is: %lf.", 10, 0
one_string_format db "%s", 0

segment .bss
name: resb INPUT_LEN
array_ptr resq 7

segment .text


manager:
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

;Print name_prompt
push qword 0
mov rax, 0
mov rdi, one_string_format
mov rsi, name_prompt
call printf
pop rax

;Get user inputted full name
mov rax, 0
mov rdi, name
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;Change nline char to NULL char
mov rax, 0
mov rdi, name
call strlen
sub rax, 1
mov byte [name + rax], 0

;Call fillArray
push qword 0
mov rax, 0
mov rdi, array_ptr
mov rsi, 6
call fillArray
mov r15, rax
pop rax

;Print array_display_output
push qword 0
mov rax, 0
mov rdi, one_string_format
mov rsi, array_display_output
call printf
pop rax

;Call displayArray
mov rax, 0
mov rdi, array_ptr
mov rsi, r15
call displayArray


;Call sumArray
mov rax, 0
mov rdi, array_ptr
mov rsi, r15
call sumArray
movsd xmm15, xmm0

;Print array_length_output
mov rax, 1
mov rdi, array_length_output
movsd xmm0, xmm15
call printf

;Move name to rax to return
mov rax, name

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
mov rsp,rbp
pop rbp


ret
