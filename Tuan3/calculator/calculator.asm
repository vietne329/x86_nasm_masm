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
    msg10    db "----> Ket qua: ",0
    result   dw 1 dup(?)
    msg1     db "Nhap so a: ",0
    a        dw 1 dup(?)
    a_str    db 10 dup(?)
    msg2     db "Nhap so b: ",0
    b_str    db 10 dup(?)
     b        dw 1 dup(?)
    msg3     db "---------CALCULATOR------------",0Ah,0
    msg4     db "1.Cong", 0Ah , 0
    msg5     db "2.Tru", 0Ah , 0
    
    msg6     db "3.Nhan", 0Ah , 0
   
    msg7     db "4.Chia", 0Ah , 0
    msg8     db "5.Thoat", 0Ah, 0
    msg9     db "Ban chon? :",0
    choose_str   db 5 dup(?)
    choose       dw 1 dup(?)

    
   
.code
start:
    
    loop_calculator:
    push offset msg1
    call StdOut
    
    push 10
    push offset a_str
    call StdIn
    push offset a_str
    call atoi
    mov dword ptr[a],eax
    
    push offset msg2
    call StdOut
    
    push 10
    push offset b_str
    call StdIn
    push offset b_str
    call atoi
    mov dword ptr[b],eax
    
    reset_cal:
    push offset msg3
    call StdOut
    push offset msg4
    call StdOut
    push offset msg5
    call StdOut
    push offset msg6
    call StdOut
    push offset msg7
    call StdOut
    push offset msg8
    call StdOut
    push offset msg9
    call StdOut
    
    push 5
    push offset choose_str
    call StdIn
    
    push offset choose_str
    call atoi
    mov dword ptr[choose],eax
    
    mov esi,dword ptr[choose]
    cmp esi,5
    je exit_program
    cmp esi,1
    je additions
    cmp esi,2
    je subtract
    cmp esi,3
    je multiply
    cmp esi,4
    je divide
    
    jmp loop_calculator
    
    additions:
    push offset msg10
    call StdOut
    mov eax,dword ptr[a]
    add eax,dword ptr[b]
    push eax
    call print_num
    jmp reset_cal
    
    subtract:
    push offset msg10
    call StdOut
    mov eax,dword ptr[a]
    sub eax,dword ptr[b]
    push eax
    call print_num
    jmp reset_cal
    
    multiply:
    push offset msg10
    call StdOut
    mov eax,dword ptr[a]
    imul eax,dword ptr[b]
    push eax
    call print_num
    jmp reset_cal
    
    divide:
    push offset msg10
    call StdOut
    mov edx,0
    mov eax,dword ptr[a]
    mov ecx,dword ptr[b]
    div ecx
    push eax
    call print_num
    jmp reset_cal
    
    exit_program:
    ;exit program
    xor eax,eax
    ret
    
    print_num:
        push ebp
        mov ebp,esp
        sub esp,10
        push esi
        push edi
        push ebx
        push edx
        
      
        xor esi,esi
        mov eax,[ebp+8]     ;param 1: number
        lea esi,[ebp-10]
        
        mov ecx,9
        loop_clear_output:
        mov byte ptr[esi+ecx],0
        loop loop_clear_output
    
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
        
        push esi
        call str_len
        mov bl,10
        mov byte ptr[esi+eax],bl
        push esi
        call StdOut
        
        pop edx
	pop ebx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 4      
                         
    
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
