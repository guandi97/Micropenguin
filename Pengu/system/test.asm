ls:

	mov si, 0x200
	mov bx, 0x7c00

.read_root_dir:
	call .show_dir_init

.show_dir_init:

.start_entry:
	mov si, dx
	mov cx, 0
.loop:
	mov byte al, [si]
	cmp al, ' '
	;je .ignore_space
	mov  byte [di], al
	
	inc si
	inc di
	inc cx
	cmp cx, 8
	je .add_dot
	cmp cx, 11
	je .done_copy
	jmp .loop


.add_dot
	mov byte [di], '.'
	inc di
	jmp .loop

.done_copy
	mov byte [di], ','
	inc di

.nxtfile
	mov si, dx
	add si, 32
	jmp .start_entry

.done:
	dec di
	mov byte [di],0


ret