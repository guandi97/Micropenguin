 ;mov ax, 0x07C0  ; set up segments
  ; mov ds, ax
  ; mov es, ax
;------------------------------------------------- 

	cli				; Clear interrupts
	mov ax, 0
	mov ss, ax			; Set stack segment and pointer
	mov sp, 0FFFFh
	sti				; Restore interrupts

	cld				; The default direction for string operations
					; will be 'up' - incrementing address in RAM

	mov ax, 2000h			; Set all segments to match where kernel is loaded
	mov ds, ax			; After this, we don't need to bother with
	mov es, ax			; segments ever again, as MikeOS and its programs
	mov fs, ax			; live entirely in 64K
	mov gs, ax




   
mov ah, 09h             ;Change screen color
mov cx, 1000h
mov al, 20h
mov bl, 17h
int 10h

	mov si, welcome
   call print_string
 
 mainloop:
   mov si, prompt
   call print_string
 
   mov di, buffer
   call get_string
 
   mov si, buffer
   cmp byte [si], 0  ; blank line?
   je mainloop       ; yes, ignore it
 
   mov si, buffer
   mov di, cmd_hi  ; "hi" command
   call strcmp
   jc .helloworld
 
   mov si, buffer
   mov di, cmd_help  ; "help" command
   call strcmp
   jc .help

   mov si, buffer
   mov di, cmd_info
   call strcmp
   jc .infotag
  
   mov si, buffer
   mov di, cmd_ram
   call strcmp
   jc .ram
 
   ;mov si, buffer           ;Removed Prime call
   ;mov di, cmd_prime
   ;call strcmp
   ;jc .prime
 
   mov si,badcommand
   call print_string 
   jmp mainloop  
 
 .helloworld:
   mov si, msg_helloworld
   call print_string
   jmp mainloop
 
 .infotag:
   mov si, msg_info
   call print_string
   jmp mainloop
 
 .help:
   mov si, msg_help
   call print_string
   jmp mainloop
 
 .ram:
   mov si, msg_ram
   call print_string
   int 0x12
   mov si, ax
   call print_string
    

;.prime:
   ;call _prime
 
   jmp mainloop
 
 welcome db 'Welcome to Pengu!', 0x0D, 0x0A, 0
 msg_helloworld db 'Hello World!', 0x0D, 0x0A, 0
 msg_info db 'Forums.micropenguin.net', 0x0D, 0x0a, 0
 msg_prime db 'Enter a number', 0x0D, 0x0a, 0
 msg_ram db 'The amount of ram: ', 0x0D, 0x0a, 0
 badcommand db 'Bad command entered.', 0x0D, 0x0A, 0
 msg_out db 'The number you entered: ', 0
 prompt db '>', 0
 cmd_hi db 'hi', 0
 cmd_help db 'help', 0
 cmd_info db 'info', 0
 cmd_prime db 'prime',0
 cmd_ram db 'ram', 0
 msg_help db 'Pengu: Commands: hi, help, info, ram', 0x0D, 0x0A, 0
 buffer times 64 db 0
 
 ; ================
 ; calls start here
 ; ================
 
 print_string:
   lodsb        ; grab a byte from SI
   cmp al, 0
   ;or al, al  ; logical or AL by itself
   jz .done   ; if the result is zero, get out
 
   mov ah, 0x0E
   int 0x10      ; otherwise, print out the character!
 
   jmp print_string
 
 .done:
   ret
 
 get_string:
  ; xor cl, cl
 
 .loop:
   mov ah, 0
   int 0x16   ; wait for keypress
 
   cmp al, 0x08    ; backspace pressed?
   je .backspace   ; yes, handle it
 
   cmp al, 0x0D  ; enter pressed?
   je .done      ; yes, we're done
 
   cmp cl, 0x3F  ; 63 chars inputted?
   je .loop      ; yes, only let in backspace and enter
 
   mov ah, 0x0E
   int 0x10      ; print out character
 
   stosb  ; put character in buffer     (stores in DI)
   inc cl
   jmp .loop
 
 .backspace:
   cmp cl, 0	; beginning of string?
   je .loop	; yes, ignore the key
 
   dec di
   mov byte [di], 0	; delete character
   dec cl		; decrement counter as well
 
   mov ah, 0x0E
   mov al, 0x08
   int 10h		; backspace on the screen
 
   mov al, ' '
   int 10h		; blank character out
 
   mov al, 0x08
   int 10h		; backspace again
 
   jmp .loop	; go to the main loop
 
 .done:
   mov al, 0	; null terminator
   stosb
 
   mov ah, 0x0E
   mov al, 0x0D
   int 0x10
   mov al, 0x0A
   int 0x10		; newline
 
   ret
 
 strcmp:
 .loop:
   mov al, [si]   ; grab a byte from SI
   mov bl, [di]   ; grab a byte from DI
   cmp al, bl     ; are they equal?
   jne .notequal  ; nope, we're done.
 
   cmp al, 0  ; are both bytes (they were equal before) null?
   je .done   ; yes, we're done.
 
   inc di     ; increment DI
   inc si     ; increment SI
   jmp .loop  ; loop!
 
 .notequal:
   clc  ; not equal, clear the carry flag
   ret
 
 .done: 	
   stc  ; equal, set the carry flag
   ret


;_prime:

	;mov si, msg_prime
	;call print_string           ;print prompt for number
        
        ;mov di, buffer              ;gets user input
        ;call get_string
	
	;mov si, msg_out            ;prints statement before user input
	;call print_string
	

	;mov si, buffer
	;call print_string
        
	;mov ah, 0x0E
   	;mov al, 0x0D
   	;int 0x10
  	; mov al, 0x0A
   	;int 0x10		; newline
       	
;ret


;times 510-($-$$) db 0
   ;dw 0AA55h ; some BIOSes require this signature