#! /bin/sh

echo selfinstall image
TARGET_PATH=$1
TARGET_IMAGE=$TARGET_PATH/selfinstall.img
GPT_PATH=$PROJECT_TOP/device/hardkernel/common/selfinstall/gpt.img

BOOTSCR_SUPPORT=false

if [ "$BOOTSCR_SUPPORT" = true ] ; then
BOOT_SCRIPT_PATH=$PROJECT_TOP/device/hardkernel/common/boot_script
SIMG2IMG=$PROJECT_TOP/mkcombinedroot/bin/simg2img

if  [ -e "$BOOT_SCRIPT_PATH/boot.scr" ] ; then
    break
else
    $BOOT_SCRIPT_PATH/mkbootscript.sh $BOOT_SCRIPT_PATH/boot.cmd $BOOT_SCRIPT_PATH/boot.scr
fi
cp $BOOT_SCRIPT_PATH/boot.scr $TARGET_PATH/boot.scr


FAT_IMAGE=$TARGET_PATH/fat.img
dd if=/dev/zero of=$FAT_IMAGE bs=512 count=4096
mkfs.fat -F16 -n VFAT $FAT_IMAGE
build/make/tools/fat16copy.py $FAT_IMAGE \
	$TARGET_PATH/boot.scr
fi

dd if=$GPT_PATH of=$TARGET_IMAGE bs=512

if [ "$BOOTSCR_SUPPORT" = true ] ; then
dd if=$FAT_IMAGE of=$TARGET_IMAGE bs=512 seek=8192 #start=4MB
else
dd if=$TARGET_PATH/uboot.img of=$TARGET_IMAGE bs=512 seek=16384
fi
dd if=$TARGET_PATH/misc.img of=$TARGET_IMAGE bs=512 seek=24576
dd if=$TARGET_PATH/dtbo.img of=$TARGET_IMAGE bs=512 seek=32768
dd if=$TARGET_PATH/vbmeta.img of=$TARGET_IMAGE bs=512 seek=40960
dd if=$TARGET_PATH/boot.img of=$TARGET_IMAGE bs=512 seek=43008
dd if=$TARGET_PATH/recovery.img of=$TARGET_IMAGE bs=512 seek=124928
dd if=$TARGET_PATH/baseparameter.img of=$TARGET_IMAGE bs=512 seek=1140736
dd if=$TARGET_PATH/super.img of=$TARGET_IMAGE bs=512 seek=1142784

pigz -k  $TARGET_PATH/selfinstall.img
