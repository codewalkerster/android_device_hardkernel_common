setenv bootlabel "Android 14"

echo "Start Selfinstall booting."

echo "  Init default values"

setenv buffer_addr 0x20000000
setenv boot_size 0x2000

mmc dev 1

echo "  Copy bootloader to boot0/1"

part start mmc 1 2 part_start
part size mmc 1 2 part_size

mmc read $buffer_addr $part_start $boot_size

mmc dev 1 1
mmc erase 0 $boot_size
mmc write $buffer_addr 1 0x1999

mmc dev 1 2
mmc erase 0 $boot_size
mmc write $buffer_addr 1 0x1999

echo "  Install GPT"
mmc dev 1
load mmc 1:1 $buffer_addr gpt.bin
mmc write $buffer_addr 0 0x43
fatrm mmc 1:1 gpt.bin

echo "  Change boot.scr"
load mmc 1:1 $buffer_addr origin.boot.scr
fatrm mmc 1:1 boot.scr
fatwrite mmc 1:1 $fileaddr boot.scr $filesize
fatrm mmc 1:1 origin.boot.scr

echo "  Reboot and reset userdata"
reboot
