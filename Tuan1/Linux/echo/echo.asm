section .data
	msg1 		db "Input string: ",0
	len_msg1	equ $-msg1
	msg2		db "Result: ",0
	len_msg2	equ $-msg2

section .bss
	input_str	resb  32

section .text
	global _start

_start:
	mov eax,len_msg1
	push eax
	lea ebx,[msg1]
	push ebx
	call print

	mov eax,32
	lea ebx,[input_str]
	push eax
	push ebx
	call stdIn

	lea ebx,[input_str]
	push ebx
	call str_len

	push eax
	lea ebx,[input_str]
	push ebx
	call print

	;Exit program
	mov eax,1
	mov ebx,0
	int 0x80


;some untilities functions
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
