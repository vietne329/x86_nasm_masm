.386
.model flat, stdcall
option casemap : none
include \masm32\include\masm32rt.inc

.data
    num1_str db 32 dup(?)
    num2_str db 32 dup(?)
    caption_Box	db "Ket qua",0Dh,0Ah,0
    result db 32 dup(?)
.code
start:
    
    push 32
    push offset num1_str
    call StdIn
    
    push 32
    push offset num2_str
    call StdIn
    
    push offset num1_str
    call atoi
    mov ebx,eax
    
    push offset num2_str
    call atoi
    add ebx,eax
    
    push offset result
    push ebx
    call print_num
    
    
    xor eax,eax
    ret
    
    
    print_num:
        push ebp
        mov ebp,esp
        push esi
        push edi
        push ebx
        
        xor esi,esi
        mov eax,[ebp+8]     ;param 1: number
        mov esi,[ebp+12]
        mov ecx,0
        
        loop_convert:
        inc ecx
        mov ebx,10
        xor edx,edx
        idiv ebx
        add  edx,48
        push edx
        
        cmp eax,0
        jne loop_convert
        
        mov edi,-1
        print_result:
        inc edi
        dec ecx
        mov ebx,dword ptr[esp]
        mov byte ptr[esi+edi],bl
        pop ebx
        cmp ecx,0
        jne print_result
        
        lea		ebx,caption_Box
        push		MB_OK
        push		ebx
        push		esi
        push		0
        call		MessageBox
        
	pop ebx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 8
     
    atoi:
        push ebp
        mov ebp,esp
        push esi
        push edi
        push ebx
        
        mov eax,0
        mov ebx,0
        mov esi,[ebp+8]
        convert:
        movzx ebx,byte ptr[esi]
        test ebx,ebx            ;check for \0
        je done_convert
        cmp ebx,48              
        jl error
        
        cmp ebx,57
        jg error
        
        sub ebx,48              ;convert from ascii to decimal
        imul eax,10
        add eax,ebx
        
        inc esi
        jmp convert
        
        error:
        mov eax,-1
        done_convert:
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 4
    
    ;some untility functions 
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
        
        done_count:
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 4
    
    
    end start
