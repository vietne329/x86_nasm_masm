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
    msg1        db  "Input n: ",0
    n           db  256 dup(?)
    result      db  256 dup(?)
    results     db  20 dup(?)
    space       db  " ",0
    i           dw  ?
    
.code
start:
    ;print notice msg1 for user
    push offset msg1
    call StdOut
    
    ;get input of user
    push 256
    push offset n
    call StdIn
    
    push offset n
    call atoi
    
    mov dword ptr[i],eax
    l1:
    cmp dword ptr[i],0
    je exit_program
    
    push 1
    push 0
    push dword ptr[i]
    call fibonacci

    
    push offset results
    push eax
    call print_num
    
    mov ecx,20
    lea esi,results
    clear_result:
    mov byte ptr[esi+ecx],0
    loop clear_result
    
    
    
    dec dword ptr[i]
    jmp l1
    
    exit_program:
    ;exit program
    xor eax,eax
    ret
    
    ;some untility functions 
    fibonacci:
        push ebp
        mov ebp,esp
        push esi
        push edi
        push ebx
        
        fibo:       ;fibo(n,a,b)
        mov esi,[ebp+8]         ;esi = n
        mov edi,[ebp+12]        ;edi = a
        mov ebx,[ebp+16]        ;ebx = b
        
        cmp esi,0
        je n_equal_0
        cmp esi,1
        je n_equal_1
        
        mov eax,[ebp+12]
        add eax,[ebp+16]
        
        dec dword ptr[ebp+8]
        mov dword ptr[ebp+12],ebx
        mov dword ptr[ebp+16],eax
        jmp fibo
        
        n_equal_0:
        mov eax,[ebp+12]
        jmp complete
        
        n_equal_1:
        mov eax,[ebp+16]
        
        complete:
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 12
    
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
        
        push esi
        call str_len
        mov bl,32
        mov byte ptr[esi+eax],bl
        push esi
        call StdOut
        
        
        
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
