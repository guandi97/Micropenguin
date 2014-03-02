BITS 16

jmp short bootloader_start
nop

bootloader_start:
	mov ax, 07C0h
	mov ds, ax
	mov es, ax            ;set up segments

	
	cli
	mov ss, ax
	mov sp, 4096
	sti

	mov ax, 07C0h
	mov ds, ax









times 510-($-$$) db 0	        ; Pad remainder of boot sector with zeros
	dw 0AA55h		; Boot signature (DO NOT CHANGE!)


	