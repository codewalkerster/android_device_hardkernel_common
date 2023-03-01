#!/bin/bash

set -e
export KERNEL_BUILD_VAR_FILE=`mktemp /tmp/kernel.XXXXXXXXXXXX`

echo
echo "========================================================"
echo "enter kernel build: $@"
pushd ${KERNEL_REPO}
if [ $KERNEL_A32_SUPPORT ]; then
	./mk.sh --arch arm --android_project ${BOARD_DEVICENAME} $@
else
	./mk.sh --android_project ${BOARD_DEVICENAME} $@
fi

popd
echo "========================================================"
echo "exit kernel build"
echo "========================================================"
echo

echo
echo "========================================================"
echo "copy files to android project"
source ${KERNEL_BUILD_VAR_FILE}

if [ $KERNEL_A32_SUPPORT ]; then
	TARGET_KERNEL_DIR=32/${KERNEL_VERSION}
else
	TARGET_KERNEL_DIR=${KERNEL_VERSION}
fi

if [ ! -d "device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/ramdisk/lib/modules/" ]; then
	mkdir -p device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/ramdisk/lib/modules/
fi
rm -rf device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/ramdisk/lib/modules/*
modules_list=$(find ${OUT_AMLOGIC_DIR}/modules/ramdisk -type f -name "*.ko")
cp ${OUT_AMLOGIC_DIR}/modules/ramdisk/*.ko device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/ramdisk/lib/modules/

if [ -s ${OUT_AMLOGIC_DIR}/modules/recovery/recovery_modules.order ]; then
cp ${OUT_AMLOGIC_DIR}/modules/recovery/*.ko device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/ramdisk/lib/modules/
fi

if [ ! -d "device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/lib/modules/" ]; then
	mkdir -p device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/lib/modules/
fi
rm -rf device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/lib/modules/*
cp ${OUT_AMLOGIC_DIR}/modules/vendor/*.ko device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/lib/modules/
cp -a ${COMMON_OUT_DIR}/vendor_lib/* device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/lib/

cp ${OUT_AMLOGIC_DIR}/modules/ramdisk/ramdisk_modules.order device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_recovery.modules.load

# NORMAL_MODE_END_MODULE=amlogic-mmc.ko
if [ -z ${NORMAL_MODE_END_MODULE} ]; then
	NORMAL_MODE_END_MODULE=`tail -n 1 device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_recovery.modules.load`
fi
END_MODULE_LINE_NUM=`awk '/'${NORMAL_MODE_END_MODULE}'/{print NR}' device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_recovery.modules.load`
head device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_recovery.modules.load -n ${END_MODULE_LINE_NUM} > device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_boot.modules.load

tail device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_recovery.modules.load -n +${END_MODULE_LINE_NUM} > device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_dlkm.modules.load
sed -i '1d' device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_dlkm.modules.load

cat ${OUT_AMLOGIC_DIR}/modules/recovery/recovery_modules.order >> device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_recovery.modules.load

for recovery_module in $(cat device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_dlkm.modules.load)
do
	cp device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/ramdisk/lib/modules/$recovery_module device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/lib/modules/
done

cat ${OUT_AMLOGIC_DIR}/modules/vendor/vendor_modules.order >> device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_dlkm.modules.load
if [[ -n ${LOAD_EXT_MODULES_IN_SECOND_STAGE} ]]; then
	cp ${OUT_AMLOGIC_DIR}/ext_modules/*.ko device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/lib/modules/
	cat ${OUT_AMLOGIC_DIR}/ext_modules/ext_modules.order >> device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/vendor_dlkm.modules.load
fi

cp ${DIST_DIR}/dtbo.img device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/

if [ $CONFIG_KERNEL_FCC_PIP ]; then
	export KERNEL_DEVICETREE=${KERNEL_DEVICETREE_FCC_PIP}
fi

DTBTOOL=device/amlogic/common/kernelbuild/dtbTool
dtb_files_count=0
mkdir -p ${OUT_AMLOGIC_DIR}/dtb
for dtb_file in ${KERNEL_DEVICETREE}; do
	cp ${DIST_DIR}/${dtb_file}.dtb ${OUT_AMLOGIC_DIR}/dtb/
	dtb_files_count=`expr ${dtb_files_count} + 1`
done
if [[ ${dtb_files_count} == 1 ]]; then
	if [ $CONFIG_KERNEL_FCC_PIP ]; then
		if [[ ${PRODUCT_DIRNAME} == *"ohm"* ]]; then
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/ohm_mxl258c.dtb
		elif [[ ${PRODUCT_DIRNAME} == *"oppencas"* ]]; then
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/oppencas_mxl258c.dtb
		elif [[ ${PRODUCT_DIRNAME} == *"oppen"* ]]; then
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/oppen_mxl258c.dtb
		else
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/${BOARD_DEVICENAME}.dtb
		fi
	else
		cp ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/${BOARD_DEVICENAME}.dtb
	fi
else
	${DTBTOOL} -o device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/${BOARD_DEVICENAME}.dtb -p ${COMMON_OUT_DIR}/${KERNEL_DIR}/scripts/dtc/ ${OUT_AMLOGIC_DIR}/dtb/
fi

if [ $KERNEL_A32_SUPPORT ]; then
	cp ${DIST_DIR}/uImage device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/
else
	cp ${DIST_DIR}/Image.gz device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}/
fi

rm -f ${KERNEL_BUILD_VAR_FILE}
echo "========================================================"
echo "build end"
echo "========================================================"
echo
set +e
