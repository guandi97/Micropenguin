;Justin Y

global _main

%define ARRAY_SIZE 100
%define NEW_LINE 10

segment .data

FirstMsg	db	"First 10 elements of array",0
Prompt		db	"Enter index of element to display: ",0
Secondmsg	db	"Element %d id %d", NEW_LINE, 0
Thirdmsg	db	"Elements 20 through 29 of array", 0
fmt	db	"%d", 0DH, 0AH, 0

segment .bss

array	resd ARRAY_SIZE

segment .text

extern _puts, _printf, _scanf, _dump_line, _push_array

_main: 
	
	push ebp
	mov ebp, esp



	;initialize array to 100, 99, 98, 97....
	
	mov ebx, array 
	mov ecx, ARRAY_SIZE
	mov eax, 3              
	
init_loop:
	;push eax                        ;MUL (EAX * SOURCE)
	mov eax, ecx                     ;push EAX or else it will be (EAX * ECX * EAX...) 
	;mul ecx
	mov [ebx], eax             ;loop decrements value in ecx that gets stored in ebx
	add ebx, 4                 ;Move down 4 bytes to next address
	;pop eax
	loop init_loop                  
	
	
	mov ecx, ARRAY_SIZE
	mov eax, 0
	;push ecx

	print_array:
	
	push ecx                     ;Save ECX on Stack lest it gets junked
	sub ebx, 4                 ; Move up 4 bytes to next address
	mov eax, [ebx]               ; Move value at address to EAX register
	push ebx 
	push eax
	push fmt
	call _printf
	add esp, 4
	pop eax
	pop ebx
	pop ecx
	loop print_array





	mov esp, ebp
	pop ebp
	ret