;Justin Yang
;PenguOS v.4 BOOTLOADER

	BITS 16

	jmp short bootloader_start	; Jump past disk description section
	nop				; Pad out before disk description


; ------------------------------------------------------------------
; Disk description table, to make it a valid floppy
; Note: some of these values are hard-coded in the source!
; Values are those used by IBM for 1.44 MB, 3.5" diskette

OEMLabel		db "BOOT    "	; Disk label
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
VolumeLabel		db "PenguOS "; Volume Label: any 11 chars
FileSystem		db "FAT12   "	; File system type: don't change!


absoluteSector db 0
absoluteHead db 0
absoluteTrack db 0 
; ------------------------------------------------------------------
; Main bootloader code

bootloader_start:
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

no_change:
	mov eax, 0			; Needed for some older BIOSes


; First, we need to load the root directory from the disk. Technical details:
; Start of root = ReservedForBoot + NumberOfFats * SectorsPerFat = logical 19
; Number of root = RootDirEntries * 32 bytes/entry / 512 bytes/sector = 14
; Start of user data = (start of root) + (number of root) = logical 33

floppy_ok:				; Ready to read first block of data
	mov ax, 19			; Root dir starts at logical sector 19
	call CHS

	;mov si, buffer			; Set ES:BX to point to our buffer (see end of code)
	mov si, 0x0200
	mov bx, ds
	mov es, bx
	mov bx, si

	mov ah, 2			; Params for int 13h: read floppy sectors
	mov al, 14			; And read 14 of them

	pusha				; Prepare to enter loop


read_root_dir:
	popa				; In case registers are altered by int 13h
	pusha

	stc				; A few BIOSes do not set properly on error
	int 13h				; Read sectors using BIOS

	jnc search_dir			; If read went OK, skip ahead
	call reset_floppy		; Otherwise, reset floppy controller and try again
	jnc read_root_dir		; Floppy reset OK?

	jmp reboot			; If not, fatal double error


search_dir:
	popa

	mov ax, ds			; Root dir is now in [buffer]
	mov es, ax			; Set DI to this info
	;mov di, buffer
	mov di, 0x0200
	
	mov cx, word [RootDirEntries]	; Search all (224) entries
	mov ax, 0			; Searching at offset 0


next_root_entry:
	mov ax, ds
	mov es, ax
	mov di, 0x0200
	
	mov cx, word [RootDirEntries] 
	.LOOP:
		push cx
		push di
		mov cx, 0x000B
		mov si, kern_filename
	rep cmpsb
		pop di
		je found_file_to_load
		pop cx
		add di, 0x0020
		loop .LOOP
		jmp file_not_found



found_file_to_load:			; Fetch cluster and load FAT into RAM
	;mov ax, word [es:di+0Fh]	; Offset 11 + 15 = 26, contains 1st cluster
	mov ax, word [di+0x001A]
	mov word [cluster], ax

	mov ax, 1			; Sector 1 = first sector of first FAT
	call CHS

	;mov di, buffer			; ES:BX points to our buffer
	mov di, 0x0200
	mov bx, di

	mov ah, 2			; int 13h params: read (FAT) sectors
	mov al, 9			; All 9 sectors of 1st FAT

	pusha				; Prepare to enter loop


read_fat:
	popa				; In case registers are altered by int 13h
	pusha

	stc
	int 13h				; Read sectors using the BIOS

	jnc read_fat_ok			; If read went OK, skip ahead
	call reset_floppy		; Otherwise, reset floppy controller and try again
	jnc read_fat			; Floppy reset OK?

; ******************************************************************
fatal_disk_error:
; ******************************************************************
	mov si, disk_error		; If not, print error message and reboot
	call print_string
	jmp reboot			; Fatal double error


read_fat_ok:
	popa

	;mov ax, 2000h			; Segment where we'll load the kernel
	mov ax, 2000h
	mov es, ax
	mov bx, 0

	mov ah, 2			; int 13h floppy read params
	mov al, 1

	push ax				; Save in case we (or int calls) lose it


; Now we must load the FAT from the disk. Here's how we find out where it starts:
; FAT cluster 0 = media descriptor = 0F0h
; FAT cluster 1 = filler cluster = 0FFh
; Cluster start = ((cluster number) - 2) * SectorsPerCluster + (start of user)
;               = (cluster number) + 31

