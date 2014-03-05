;Pengu FileSystem
;Used to browse disk for files to load
;Read root sector into memory
;Browse file names and put into a string buffer
;Print each file name


pusha				;Save registers
call reset_floppy   ;Make sure floppy controller starts reading from first sector

mov word [.tmp_list], ax   ;Store string of file temporarily
mov bx, 0x200              ;(EX:BX) Root dir starts at 0x7c00
mov ex, 0x7c00

call ReadSectors           ;EX:BX points to buffer

mov ah, 2                  ;For INT 13h
mov al, [datasectors]      ;Read from beginning of datasectors

						   ;Location of memory to read root from

int 13h
