#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2023.06.30

TARGET_NAME=$1
BOARD_NAME=$2
DEVICE_DIR=$3
KERNEL_DIR=$4
ANDROID_OUTPUT_PATH=$5
REAL_BOARD=$6
LOCAL_DTB=$7

if [[ "$BOARD_NAME" = "adt4" ]]; then
	DEVICE_ANDL_DIR=device/sei/$BOARD_NAME
elif [ "$BOARD_NAME" = "mercury" ];then
	DEVICE_ANDL_DIR=device/amlogic_car/$BOARD_NAME
else
	DEVICE_ANDL_DIR=device/amlogic/$BOARD_NAME
fi

echo "start build $TARGET_NAME firmware"

./out/host/linux-x86/bin/img_from_target_files ${TARGET_NAME}_target.zip $TARGET_NAME-img.zip

if [ $? -ne 0 ]; then
	echo "build $TARGET_NAME img zip ERROR"
	exit 1
fi
echo "build $TARGET_NAME img zip OK"

unzip -o -q $TARGET_NAME-img.zip -d $TARGET_NAME-img
rm $TARGET_NAME-img.zip

if [ "$TARGET_NAME" = "signed" ]; then
	echo "unzip -o -q ${TARGET_NAME}_target.zip -d ${TARGET_NAME}_target"
	unzip -o -q ${TARGET_NAME}_target.zip -d ${TARGET_NAME}_target
fi

cp -a $TARGET_NAME-img $TARGET_NAME-fastboot
rm -rf $TARGET_NAME-fastboot/aml* $TARGET_NAME-fastboot/dt.img $TARGET_NAME-fastboot/platform.conf $TARGET_NAME-fastboot/super.img
rm -rf $TARGET_NAME-fastboot/u-boot* $TARGET_NAME-fastboot/usb_flow* $TARGET_NAME-fastboot/userdata.img

if [ -f $TARGET_NAME-fastboot/cache.img ];then
	rm -rf $TARGET_NAME-fastboot/cache.img
fi

if [ -f $ANDROID_OUTPUT_PATH/gpt.bin ];then
	cp -a $ANDROID_OUTPUT_PATH/gpt.bin $TARGET_NAME-fastboot/
else
	if [ -f ${TARGET_NAME}_target/VENDOR_BOOT/dtb ];then
		cp -a ${TARGET_NAME}_target/VENDOR_BOOT/dtb $TARGET_NAME-fastboot/dt.img
	elif [ -f ${TARGET_NAME}_target/BOOT/dtb ];then
		cp -a ${TARGET_NAME}_target/BOOT/dtb $TARGET_NAME-fastboot/dt.img
	fi
fi

./device/amlogic/common/scripts/generate_fastboot_zip.sh $TARGET_NAME $BOARD_NAME $ANDROID_OUTPUT_PATH $REAL_BOARD &

if [ -f $DEVICE_ANDL_DIR/upgrade/aml_sdc_burn.ini ];then
    cp -a $DEVICE_ANDL_DIR/upgrade/aml_sdc_burn.ini $TARGET_NAME-img/
else
    cp -a device/amlogic/common/upgrade/aml_sdc_burn.ini $TARGET_NAME-img/
fi
cp -a $ANDROID_OUTPUT_PATH/upgrade/aml_upgrade_package*.conf $TARGET_NAME-img/aml_upgrade_package.conf

cp -a $KERNEL_DIR/$LOCAL_DTB.dtb $TARGET_NAME-img/dt.img
if [ -f $DEVICE_ANDL_DIR/upgrade/platform.conf ];then
    cp -a $DEVICE_ANDL_DIR/upgrade/platform.conf $TARGET_NAME-img/
else
    cp -a device/amlogic/common/upgrade/platform.conf $TARGET_NAME-img/
fi
cp -a $DEVICE_DIR/upgrade/u-boot.bin.* $TARGET_NAME-img/
if [ -f $DEVICE_ANDL_DIR/upgrade/usb_flow.aml ];then
    cp -a $DEVICE_ANDL_DIR/upgrade/usb_flow.aml $TARGET_NAME-img/
else
    cp -a device/amlogic/common/upgrade/usb_flow.aml $TARGET_NAME-img/
fi
cp -a $ANDROID_OUTPUT_PATH/gpt.bin $TARGET_NAME-img/

./out/host/linux-x86/bin/build_super_image -v ${TARGET_NAME}_target $TARGET_NAME-img/super.img

if [ $? -ne 0 ]; then
	echo "build $TARGET_NAME super.img ERROR"
	exit 1
fi

if [ "$TARGET_NAME" = "signed" ]; then
	./vendor/amlogic/common/tools/aml_upgrade/aml_image_v2_packer -r $TARGET_NAME-img/aml_upgrade_package.conf $TARGET_NAME-img out_publish/aml_upgrade_package_${TARGET_NAME}.img
else
	./vendor/amlogic/common/tools/aml_upgrade/aml_image_v2_packer -r $TARGET_NAME-img/aml_upgrade_package.conf $TARGET_NAME-img out_publish/aml_upgrade_package.img
fi

if [ $? -ne 0 ]; then
	echo "build $TARGET_NAME usb burn fw ERROR"
	exit 1
fi

echo "build $TARGET_NAME firmware OK"
exit 0
