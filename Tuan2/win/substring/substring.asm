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
    counts      dw  0
    msg1        db  "Input S string: ",0
    msg2        db  "Input C string: ",0
    s_str       db  100 dup(?)
    c_str       db  10  dup(?)
    len_s       dw  ?
    len_c       dw  ?
    positions   dw  1000 dup(?)
    nl          db  10,0
    cache       db  3 dup(?)
    space       db  32
    i           dw  0 
     
.code
start:
    
    push offset msg1
    call StdOut
    
    push 100
    push offset s_str
    call StdIn
    
    push offset msg2
    call StdOut
    
    push 10
    push offset c_str
    call StdIn
    
    
    push offset positions
    push offset c_str
    push offset s_str
    call resolve
    
    mov dword ptr[counts],eax
    
    push offset cache
    push eax
    call print_num
    
    push offset nl
    call StdOut
    
    mov ecx,dword ptr[counts]
    mov ebx,0
    loop_print_positions:
        mov ebx, dword ptr[i]
        mov eax, dword ptr[positions+4*ebx]
        push ecx
        
        mov ecx,3
        lea esi,cache
        clear_result:
        mov byte ptr[esi+ecx],0
        loop clear_result
        
        push offset cache
        push eax
        call print_num
        
        pop ecx
        inc dword ptr[i]      
        
        loop loop_print_positions
    
    exit_program:
        xor eax,eax
        ret
    
    ;some untility functions 
   
   resolve:
       push ebp
       mov ebp,esp
       sub esp,8    ;i
       push esi
       push edi
       push ebx
       
       mov dword ptr[ebp-8],0
       mov dword ptr[ebp-4],0
       mov esi,[ebp+8]    ;s_str
       mov edi,[ebp+12]   ;c_str
       mov ecx,-1
       
       count_loop:
       inc ecx
       cmp byte ptr[esi+ecx],0
       je done_count_loop
       lea ebx,[esi+ecx]
       lea edx,[edi]
       push edx
       push ebx
       call compare_string
       
       cmp eax,1
       je count_inc
       jmp count_loop
       
       count_inc:
       inc dword ptr[ebp-8]
       push ebx
       push eax
       mov ebx,dword ptr[ebp-4]
       mov eax,[ebp+16]
       mov dword ptr[eax+4*ebx],ecx
       inc dword ptr[ebp-4]
       pop eax
       pop ebx
       jmp count_loop
       
       done_count_loop:
       mov eax,dword ptr[ebp-8]
       pop ebx
       pop edi
       pop esi
       mov esp,ebp
       pop ebp
       ret 12
       
   compare_string:
        push ebp
        mov ebp,esp
        push esi
        push edi
        push ebx
        push ecx
        
        mov esi,[ebp+8]     ;s_str
        mov edi,[ebp+12]    ;c_str
    
        mov ecx,0
        loop_compare:
        mov bl, byte ptr[edi+ecx]
        cmp bl,0
        je check
        cmp bl,byte ptr[esi+ecx]
        jne not_equal
        inc ecx
        jmp loop_compare
                
        check:
        mov eax,1
        jmp return_compare
        
        not_equal:
        mov eax,-1
        
        return_compare:
        pop ecx
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 8
    
     print_num:
        push ebp
        mov ebp,esp
        push esi
        push edi
        push ebx
        push edx
        
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
        
        pop edx
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
