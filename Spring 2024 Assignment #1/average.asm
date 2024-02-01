extern printf
extern scanf
extern fgets
extern stdin
extern strlen

global average

INPUT_LEN equ 256

section .data

name_prompt    db "Please enter your first and last names:", 10, 0
title_prompt    db "Please enter your title such as Lieutenant, Chief, Mr, Ms, Influencer, Chairman, Freshman, Foreman, Project Leader, etc: ", 10, 0
thank_you_msg db "Thank you %s %s.", 10,  0

destination_one_prompt db "Enter the number of miles traveled from Fullerton to Santa Ana: ", 0
destination_two_prompt db "Enter the number of miles traveled from Santa Ana to Long Beach: ", 0
destination_three_prompt db "Enter the number of miles traveled from Long Beach to Fullerton: ", 0
speed_prompt db "Enter your average speed during that leg of the trip: ", 0

process_msg db "The inputted data are being processed.", 10, 10, 0

distance_msg db "The total distance traveled is %1.16lf miles.", 10, 0
time_msg db "The time of the trip is %1.16lf hours.", 10, 0
speed_msg db "The average speed during this trip is %1.16lf mph.", 10, 0

new_line db "", 10, 0

float_received db "The number that was received was: %lf", 10, 0

one_string_format db "%s", 0
one_float_format db "%lf", 0

section .bss
title: resb INPUT_LEN
name: resb INPUT_LEN

section .text

average:
;Backup registers
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
mov rdi, name_prompt
call printf

;Get user inputted name
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

;Print welcome_msg
mov rax, 0  ;# of xmm registers are used
mov rdi, title_prompt
call printf

;Get user inputted title
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

;Print name
mov rax, 0
mov rdi, thank_you_msg
mov rsi, title
mov rdx, name
call printf

;-------------------------------ONE-------------------------------
;Print destination_one_prompt
mov rax, 0  ;# of xmm registers are used
mov rdi, destination_one_prompt
call printf

;Begin the scanf block
mov rax, 0
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm14, [rsp]

;Print speed_prompt
mov rax, 0  ;# of xmm registers are used
mov rdi, speed_prompt
call printf

;Begin the scanf block
mov rax, 0
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm13, [rsp]


;-------------------------------TWO-------------------------------
;Print destination_two_prompt
mov rax, 0  ;# of xmm registers are used
mov rdi, destination_two_prompt
call printf

;Begin the scanf block
mov rax, 0
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm12, [rsp]

;Print speed_prompt
mov rax, 0  ;# of xmm registers are used
mov rdi, speed_prompt
call printf

;Begin the scanf block
mov rax, 0
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm11, [rsp]

;-------------------------------THREE-------------------------------
;Print destination_two_prompt
mov rax, 0  ;# of xmm registers are used
mov rdi, destination_three_prompt
call printf

;Begin the scanf block
mov rax, 0
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm10, [rsp]

;Print speed_prompt
mov rax, 0  ;# of xmm registers are used
mov rdi, speed_prompt
call printf

;Begin the scanf block
mov rax, 0
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm15, [rsp]

;--------------------Calculations--------------------
;Print new_line
mov rax, 0  ;# of xmm registers are used
mov rdi, new_line
call printf

;Print process_msg
mov rax, 0  ;# of xmm registers are used
mov rdi, process_msg
call printf

;Distance Calc
movsd xmm8, xmm14
addsd xmm8, xmm12
addsd xmm8, xmm10

;Print distance_msg
mov rax, 1  ;# of xmm registers are used
mov rdi, distance_msg
movsd xmm0, xmm8
call printf

;Time Calc
divsd xmm14, xmm13
divsd xmm12, xmm11
divsd xmm10, xmm15

addsd xmm14, xmm12
addsd xmm14, xmm10

;Print time_msg
mov rax, 1  ;# of xmm registers are used
mov rdi, time_msg
movsd xmm0, xmm14
call printf

;Average Speed Calc
movsd xmm7, xmm13
addsd xmm7, xmm11
addsd xmm7, xmm15

;Put 3.0 in xmm8
mov rdx, 3
cvtsi2sd xmm8, rdx
divsd xmm7, xmm8

;Print speed_msg
mov rax, 1  ;# of xmm registers are used
mov rdi, speed_msg
movsd xmm0, xmm7
call printf

movsd xmm0, xmm7

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