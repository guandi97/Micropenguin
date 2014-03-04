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
;=========================================================
;BIOS Parameter Block

bpbOEM			db "My OS   "			; OEM identifier (Cannot exceed 8 bytes!)
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	DB 2
bpbRootEntries: 	DW 224
bpbTotalSectors: 	DW 2880
bpbMedia: 		DB 0xF0
bpbSectorsPerFAT: 	DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 		DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOSSTHEBOSS"
bsFileSystem: 	        DB "FAT12   "

;==============================================================


bootloader_start:
	mov ax, 07C0h           ;If the disk is bootable, Then the bootsector will be loaded 
			        ;at 0x7C00, and INT 0x19 will jump to it, therby giving 
				;control to the bootloader.
	mov ds, ax
	mov es, ax            ;set up segments

	mov     ax, 0x0000				; set the stack
        mov     ss, ax
        mov     sp, 0xFFFF
        sti						; restore interrupts


	mov si, msg_loading
	call Print	

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
          call    Read_Sector


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
LOAD_FAT:
;----------------------------------------------------------------
	
	mov dx, [di + 0x001A]          ;After finding stage 2, DI contains the starting address of entry
	mov WORD [cluster], dx         ;Save info to variable             
	
				       ;Find how many sectors are in both FAT
				       ;Compute size of FAT
	xor ax, ax 
	mov al, [bpbNumberOfFATs]
	mul WORD [bpbSectorsPerFAT]
        mov cx, ax                               ;CX = number of sectors the FATs use
	
	mov ax, WORD[bpbReservedSectors]  ;Account for bootsector
	

	mov bx, 0x0200              
	call Read_Sector               ;Load FAT Table

	;Read image file to memory
	
	mov ax, 0x0050
	mov es, ax 
	mov bx, 0x0000                    ;Where image will be read to
	push bx 

;----------------------------------------------------------------
;LOAD IMAGE FILE (KERNEL)
;----------------------------------------------------------------
	
Load_Image:
	mov ax, WORD [cluster]                    ;cluster to read into memory
	pop bx                                    ;Where to read into
	call CHS_LBA                              ;Convert cluster to LBA
	mov cl, BYTE [bpbSectorsPerCluster]       ;Number of sectors to read
	call Read_Sector                          ;Read all sectors used by image file
	push bx                                   

	mov ax, WORD [cluster]              ;Get current cluster
	mov cx, ax                          ;copy to CX
	mov dx, ax                          ;copy to DX
	shr dx, 0x0001
	add cx, dx
	mov bx, 0x0200
	add bx, cx
	mov dx, WORD [bx]
	test ax, 0x0001
	jnz .ODD_CLUSTER

.EVEN_CLUSTER:
	and	dx, 0000111111111111b        ;Mask top 4 bits
	jmp .DONE
.ODD_CLUSTER:
	shr	dx, 0x0004                   ;Shift down 4 bits
.DONE:
	mov WORD[cluster], dx
	cmp dx, 0x0FF0
	jb	Load_Image


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

	ret
				 
	

;-----------------------------------------------------------------
;Convert CHS to LBA

CHS_LBA:
          sub     ax, 0x0002                          ; zero base cluster number
          xor     cx, cx
          mov     cl, BYTE [bpbSectorsPerCluster]     ; convert byte to word
          mul     cx
          add     ax, WORD [datasector]               ; base data sector
          ret
;-------------------------------------------------------------------

;-------------------------------------------------------------------
;Convert LBA to CHS
LBACHS:
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbSectorsPerTrack]           ; calculate
          inc     dl                                  ; adjust for sector 0
          mov     BYTE [absoluteSector], dl
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbHeadsPerCylinder]          ; calculate
          mov     BYTE [absoluteHead], dl
          mov     BYTE [absoluteTrack], al
          ret
;---------------------------------------------------------------------


 FAILURE:
     
          mov     si, msgFailure
          call Print
          mov     ah, 0x00
          int     0x16                                ; await keypress
          int     0x19                                ; warm boot computer

;------------------------------------------

Print:
			lodsb				; load next byte from string from SI to AL
			or	al, al			; Does AL=0?
			jz	PrintDone		; Yep, null terminator found-bail out
			mov	ah, 0eh			; Nope-Print the character
			int	10h
			jmp	Print			; Repeat until null terminator found
	PrintDone:
			ret	



;Data

bootdev db 0                                           ;boot device number (used by int 13h)
fileName db "KERNEL  BIN"                              ;must be 11 bytes in size
FirstSector dw 0
msg db "hello!", 0
msg_loading db "Pengu Operating System Loading...",0
datasector db "",0
absoluteSector db 0x00
absoluteHead   db 0x00
absoluteTrack  db 0x00
cluster     dw 0x0000
msgFailure  db 0x0D, 0x0A, "ERROR : Press Any Key to Reboot", 0x0A, 0x00

times 510-($-$$) db 0	        ; Pad remainder of boot sector with zeros
	dw 0AA55h		; Boot signature (DO NOT CHANGE!) This tells BIOS that disk is bootable


