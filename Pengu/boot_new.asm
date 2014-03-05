;----Some Info-------
;Segments are sections of memory 64kb in size
;Registers that store the base address of a segment: CS, DS, ES, SS
;Offset is a number that is added to a base number
;Segment:offset addressing (Add base address[segment] with offset address)
;We keep one address fixed (base address) and add a number (offset) to it to reach any location between (0-64kb)
;xor bx, bx clears BX to 0 (xor against oneself always results in zero)

;FAT: http://www.eit.lth.se/fileadmin/eit/courses/eitn50/Projekt1/FAT12Description.pdf
;(Cluster - 2) Y??? Here's why: http://stackoverflow.com/questions/14785723/converting-the-cluster-number-stored-in-fat-table-of-fat12-filesystem-for-read

;ISO (RENAME KERNEL.BIN in current directory, OTHERWISE INT 0x18 ERROR)
;  //mkisofs -no-emul-boot -boot-load-size 4 -o PenguOS.iso -b boot.img .



BITS 16						; we are in 16 bit real mode

;org	0						; we will set regisers later

start:	jmp	main					; jump to start of bootloader

;*********************************************
;	BIOS Parameter Block
;*********************************************

; BPB Begins 3 bytes from start. We do a far jump, which is 3 bytes in size.
; If you use a short jump, add a "nop" after it to offset the 3rd byte.

bpbOEM			db "My OS   "			; OEM identifier (Cannot exceed 8 bytes!)
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	DB 2
bpbRootEntries: 	DW 224
bpbTotalSectors: 	DW 2880
bpbMedia: 		DB 0xf8  ;; 0xF1
bpbSectorsPerFAT: 	DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 		DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "

;************************************************;
;	Prints a string
;	DS=>SI: 0 terminated string
;************************************************;
Print:
			lodsb				; load next byte from string from SI to AL
			or	al, al			; Does AL=0?
			jz	PrintDone		; Yep, null terminator found-bail out
			mov	ah, 0eh			; Nope-Print the character
			int	10h
			jmp	Print			; Repeat until null terminator found
	PrintDone:
			ret				; we are done, so return

;************************************************;
; Reads a series of sectors
; CX=>Number of sectors to read
; AX=>Starting sector
; ES:BX=>Buffer to read to
;************************************************;

ReadSectors:
     .MAIN:
          mov     di, 0x0005                          ; five retries for error
     .SECTORLOOP:
          push    ax
          push    bx
          push    cx
          call    LBACHS                              ; convert starting sector to CHS (Needed for Int 0x13)
		  mov     ah, 0x02                            ; BIOS read sector
          mov     al, 0x01                            ; read one sector
          mov     ch, BYTE [absoluteTrack]            ; track
          mov     cl, BYTE [absoluteSector]           ; sector
          mov     dh, BYTE [absoluteHead]             ; head
          mov     dl, BYTE [bsDriveNumber]            ; drive
          int     0x13                                ; invoke BIOS
          jnc     .SUCCESS                            ; test for read error
          xor     ax, ax                              ; BIOS reset disk
          int     0x13                                ; invoke BIOS
          dec     di                                  ; decrement error counter
          pop     cx
          pop     bx
          pop     ax
          jnz     .SECTORLOOP                         ; attempt to read again
          int     0x18
     .SUCCESS:
          mov     si, msgProgress
          call    Print
          pop     cx
          pop     bx
          pop     ax
          add     bx, WORD [bpbBytesPerSector]        ; queue next buffer
          inc     ax                                  ; queue next sector
          loop    .MAIN                               ; read next sector
          ret

;************************************************;
; Convert CHS to LBA
; LBA = (cluster - 2) * sectors per cluster
;************************************************;

ClusterLBA:
          sub     ax, 0x0002                          ; zero base cluster number
          xor     cx, cx
          mov     cl, BYTE [bpbSectorsPerCluster]     ; convert byte to word
          mul     cl
          add     ax, WORD [datasector]               ; base data sector
		  
          ret
     
;************************************************;
; Convert LBA to CHS
; AX=>LBA Address to convert
;
; absolute sector = (logical sector % sectors per track) + 1
; absolute head   = (logical sector / sectors per track) MOD number of heads
; absolute track  = logical sector / (sectors per track * number of heads)
;
;************************************************;

LBACHS:
		  xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbSectorsPerTrack]           ; calculate (AX / WORD [bpbSectorsPerTrack]
          inc     dl                                  ; adjust for sector 0
          mov     BYTE [absoluteSector], dl
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbHeadsPerCylinder]          ; calculate
          mov     BYTE [absoluteHead], DL             ;
          mov     BYTE [absoluteTrack], AL            ;Quotient is returned in AL
          ret

;*********************************************
;	Bootloader Entry Point
;*********************************************

