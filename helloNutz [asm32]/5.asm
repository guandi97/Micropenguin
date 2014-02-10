;Guandi97
;null terminated while loop

;set edi,esi
;check against 0x0
;write 1B at a time

section .text
global _main
_main:
	push	ebp
	mov	ebp,		esp
	mov	esi,		sdr
	push	dword 	0x1			;04
	push	dword	0x0
	push	dword	0x1
	sub	esp,		0x4
	mov	edi,		ebp
	sub	edi,		0x8
cloops	cmp	byte [esi],	0x0
	je	cloope
	mov	[edi],		esi
	mov	eax,		0x4
	int	0x80
	add	esi,		0x1
	jmp	cloops
cloope	mov	[esp],		dword 0x1
	sub	esp,		0x4	
	mov	eax,		0x1
	int	0x80
section .data
sdr	db	'PootisSpencer here!',0xa,0x0
