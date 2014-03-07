;Pengu OS Filesystem
;Lists all of the files in the current directory
;Root directory loaded at (0x7c00:0x200)


ls:

pusha             ;Save register values just incase they get smegged
								
		mov ah, 0
		mov dl, 0
		int 0x13			
								
								
								
;mov ax, 19        ;Root directory beginning 

mov si, 0x200            ; (ES:BX buffer location)
mov bx, 0x7c00

mov ah, 2			;INT 0x13h
mov al, 18			;Load all 18 sectors (14 sectors containing root directory)

.read_root:
	popa
	pusha
	
	int 13h
	call .show_dir

.show_dir:
	popa
	;mov ax, 0
	
	mov word di, 0
	
.start_entry:
	mov al, [si+11]
	cmp al, 0Fh       ;Windows marker
	je .skip
	






 

