setenv bootlabel "Android 14"

echo "Start Update booting."

echo "  Init default values"

setenv buffer_addr 0x20000000
setenv boot_size 0x2000

setenv target_media 0
setenv fat_index 2

setenv fat_partitions 1 2 3

for idx in $fat_partitions; do
	if fatinfo mmc $target_media:$idx; then
		setenv fat_index $idx;
	fi;
done;

mmc dev $target_media

echo "  Copy bootloader to boot0/1"

load mmc $target_media:$fat_index $buffer_addr u-boot.img
fatrm mmc $target_media:$fat_index u-boot.img

mmc dev $target_media 1
mmc erase 0 $boot_size
mmc write $buffer_addr 1 0x1999

mmc dev $target_media 2
mmc erase 0 $boot_size
mmc write $buffer_addr 1 0x1999

echo "  Change boot.scr"
load mmc $target_media:$fat_index $buffer_addr scripts/boot.scr
fatrm mmc $target_media:$fat_index boot.scr
fatwrite mmc $target_media:$fat_index $fileaddr boot.scr $filesize

echo "  Reboot and reset userdata"
reboot
