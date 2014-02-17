global _main

extern _printf
extern _scanf


section .data

prompt	   db "Enter a number: ", 0
square_msg db "Square of input is: ",0
cube_msg   db "Cube of input is ", 0
cube25_msg db "Cube of input times 25 is ",0
quot_msg   db "Quotient of cube/100 is ",0
rem_msg    db "Remainder of cube/100 is ",0
neg_msg    db "The negation of the remainder is ",0
nl 	   db "",0DH, 0AH, 0

fmt db "%s",0
fmtint db "%d",0

segment .bss
input resd 1


segment .text

_main:
	push ebp
	mov ebp, esp
	
	mov eax, prompt
	push eax
	call _printf
	pop eax

	push input
	push fmtint        ;format for inputting numbers
	call _scanf
	add esp, 8
	
	mov eax, [input]  ;copy value in input to eax register
	
	imul eax
	mov ebx, eax
	mov eax, square_msg
	push eax
	push fmt
	call _printf
	add esp, 4
	pop eax

	
	mov eax, ebx
	imul ebx, [input]
	mov eax, cube_msg
	push eax
	push fmt
	call _printf
	add esp, 4
	pop eax
	
	mov eax, ebx
	push eax
	push fmtint
	call _printf
	add esp, 4
	pop eax

	
	push nl          ;prints a new line
	call _printf
	add esp, 4

	mov eax, cube25_msg
	push eax
	push fmt
	call _printf
	add esp, 4
	pop eax

	imul ecx, ebx, 25    ; ecx = ebx*25
	mov eax, ecx
	push eax
	push fmtint	
	call _printf
	add esp, 4
	pop eax
	
	push nl          ;prints a new line
	call _printf
	add esp, 4

	mov eax, ebx
	cdq
	mov ecx, 100
	idiv ecx               ;edx:eax / ecx
	mov ecx, eax           ; saves the quotient into ecx
	mov eax, quot_msg
	push edx
	push ecx
	push eax
	push fmt
	call _printf
	add esp,4
	pop eax
	pop ecx
	pop edx
	
	mov eax, ecx
	push edx
	push eax
	push fmtint
	call _printf
	add esp, 4
	pop eax
	pop edx

	push edx
	push nl          ;prints a new line
	call _printf
	add esp, 4
	pop edx

	
	
	mov eax, rem_msg
	push edx
	push eax
	push fmt
	call _printf
	add esp, 4
	pop eax
	pop edx
	
	mov eax, edx
	push edx
	push eax
	push fmtint
	call _printf
	add esp, 4
	pop eax
	pop edx

	push edx
	push nl          ;prints a new line
	call _printf
	add esp, 4
	pop edx	

	neg edx
	mov eax, neg_msg
	push edx
	push eax
	push fmt
	call _printf
	add esp, 4
	pop eax
	pop edx
	
	mov eax, edx
	push eax
	push fmtint
	call _printf
	add esp, 4
	pop eax
	
	
	
	

	
	
	


	mov esp, ebp
	pop ebp
ret
	