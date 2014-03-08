Bits 16

jmp short boot
nop

;===========================================================
OEMLabel		db "Boot    "	; Disk label
BytesPerSector		dw 512		; Bytes per sector
SectorsPerCluster	db 1		; Sectors per cluster
ReservedForBoot		dw 1		; Reserved sectors for boot record
NumberOfFats		db 2		; Number of copies of the FAT
RootDirEntries		dw 224		; Number of entries in root dir
					; (224 * 32 = 7168 = 14 sectors to read)
LogicalSectors		dw 2880		; Number of logical sectors
MediumByte		db 0F0h		; Medium descriptor byte
SectorsPerFat		dw 9		; Sectors per FAT
SectorsPerTrack		dw 18		; Sectors per track (36/cylinder)
Sides			dw 2		; Number of sides/heads
HiddenSectors		dd 0		; Number of hidden sectors
LargeSectors		dd 0		; Number of LBA sectors
DriveNo			dw 0		; Drive No: 0
Signature		db 41		; Drive signature: 41 for floppy
VolumeID		dd 00000000h	; Volume ID: any number
VolumeLabel		db "PENGUOS    "; Volume Label: any 11 chars
FileSystem		db "FAT12   "	; File system type



absoluteSector   db 0
absoluteTrack	  db 0
absoluteHead      db 0


;====================================================================


boot:
	cli
	mov ax, 0x07C0               ;set segment registers
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
								 ;create stack
	
	mov ax, 0x0000				 ;bottom of stack
	mov ss, ax
	mov sp, 0xFFFF              ;top of stack
	sti							;restore interrupts
	
	
	mov dl, 0
	mov [bootdev], dl
	
	;Logical sector location of root = ReservedSectors + FATs = 1 + 2*(9) = 19
	;Load Root Directory into Memory Location (0x07C0:0x0200)
	mov ax, 19
.Load_Root:	
	call CHS
	mov bx, ds
	mov bx, 0x0200
	mov es, bx
	
	mov ah, 2			;Int 0x13 function code to read disk into memory
	mov al, 14		    ;Read all 14 sectors containing root directory
	;pusha
	
.Read_Root:
	;popa 
	pusha
	
	stc					;Set carry flag to one
	call ReadSectors
	;int 13h				;Interrupt to read sectors into memory
						;Sets carry on error, clears if no error
						
	jnc .Search_Root		;If carry is not set, read successful
	call Reset			;Otherwise, reset 
	
.Search_Root:
	popa
	mov ax, ds
	mov es, ax
	mov di, 0x0200
	
	mov cx, word [RootDirEntries] 
	.LOOP:
		push cx
		push di
		mov cx, 0x000B
		mov si, KernelName
	rep cmpsb
		pop di
		je Found_File
		pop cx
		add di, 0x0020
		loop .LOOP
		jmp Reset

Found_File:
	mov ax, word [di + 0x001A]
	mov word [cluster], ax
		
	xor ax, ax
	mov bx, 0x0200 				;(Overrwrite Root Directory in Memory)
	
	mov ax, 1					;ReservedSector = 1
	call CHS
	
	
	mov ah, 2
	mov al, 9					;All 9 sectors of first FAT
								;2nd FAT used for backup
								
Read_FAT:
	call ReadSectors
	
	;int 0x13					;INT 13 read
	
	jnc Read_OK
	call Reset
	jnc Read_FAT
	

Read_OK:
	mov ax, 50h					;Location where kernel image will be loaded
	mov es, ax					;(ES:BX) => (50h:0000)
	mov bx, 0
	
	mov ah, 2
	mov al, 1
	
	
	push ax						;Save AX
	
	
