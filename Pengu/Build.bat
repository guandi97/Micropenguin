nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel_new.asm -o kernel.bin
copy /b boot.bin boot.img


imdisk -a -f boot.img -s 1440K -m B:
copy kernel.bin B:

imdisk -d -m B:



