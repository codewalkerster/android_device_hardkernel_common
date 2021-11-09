#!/bin/bash

source build/envsetup.sh >/dev/null

echo selfinstall image
TARGET_PATH=$1
TARGET_IMAGE=$TARGET_PATH/selfinstall.img
MKFS_FAT=$PROJECT_TOP/device/hardkernel/proprietary/bin/mkfs.fat

HOST_OUT=`get_build_var HOST_OUT_EXECUTABLES`
SGDISK_HOST=$HOST_OUT/sgdisk

BOOTSCR_SUPPORT=true

if [ "$BOOTSCR_SUPPORT" = true ] ; then
BOOT_SCRIPT_PATH=$PROJECT_TOP/device/hardkernel/common/boot_script
SIMG2IMG=$PROJECT_TOP/mkcombinedroot/bin/simg2img

$BOOT_SCRIPT_PATH/mkbootscript.sh $OUT/boot.cmd $OUT/boot.scr
cp $OUT/boot.scr $TARGET_PATH/boot.scr


FAT_IMAGE=$TARGET_PATH/fat.img
dd if=/dev/zero of=$FAT_IMAGE bs=1024 count=16384
$MKFS_FAT -F16 -n VFAT $FAT_IMAGE
build/make/tools/fat16copy.py $FAT_IMAGE \
	$TARGET_PATH/boot.scr
fi

dd if=$TARGET_PATH/uboot.img of=$TARGET_IMAGE bs=512 seek=16384

if [ "$BOOTSCR_SUPPORT" = true ] ; then
dd if=$FAT_IMAGE of=$TARGET_IMAGE bs=512 seek=20480
fi

dd if=$TARGET_PATH/misc.img of=$TARGET_IMAGE bs=512 seek=53248
dd if=$TARGET_PATH/dtb.img of=$TARGET_IMAGE bs=512 seek=61440
dd if=$TARGET_PATH/vbmeta.img of=$TARGET_IMAGE bs=512 seek=69632
dd if=$TARGET_PATH/boot.img of=$TARGET_IMAGE bs=512 seek=71680
dd if=$TARGET_PATH/recovery.img of=$TARGET_IMAGE bs=512 seek=153600
dd if=$TARGET_PATH/baseparameter.img of=$TARGET_IMAGE bs=512 seek=2480128
dd if=$TARGET_PATH/super.img of=$TARGET_IMAGE bs=512 seek=2482176
dd if=/dev/zero of=$TARGET_IMAGE bs=512 seek=8855552 count=34

$SGDISK_HOST \
	--n=1:8192:16383 --change-name=1:security \
	--n=2:16384:20479 --change-name=2:uboot \
	--n=3:20480:53247 --change-name=3:fat \
	--n=4:53248:61439 --change-name=4:misc \
	--n=5:61440:69631 --change-name=5:dtb \
	--n=6:69632:71679 --change-name=6:vbmeta \
	--n=7:71680:153599 --change-name=7:boot \
	--n=8:153600:350207 --change-name=8:recovery \
	--n=9:350208:2447359 --change-name=9:cache \
	--n=10:2447360:2480127 --change-name=10:metadata \
	--n=11:2480128:2482175 --change-name=11:baseparameter \
	--n=12:2482176:8855551 --change-name=12:super \
	$TARGET_IMAGE

pigz -k  $TARGET_PATH/selfinstall.img
