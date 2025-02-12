#!/bin/bash

source build/envsetup.sh >/dev/null

echo selfinstall image
TARGET_PATH=$1
TARGET_IMAGE=$TARGET_PATH/selfinstall.img

HOST_OUT=`get_build_var HOST_OUT_EXECUTABLES`
SGDISK_HOST=$HOST_OUT/sgdisk

PRODUCT_OUT=`get_build_var PRODUCT_OUT`

UBOOT_BUILD_PATH=u-boot/build
UBOOT_IMG=u-boot.bin.signed

MISC_PATH=device/hardkernel/common/selfinstall

dd if=$UBOOT_BUILD_PATH/$UBOOT_IMG of=$TARGET_IMAGE bs=512 seek=1

dd if=$PRODUCT_OUT/fat.img of=$TARGET_IMAGE bs=512 seek=8192
dd if=$PRODUCT_OUT/vendor_boot.img of=$TARGET_IMAGE bs=512 seek=309248
dd if=$UBOOT_BUILD_PATH/$UBOOT_IMG of=$TARGET_IMAGE bs=512 seek=575488
dd if=$MISC_PATH/misc.img of=$TARGET_IMAGE bs=512 seek=681984
dd if=$PRODUCT_OUT/dtbo.img of=$TARGET_IMAGE bs=512 seek=688128
dd if=$PRODUCT_OUT/odm_ext.img of=$TARGET_IMAGE bs=512 seek=753664
dd if=$PRODUCT_OUT/oem.img of=$TARGET_IMAGE bs=512 seek=823296
dd if=$PRODUCT_OUT/boot.img of=$TARGET_IMAGE bs=512 seek=958464
dd if=$PRODUCT_OUT/init_boot.img of=$TARGET_IMAGE bs=512 seek=1224704
dd if=$PRODUCT_OUT/super.img of=$TARGET_IMAGE bs=512 seek=1394688

echo -e \
	"n\np\n1\n" \
	"8192\n47103\n" \
	"t\n4\n" \
	"n\np\n2\n" \
	"575488\n583679\n" \
	"t\n2\n83\n" \
	"w\n" \
	|fdisk $TARGET_IMAGE >/dev/null #2>&1
sync
echo "Done."
