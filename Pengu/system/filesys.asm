;Pengu FileSystem
;Used to browse disk for files to load
;Read root sector into memory
;Browse file names and put into a string buffer
;Print each file name


list_directory:
	mov cx,	0			; Counter

	mov ax, dirlist			; Get list of files on disk
	call os_get_file_list

	mov si, dirlist
	mov ah, 0Eh			; BIOS teletype function

.repeat:
	lodsb				; Start printing filenames
	cmp al, 0			; Quit if end of string
	je .done

	cmp al, ','			; If comma in list string, don't print it
	jne .nonewline
	pusha
	call os_print_newline		; But print a newline instead
	popa
	jmp .repeat

.nonewline:
	int 10h
	jmp .repeat

.done:
	call os_print_newline
	jmp get_cmd
	
;;=====================================================
_os_get_file_list:
	pusha

	;mov word [.file_list_tmp], ax

	;mov eax, 0			; Needed for some older BIOSes

	call disk_reset_floppy		; Just in case disk was changed

	;mov ax, 19			; Root dir starts at logical sector 19  (Reserved Sectors(1) + FATs( 2 * 9))
	;call disk_convert_l2hts

	;mov si, disk_buffer		; ES:BX should point to our buffer
	;mov bx, si

	mov si, 0x200
	mov bx, 0x7c00
	
	
	mov ah, 2			; Params for int 13h: read floppy sectors
	mov al, 18			; And read 14 of them

	pusha				; Prepare to enter loop


.read_root_dir:
	popa
	pusha

	stc
	int 13h				; Read sectors
	;call disk_reset_floppy		; Check we've read them OK
	;jnc .show_dir_init		; No errors, continue
	
	call .show_dir_init
	
	;call disk_reset_floppy		; Error = reset controller and try again
	;jnc .read_root_dir
	;jmp .done			; Double error, exit 'dir' routine

.show_dir_init:
	popa

	mov ax, 0
	;mov si, disk_buffer		; Data reader from start of filenames

	mov word di, 0 ;[.file_list_tmp]	; Name destination buffer


.start_entry:
	mov al, [si+11]			; File attributes for entry
	cmp al, 0Fh			; Windows marker, skip it
	je .skip

	test al, 18h			; Is this a directory entry or volume label?
	jnz .skip			; Yes, ignore it

	mov al, [si]
	cmp al, 229			; If we read 229 = deleted filename
	je .skip

	cmp al, 0			; 1st byte = entry never used
	je .done


	;mov cx, 1			; Set char counter
	mov dx, si			; Beginning of possible entry
	mov cx, 11
	
.testdirentry:
	inc si
	mov al, [si]			; Test for most unusable characters
	cmp al, ' '			; Windows sometimes puts 0 (UTF-8) or 0FFh
	jl .nxtdirentry
	cmp al, '~'
	ja .nxtdirentry

	;inc cx
	;cmp cx, 11			; Done 11 char filename?
	;je .gotfilename
	;jmp .testdirentry
	loop .testdirentry
	
	

.gotfilename:				; Got a filename that passes testing
	mov si, dx			; DX = where getting string

	mov cx, 0
.loopy:
	mov byte al, [si]
	cmp al, ' '
	je .ignore_space
	mov byte [di], al
	inc si
	inc di
	inc cx
	cmp cx, 8
	je .add_dot
	cmp cx, 11
	je .done_copy
	jmp .loopy

.ignore_space:
	inc si
	inc cx
	cmp cx, 8
	je .add_dot
	jmp .loopy

.add_dot:
	mov byte [di], '.'
	inc di
	jmp .loopy

.done_copy:
	mov byte [di], ','		; Use comma to separate filenames
	inc di

.nxtdirentry:
	mov si, dx			; Start of entry, pretend to skip to next

.skip:
	add si, 32			; Shift to next 32 bytes (next filename)
	jmp .start_entry


.done:
	dec di
	mov byte [di], 0		; Zero-terminate string (gets rid of final comma)

	popa
	ret


	.file_list_tmp		dw 0