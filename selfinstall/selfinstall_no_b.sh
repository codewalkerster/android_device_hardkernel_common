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

COMMON_KERNEL_BUILD_PATH=common/common14-5.15/out/android/`get_build_var TARGET_PRODUCT`/

MISC_PATH=device/hardkernel/common/selfinstall

dd if=$UBOOT_BUILD_PATH/$UBOOT_IMG of=$TARGET_IMAGE bs=512 seek=1

dd if=$PRODUCT_OUT/fat.img of=$TARGET_IMAGE bs=512 seek=8192
dd if=$PRODUCT_OUT/vendor_boot.img of=$TARGET_IMAGE bs=512 seek=260096
dd if=$UBOOT_BUILD_PATH/$UBOOT_IMG of=$TARGET_IMAGE bs=512 seek=327680
dd if=$MISC_PATH/misc.img of=$TARGET_IMAGE bs=512 seek=405504
dd if=$COMMON_KERNEL_BUILD_PATH/dtbo.img of=$TARGET_IMAGE bs=512 seek=411648
dd if=$PRODUCT_OUT/odm_ext.img of=$TARGET_IMAGE bs=512 seek=471040
dd if=$PRODUCT_OUT/oem.img of=$TARGET_IMAGE bs=512 seek=505856
dd if=$PRODUCT_OUT/boot.img of=$TARGET_IMAGE bs=512 seek=573440
dd if=$PRODUCT_OUT/init_boot.img of=$TARGET_IMAGE bs=512 seek=706560
dd if=$PRODUCT_OUT/super.img of=$TARGET_IMAGE bs=512 seek=858112

echo -e \
	"n\np\n2\n" \
	"8192\n47103\n" \
	"t\n4\n" \
	"n\np\n3\n" \
	"327680\n335871\n" \
	"t\n2\n83\n" \
	"w\n" \
	|fdisk $TARGET_IMAGE >/dev/null #2>&1
sync
echo "Done."
