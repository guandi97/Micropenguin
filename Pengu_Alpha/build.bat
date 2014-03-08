nasm -f bin boot.asm -o boot.bin
copy /b boot.bin boot.img

imdisk -a -f boot.img -s 1440K -m B:
copy kernel.bin B:

imdisk -d -m B:

