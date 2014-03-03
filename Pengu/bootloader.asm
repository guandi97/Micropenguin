;----Some Info-------
;Segments are sections of memory 64kb in size
;Registers that store the base address of a segment: CS, DS, ES, SS
;Offset is a number that is added to a base number
;Segment:offset addressing (Add base address[segment] with offset address)
;We keep one address fixed (base address) and add a number (offset) to it to reach any location between (0-64kb)





BITS 16

jmp short bootloader_start
nop

bootloader_start:
	mov ax, 07C0h           ;If the disk is bootable, Then the bootsector will be loaded 
			        ;at 0x7C00, and INT 0x19 will jump to it, therby giving 
				;control to the bootloader.
	mov ds, ax
	mov es, ax            ;set up segments

	                      ;set up stack
	cli                   ;clear interupts
	mov ss, ax            ;set stack segment pointer to base of stack (takes register as source because it is a segment)
	mov sp, 4096          ;set stack pointer to top of stack
	sti                   ;restores interupts

	;mov ax, 07C0h
	;mov ds, ax               ;move ax into data segment
	;mov es, ax

	mov [bootdev], dl        ;Saves boot device number (useful for switching drives)

				 ;Now we have to load the root
	
	




	


;------------------------------------------
;Data

bootdev db 0                                           ;boot device number (used by int 13h)
filename db "KERNEL  BIN"                              ;must be 11 bytes in size
FirstSector dw 0
msg db "hello!", 0


times 510-($-$$) db 0	        ; Pad remainder of boot sector with zeros
	dw 0AA55h		; Boot signature (DO NOT CHANGE!) This tells BIOS that disk is bootable


buffer:                         ;Where root begins
	