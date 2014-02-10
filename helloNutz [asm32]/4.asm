;Guandi97
;push method

;calculate len 
;push all onto stack
;write 1B at a time

section .text
global _main
_main:
	mov	esi,		sdr
	mov	edi,		esi
	add	esi,		len
ploops	cmp	esi,		edi		;push onto stack
	jl	ploope
	mov	edx,		0x0
	mov	dl,		byte [esi]
	push	edx
	sub	esi,		0x1
	jmp	ploops
ploope	mov	ecx,		0x0
wloops	cmp	ecx,		len		
	jge	wloope
	push	dword 	0x1			;-04
	mov	esi,	esp
	add	esi,	0x4
	push	dword 	esi			;-08 -wtf?			
	push	dword 	0x1			;-12
	sub	esp,		0x4		;-16
	mov	eax,		0x4
	int	0x80
	add	esp,		0x14
	add	ecx,		0x1
	jmp	wloops
wloope	push	dword 	0x1
	sub	esp,		0x4
	mov	eax,		0x1
	int	0x80
section .data
sdr	db	'engieUNion!',0xa
len	equ	$-sdr
