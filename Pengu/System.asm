;This is the kernel for Pengu
;Does not have the 512 bytes restriction that the bootloader has.


bits 16
jmp main


Print:
	lodsb                 ;Loads next byte from SI to AL
	or al, al              ;Check if AL = 0
	jz .done               ;If AL = 0, jump to .done
	mov ah, 0eh            ;Otherwise print the character (function code)
	int 10h	 
	jmp Print              ;Loop until 0 terminator is found

.done:
	ret


main:
	cli
	push cs        ;Makes sure DS = CS
	pop ds

	mov si, msg
	call Print

	cli 
	hlt



msg db "Loading Pengu Operating System....",0