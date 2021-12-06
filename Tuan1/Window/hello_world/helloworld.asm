.386
.model flat, stdcall
option casemap : none

include \masm32\include\masm32rt.inc

.data
    msg db "Hello world!",0
.code

start:
    ;write your code here
    push offset msg
    call StdOut
    
    xor eax, eax
    ret
    end start
