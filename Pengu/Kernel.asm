
;*********************************************
;	Stage2.asm
;		- Second Stage Bootloader
;
;	Operating Systems Development Series
;*********************************************

org 0x0					; offset to 0, we will set segments later

bits 16					; we are still in real mode

; we are loaded at linear address 0x10000

jmp _main				; jump to main

;*************************************************;
;	Prints a string
;	DS=>SI: 0 terminated string
;************************************************;

_Print:
	lodsb					; load next byte from string from SI to AL
	or			al, al		; Does AL=0?
	jz			_PrintDone	; Yep, null terminator found-bail out
	mov			ah,	0eh		; Nope-Print the character
	int			10h
	jmp			_Print		; Repeat until null terminator found
_PrintDone:
	ret				; we are done, so return

;*************************************************;
;	Second Stage Loader Entry Point
;************************************************;

_main:
	cli					; clear interrupts
	push			cs		; Insure DS=CS
	pop				ds

	mov			si, Msg
	call			_Print
	
	mov si, line1
	call _Print
	call _Printline
	mov si, line2
	call _Print
	call _Printline
	mov si, line3
	call _Print
	call _Printline
	mov si, line4
	call _Print
	call _Printline
	mov si, line5
	call _Print
	call _Printline
	
	

	mov si, welcome
   call print_string
 
 mainloopz:
   mov si, promptz
   call print_string
 
   mov di, buffer
   call get_string
   ;call os_input_string
   
 
   mov si, buffer
   cmp byte [si], 0  ; blank line?
   je mainloopz       ; yes, ignore it
 
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
   
   mov si, buffer
   mov di, cmd_dir
   call strcmp
   jc	.dir
   
   mov si, buffer
   mov di, cmd_cli
   call strcmp
   jc .cli
 
   ;mov si, buffer           ;Removed Prime call
   ;mov di, cmd_prime
   ;call strcmp
   ;jc .prime
 
   mov si,badcommand
   call print_string 
   jmp mainloopz  
 
 .helloworld:
   mov si, msg_helloworld
   call print_string
   jmp mainloopz
 
 .infotag:
   mov si, msg_info
   call print_string
   jmp mainloopz
 
 .help:
   mov si, msg_help
   call print_string
   jmp mainloopz
 
 .ram:
   mov si, msg_ram
   call print_string
   
   mov si, msg_ram
   call print_string
   jmp mainloopz
   
.dir:
		
	call list_directory

	
	
	;call ls
	;pusha
	;call print_time
	;popa
	jmp mainloopz

	
.cli:
	;call os_command_line
   jmp mainloopz
 
 welcome db 'Welcome to Pengu!', 0x0D, 0x0A, 0
 msg_helloworld db 'Hello World!', 0x0D, 0x0A, 0
 msg_info db 'Forums.micropenguin.net', 0x0D, 0x0a, 0
 msg_prime db 'Enter a number', 0x0D, 0x0a, 0
 msg_ram db 'The amount of ram: ', 0x0D, 0x0a, 0
 badcommand db 'Bad command entered.', 0x0D, 0x0A, 0
 msg_out db 'The number you entered: ', 0
 promptz db '>', 0
 cmd_hi db 'hi', 0
 cmd_help db 'help', 0
 cmd_info db 'info', 0
 cmd_prime db 'prime',0
 cmd_dir db 'dir',0
 cmd_cli db 'cli', 0
 cmd_time db 'time',0
 
line1 db '   ___                     ____  ____',0
line2 db '  / _ \___ ___  ___ ___ __/ __ \/ __/',0
line3 db ' / ___/ -_) _ \/ _ `/ // / /_/ /\ \  ',0
line4 db '/_/   \__/_//_/\_, /\_,_/\____/___/  ',0
line5 db '              /___/                  ',0

 cmd_ram db 'ram', 0
 msg_help db 'Pengu: Commands: hi, help, info, ram, cli', 0x0D, 0x0A, 0
 buffer times 64 db 0
 
 ; ================
 ; calls start here
 ; ================
 
 print_string:
   lodsb        ; grab a byte from SI
   ;cmp al, 0
   or al, al  ; logical or AL by itself
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
 
   ;cmp cl, 0x3F  ; 63 chars inputted?             
   ;je .loop      ; yes, only let in backspace and enter
 
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


_Printline:
	pusha

	mov ah, 0Eh			; BIOS output char code

	mov al, 13
	int 10h
	mov al, 10
	int 10h

	popa
	ret


	;cli					; clear interrupts to prevent triple faults
	;hlt					; hault the syst

;*************************************************;
;	Data Section
;************************************************;

Msg	db	"Preparing to load operating system...",13,10,0


	%DEFINE MIKEOS_VER '4.4'	; OS version number
	%DEFINE MIKEOS_API_VER 16	; API version for programs to check
	disk_buffer	equ	24576

	;%INCLUDE "features/cli.asm"
 	;%INCLUDE "features/disk.asm"
	;%INCLUDE "features/keyboard.asm"
	;%INCLUDE "features/math.asm"
	;%INCLUDE "features/misc.asm"
	;%INCLUDE "features/ports.asm"
	;%INCLUDE "features/screen.asm"
	;%INCLUDE "features/sound.asm"
	;%INCLUDE "features/string.asm"
	;%INCLUDE "features/basic.asm"
	
	;LEGACY 998
	%INCLUDE "system/filesys.asm"
	
	
	fmt_12_24	db 0		; Non-zero = 24-hr format

	fmt_date	db 0, '/'	; 0, 1, 2 = M/D/Y, D/M/Y or Y/M/D
					; Bit 7 = use name for months
					; If bit 7 = 0, second byte = separator character

				