;****************************************************************************************************************************
;Program name: "Float Comparison".  This program takes two floats as input. Then compares them and returns the larger float.
;Copyright (C) 2022 Kyle Chan
;                                                                                                                           *
;This file is part of the software program "Float Comparison".                                                                   *
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
;  Programming languages: Two modules in c++ and one module in X86
;  Date program began: 2022 Aug 31
;  Date of last update: 2022 Sep 4
;
;  Files in this program: driver.cpp, isFloat.cpp, floatComparison.asm, run.sh
;  Status: Finished.
;
;This file
;   File name: floatComparison.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l compare.lis -o floatComparison.o floatComparison.asm

;===== Begin code area ================================================================================================

extern printf
extern scanf
extern atof
extern isFloat

global compareFloat

segment .data

welcome_msg db "Please enter two float numbers separated by white space.  Press enter after the second input.", 10, 0
one_string_format db "%s", 0
invalid_input_one db "The first input was invalid.  Please input a float number. You may run this program again.", 10, 0
invalid_input_two db "The second input was invalid.  Please input a float number. You may run this program again.", 10, 0
float_msg db "The numbers you inputted are :", 10, 0
one_float_format db "%1.16f", 10, 0
larger_number_format db "The larger number is %1.16f.", 10, 0
i_need_help db "Who you going to call?", 10, 0

segment .bss

segment .text


compareFloat:
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

;Print welcome_msg
;-----------------------------------------------------------------------------------------------------------------------
mov rax, 0  ;# of xmm registers are used
mov rdi, welcome_msg
call printf

;Take userinput
;------------------------------------------------------------------------------------------------------------------------
sub rsp, 2048
mov rax, 0
mov rdi, one_string_format
mov rsi, rsp
call scanf

add rsp, 1024
mov rax, 0
mov rdi, one_string_format
mov rsi, rsp
call scanf

;Validate that floats were inputted
;-----------------------------------------------------------------------------------------------------------------------
;Float One

mov rax, 0
mov rdi, rsp
call isFloat	;After this the boolean answer will be in rax
cmp rax, 0      ;Check if rax = 0
je badInputTwo     ;Was the last comparison equal? If it's not a bad input it will not jump and the next line will run

;Float Two
mov rax, 0
sub rsp, 1024
mov rdi, rsp
call isFloat	;After this the boolean answer will be in rax
cmp rax, 0      ;Check if rax = 0
je badInputOne     ;Was the last comparison equal? If it's not a bad input it will not jump and the next line will run


;Inputs are a floast, convert to a float
;Input One
mov rax, 0
mov rdi, rsp    ;atof will look here to find the string to convert
call atof
movsd xmm15, xmm0

;Input Two
mov rax, 0
add rsp, 1024
mov rdi, rsp    ;atof will look here to find the string to convert
call atof
movsd xmm14, xmm0

;Print float_msg
mov rax, 0
mov rdi, float_msg
call printf

;First number to put into our printf
mov rax, 2
mov rdi, one_float_format
movsd xmm0, xmm15
call printf

;Second number to put into our printf
mov rax, 2
mov rdi, one_float_format
movsd xmm0, xmm14
call printf



;Compare floats
ucomisd xmm15, xmm14
ja xmm15larger
movsd xmm11, xmm14 ;Move bigger number into xmm10
movsd xmm10, xmm15
jmp continue

;Move the bigger number
xmm15larger:
movsd xmm11, xmm15  ;Move bigger number into xmm10
movsd xmm10, xmm14

;Output large value
continue:
mov rax, 1 ; We are printing out something with 1 number in it!
mov rdi, larger_number_format
movsd xmm0, xmm11
call printf

movsd xmm0, xmm10

jmp final

badInputOne:
mov rax, 0
mov rdi, invalid_input_one
call printf
mov rax,-1
cvtsi2sd xmm13,rax
movsd xmm0,xmm13
jmp final

badInputTwo:
mov rax, 0
mov rdi, invalid_input_two
call printf
mov rax, -1
cvtsi2sd xmm13, rax
movsd xmm0,xmm13

final:
add rsp, 2048


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