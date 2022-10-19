;****************************************************************************************************************************
;Program name: "Right Triangle".  This program takes two strings and two floats as input. This program outputs your title followed by your last name. It also outputs the hypotenuse of a right triangle given its two other sides. Copyright (C) 2022 Kyle Chan.*
;                                                                                                                           *
;This file is part of the software program "Right Triangle".                                                                   *
;Float Comparison is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;Float Comparison is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Kyle Chan
;  Author email: kchan21@csu.fullerton.edu
;
;Program information
;  Program name: Float Comparison
;  Programming languages: One modules in c++ and one module in X86
;  Date program began: 2022 Sep 8
;  Date of last update: 2022 Sep 27
;
;  Files in this program: driver.cpp, rightTriangle.asm, run.sh
;  Status: Finished.
;
;This file
;   File name: rightTriangle.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l compare.lis -o rightTriangle.o rightTriangle.asm

;===== Begin code area ================================================================================================

extern printf
extern scanf
extern fgets
extern stdin
extern strlen

INPUT_LEN equ 256
LARGE_BOUNDARY equ 64
SMALL_BOUNDARY equ 16

global rightTriangle

segment .data

align SMALL_BOUNDARY

last_prompt_msg db "Please enter your last name: ", 0
title_prompt_msg db "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0 
float_prompt_msg db "Please enter the sides of your triangle as two float numbers separated by white space. Press enter after the second input.", 10, 0
float_return_msg db "The length of the hypotenuse is %1.16lf units.", 10, 0
last_title_return_msg db "Please enjoy your triangle ", 0
two_float_format db "%lf %lf", 0
one_float_format db "%lf", 0
one_string_format db "%s", 0
space db " ", 0
period db ".", 10, 0

align LARGE_BOUNDARY

segment .bss
title: resb INPUT_LEN
last: resb INPUT_LEN

segment .text


rightTriangle:
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

;Print last name prompt
mov rax, 0
mov rdi, one_string_format
mov rsi, last_prompt_msg
call printf

;Get user inputted last name
mov rax, 0
mov rdi, last
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;Change nline char to NULL char
mov rax, 0
mov rdi, last
call strlen
sub rax, 1
mov byte [last + rax], 0

;Print title name prompt
mov rax, 0
mov rdi, one_string_format
mov rsi, title_prompt_msg
call printf

;Get user inputted title name
mov rax, 0
mov rdi, title
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;Change nline char to NULL char
mov rax, 0
mov rdi, title
call strlen
sub rax, 1
mov byte [title + rax], 0

;Print float prompt
mov rax, 0
mov rdi, one_string_format
mov rsi, float_prompt_msg
call printf

;Get User input
sub rsp, 1024
mov rax, 0
mov rdi, two_float_format
push qword 0
mov rsi, rsp

push qword 0
mov rdx, rsp
call scanf
movsd xmm10, [rsp]
pop rax
movsd xmm11, [rsp]
pop rax

;Math
mulsd xmm10, xmm10
mulsd xmm11, xmm11
addsd xmm10, xmm11
sqrtsd xmm14, xmm10

;Print float_return_msg with the correct float in xmm0
mov rax, 1
mov rdi, float_return_msg
movsd xmm0, xmm14
call printf

;Print last_title_return_msg
mov rax, 0
mov rdi, one_string_format
mov rsi, last_title_return_msg
call printf

;Print title
mov rax, 0
mov rdi, one_string_format
mov rsi, title
call printf

;Print space
mov rax, 0
mov rdi, one_string_format
mov rsi, space
call printf

;Print last name
mov rax, 0
mov rdi, one_string_format
mov rsi, last
call printf

;Print period
mov rax, 0
mov rdi, one_string_format
mov rsi, period
call printf

movsd xmm0, xmm14

add rsp, 1024

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