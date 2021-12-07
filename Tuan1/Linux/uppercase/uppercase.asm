section .data
	msg1		db	"Input string: ",0
	len_msg1 	equ	$-msg1

section .bss
	input_str	resb	32

section .text
	global _start:
_start:

	mov eax,len_msg1
	lea ebx,[msg1]
	push eax
	push ebx
	call print

	push 32
	lea ebx,[input_str]
	push ebx
	call stdIn

	lea ebx,[input_str]
	push ebx
	call  Uppercase

	push 32
	lea ebx,[input_str]
	push ebx
	call print

	mov eax,1
	mov ebx,0
	int 0x80


;some untilities functions
Uppercase:
	push ebp
	mov ebp,esp
	push esi
	push edi
	push ebx

	mov esi,[ebp+8]
	mov ecx,-1

	L2:
	inc ecx
	mov bl,byte[esi+ecx]
	cmp bl,0
	je done_upper
	cmp bl,'a'
	jl  noChange
	cmp bl,'z'
	jle toUppercase

	noChange:
	jmp L2

	toUppercase:
	sub bl,20h
	mov byte[esi+ecx],bl
	jmp L2

	done_upper:
	pop ebx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 4


print:
	push ebp
	mov ebp,esp
	push esi
	push edi
	push ebx

	mov edx,[ebp+12]
	mov ecx,[ebp+8]
	mov ebx,1
	mov eax,4
	int 0x80

	pop ebx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 8

stdIn:
	push ebp
	mov ebp,esp
	push esi
	push edi
	push ebx

	mov edx,[ebp+12]
	mov ecx,[ebp+8]
	mov ebx,2
	mov eax,3
	int 0x80

	pop ebx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 8

str_len:
	push ebp
	mov ebp,esp
	push esi
	push edi
	push ebx

	mov eax,0
	mov esi,[ebp+8]
	mov ecx,-1

	loop_count_length:
	inc ecx
	mov bl,byte[esi+ecx]
	cmp bl,0
	je done_count_length
	inc eax
	jmp loop_count_length

	done_count_length:
	pop ebx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 4