main:

     ;----------------------------------------------------
     ; code located at 0000:7C00, adjust segment registers
     ;----------------------------------------------------
     
          cli						; disable interrupts
          mov     ax, 0x07C0				; setup registers to point to our segment
          mov     ds, ax
          mov     es, ax
          mov     fs, ax
          mov     gs, ax

     ;----------------------------------------------------
     ; create stack
     ;----------------------------------------------------
     
          mov     ax, 0x0000				; set the stack
          mov     ss, ax
          mov     sp, 0xFFFF
          sti						; restore interrupts

     ;----------------------------------------------------
     ; Display loading message
     ;----------------------------------------------------
     
	mov ah, 09h             ;Change screen color
	mov cx, 1000h
	mov al, 20h
	mov bl, 17h
	int 10h
	
	
	reset_floppy:
		mov ah, 0
		mov dl, 0
		int 0x13
		jc reset_floppy
	 
	 
	 
          mov     si, msgLoading
          call    Print
          
     ;----------------------------------------------------
     ; Load root directory table
     ;----------------------------------------------------

     LOAD_ROOT:
     
     ; compute size of root directory and store in "cx"
     
          xor     cx, cx
          xor     dx, dx
          mov     ax, 0x0020                           ; 32 byte directory entry
          mul     WORD [bpbRootEntries]                ; total size of directory
          div     WORD [bpbBytesPerSector]             ; sectors used by directory
          xchg    ax, cx
          
     ; compute location of root directory and store in "ax"
     
          mov     al, BYTE [bpbNumberOfFATs]            ; number of FATs
          mul     WORD [bpbSectorsPerFAT]               ; sectors used by FATs
          add     ax, WORD [bpbReservedSectors]         ; adjust for bootsector
          mov     WORD [datasector], ax                 ; base of root directory
          add     WORD [datasector], cx
          
     ; read root directory into memory (7C00:0200)
     
          mov     bx, 0x0200                            ; copy root dir above bootcode
          call    ReadSectors                           ;(ES:BX)(0x07C0H:0200)

     ;----------------------------------------------------
     ; Find stage 2
     ;----------------------------------------------------

     ; browse root directory for binary image
          mov     cx, WORD [bpbRootEntries]             ; load loop counter
          mov     di, 0x0200                            ; locate first root entry
     .LOOP:
          push    cx
          mov     cx, 0x000B                            ; eleven character name
          mov     si, ImageName                         ; image name to find
          push    di
     rep  cmpsb                                         ; test for entry match
          pop     di                                    ;Restore value of DI
          je      LOAD_FAT
          pop     cx
          add     di, 0x0020                            ; queue next directory entry
          loop    .LOOP
          jmp     FAILURE

     ;----------------------------------------------------
     ; Load FAT
     ;----------------------------------------------------

     LOAD_FAT:
     
     ; save starting cluster of boot image
     
          mov     si, msgCRLF
          call    Print
          mov     dx, WORD [di + 0x001A]
          mov     WORD [cluster], dx                  ; file's first cluster
          
     ; compute size of FAT and store in "cx"
     
          xor     ax, ax
          mov     al, BYTE [bpbNumberOfFATs]          ; number of FATs
          mul     WORD [bpbSectorsPerFAT]             ; sectors used by FATs
          mov     cx, ax

     ; compute location of FAT and store in "ax"

          mov     ax, WORD [bpbReservedSectors]       ; adjust for bootsector
          
     ; read FAT into memory (7C00:0200)

          mov     bx, 0x0200                          ; copy FAT above bootcode
          call    ReadSectors

     ; read image file into memory (0050:0000)
     
          mov     si, msgCRLF
          call    Print
          mov     ax, 0x0050
          mov     es, ax                              ; destination for image (ES:BX buffer)
          mov     bx, 0x0000                          ; destination for image
          push    bx

     ;----------------------------------------------------
     ; Load Stage 2
     ;----------------------------------------------------

     LOAD_IMAGE:
                                               
          mov     ax, WORD [cluster]                  ; cluster to read
          pop     bx                                  ; buffer to read into
          call    ClusterLBA                          ; convert cluster to LBA      (So we can Read it in)
          ;xor     cx, cx								;NOTE: Cluster numbers are relative to the partition and NOT the start of the disk   (Cluster numbers (0 and 1) are reserved)
													   ;Convert cluster number to LBA to get absolute disk sector where cluster is stored in the data region
													   ;http://micropenguin.net/files/Pengu/FAT12Description.pdf
          ;mov     cl, BYTE [bpbSectorsPerCluster]     ; sectors to read
          call    ReadSectors                          ;(ES:BX from above)
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
     
          and     dx, 0000111111111111b               ; take low twelve bits
         jmp     .DONE
         
     .ODD_CLUSTER:
     
          shr     dx, 0x0004                          ; take high twelve bits
          
     .DONE:
     
          mov     WORD [cluster], dx                  ; store new cluster
          cmp     dx, 0x0FF0                          ; test for end of file
          jb     LOAD_IMAGE
          
     DONE:
     
          mov     si, msgCRLF
          call    Print
          ;push    WORD 0x0050
          ;push    WORD 0x0000
          ;retf
          
		  jmp 0x0050:0x0000
		  
		  
     FAILURE:
     
          mov     si, msgFailure
          call    Print
          mov     ah, 0x00
          int     0x16                                ; await keypress
          int     0x19                                ; warm boot computer
     
     absoluteSector db 0x00
     absoluteHead   db 0x00
     absoluteTrack  db 0x00
     
     datasector  dw 0x0000
     cluster     dw 0x0000
     ImageName   db "KERNEL  BIN"
     msgLoading  db 0x0D, 0x0A, "Loading PenguOS.... ", 0x0D, 0x0A, 0x00
     msgCRLF     db 0x0D, 0x0A, 0x00
     msgProgress db ".", 0x00
	 msg_lol	 db "*", 0
     msgFailure  db 0x0D, 0x0A, "ERROR : Press Any Key to Reboot", 0x0A, 0x00
     
          TIMES 510-($-$$) DB 0
          DW 0xAA55