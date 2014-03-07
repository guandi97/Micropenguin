del Pengu.iso

nasm -f bin boot_new.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin

copy /b boot.bin boot.img


imdisk -a -f boot.img -s 1440K -m B:
copy kernel.bin B:
copy Test.txt B:
copy 123123.txt B:
imdisk -d -m B:

del kernel.bin
del Test.txt
::Delete kernel.bin because there is already a copy in the image file. 
:: If kernel.bin is not deleted from the directory, OS will throw Int 0x18
mkisofs -o Pengu.iso -b boot.img .

