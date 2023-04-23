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

[[ "$@" =~ "--patch" ]] && echo "Finish patch" &&  exit

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

DEVICE_KERNEL_DIR=device/${BOARD_MANUFACTURER}/${BOARD_DEVICENAME}-kernel/${TARGET_KERNEL_DIR}

echo "copy symbols"
mkdir -p ${DEVICE_KERNEL_DIR}
if [[ -d  ${DEVICE_KERNEL_DIR}/symbols ]]; then
	rm -rf ${DEVICE_KERNEL_DIR}/symbols
fi
cp -rf ${OUT_AMLOGIC_DIR}/symbols ${DEVICE_KERNEL_DIR}/symbols

echo "copy ramdisk module ko"
if [ ! -d "${DEVICE_KERNEL_DIR}/ramdisk/lib/modules/" ]; then
	mkdir -p ${DEVICE_KERNEL_DIR}/ramdisk/lib/modules/
fi
rm -rf ${DEVICE_KERNEL_DIR}/ramdisk/lib/modules/*
cp ${OUT_AMLOGIC_DIR}/modules/ramdisk/*.ko ${DEVICE_KERNEL_DIR}/ramdisk/lib/modules/

if [ -s ${OUT_AMLOGIC_DIR}/modules/recovery/recovery_modules.order ]; then
	cp ${OUT_AMLOGIC_DIR}/modules/recovery/*.ko ${DEVICE_KERNEL_DIR}/ramdisk/lib/modules/
fi

echo "copy vendor_dlkm module ko"
if [ ! -d "${DEVICE_KERNEL_DIR}/lib/modules/" ]; then
	mkdir -p ${DEVICE_KERNEL_DIR}/lib/modules/
fi
rm -rf ${DEVICE_KERNEL_DIR}/lib/modules/*
if [[ -d ${COMMON_OUT_DIR}/vendor_lib ]]; then
	cp -a ${COMMON_OUT_DIR}/vendor_lib/* ${DEVICE_KERNEL_DIR}/lib/
fi
if [[ "$@" =~ "--bazel" ]]; then
	cp -a ${OUT_AMLOGIC_DIR}/ext_modules/*.ko ${DEVICE_KERNEL_DIR}/lib/modules/

	for src_dst in ${FILES_COPY}; do
		src=`echo ${src_dst} | cut -d '+' -f 1`
		dst=`echo ${src_dst} | cut -d '+' -f 2`
		mkdir -p ${DEVICE_KERNEL_DIR}/lib/${dst}
		cp -a ${src} ${DEVICE_KERNEL_DIR}/lib/${dst}
	done
fi
cp ${OUT_AMLOGIC_DIR}/modules/vendor/*.ko ${DEVICE_KERNEL_DIR}/lib/modules/

echo "copy service_module ko"
res=`ls ${OUT_AMLOGIC_DIR}/modules/service_module`
if [[ -n ${res} ]]; then
	cp ${OUT_AMLOGIC_DIR}/modules/service_module/*.ko ${DEVICE_KERNEL_DIR}/lib/modules/
fi

echo "copy modules.load"
cp ${OUT_AMLOGIC_DIR}/modules/ramdisk/ramdisk_modules.order ${DEVICE_KERNEL_DIR}/vendor_boot.modules.load
cp ${OUT_AMLOGIC_DIR}/modules/ramdisk/ramdisk_modules.order ${DEVICE_KERNEL_DIR}/vendor_recovery.modules.load
cat ${OUT_AMLOGIC_DIR}/modules/recovery/recovery_modules.order >> ${DEVICE_KERNEL_DIR}/vendor_recovery.modules.load
cp ${OUT_AMLOGIC_DIR}/modules/vendor/vendor_modules.order ${DEVICE_KERNEL_DIR}/vendor_dlkm.modules.load

echo "copy ext modules ko"
if [[ -n ${LOAD_EXT_MODULES_IN_SECOND_STAGE} ]]; then
	cp ${OUT_AMLOGIC_DIR}/ext_modules/*.ko ${DEVICE_KERNEL_DIR}/lib/modules/
	cat ${OUT_AMLOGIC_DIR}/ext_modules/ext_modules.order >> ${DEVICE_KERNEL_DIR}/vendor_dlkm.modules.load
fi

echo "copy gki image"
if [[ ${FULL_KERNEL_VERSION} != "common13-5.15" && "$KERNEL_A32_SUPPORT" != "true" ]]; then
	DIST_GKI_DIR=${DIST_GKI_DIR:-${DIST_DIR}}
        if [[ -e ${DEVICE_KERNEL_DIR}/system_dlkm.modules.load ]]; then
                rm ${DEVICE_KERNEL_DIR}/system_dlkm.modules.load
        fi
        cat ${DEVICE_KERNEL_DIR}/vendor_dlkm.modules.load  | rev | cut -d '/' -f 1 | rev | while read gki_module; do
		awk "/${gki_module}/" ${DIST_GKI_DIR}/system_dlkm.modules.load >> ${DEVICE_KERNEL_DIR}/system_dlkm.modules.load
	done
	cat ${DIST_GKI_DIR}/system_dlkm.modules.load  | rev | cut -d '/' -f 1 | rev | while read gki_module; do
		sed -i "/${gki_module}/d" ${DEVICE_KERNEL_DIR}/vendor_dlkm.modules.load
		rm ${DEVICE_KERNEL_DIR}/lib/modules/${gki_module}
	done
	if [[ -d ${DEVICE_KERNEL_DIR}/gki ]]; then
		rm -rf ${DEVICE_KERNEL_DIR}/gki
	fi
	mkdir ${DEVICE_KERNEL_DIR}/gki
	cp ${DIST_GKI_DIR}/Image* ${DEVICE_KERNEL_DIR}/gki
	cp ${DIST_GKI_DIR}/boot* ${DEVICE_KERNEL_DIR}/gki
	cp ${DIST_GKI_DIR}/system_dlkm* ${DEVICE_KERNEL_DIR}/gki
	cp ${DIST_GKI_DIR}/vmlinux ${DEVICE_KERNEL_DIR}/gki

	if [ -f ${DEVICE_KERNEL_DIR}/gki/system_dlkm_staging_archive.tar.gz ]; then
		(cd ${DEVICE_KERNEL_DIR}/gki; tar -zxf system_dlkm_staging_archive.tar.gz)
	fi
fi

echo "copy dtb"
[[ -f ${DEVICE_KERNEL_DIR}/dtbo.img ]] && rm -f ${DEVICE_KERNEL_DIR}/dtbo.img
cp ${DIST_DIR}/dtbo.img ${DEVICE_KERNEL_DIR}/

if [ $CONFIG_KERNEL_FCC_PIP ]; then
	export KERNEL_DEVICETREE=${KERNEL_DEVICETREE_FCC_PIP}
fi

DTBTOOL_DIR=device/amlogic/common/kernelbuild
dtb_files_count=0
mkdir -p ${OUT_AMLOGIC_DIR}/dtb
for dtb_file in ${KERNEL_DEVICETREE}; do
	cp ${DIST_DIR}/${dtb_file}.dtb ${OUT_AMLOGIC_DIR}/dtb/
	dtb_files_count=`expr ${dtb_files_count} + 1`
done
if [[ ${dtb_files_count} == 1 ]]; then
	if [ $CONFIG_KERNEL_FCC_PIP ]; then
		if [[ ${PRODUCT_DIRNAME} == *"ohm"* ]]; then
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb ${DEVICE_KERNEL_DIR}/ohm_mxl258c.dtb
		elif [[ ${PRODUCT_DIRNAME} == *"oppencas"* ]]; then
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb ${DEVICE_KERNEL_DIR}/oppencas_mxl258c.dtb
		elif [[ ${PRODUCT_DIRNAME} == *"oppen"* ]]; then
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb ${DEVICE_KERNEL_DIR}/oppen_mxl258c.dtb
		else
			cp -f ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb ${DEVICE_KERNEL_DIR}/${BOARD_DEVICENAME}.dtb
		fi
	else
		if [[ ${KERNEL_DEVICETREE} == "adt4_1k_ui" ]]; then
			cp ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb ${DEVICE_KERNEL_DIR}/${KERNEL_DEVICETREE}.dtb
		else
			cp ${DIST_DIR}/${KERNEL_DEVICETREE}.dtb ${DEVICE_KERNEL_DIR}/${BOARD_DEVICENAME}.dtb
		fi
	fi
else
	${DTBTOOL_DIR}/dtbTool -o ${DEVICE_KERNEL_DIR}/${BOARD_DEVICENAME}.dtb -p ${DTBTOOL_DIR}/ ${OUT_AMLOGIC_DIR}/dtb/
fi

echo "copy Image*"
if [ $KERNEL_A32_SUPPORT ]; then
	cp ${DIST_DIR}/uImage ${DEVICE_KERNEL_DIR}/
else
	[[ -f ${DEVICE_KERNEL_DIR}/Image ]] && rm -f ${DEVICE_KERNEL_DIR}/Image*
	if [[ ${FULL_KERNEL_VERSION} != "common13-5.15" ]]; then
		cp ${DIST_GKI_DIR}/Image* ${DEVICE_KERNEL_DIR}/
	else
		cp ${DIST_DIR}/Image.gz ${DEVICE_KERNEL_DIR}/
	fi
fi

rm -f ${KERNEL_BUILD_VAR_FILE}
echo "========================================================"
echo "build end"
echo "========================================================"
echo
set +e
