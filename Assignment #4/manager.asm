;************************************************************************************************************************
;Program name: "Pure Assembly Practice".  This program will output time in tics, accept a char array, covert the char   *
;into a float, convert the float into radians, call cosine, and output the time again in tics.                          *
;Copyright (C) 2022  Kyle Chan                                                                                          *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public      *
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will  *
;be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  *
;PURPOSE.  See the GNU General Public License for more details.  A copy of the GNU General Public License v3 is         *
;available here:  <https://www.gnu.org/licenses/>.                                                                      *
;************************************************************************************************************************
;
;Author information
;   Author name: Kyle Chan
;   Author's email: kchan21@fullerton.edu
;
;File Purpose:
;   File name: manager
;   Programming language: X86
;   Language syntax: Intel
;
;Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;
;Date development began: 2022-October-26
;Date comments restructured: 2022-October-30
;
;Contains _start
;===== Begin executable code section ====================================================================================

global _start

extern strlen
extern itoa
extern stringtof
extern ftoa
extern cosine

;Initialize Constants
string_size equ 32

;Kernel Functions
sys_read equ 0           ;read
sys_write equ 1          ;write
sys_terminate equ 60     ;exit
;Reference:
;https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md

exit_with_success equ 0
enter_input equ 10

segment .data
welcome_msg db "Welcome to Accurate Cosines by Kyle Chan.", 10, 0
current_time db "The current time is ", 0
current_time_two db " tics.", 10, 0
angle_prompt db "Please enter an angle in degrees and press enter: ", 0       
user_input_msg db "You entered ", 0
radians_msg db "The equivalent radians is ", 0
cosine_msg db "The cosine of those degrees is ", 0
exit_msg db "The progam will now terminate. Have a nice day. Bye.", 10, 0
period db ".", 10, 0
new_line db 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0        ;Declare an array of 8 bytes where each byte is initialize with ascii value 10 (newline)

segment .bss
user_input resb string_size
return_string resb string_size
output_string resb string_size
radians_string resb string_size
cosine_string resb string_size

segment .text

_start:

;Call strlen with the welcome_msg
mov rax, 0
mov rdi, welcome_msg
call strlen
mov r12, rax

;Print welcome_msg
mov rax, sys_write   ;1 is the code number of the kernel function to be called.
mov rdi, 1              ;1 = number of stdout
mov rsi, welcome_msg    ;The starting address of the string hello is in rdi.
mov rdx, r12            ;Put the number of chars the string is in rdx
syscall

;Get time as int (stored in r14)
cpuid           ;Pause other CPU process
rdtsc           ;Get clock from CPU which get returned into rdx and rax
shl rdx, 32     ;
or rdx, rax     ;Combine the two parts together
mov r14, rdx    ;Move time from rdx into a GPR

;Convert the r14 to string using itoa
mov rax, 0
mov rdi, r14
mov rsi, output_string
call itoa
mov r15, output_string

;Call strlen with the current_time
mov rax, 0
mov rdi, current_time
call strlen
mov r12, rax

;Print current_time
mov rax, sys_write
mov rdi, 1
mov rsi, current_time
mov rdx, r12
syscall

;Call strlen with the output_string (holds tics as a string which is in r15)
mov rax, 0
mov rdi, r15
call strlen
mov r12, rax

;Print current tics (which is in r15)
mov rax, sys_write
mov rdi, 1
mov rsi, r15
mov rdx, r12
syscall

;Call strlen with the current_time
mov rax, 0
mov rdi, current_time_two
call strlen
mov r12, rax

;Print current_time
mov rax, sys_write
mov rdi, 1
mov rsi, current_time_two
mov rdx, r12
syscall

;Call strlen with the angle_prompt
mov rax, 0
mov rdi, angle_prompt
call strlen
mov r12, rax

;Print angle_prompt
mov rax, sys_write
mov rdi, 1
mov rsi, angle_prompt
mov rdx, r12
syscall

;Loop start
mov rbx, user_input
mov r12, 0      ;r12 is counter of number of bytes inputted
push qword 0    ;Storage for incoming byte

begin_loop:     ;This is the one point of entry into the loop structure.
mov rax, sys_read
mov rdi, 0
mov rsi, rsp
mov rdx, 1      ;one byte will be read from the input buffer
syscall

mov al, byte [rsp]
cmp al, enter_input
je exit_loop    ;If EOL is encountered then discard EOL and exit the loop.

;This is the only point in the loop structure where exit is allowed.

inc r12             ;Count the number of bytes placed into the array.

