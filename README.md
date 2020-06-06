# AMPT_Assignment
for assignment 1-
nasm -fbin Assignment1.asm -o Assignment1.bin ,
qemu-system-i386 Assignment1.bin

for assignment 2-
nasm -fbin Assignment2.asm -o Assignment2.bin ,
qemu-system-i386 Assignment2.bin

for assignment 3(matrix tran)-
nasm -fbin matrix_transpose.asm -o kernel.bin ,
nasm -fbin bootloader.asm -o boot.bin ,
cat boot.bin kernel.bin > matrix.bin ,
qemu-system-i386 matrix.bin
