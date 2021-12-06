.386
.model flat, stdcall
option casemap : none
include \masm32\include\masm32rt.inc

.data
    msg1 db "Input string: ",0
    input_str db 256 dup(?)
    result db 256 dup(?)
    caption_Box	db "Ket qua",0Dh,0Ah,0
.code
start:
    ;print notice msg1 for user
    push offset msg1
    call StdOut
    
    ;get input of user
    push 256
    push offset input_str
    call StdIn
    
    push offset result
    push offset input_str
    call reverse_string
    
    
    ;exit program
    xor eax,eax
    ret
    
    ;some untility functions 

;-----------------reverse_string---------------------------    
    reverse_string:
        push ebp        ;save ebf of caller onto stack
        mov ebp,esp     ;save ebp of callee onto stack 
        push esi        ;
        push edi        ; save somes register (register convention)
        push ebx        ;
        
        mov esi,[ebp+8]     ;initial string
        mov edi,[ebp+12]    ;reversed string
        
        push esi            ;push length of string onto stack
        call str_len        ;calculate length of intial string
        mov ecx,eax         ;move length to ecx
        
        xor ebx,ebx         ;clear ebx
        xor edx,edx         ;setup index for reverse string
        
        sub ecx,1   
        loop_reverse:       ;implementing reverse
        mov bl,byte ptr[esi+ecx]
        mov byte ptr[edi+edx],bl
        inc edx
        dec ecx
        cmp ecx,-1
        jne loop_reverse
        
        ;print result by MessageBox
        lea		ebx,caption_Box
        push		MB_OK
        push		ebx
        push		edi
        push		0
        call		MessageBox
        
        ;clear stack before return to return address
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 8
    
;---------------calculate length of string---------------    
    str_len:
        push ebp
        mov ebp,esp
        push esi
        push edi
        push ebx
        
        xor eax,eax
        xor ebx,ebx
        mov esi,[ebp+8]
        
        count_length:
        mov bl,byte ptr[esi]
        cmp bl,0
        je done_count
        inc eax
        inc esi
        jmp count_length
        
        done_count:
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 4
    
    
    end start