;Check that the destination array has not overflowed.
cmp r12, string_size
;if(r12 >= string_size)
jge end_if_else
;else (r12 < string_size)
mov byte [rbx], al
inc rbx
end_if_else:

jmp begin_loop

exit_loop:
mov byte [rbx], 0
;User's string is now in user_input

;Call strlen with the user_input_msg
mov rax, 0
mov rdi, user_input_msg
call strlen
mov r12, rax

;Print angle_prompt
mov rax, sys_write
mov rdi, 1
mov rsi, user_input_msg
mov rdx, r12
syscall

;Call stringtof with user_input (result returned in xmm0)
mov rax, 0
mov rdi, user_input
call stringtof
movsd xmm9, xmm0

;Call ftoa with xmm9 (size is returned in rax)
mov rax, 1
mov rdi, output_string
movsd xmm0, xmm9
mov rsi, string_size
call ftoa
mov r11, rax

;Print output_string
mov rax, sys_write
mov rdi, 1
mov rsi, output_string
mov rdx, r11
syscall

;Print period
mov rax, sys_write
mov rdi, 1
mov rsi, period
mov rdx, 2
syscall

;Call strlen with the radians_msg
mov rax, 0
mov rdi, radians_msg
call strlen
mov r12, rax

;Print radians_msg
mov rax, sys_write
mov rdi, 1
mov rsi, radians_msg
mov rdx, r12
syscall

;Put pi into xmm11
mov rax, 0x400921FB54442D18
push rax
movsd xmm11, [rsp]
pop rax

;Put 180.0 in xmm10
mov rbx, 180
cvtsi2sd xmm10, rbx

;Do the math (answer is in xmm8)
movsd xmm8, xmm9
mulsd xmm8, xmm11
divsd xmm8, xmm10

;Call ftoa with xmm8 (size is returned in rax)
mov rax, 1
mov rdi, radians_string
movsd xmm0, xmm8
mov rsi, string_size
call ftoa
mov r11, rax

;Print radians_string
mov rax, sys_write
mov rdi, 1
mov rsi, radians_string
mov rdx, r11
syscall

;Print period
mov rax, sys_write
mov rdi, 1
mov rsi, period
mov rdx, 2
syscall

;Call strlen with the cosine_msg
mov rax, 0
mov rdi, cosine_msg
call strlen
mov r12, rax

;Print cosine_msg
mov rax, sys_write
mov rdi, 1
mov rsi, cosine_msg
mov rdx, r12
syscall

;Call cosine with xmm9
mov rax, 1
movsd xmm0, xmm9
call cosine
movsd xmm12, xmm0

;Call ftoa with xmm12 (size is returned in rax)
mov rax, 1
mov rdi, cosine_string
movsd xmm0, xmm12
mov rsi, string_size
call ftoa
mov r11, rax

;Print cosine_string
mov rax, sys_write
mov rdi, 1
mov rsi, cosine_string
mov rdx, r11
syscall

;Print period
mov rax, sys_write
mov rdi, 1
mov rsi, period
mov rdx, 2
syscall

;Get time as int (stored in r14)
cpuid           ;Pause other CPU process
rdtsc           ;Get clock from CPU which get returned into rdx and rax
shl rdx, 32     ;
or rdx, rax     ;Combine the two parts together
mov r14, rdx    ;Move time from rdx into a GPR

;Convert the r14 to string using itoa
mov rax, 0
mov rdi, r14
mov rsi, output_string
call itoa
mov r15, output_string

;Call strlen with the current_time
mov rax, 0
mov rdi, current_time
call strlen
mov r12, rax

;Print current_time
mov rax, sys_write
mov rdi, 1
mov rsi, current_time
mov rdx, r12
syscall

;Call strlen with the output_string (holds tics as a string which is in r15)
mov rax, 0
mov rdi, r15
call strlen
mov r12, rax

;Print current tics (which is in r15)
mov rax, sys_write
mov rdi, 1
mov rsi, r15
mov rdx, r12
syscall

;Call strlen with the current_time
mov rax, 0
mov rdi, current_time_two
call strlen
mov r12, rax

;Print current_time
mov rax, sys_write
mov rdi, 1
mov rsi, current_time_two
mov rdx, r12
syscall

;Call strlen with the exit_msg
mov rax, 0
mov rdi, exit_msg
call strlen
mov r12, rax

;Print exit_msg
mov rax, 1
mov rdi, 1
mov rsi, exit_msg
mov rdx, r12
syscall

mov rax, sys_terminate        ;60 is the number of the kernelfunction that terminates an executing program.
mov rdi, exit_with_success       ;0 is the error code number for success, that will be returned to the OS.
syscall