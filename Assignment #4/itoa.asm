;************************************************************************************************************************
;Program name: "Pure Assembly Practice".  This function takes in a long and the char array where the string will        *
;be located.                                                                                                            *
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
;   File name: itoa
;   Programming language: X86
;   Language syntax: Intel
;
;Assemble: nasm -f elf64 -l itoa.lis -o itoa.o itoa.asm
;
;Date development began: 2022-October-26
;Date comments restructured: 2022-October-30
;
;void itoa (long int x, char * y)
;Converts a long into an string stored in (y)
;===== Begin executable code section ====================================================================================

global itoa

; Copy-pasted from _lib.asm.
%macro @cdiv 2
        mov  rax, %1                   ; idiv uses this
        mov  rdx, 0                    ; idiv also uses this (for remainder)
        mov  rdi, %2                   ; we use this on our own
        idiv rdi                       ; rax, rdx is implicitly set;
                                       ; div/idiv is very weird
%endmacro

section .text

; long int itoa(long int n, char* buf, long int len)
itoa:
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15

%define num r12    ; input number (long int)
%define numlen r13 ; length of the number (long int, def 0)
%define buf r10    ; buffer to write to (char*)
%define buflen r11 ; length of the buffer (long int)
%define isneg r8   ; is the number negative (bool)

        mov num, rdi                   ; input number (long int) into tmp
        mov numlen, 0
        mov buf, rsi                   ; buffer (char*)
        mov buflen, rdx                ; length (int64)
        mov isneg, 0                   ; not negative by default

%define tmp r9
.count:
        mov tmp, num                   ; borrow r14 for counting

; Check if negative.
        cmp num, 0
        jge .countmore                 ; skip if not

        mov isneg, 1                   ; mark as negative
        inc numlen                     ; increment for the - symbol
        neg num                        ; num = -num (absolute value)
        mov tmp, num                   ; update tmp

.countmore:
        inc numlen                     ; always at least 1 digit, start counting

        @cdiv r9, 10                   ; rax = r9 / 10, rdx = rcx % 10
        mov   r9, rax                  ; r9 = rax

        cmp r9, 0                      ; if (r9 != 0)
        jne .countmore                 ;   keep counting

; Start preparing our parse loop.
%define idx r14
        mov idx, numlen                ; idx will be our index into the buffer

; Bound-check: ensure that we have enough in the buffer to write stuff into.
.boundcheck:
        cmp numlen, buflen
        jae .overflow                  ; jump if numlen >= buflen

; Start parsing.
        mov byte [buf + idx], 0        ; null-terminate the string beforehand,
                                       ; since we already know our tail

; Check if negative so we can print the sign bit.
        cmp isneg, 1
        jne .parsemore
; Print the sign bit.
        mov byte [buf], '-'
        dec idx
; Also increment buf so that we don't overwrite the sign bit.
        inc buf

; Start parsing from the end of the number into the end of the buffer. We can do
; this because we know where the buffer ends.
.parsemore:
        @cdiv num, 10                  ; rax = r12 / 10, rdx = r12 % 10
        mov   num, rax                 ; num = rax
        mov   r15, rdx                 ; r15 = rdx

        add r15, '0'                   ; tmp += '0' (convert to ascii)
        mov [buf + idx - 1], r15b      ; save the ascii to the buf
                                       ; (r15b for the byte of r15)
        dec idx                        ; decrement the index

        cmp idx, 0                     ; if (idx != 0)
        jne .parsemore                 ;   keep parsing

        mov rax, numlen                ; return the length of the string

.return:
        pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        ret 

.overflow:
        mov byte [buf], 0              ; null terminate the string
        mov rax, 0                     ; return 0
        jmp .return