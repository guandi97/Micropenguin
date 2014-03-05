;Pengu FileSystem
;Used to browse disk for files to load



pusha				;Save registers
call reset_floppy   ;Make sure floppy controller starts reading from first sector

mov word [.tmp_list], ax   ;Store string of file temporarily
mov bx, 0x200              ;(EX:BX) Root dir starts at 0x7c00
mov ex, 0x7c00

call ReadSectors           ;EX:BX points to buffer

