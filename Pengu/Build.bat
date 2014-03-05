nasm -f bin boot_new.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin

copy /b boot.bin boot.img


imdisk -a -f boot.img -s 1440K -m B:
copy kernel.bin B:

imdisk -d -m B:


;mkisofs -no-emul-boot -boot-load-size 4 -o PenguOS.iso -b boot.img .

