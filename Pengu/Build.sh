rm Pengu.iso
rm boot.img
rm -rf tmp-loop

nasm -f bin boot/boot.asm -o boot.bin
nasm -f bin boot/Kernel.asm -o kernel.bin

mkdosfs -C boot.img 1440

dd status=noxfer conv=notrunc if=boot.bin of=boot.img

mkdir tmp-loop && mount -o loop -t vfat boot.img tmp-loop && cp kernel.bin tmp-loop/

sleep 2.0
umount tmp-loop
rm -rf tmp-loop


mkisofs -o Pengu.iso -b boot.img .
