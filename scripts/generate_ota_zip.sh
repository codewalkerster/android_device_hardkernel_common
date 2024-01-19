#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2023.06.30

TARGET_NAME=$1
BOARD_NAME=$2
REAL_BOARD=$3
DEVICE_DIR=$4
ANDROID_OUTPUT_PATH=$5

echo "start build $TARGET_NAME ota zip"

if [ "$TARGET_NAME" = "signed" ]; then
	./out/host/linux-x86/bin/ota_from_target_files \
	--extracted_input_target_files ${TARGET_NAME}_target \
	--path out/host/linux-x86 \
	--oem_settings $ANDROID_OUTPUT_PATH/oem.prop \
	${TARGET_NAME}_target.zip \
	out_publish/$REAL_BOARD-ota-$TARGET_NAME.zip
else
	./out/host/linux-x86/bin/ota_from_target_files \
	--extracted_input_target_files ${TARGET_NAME}_target \
	--path out/host/linux-x86 \
	--oem_settings $ANDROID_OUTPUT_PATH/oem.prop \
	${TARGET_NAME}_target.zip \
	out_publish/$REAL_BOARD-ota.zip
fi

if [ $? -ne 0 ]; then
	echo "build $TARGET_NAME ota zip ERROR"
	exit 1
fi

echo "build $TARGET_NAME ota zip OK"
exit 0
