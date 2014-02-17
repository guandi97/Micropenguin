global _main

extern _printf
extern _scanf

section .data
msg db "Find primes up to: ",0
fmtint db "%d", 0
fmt 	db "%s", 0
nl      db "", 0DH, 0AH, 0


segment .bss
Limit resd 1
Guess resd 1

segment .text

_main:
	push ebp
	mov ebp, esp        ;ebp and esp point to the top of the stack

	mov eax, msg
	push eax
	push fmt
	call _printf
	add esp, 4
	pop eax
	

	push Limit
	push fmtint
	call _scanf
	add esp, 8
	
	mov eax, 2
	push eax
	push fmtint
	call _printf
	add esp, 4
	pop eax
	
	push nl             ;Prints new line
	call _printf
	add esp, 4

	mov eax, 3
	push eax
	push fmtint
	call _printf
	add esp, 4
	pop eax

	push nl
	call _printf
	add esp, 4


	mov dword [Guess], 5
while_limit:
	mov eax, [Guess]
	cmp eax, [Limit]
	jnbe end_while_limit
	mov ebx, 3

while_factor:
	mov eax, ebx
	mul eax
	jo end_while_factor
	cmp eax, [Guess]
	jnb end_while_factor
	mov eax, [Guess]
	mov edx, 0
	div ebx
	cmp edx, 0
	je end_while_factor

	add ebx, 2
	jmp while_factor

end_while_factor:
	je end_if
	mov eax, [Guess]
	push eax
	push fmtint
	call _printf
	add esp, 4
	pop eax

	push nl
	call _printf
	add esp, 4
	
end_if:
	add dword [Guess], 2
	jmp while_limit


end_while_limit:
	
	mov esp, ebp
	pop ebp
ret
	
	
