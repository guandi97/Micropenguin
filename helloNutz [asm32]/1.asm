;Guandi97
;std method, the "correct" way to do this

section .text
global _main
_main:
	push 	len
	push	sdr
	push	0x1
	sub	esp,		0x4
	mov	eax,		0x4
	int	0x80
	add	esp,		0x10

	push	0x1
	sub	esp,		0x4		;always 8-byte aligned on intel32
	mov	eax,		0x1
	int	0x80
section .data
sdr	db	"noobie plz",0xa		;consecutive byte sequence, or char array
len	equ	$-sdr				;this is the same as the sizeof() in C
