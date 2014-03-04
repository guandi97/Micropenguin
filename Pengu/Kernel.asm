

;*********************************************
;	Stage2.asm
;		- Second Stage Bootloader
;
;	Operating Systems Development Series
;*********************************************

org 0x0					; offset to 0, we will set segments later

bits 16					; we are still in real mode

; we are loaded at linear address 0x10000

jmp main				; jump to main

;*************************************************;
;	Prints a string
;	DS=>SI: 0 terminated string
;************************************************;

Print:
	lodsb					; load next byte from string from SI to AL
	or			al, al		; Does AL=0?
	jz			PrintDone	; Yep, null terminator found-bail out
	mov			ah,	0eh		; Nope-Print the character
	int			10h
	jmp			Print		; Repeat until null terminator found
PrintDone:
	ret					; we are done, so return

;*************************************************;
;	Second Stage Loader Entry Point
;************************************************;

main:
	cli					; clear interrupts
	push			cs		; Insure DS=CS
	pop				ds

	mov			si, Msg
	call			Print
	
	



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
   ;or ax, ax
   ;int 0x12
   mov si, msg_ram
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





	cli					; clear interrupts to prevent triple faults
	hlt					; hault the syst

;*************************************************;
;	Data Section
;************************************************;

Msg	db	"Preparing to load operating system...",13,10,0