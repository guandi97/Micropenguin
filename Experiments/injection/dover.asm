;must use "relative" addressing because stack location can't be considered a constant if targeted for multiple programs
	mov	esi,	esp
	add	esi,	0x1		;esi+1B
	mov	eax,	0x4
	int	0x80
	mov	eax,	0x1		;screw stack cleanup
	int	0x80			;leave it to the system when we exit
	
