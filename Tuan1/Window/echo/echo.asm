.386
.model flat, stdcall
option casemap : none
include \masm32\include\masm32rt.inc

.data
    msg db "Input something :",0
    input_user db 50 DUP(?)
    input_len  dword ?
    
.code
start:
    
    push offset msg
    call StdOut
    
    push 33
    push offset input_user
    call StdIn
    
    push offset input_user
    call StdOut
    
    xor eax, eax
    ret
    end start