load_file_sector:
	mov ax, word [cluster]		; Convert sector to logical
	add ax, 31

	call CHS
	;call l2hts			; Make appropriate params for int 13h

	mov ax, 2000h			; Set buffer past what we've already read
	mov es, ax
	mov bx, word [pointer]

	pop ax				; Save in case we (or int calls) lose it
	push ax

	stc
	;call CHS
	int 13h

	jnc calculate_next_cluster	; If there's no error...

	call reset_floppy		; Otherwise, reset floppy and retry
	jmp load_file_sector


	; In the FAT, cluster values are stored in 12 bits, so we have to
	; do a bit of maths to work out whether we're dealing with a byte
	; and 4 bits of the next byte -- or the last 4 bits of one byte
	; and then the subsequent byte!

calculate_next_cluster:
	mov ax, [cluster]
	mov dx, 0
	mov bx, 3
	mul bx
	mov bx, 2
	div bx				; DX = [cluster] mod 2
	;mov si, buffer
	mov si, 0x0200
	add si, ax			; AX = word in FAT for the 12 bit entry
	mov ax, word [si]

	;or dx, dx			; If DX = 0 [cluster] is even; if DX = 1 then it's odd
	
	test dx, 1
	
	jz even				; If [cluster] is even, drop last 4 bits of word
					; with next cluster; if odd, drop first 4 bits

odd:
	shr ax, 4			; Shift out first 4 bits (they belong to another entry)
	jmp short next_cluster_cont


even:
	and ax, 0FFFh			; Mask out final 4 bits


next_cluster_cont:
	mov word [cluster], ax		; Store cluster

	cmp ax, 0FF8h			; FF8h = end of file marker in FAT12
	jae end

	add word [pointer], 512		; Increase buffer pointer 1 sector length
	;add bx, ax
	jmp load_file_sector


end:					; We've got the file to load!
	pop ax				; Clean up the stack (AX was pushed earlier)
	mov dl, byte [bootdev]		; Provide kernel with boot device info

	jmp 2000h:0000h			; Jump to entry point of loaded kernel!
; ------------------------------------------------------------------
; BOOTLOADER SUBROUTINES

reboot:
	mov ax, 0
	int 16h				; Wait for keystroke
	mov ax, 0
	int 19h				; Reboot the system


print_string:				; Output string in SI to screen
	pusha

	mov ah, 0Eh			; int 10h teletype function

.repeat:
	lodsb				; Get char from string
	cmp al, 0
	je .done			; If char is zero, end of string
	int 10h				; Otherwise, print it
	jmp short .repeat

.done:
	popa
	ret


reset_floppy:		; IN: [bootdev] = boot device; OUT: carry set on error
	push ax
	push dx
	mov ax, 0
	mov dl, byte [bootdev]
	stc
	int 13h
	pop dx
	pop ax
	ret


CHS:

xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [SectorsPerTrack]           ; calculate (AX / WORD [bpbSectorsPerTrack]
          inc     dl                                  ; adjust for sector 0
          mov     BYTE [absoluteSector], dl
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [Sides]          ; calculate
          mov     BYTE [absoluteHead], DL             ;
          mov     BYTE [absoluteTrack], AL            ;Quotient is returned in AL
          
		  mov     ch, BYTE [absoluteTrack]            ; track
          mov     cl, BYTE [absoluteSector]           ; sector
          mov     dh, BYTE [absoluteHead]             ; head
          mov     dl, 0            ; drive
          ;int     0x13                                ; invoke BIOS
		  
		  
		  ret
	
	
	
	
ClusterLBA:
          sub     ax, 0x0002                          ; zero base cluster number
          xor     cx, cx
          mov     cl, BYTE [SectorsPerCluster]     ; convert byte to word
          mul     cl
          ;add     ax, WORD [datasector]               ; base data sector
		  add word ax, 33
          ret
	
	
	
	
	
; ------------------------------------------------------------------
; STRINGS AND VARIABLES

	kern_filename	db "KERNEL  BIN"	; MikeOS kernel filename

	disk_error	db "Floppy error! Press any key...", 0
	file_not_found	db "KERNEL.BIN not found!", 0

	bootdev		db 0 	; Boot device number
	cluster		dw 0 	; Cluster of the file we want to load
	pointer		dw 0 	; Pointer into Buffer, for loading kernel


; ------------------------------------------------------------------
; END OF BOOT SECTOR AND BUFFER START

	times 510-($-$$) db 0	; Pad remainder of boot sector with zeros
	dw 0AA55h		; Boot signature (DO NOT CHANGE!)




; ==================================================================

Print:
			lodsb				; load next byte from string from SI to AL
			or	al, al			; Does AL=0?
			jz	PrintDone		; Yep, null terminator found-bail out
			mov	ah, 0eh			; Nope-Print the character
			int	10h
			jmp	Print			; Repeat until null terminator found
	PrintDone:
			ret				; we are done, so return
