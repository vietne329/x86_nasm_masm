.386
.model flat, stdcall
option casemap : none
include \masm32\include\masm32rt.inc

.data
    msg db "Input string: ",0
    input_str db 33 dup(?)
    input_len dword ?
    caption_Box	db "Ket qua",0Dh,0Ah,0
.code
start:
    
    lea  ebx,[msg]
    push ebx
    call StdOut
    
    push 33
    push offset input_str
    call StdIn
   
    lea   ebx,input_str
    call  str_len
    mov   ebx,eax
    lea   eax,input_str
    push  ebx
    push  eax
    call  uppercase
    
    lea		ebx,caption_Box
    lea		eax,input_str
    push		MB_OK
    push		ebx
    push		eax
    push		0
    call		MessageBox
    
    xor eax, eax
    ret    
    
    str_len:
    push		ebp
	mov		ebp,esp
	sub		esp,4
	push		ebx
	push		esi

	mov		esi,[ebp+8]		; esi = *str
	mov		eax,0

	loop1:

	mov		bl,[esi]
	cmp		bl,0Dh
	je		done
	inc		eax
	inc		esi
	jmp		loop1

	done:
	pop		esi
	pop		ebx
	mov		esp,ebp
	pop		ebp
	ret		4
    
    ;void Uppercase(char *str,int len)
	uppercase:
	push		ebp
	mov		ebp,esp
	push		esi
        push            edi
	push		ebx

	mov		esi,[ebp+8]		;esi = *str
        mov             edi,[ebp+12]
	mov		ecx,-1			;index for str

	L2:
	inc		ecx
	mov		bl,byte ptr[esi+ecx]
	cmp		bl,0Dh
	je		done2
	cmp             bl,'a'
        jl              nochange
        cmp             bl,'z'
        jle             toUppercase
        
        nochange:
        jmp             L2
        
        toUppercase:
        sub             bl,20h
        mov             byte ptr[esi+ecx],bl
        jmp             L2
        
	done2:
	pop		ebx
        pop             edi
	pop		esi
	mov		esp,ebp
	pop		ebp
	ret		8
        
    end start
