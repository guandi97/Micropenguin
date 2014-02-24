section .data
msg:    db "Hello World",10,0
fmt db "%d", 0Dh, 0Ah, 0
section .text
    global _main
    extern _printf


_main:
  
	push ebp
	mov ebp, esp
	mov ecx, 0
	
	
.next:
    ;push ecx         ;Save ECX
	add ecx, 1
	push ecx
	
	;push msg 
	
	push fmt
    	call _printf
    	add esp,4       

    	pop ecx          ;Restore ECX
	sub ecx, 1
    add ecx, 1
	cmp ecx, 5
    jne .next         

	

	mov esp, ebp
	pop ebp
    ret