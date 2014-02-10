;Guandi97
;using a forloop 

;calculate esi,edi
;push args onto stack
;write 1B at a time, and update pointer

section .text
global _main
_main:
	push	ebp
	mov	ebp,		esp	;00
	mov	esi,		sdr
	mov	edi,		esi
	add	edi,		len

	push	dword	0x1		;04
	push	dword 	0x0		;08
	push	dword	0x1		;12
	sub	esp,		0x4	;16

wloops	cmp	esi,		edi
	jge	wloope
	mov	[ebp-0x8],	esi
	mov	eax,		0x4
	int 	0x80
	add	esi,		0x1
	jmp	wloops

wloope	add	esp,		0x10
	push	dword	0x1
	sub	esp,		0x4
	mov	eax,		0x1
	int	0x80
section .data
sdr	db	'twilicorn OP',0xa
len	equ	$-sdr
