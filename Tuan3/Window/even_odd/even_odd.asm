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
    n        dw ?
    msg1     db "Nhap cac phan tu cua mang:(cach nhau boi dau cach) ",0
    arr      db 1001 dup(?)  
    arr_num  dw 101 dup(?)
    
    msg2     db "Chan: ",0
    msg3     db "Le: ",0
    
    even_num dw ?
    
.code
start:
    
    push offset msg1
    call StdOut
    
    push 1001
    push offset arr
    call StdIn
    
    push offset arr
    call count_elements
    mov dword ptr[n],eax
    
    push offset arr_num
    push offset arr
    call calculate
    
    push offset msg2
    call StdOut
    
    push offset arr_num
    call count_even
    mov dword ptr[even_num],eax
    push eax
    call print_num
    
    push offset msg3
    call StdOut
    
    mov eax,dword ptr[n]
    sub eax,dword ptr[even_num]
    push eax
    call print_num
    
    exit_program:
    ;exit program
    xor eax,eax
    ret
    
    ;some untility functions 
    count_even:
        push ebp
        mov ebp,esp
        sub esp,4       ;count_even
        push esi
        push edi
        push ebx
        
        mov dword ptr[ebp-4],0
        mov esi,[ebp+8]
        mov eax,0
        mov ecx,-1
        loop_even:
        inc ecx
        mov eax,dword ptr[esi+4*ecx]
        cmp eax,0
        je done_count_even
        mov ebx,2
        mov edx,0
        div ebx
        cmp edx,0
        jne loop_even
        inc dword ptr[ebp-4]
        jmp loop_even
        
        done_count_even:
        mov eax,dword ptr[ebp-4]
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 4
    
    calculate:
        push ebp
        mov ebp,esp
        sub esp,18
        push esi
        push edi
        push ebx
        
        mov dword ptr[ebp-14],0     
        mov dword ptr[ebp-18],0     ;index of arr_num
        lea ebx,[ebp-10] ;temp_num
        mov esi,[ebp+8]  ;arr_str
        mov edi,[ebp+12] ;arr_num
        
        mov ecx,-1
        loop_cal:
        inc ecx
        mov dl,byte ptr[esi+ecx]
        cmp dl,0
        je done_cal
        cmp dl,20h
        je coppy_to_temp
        mov eax,dword ptr[ebp-14]
        mov byte ptr[ebx+eax],dl
        inc dword ptr[ebp-14]
        jmp loop_cal
        
        coppy_to_temp:
        mov byte ptr[ebp-14],0
        push ebx
        lea ebx,[ebp-10]
        push ebx
        call atoi
        mov ebx,dword ptr[ebp-18]
        mov dword ptr[edi+4*ebx],eax
        inc dword ptr[ebp-18]
        pop ebx
        jmp loop_cal
        
        done_cal:
        mov byte ptr[ebp-14],0
        push ebx
        lea ebx,[ebp-10]
        push ebx
        call atoi
        mov ebx,dword ptr[ebp-18]
        mov dword ptr[edi+4*ebx],eax
        inc dword ptr[ebp-18]
        pop ebx
        
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 8
    
    count_elements:
        push ebp
        mov ebp,esp
        push esi
        push edi
        push ebx
        
        mov esi,[ebp+8]
        mov eax,0
        mov ecx,-1
        loop_counts:
        inc ecx
        mov bl,byte ptr[esi+ecx]
        cmp bl,0
        je done_counts
        cmp bl,32
        jne loop_counts
        inc eax
        jmp loop_counts
        
        done_counts:
        add eax,1
        
        pop ebx
        pop edi
        pop esi
        mov esp,ebp
        pop ebp
        ret 4
    
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
