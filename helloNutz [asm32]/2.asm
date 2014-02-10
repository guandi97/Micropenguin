;Guandi97
;function call method, the other "correct" way to do this

section .text
global _main
_main:
	push	dword 	sdr
	push 	dword 	len
	call	_rite
	add	esp,		0x8

	push	0x1
	sub	esp,		0x4		;always 8-byte aligned on intel32
	mov	eax,		0x1
	int	0x80
_rite:	push	ebp
	mov	ebp,	esp
	push	dword 	[ebp+0x8]
	push	dword 	[ebp+0xc]
	push	dword	0x1
	sub	esp,		0x4
	mov	eax,		0x4
	int	0x80
	add	esp,		0x10
	pop	ebp
	ret
section .data
sdr	db	"Lunar Republic",0xa
len	equ	$-sdr
