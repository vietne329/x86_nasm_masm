.386
.model flat, stdcall
option casemap : none
include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\masm32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\masm32.lib


.data
    msg1 db "Nhap so thu 1: ",0
    msg2 db "Nhap so thu 2: ",0
    msg3 db "Tong la: ",0
    
    num1_str db 20 dup(?)
    num2_str db 20 dup(?)
    
    result db 21 dup(?) 
    
.code
start:
    
    push offset msg1
    call StdOut
   
    push 23
    push offset num1_str
    call StdIn
   
    push offset msg2
    call StdOut
   
    push 23
    push offset num2_str
    call StdIn
    
    push offset result
    push offset num2_str
    push offset num1_str
    call big_sum
    
    push offset msg3
    call StdOut
    
    push offset result
    call StdOut
    
    exit_program:
    ;exit program
    xor eax,eax
    ret
    
    ;some untility functions 
    big_sum:
    push ebp
    mov ebp,esp
    push esi
    push edi
    push ebx
    
    mov edx,0
    mov edi,[ebp+8]     ;num1
    mov edx,[ebp+12]    ;num2
    mov ebx,[ebp+16]    ;result
    
    mov esi,19
    mov ecx,20
    clc
    add_loop:
    mov al,byte ptr[edi+esi]
    adc al,byte ptr[edx+esi]
    aaa
    
    pushf
    or al,30h
    popf
    
    mov byte ptr[ebx+esi+1],al
    dec esi
    loop add_loop
    
    mov al,'0'
    adc al,'0'
    aaa
   
    or al,30h
    
    mov byte ptr[ebx],al
    
    finish_add:
    pop ebx
    pop edi
    pop esi
    mov esp,ebp
    pop ebp
    ret 12
    
    end start
