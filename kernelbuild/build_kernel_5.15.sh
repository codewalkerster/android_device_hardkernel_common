#!/bin/bash

set -e
export KERNEL_BUILD_VAR_FILE=`mktemp /tmp/kernel.XXXXXXXXXXXX`

echo
echo "========================================================"
echo "enter kernel build: $@"
pushd ${KERNEL_REPO}
./mk.sh --android_project ${BOARD_DEVICENAME} $@
popd
echo "========================================================"
echo "exit kernel build"
echo "========================================================"
echo

echo
echo "========================================================"
echo "copy files to android project"
source ${KERNEL_BUILD_VAR_FILE}

if [ ! -d "device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk/lib/modules/" ]; then
	mkdir -p device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk/lib/modules/
fi
rm -rf device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk/lib/modules/*
modules_list=$(find ${OUT_AMLOGIC_DIR}/modules/ramdisk -type f -name "*.ko")
cp ${OUT_AMLOGIC_DIR}/modules/ramdisk/*.ko device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/ramdisk/lib/modules/

if [ ! -d "device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/" ]; then
	mkdir -p device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/
fi
rm -rf device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/*
cp ${OUT_AMLOGIC_DIR}/modules/vendor/*.ko device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/
cp -a ${COMMON_OUT_DIR}/vendor_lib/* device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/

cp ${OUT_AMLOGIC_DIR}/modules/ramdisk/ramdisk_modules.order device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_boot.modules.load

cp ${OUT_AMLOGIC_DIR}/modules/vendor/vendor_modules.order device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_dlkm.modules.load
if [[ -n ${LOAD_EXT_MODULES_IN_SECOND_STAGE} ]]; then
	cp ${OUT_AMLOGIC_DIR}/ext_modules/*.ko device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/lib/modules/
	cat ${OUT_AMLOGIC_DIR}/ext_modules/ext_modules.order >> device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/vendor_dlkm.modules.load
fi

cp ${DIST_DIR}/dtbo.img device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/

DTBTOOL=device/amlogic/common/kernelbuild/dtbTool
dtb_files_count=0
mkdir -p ${OUT_AMLOGIC_DIR}/dtb
for dtb_file in ${KERNEL_DEVICETREE}; do
	cp ${DIST_DIR}/${dtb_file}.dtb ${OUT_AMLOGIC_DIR}/dtb/
	dtb_files_count=`expr ${dtb_files_count} + 1`
done
if [[ ${dtb_files_count} == 1 ]]; then
	cp ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/${BOARD_DEVICENAME}.dtb
else
	${DTBTOOL} -o device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/${BOARD_DEVICENAME}.dtb -p ${COMMON_OUT_DIR}/${KERNEL_DIR}/scripts/dtc/ ${OUT_AMLOGIC_DIR}/dtb/
fi

cp ${DIST_DIR}/Image.gz device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${KERNEL_VERSION}/

rm -f ${KERNEL_BUILD_VAR_FILE}
echo "========================================================"
echo "build end"
echo "========================================================"
echo
set +e
