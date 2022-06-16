#!/bin/bash

export KERNEL_BUILD_VAR_FILE=`mktemp /tmp/kernel.XXXXXXXXXXXX`

echo
echo "========================================================"
echo "enter kernel build"
pushd ${KERNEL_REPO}
./mk.sh --android_project ${BOARD_DEVICENAME}
popd
echo "========================================================"
echo "exit kernel build"
echo "========================================================"
echo

echo
echo "========================================================"
echo "copy files to android project"
source ${KERNEL_BUILD_VAR_FILE}

rm -rf device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk/lib/modules/*
modules_list=$(find ${DIST_DIR}/modules -type f -name "*.ko")
for module in ${modules_list}; do
	cp ${module} device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk/lib/modules/
done
cp -a ${COMMON_OUT_DIR}/vendor_lib/* device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/

echo "RAMDISK_KERNEL_MODULES_LOAD_FIRSTLIST += \\" > device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk_modules_order.mk
awk '{print $0" \\"}' ${DIST_DIR}/modules/modules.order >> device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk_modules_order.mk
echo "" >> device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk_modules_order.mk

cp ${DIST_DIR}/dtbo.img device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/
cp ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/${BOARD_DEVICENAME}.dtb
cp ${DIST_DIR}/Image.gz device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/

rm -f ${KERNEL_BUILD_VAR_FILE}
echo "========================================================"
echo "build end"
echo "========================================================"
echo
