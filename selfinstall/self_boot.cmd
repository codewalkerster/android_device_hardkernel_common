setenv bootlabel "Android 14"

echo "Start Selfinstall booting."

echo "  Init default values"

setenv buffer_addr 0x20000000
setenv boot_size 0x2000

setenv target_media 1
setenv fat_index 2
setenv bootloader_index 3

mmc dev $target_media

echo "  Copy bootloader to boot0/1"

part start mmc $target_media $bootloader_index part_start
part size mmc $target_media $bootloader_index part_size

mmc read $buffer_addr $part_start $boot_size

mmc dev $target_media 1
mmc erase 0 $boot_size
mmc write $buffer_addr 1 0x1999

mmc dev $target_media 2
mmc erase 0 $boot_size
mmc write $buffer_addr 1 0x1999

echo "  Install GPT"
mmc dev $target_media
load mmc $target_media:$fat_index $buffer_addr gpt.img
mmc write $buffer_addr 0 0x43
fatrm mmc $target_media:$fat_index gpt.img

echo "  Change boot.scr"
load mmc $target_media:$fat_index $buffer_addr origin.boot.scr
fatrm mmc $target_media:$fat_index boot.scr
fatwrite mmc $target_media:$fat_index $fileaddr boot.scr $filesize
fatrm mmc $target_media:$fat_index origin.boot.scr

echo "  Reboot and reset userdata"
reboot
