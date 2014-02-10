;Guandi97
;stack byte array method: this method has almost no application irl

;determine esi,edi
;loop esi
;call _byteSStack
;"flush" ebx to stack
;set args, call write

;_byteSStack (8 bit)
	;store in ebx(buffer), accum in eax,
	;shift and add to bl
;_Bflush
	;determin the number of shifts needed to align the fist byte in with the most significant bit in ebx
	;loop shifts

section .text
global _main
_main:
	push	ebp
	mov	ebp,		esp

	mov	edi,		sdr
	mov	esi,		edi
	add	esi,		len
	mov	ebx,		0x0
aloop1s	cmp	esi,		edi
	jle	aloop1e
	call	_byteSStack
	cmp	eax,		0x4		;if eax is full, flush immediately
	jge	bsPush
	jmp	aloop1s
bsPush	push	dword	ebx
	mov	ebx,		0x0
	mov	eax,		0x0
	jmp	aloop1s

aloop1e	cmp	eax,		0x0
	jne	flush
	jmp	end
flush	call	_Bflush				;need to flush manually
	push	dword	ebx
end	push	len		
	mov	edx,		esp
	add	edx,		0x4
	add	edx,		eax
	push	dword 	edx
	push	0x1
	sub	esp,		0x4
	mov	eax,		0x4		;since last 2 args on stack are the same needed for sys_exit(1), interrupt
	int	0x80				;demonstration only, this is bad practice,
	mov	eax,		0x1		;it will confuse both future you, and everybody else who views your code
	int	0x80

_byteSStack:
	sub	esi,		0x1
	shl	ebx,		8		;shift 8b to left
	mov	bl,		byte [esi]
	add	eax,		0x1
	ret
_Bflush:
	mov	edx,		0x4
	sub	edx,		eax
	mov	eax,		edx
	mov	ecx,		0x0
floops	cmp	ecx,		eax		;shift until aligned
	jge	floope
	shl	ebx,		0x8		;shift 8b to left
	add	ecx,		0x1
	jmp	floops
floope	ret
section .data
sdr	db	"AnonyMOOOOOOOOOOooooooooooose",0xa,
len	equ	$-sdr