Load_File_Sector:
	
	mov     ax, WORD [cluster]                  ; cluster to read
          pop     bx                                  ; buffer to read into
          call    ClusterLBA                          ; convert cluster to LBA      (So we can Read it in)
          ;xor     cx, cx								;NOTE: Cluster numbers are relative to the partition and NOT the start of the disk   (Cluster numbers (0 and 1) are reserved)
													   ;Convert cluster number to LBA to get absolute disk sector where cluster is stored in the data region
													   ;http://micropenguin.net/files/Pengu/FAT12Description.pdf
          ;mov     cl, BYTE [bpbSectorsPerCluster]     ; sectors to read
		  
          call    CHS                          ;(ES:BX from above)
		  ;int 0x13
		  call ReadSectors
          push    bx
          
     ; compute next cluster
     
          mov     ax, WORD [cluster]                  ; identify current cluster
          mov     cx, ax                              ; copy current cluster
          mov     dx, ax                              ; copy current cluster
          shr     dx, 0x0001                          ; divide by two
          add     cx, dx                              ; sum for (3/2)
          mov     bx, 0x0200                          ; location of FAT in memory
          add     bx, cx                              ; index into FAT
          mov     dx, WORD [bx]                       ; read two bytes from FAT
          test    ax, 0x0001
          jnz     .ODD_CLUSTER
          
     .EVEN_CLUSTER:
     
          ;and     dx, 0000111111111111b               ; take low twelve bits
         and dx, 0FFFh
		 jmp     .DONE
         
     .ODD_CLUSTER:
     
          shr     dx, 0x0004                          ; take high twelve bits
          
     .DONE:
     
          mov     WORD [cluster], dx                  ; store new cluster
          cmp     dx, 0x0FF0                          ; test for end of file
          jb     Load_File_Sector
          
     DONE:
     
          ;mov     si, msgCRLF
          ;call    Print
          ;push    WORD 0x0050
          ;push    WORD 0x0000
          ;retf
          
		  jmp 0x050:0x0000
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
CHS:			; Calculate head, track and sector settings for int 13h
			; IN: logical sector in AX, OUT: correct registers for int 13h
	push bx
	push ax

	mov bx, ax			; Save logical sector

	xor dx, dx			; First the sector
	div word [SectorsPerTrack]
	inc dl 				; Physical sectors start at 1
	mov [absoluteSector], dl  ; Sectors belong in CL for int 13h
	xor dx, dx			
	div word [Sides]		; Now calculate the head
	
	mov [absoluteHead], dl
	mov [absoluteTrack], al

	pop ax
	pop bx

	mov dl, byte [bootdev]		; Set correct device

	ret

ReadSectors:
		  mov     ch, BYTE [absoluteTrack]            ; track
          mov     cl, BYTE [absoluteSector]           ; sector
          mov     dh, BYTE [absoluteHead]             ; head
          mov     dl, BYTE [bsDriveNumber]            ; drive
          int     0x13                                ; invoke BIOS
	
	
ClusterLBA:
          sub     ax, 0x0002                          ; zero base cluster number
          xor     cx, cx
          mov     cl, BYTE [SectorsPerCluster]     ; convert byte to word
          mul     cl
          add     ax, WORD [datasector]               ; base data sector
		  
          ret
	
	
	
Reset:
		mov ah, 0
		mov dl, 0
		;int 0x13
		call ReadSectors
		ret
FAILURE:
     
          mov     si, msgFailure
          call    Print
          mov     ah, 0x00
          int     0x16                                ; await keypress
          int     0x19                                ; warm boot computer
		  
Print:
			lodsb				; load next byte from string from SI to AL
			or	al, al			; Does AL=0?
			jz	PrintDone		; Yep, null terminator found-bail out
			mov	ah, 0eh			; Nope-Print the character
			int	10h
			jmp	Print			; Repeat until null terminator found
	PrintDone:
			ret				; we are done, so return
	
	
	;===========================
	bootdev db 0            ;boot device 
	KernelName db	"KERNEL  BIN"
	cluster dw 0
	datasector dw 9
	msgFailure db "ERROR: Cannot find Kernel.bin", 0
	
	
	
	
	
times 510 - ($-$$) db 0
dw 0AA55h
