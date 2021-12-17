#!/bin/bash

source build/envsetup.sh >/dev/null

echo selfinstall image
TARGET_PATH=$1
TARGET_IMAGE=$TARGET_PATH/selfinstall.img

HOST_OUT=`get_build_var HOST_OUT_EXECUTABLES`
SGDISK_HOST=$HOST_OUT/sgdisk

dd if=$TARGET_PATH/uboot.img of=$TARGET_IMAGE bs=512 seek=16384

dd if=$TARGET_PATH/fat.img of=$TARGET_IMAGE bs=512 seek=20480
dd if=$TARGET_PATH/misc.img of=$TARGET_IMAGE bs=512 seek=53248
dd if=$TARGET_PATH/vbmeta.img of=$TARGET_IMAGE bs=512 seek=61440
dd if=$TARGET_PATH/boot.img of=$TARGET_IMAGE bs=512 seek=63488
dd if=$TARGET_PATH/recovery.img of=$TARGET_IMAGE bs=512 seek=145408
dd if=$TARGET_PATH/baseparameter.img of=$TARGET_IMAGE bs=512 seek=2471936
dd if=$TARGET_PATH/super.img of=$TARGET_IMAGE bs=512 seek=2473984
dd if=/dev/zero of=$TARGET_IMAGE bs=512 seek=8847360 count=34

$SGDISK_HOST \
	--n=1:8192:16383 --change-name=1:security \
	--n=2:16384:20479 --change-name=2:uboot \
	--n=3:20480:53247 --change-name=3:fat \
	--n=4:53248:61439 --change-name=4:misc \
	--n=5:61440:63487 --change-name=5:vbmeta \
	--n=6:63488:145407 --change-name=6:boot \
	--n=7:145408:342015 --change-name=7:recovery \
	--n=8:342016:2439167 --change-name=8:cache \
	--n=9:2439168:2471935 --change-name=9:metadata \
	--n=10:2471936:2473983 --change-name=10:baseparameter \
	--n=11:2473984:8847359 --change-name=11:super \
	$TARGET_IMAGE

pigz -k  $TARGET_PATH/selfinstall.img
