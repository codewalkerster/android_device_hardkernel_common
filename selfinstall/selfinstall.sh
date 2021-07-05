#! /bin/sh

echo selfinstall image
TARGET_PATH=$1
TARGET_IMAGE=$TARGET_PATH/selfinstall.img

BOOT_SCRIPT_PATH=$PROJECT_TOP/device/hardkernel/common/boot_script
SIMG2IMG=$PROJECT_TOP/mkcombinedroot/bin/simg2img

if  [ -e "$BOOT_SCRIPT_PATH/boot.scr" ] ; then
    break
else
    $BOOT_SCRIPT_PATH/mkbootscript.sh $BOOT_SCRIPT_PATH/boot.cmd $BOOT_SCRIPT_PATH/boot.scr
fi
cp $BOOT_SCRIPT_PATH/boot.scr $TARGET_PATH/boot.scr

GPT_PATH=$PROJECT_TOP/device/hardkernel/common/selfinstall/gpt.img

FAT_IMAGE=$TARGET_PATH/fat.img
dd if=/dev/zero of=$FAT_IMAGE bs=512 count=4096
mkfs.fat -F16 -n VFAT $FAT_IMAGE
build/make/tools/fat16copy.py $FAT_IMAGE \
	$TARGET_PATH/boot.scr

dd if=$GPT_PATH of=$TARGET_IMAGE bs=512
dd if=$FAT_IMAGE of=$TARGET_IMAGE bs=512 seek=8192 #start=4MB
dd if=$TARGET_PATH/misc.img of=$TARGET_IMAGE bs=512 seek=20480
dd if=$TARGET_PATH/dtbo.img of=$TARGET_IMAGE bs=512 seek=28672
dd if=$TARGET_PATH/vbmeta.img of=$TARGET_IMAGE bs=512 seek=36864
dd if=$TARGET_PATH/boot.img of=$TARGET_IMAGE bs=512 seek=38912
dd if=$TARGET_PATH/recovery.img of=$TARGET_IMAGE bs=512 seek=120832
dd if=$TARGET_PATH/baseparameter.img of=$TARGET_IMAGE bs=512 seek=1136640
dd if=$TARGET_PATH/super.img of=$TARGET_IMAGE bs=512 seek=1138688
