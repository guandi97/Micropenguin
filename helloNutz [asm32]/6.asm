;Guandi97
;NOTE: currently broken
;stack byte array method
;determine esi,edi
;loop esi
  ;if esi-edi>=dword:_dwordStack
  ;if esi-edi<dword:_byteSStack
;set args, call write
;_dwordStack (32 bit)-mov dword at a time
;_byteSStack (8 bit)
	;store in ebx, accum in eax,
	;shift and add to bl unless eax>=4
;"flush" ebp to stack

section .text
global _main
_main:
	push	ebp
	mov	ebp,		esp

	mov	esi,		sdr
	mov	edi,		esi
	add	esi,		len
	mov	ebx,		0x0
aloop1s	cmp	esi,		edi
	jl	aloop1e

	;mov	edx,		esi
	;sub	edx,		edi
	;cmp	edx,		0x4
	;jge	dwSk
	jmp	bsSk

dwSk	call	_dwordStack
	push	dword 	eax
	mov	eax,		0x0
	jmp	aloop1s

bsSk	call	_byteSStack
	cmp	eax,		0x4
	jge	bsPush
	jmp	aloop1s
bsPush	push	dword	ebx
	mov	ebx,		0x0
	mov	eax,		0x0
	jmp	aloop1s

aloop1e	;push	dword	ebx
	push	len		
	mov	edx,		esp
	add	edx,		0x4
	push	dword 	edx
	push	0x1
	sub	esp,		0x4
	mov	eax,		0x4
	int	0x80
	mov	eax,		0x1		;since the last 2 args on the stack are the exact params 
	int	0x80				;needed for sys_exit(1), we can go ahead and interrupt
						;demonstraction only as this is bad habit, and will 
_dwordStack:					;confuse both future you, and anybody who views your code
	mov	eax,		dword [esi]
	sub	esi,		0x4
	ret
_byteSStack:
	sub	esi,		0x1
	shl	ebx,		8		;shift 8b to left
	mov	bl,		byte [esi]
	add	eax,		0x1
	ret

section .data
sdr	db	'12345678',0xa,	;'anonyMOOOOOOOOOOooooooooooose',0xa,
len	equ	$-sdr
