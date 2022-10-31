;************************************************************************************************************************
;Program name: "Pure Assembly Practice".  This function takes in a double, char pointer, and long int. The double is    *
;converted into the location of the char pointer. This function returns the size of the char pointer.
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
;   File name: ftoa
;   Programming language: X86
;   Language syntax: Intel
;
;Assemble: nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm
;
;Date development began: 2022-October-26
;Date comments restructured: 2022-October-30
;
;long it ftoa (double x, char * y, long int z)
;z is the size of your char array.
;Converts a float into an string stored in (y)
;The converted string size is then returned.
;===== Begin executable code section ====================================================================================

global ftoa

extern itoa

section .text

ftoa:

        xor     eax, eax
        test    rsi, rsi
        je      .019
        push    rbp
        mov     rbp, rsp
        push    r15
        mov     r15, rdi
        push    r14
        push    r13
        mov     r13, rsi
        push    r12
        push    rbx
        sub     rsp, 40
        ucomisd xmm0, xmm0
        jpo     .001
        cmp     rsi, 3
        jle     .018
        mov     dword [rdi], 5136718
        mov     eax, 3
        jmp     .018

.001:
        xorps  xmm1, xmm1
        comisd xmm1, xmm0
        jbe    .004
        cmp    rsi, 1
        jg     .003
.002:
        mov byte [r15], 0
        jmp .007

.003:
        mov   byte [rdi], 45
        xorps xmm0, oword [rel .LC1]
        mov   ebx, 1
        jmp   .005

.004:
        xor ebx, ebx
.005:
        cvttsd2si r12, xmm0
        lea       rsi, [r15+rbx]
        mov       rdx, r13
        movsd     qword [rbp-48H], xmm0
        mov       rdi, r12
        call      itoa
        test      rax, rax
        jz        .002
        cvtsi2sd  xmm1, r12
        movsd     xmm0, qword [rbp-48H]
        add       rax, rbx
        subsd     xmm0, xmm1
        xorps     xmm1, xmm1
        comisd    xmm0, xmm1
        jbe       .018
        lea       rdx, [rax+2H]
        mov       r12, rsp
        cmp       rdx, r13
        jle       .008
.006:
        mov byte [r15], 0
        mov rsp, r12
.007:
        xor eax, eax
        jmp .018

.008:
        mulsd     xmm0, [rel .LC2]
        mov       byte [r15+rax], 46
        lea       r13, [rbp-37H]
        mov       edx, 7
        mov       rsi, r13
        lea       rbx, [rax+1H]
        cvttsd2si r14, xmm0
        mov       rdi, r14
        call      itoa
        mov       rdx, rax
        test      rax, rax
        jz        .006
        xor       ecx, ecx
        test      r14, r14
        jle       .014
.009:
        cmp  r14, 99999
        jg   .010
        imul r14, r14, 10
        inc  rcx
        jmp  .009

.010:
        dec rdx
        lea rax, [r13+rcx]
.011:
        test rdx, rdx
        js   .012
        mov  sil, byte [r13+rdx]
        mov  byte [rax+rdx], sil
        dec  rdx
        jmp  .011

.012:
        xor   eax, eax
        test  rcx, rcx
        mov   rdi, r13
        mov   edx, 6
        cmovs rcx, rax
        mov   al, 48
        rep   stosb
        jmp   .014

.013:
        cmp byte [r13+rdx-1H], 48
        lea rax, [rdx-1H]
        jnz .015
        mov rdx, rax
.014:
        cmp rdx, 1
        jg  .013
.015:
        mov rax, rbx
.016:
        mov    ecx, eax
        mov    rsi, r15
        sub    ecx, ebx
        add    rsi, rax
        movsxd rcx, ecx
        cmp    rcx, rdx
        jge    .017
        mov    cl, byte [rbp+rcx-37H]
        mov    byte [r15+rax], cl
        inc    rax
        jmp    .016

.017:
        mov byte [rsi], 0
        mov rsp, r12
.018:
        lea rsp, [rbp-28H]
        pop rbx
        pop r12
        pop r13
        pop r14
        pop r15
        pop rbp
        ret 

.019:

        ret 

section .data

section .bss

section .rodata

        ALIGN 16
.LC1:

 dd 00000000H, 80000000H
 dd 00000000H, 00000000H

section .rodata

.LC2:
 dq 412E848000000000H

section .note

 db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H
 db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H
 db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H
 db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
 db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H
 db 09H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
