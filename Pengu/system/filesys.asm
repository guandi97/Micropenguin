;Pengu FileSystem
;Used to browse disk for files to load
;Read root sector into memory
;Browse file names and put into a string buffer
;Print each file name



ls: 

pusha				;Save registers
call reset_floppy_   ;Make sure floppy controller starts reading from first sector


;call ReadSectors           ;EX:BX points to buffer

;mov ah, 2                  ;For INT 13h
;mov al, [datasectors]      ;Read from beginning of datasectors

						   ;Location of memory to read root from
;int 13h


;Just like parsing the root directory for our kernel
;We do the same for all files
mov cx, WORD [bpbRootEntries_]  
;mov di, 0x200                  ;This is where root directory starts in PenguOS
;push si                        ;Save SI, this register will be used for LODSB

mov si, lol
call f_Print


mov di, 0x7c00
mov si, 0x200
push ax



mov es, di

mov     cx, WORD [bpbRootEntries_]             ; load loop counter
          mov     di, 0x0200                            ; locate first root entry
     .LOOP:
          push    cx
          mov     cx, 0x000B                            ; eleven character name
          mov     si, ImageName_                         ; image name to find
          push    di
     rep  cmpsb                                         ; test for entry match
          pop     di                                    ;Restore value of DI
          je      _Printaws
          pop     cx
          add     di, 0x0020                            ; queue next directory entry
          loop    .LOOP








retf

;===============================================================
;Needs to be put in some separate include file

        reset_floppy_:
		mov ah, 0
		mov dl, 0
		int 0x13
		jc reset_floppy_
		ret
		  
		  
		f_PrintLine:
		mov ah, 0x0E
		int 0x10      ; otherwise, print out the character!
		ret
		
		_Printaws:
		mov si, lol
		call f_Print
		ret
;FAIL:
     
          ;mov     si, msgFailure_
          ;call    _Print
          ;mov     ah, 0x00
          ;int     0x16                                ; await keypress
          ;int     0x19                                ; warm boot computer



		  f_Print:
	lodsb					; load next byte from string from SI to AL
	or			al, al		; Does AL=0?
	jz			f_PrintDone	; Yep, null terminator found-bail out
	mov			ah,	0eh		; Nope-Print the character
	int			10h
	jmp			f_Print		; Repeat until null terminator found
f_PrintDone:
	ret				; we are done, so return

;================================
file_buffer times 64 db 0
msgFailure_	db "System failed to load directory...Rebooting",0
lol			db "You are awesome, you found me.",0
ImageName_ db "KERNEL  BIN"
tmp_list		dw 0

bpbRootEntries_: 	DW 224
