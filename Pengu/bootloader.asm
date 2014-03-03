;----Some Info-------
;Segments are sections of memory 64kb in size
;Registers that store the base address of a segment: CS, DS, ES, SS
;Offset is a number that is added to a base number
;Segment:offset addressing (Add base address[segment] with offset address)
;We keep one address fixed (base address) and add a number (offset) to it to reach any location between (0-64kb)
;xor bx, bx clears BX to 0 (xor against oneself always results in zero)




BITS 16

jmp short bootloader_start
nop

bootloader_start:
	mov ax, 07C0h           ;If the disk is bootable, Then the bootsector will be loaded 
			        ;at 0x7C00, and INT 0x19 will jump to it, therby giving 
				;control to the bootloader.
	mov ds, ax
	mov es, ax            ;set up segments

	


.reset_floppy:
	mov ah, 0
	mov dl, 0
	int 0x13
	jc .reset_floppy



load_root:
	LOAD_ROOT:
     
     	; compute size of root directory and store in "cx"
	;Multiply the number of entrys in the root directory by size of each entry (32 bytes)
     
          xor     cx, cx                          ;Make CX = 0
          xor     dx, dx                          ;Make DX = 0
          mov     ax, 0x0020                      ; 32 byte directory entry
          mul     WORD [bpbRootEntries]           ; total size of directory   (AX *= WORD [bpbRootEntries])
          div     WORD [bpbBytesPerSector]        ; sectors used by directory (AX */ WORD [bpbBytesPerSector])
          xchg    ax, cx                          ;swaps ax and cx. CX = AX, AX = 0
          
     ; compute location of root directory and store in "ax"
     
          mov     al, BYTE [bpbNumberOfFATs]       ; number of FATs      
          mul     WORD [bpbSectorsPerFAT]          ; sectors used by FATs
          add     ax, WORD [bpbReservedSectors]    ; adjust for bootsector
          mov     WORD [datasector], ax            ; base of root directory
          add     WORD [datasector], cx
          
     ; read root directory into memory (7C00:0200)
     
          mov     bx, 0x0200                        ; copy root dir above bootcode
          call    ReadSectors


;----------------------------------------------------------------
;FIND DAT STAGE 2
;----------------------------------------------------------------

	mov cx, [bpbRootEntries]	;Number of entries in Root Dir
	mov di, 0x0200                  ;Where Root directory was loaded
.Loop:
	push cx                         ;Save CX onto Stack
	mov cx, 11                      ;11 bytes per name
	mov si, fileName                ;Compare 11 bytes with name of kernel
	push di				;Save DI onto Stack
	rep cmpsb			;Repeat 11 times comparing each byte from DI with each byte in SI
					;Sets ZF flag if equal

	pop di                          ;Restore original value of DI before adding 11 bytes
	je LOAD_FAT			;If equal jump. (ZF flag set)
	pop cx
	add di, 32                      ;Go to the next entry(32 bytes)
	loop .Loop
	jmp FAILURE


;----------------------------------------------------------------
;LOAD FAT
;----------------------------------------------------------------
	
	mov dx, [di + 0x001A]          ;After finding stage 2, DI contains the starting address of entry

;----------------------------------------------------------------
;READ SECTOR INTO MEMORY
;----------------------------------------------------------------
Read_Sector:

	mov ax, 0x1000                 ;Writes sector to part memory!
	mov es, ax                     ;set es to address in memory
	xor bx, bx		       ;set bx to zero
				       ;ES:BX buffer address pointer


	mov ah, 0x02                   ;Set up registers for INT 0x13 (Read sector into memory address)
	mov al, 1
	mov ch, 1
	mov cl, 2
	mov dh, 0
	mov dl, 0
	int 0x13

	jmp 0x1000:0x0
				 
	
	
;------------------------------------------
;Data

bootdev db 0                                           ;boot device number (used by int 13h)
filename db "KERNEL  BIN"                              ;must be 11 bytes in size
FirstSector dw 0
msg db "hello!", 0


times 510-($-$$) db 0	        ; Pad remainder of boot sector with zeros
	dw 0AA55h		; Boot signature (DO NOT CHANGE!) This tells BIOS that disk is bootable


