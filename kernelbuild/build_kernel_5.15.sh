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
modules_list=$(find ${DIST_DIR}/modules/ramdisk -type f -name "*.ko")
cp ${DIST_DIR}/modules/ramdisk/*.ko device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk/lib/modules/
rm -rf device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/*
cp ${DIST_DIR}/modules/vendor/*.ko device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/
cp -a ${COMMON_OUT_DIR}/vendor_lib/* device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/

# awk '{print $0" \\"}' ${DIST_DIR}/modules/ramdisk/ramdisk_modules.order > device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_boot.modules.load
awk '{print $0}' ${DIST_DIR}/modules/ramdisk/ramdisk_modules.order > device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_boot.modules.load
echo "" >> device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_boot.modules.load

# awk '{print $0" \\"}' ${DIST_DIR}/modules/vendor/vendor_modules.order > device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_dlkm.modules.load
awk '{print $0}' ${DIST_DIR}/modules/vendor/vendor_modules.order > device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_dlkm.modules.load
if [[ -n ${LOAD_EXT_MODULES_IN_SECOND_STAGE} ]]; then
	cp ${DIST_DIR}/ext_modules/*.ko device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/
#	awk '{print $0" \\"}' ${DIST_DIR}/ext_modules/ext_modules.order >> device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_dlkm.modules.load
	awk '{print $0}' ${DIST_DIR}/ext_modules/ext_modules.order >> device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_dlkm.modules.load
fi
echo "" >> device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_dlkm.modules.load

cp ${DIST_DIR}/dtbo.img device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/
cp ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/${BOARD_DEVICENAME}.dtb
cp ${DIST_DIR}/Image.gz device/amlogic/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/

rm -f ${KERNEL_BUILD_VAR_FILE}
echo "========================================================"
echo "build end"
echo "========================================================"
echo
