#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2023.06.30

TARGET_NAME=$1
BOARD_NAME=$2
ANDROID_OUTPUT_PATH=$3
REAL_BOARD=$4

echo "start build $TARGET_NAME fastboot zip"

if [[ "$BOARD_NAME" =~ newton|franklin ]]; then
cp -a device/amlogic/common/scripts/fastboot_scripts/flash-all.bat $TARGET_NAME-fastboot/flash-all.bat
cp -a device/amlogic/common/scripts/fastboot_scripts/flash-all.sh $TARGET_NAME-fastboot/flash-all.sh
else
cp -a device/amlogic/common/scripts/fastboot_scripts/flash-all-ab.bat $TARGET_NAME-fastboot/flash-all.bat
cp -a device/amlogic/common/scripts/fastboot_scripts/flash-all-ab.sh $TARGET_NAME-fastboot/flash-all.sh
fi
if [[ "$BOARD_NAME" = "adt4" ]]; then
    DEVICE_DIR=device/sei/$BOARD_NAME
else
    DEVICE_DIR=device/amlogic/$BOARD_NAME
fi

cp -a $DEVICE_DIR/board-info.txt $TARGET_NAME-fastboot/android-info.txt

if [ "$TARGET_NAME" = "signed" ]; then
	(cd $TARGET_NAME-fastboot; zip -1 -r ../out_publish/$REAL_BOARD-fastboot-$TARGET_NAME *)
else
	(cd $TARGET_NAME-fastboot; zip -1 -r ../out_publish/$REAL_BOARD-fastboot *)
fi

if [ $? -ne 0 ]; then
	echo "build $TARGET_NAME fastboot zip ERROR"
	exit 1
fi

if [ -d ${TARGET_NAME}_target/VENDOR_BOOT ]; then
	./out/host/linux-x86/bin/mkbootfs -d ${TARGET_NAME}_target/SYSTEM ${TARGET_NAME}_target/VENDOR_BOOT/RAMDISK $ANDROID_OUTPUT_PATH/vendor_debug_ramdisk $ANDROID_OUTPUT_PATH/debug_ramdisk | out/host/linux-x86/bin/lz4 -l -12 --favor-decSpeed > ${TARGET_NAME}_target/vendor_ramdisk-debug.cpio.lz4

	if [ $? -ne 0 ]; then
		echo "build $TARGET_NAME vendor_ramdisk-debug ERROR"
		exit 1
	fi

	if [ "$TARGET_NAME" = "signed" ]; then
		./out/host/linux-x86/bin/mkbootimg --dtb ${TARGET_NAME}_target/VENDOR_BOOT/dtb --base 0x0 --vendor_cmdline "bootconfig bootconfig" --vendor_bootconfig ${TARGET_NAME}_target/VENDOR_BOOT/vendor_bootconfig --kernel_offset 0x2080000 --header_version 4 --vendor_ramdisk ${TARGET_NAME}_target/vendor_ramdisk-debug.cpio.lz4 --ramdisk_type RECOVERY --ramdisk_name recovery --vendor_ramdisk_fragment $ANDROID_OUTPUT_PATH/obj/PACKAGING/vendor_ramdisk_fragments_intermediates/recovery.cpio.lz4 --vendor_boot out_publish/vendor_boot-debug-signed.img

		if [ $? -ne 0 ]; then
			echo "build $TARGET_NAME vendor_boot-debug.img ERROR"
			exit 1
		fi
	else
		./out/host/linux-x86/bin/mkbootimg --dtb ${TARGET_NAME}_target/VENDOR_BOOT/dtb --base 0x0 --vendor_cmdline "bootconfig bootconfig" --vendor_bootconfig ${TARGET_NAME}_target/VENDOR_BOOT/vendor_bootconfig --kernel_offset 0x2080000 --header_version 4 --vendor_ramdisk ${TARGET_NAME}_target/vendor_ramdisk-debug.cpio.lz4 --ramdisk_type RECOVERY --ramdisk_name recovery --vendor_ramdisk_fragment $ANDROID_OUTPUT_PATH/obj/PACKAGING/vendor_ramdisk_fragments_intermediates/recovery.cpio.lz4 --vendor_boot out_publish/vendor_boot-debug.img

		if [ $? -ne 0 ]; then
			echo "build $TARGET_NAME vendor_boot-debug.img ERROR"
			exit 1
		fi
	fi
else
	./out/host/linux-x86/bin/mkbootfs -d ${TARGET_NAME}_target/SYSTEM ${TARGET_NAME}_target/BOOT/RAMDISK $ANDROID_OUTPUT_PATH/debug_ramdisk | out/host/linux-x86/bin/minigzip > ${TARGET_NAME}_target/ramdisk-debug.img

	if [ $? -ne 0 ]; then
		echo "build $TARGET_NAME ramdisk-debug ERROR"
		exit 1
	fi

	if [ "$TARGET_NAME" = "signed" ]; then
		./out/host/linux-x86/bin/mkbootimg --kernel ${TARGET_NAME}_target/BOOT/kernel --second ${TARGET_NAME}_target/BOOT/second --ramdisk ${TARGET_NAME}_target/ramdisk-debug.img --dtb ${TARGET_NAME}_target/BOOT/dtb --cmdline "androidboot.dynamic_partitions=true androidboot.dtbo_idx=0 androidboot.boot_devices=ffe07000.emmc otg_device=1" --base 0x0 --os_version 14 --kernel_offset 0x1080000 --header_version 2 --output out_publish/boot-debug-signed.img

		if [ $? -ne 0 ]; then
			echo "build $TARGET_NAME boot-debug.img ERROR"
			exit 1
		fi
	else
		./out/host/linux-x86/bin/mkbootimg --kernel ${TARGET_NAME}_target/BOOT/kernel --second ${TARGET_NAME}_target/BOOT/second --ramdisk ${TARGET_NAME}_target/ramdisk-debug.img --dtb ${TARGET_NAME}_target/BOOT/dtb --cmdline "androidboot.dynamic_partitions=true androidboot.dtbo_idx=0 androidboot.boot_devices=ffe07000.emmc otg_device=1" --base 0x0 --os_version 14 --kernel_offset 0x1080000 --header_version 2 --output out_publish/boot-debug.img

		if [ $? -ne 0 ]; then
			echo "build $TARGET_NAME boot-debug.img ERROR"
			exit 1
		fi
	fi
fi

cd ../
echo "build $TARGET_NAME fastboot zip OK"
exit 0
