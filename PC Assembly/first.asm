section .data

extern _printf
extern _scanf

prompt1 db "Enter a number: ", 0
prompt2 db "Enter another number: ",0
outmsg1 db "You entered ",0
outmsg2 db " and ",0
outmsg3 db ", the sum of these is ",0
fmt db "%d",0

segment .bss

input1 resd 1
input2 resd 1

segment .text
global	_main

_main:
	push ebp
	mov ebp, esp
	
	push prompt1
	;push fmt
	call _printf
	add esp, 4
	
	push input1
	push fmt
	call _scanf
	add esp, 8

	push prompt2
	call _printf
	add esp, 4
	
	push input2
	push fmt
	call _scanf
	add esp, 8

	mov eax, [input1]
	add eax, [input2]
	mov ebx, eax
	mov eax, [input1]
	push eax

	push outmsg1
	call _printf
	add esp, 4
	
	push fmt
	call _printf
	add esp, 4
	
	push outmsg2
	call _printf
	add esp, 4
	
	pop eax
	
	mov eax, [input2]
	push eax
	push fmt
	call _printf
	add esp, 4

	push outmsg3
	call _printf
	add esp, 4
	
	push ebx
	push fmt
	call _printf
	add esp, 8



	mov esp, ebp
	pop ebp

ret

