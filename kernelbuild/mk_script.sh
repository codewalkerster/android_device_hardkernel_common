#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2020.04.15

function clean() {
	echo "Clean up"
	cd ${MAIN_FOLDER}
	rm -rf out/android*
	if [[ -d common-5.15/out ]]; then
		rm -rf common-5.15/out
	fi
	if [[ -d common14-5.15/out ]]; then
		[[ -d common14-5.15/bazel-out ]] && (cd common14-5.15; tools/bazel clean --async)
		rm -rf common14-5.15/out
	fi
	return
}

function build_deadpool() {
	echo "------device/askey/deadppol/build.config.meson.arm64.deadpool-----"
	cd ${MAIN_FOLDER}
	export BUILD_CONFIG=device/askey/deadpool/build.config.meson.arm64.deadpool

	. ${MAIN_FOLDER}/${BUILD_CONFIG}
	export $(sed -n -e 's/\([^=]\)=.*/\1/p' ${MAIN_FOLDER}/${BUILD_CONFIG})
	if [ $CONFIG_AB_UPDATE ]; then
		echo "=====ab update mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic_ab.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
		done
	else
		echo "=====normal mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			sed -i 's/^#include \"partition_.*/#include "partition_mbox_dynamic_deadpool.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
		done
	fi

	cd ${MAIN_FOLDER}
	./device/amlogic/common/kernelbuild/build_kernel_4.9.sh
}

function build_boreal() {
	echo "------device/google/boreal/build.config.meson.arm64.trunk-----"
	cd ${MAIN_FOLDER}
	export BUILD_CONFIG=device/google/boreal/build.config.meson.arm64.trunk
	export TARGET_BUILD_KERNEL_VERSION=5.4
        export TARGET_BUILD_KERNEL_4_9=false
	. ${MAIN_FOLDER}/${BUILD_CONFIG}
	export $(sed -n -e 's/\([^=]\)=.*/\1/p' ${MAIN_FOLDER}/${BUILD_CONFIG})

	if [ $CONFIG_KERNEL_DDR_1G ]; then
		export KERNEL_DEVICETREE=${KERNEL_DEVICETREE_DDR_1G}
	fi

	echo "KERNEL_DEVICETREE: ${KERNEL_DEVICETREE}"

	echo "=====ab update & vendor boot mode====="
	for aDts in ${KERNEL_DEVICETREE}; do
		if [ $KERNEL_A32_SUPPORT ]; then
			sed -i 's/^#include \"partition_.*/#include "partition_mbox_ab.dtsi"/' ${KERNEL_DIR}/arch/arm/boot/dts/amlogic/$aDts.dts;
		else
			sed -i 's/^#include \"partition_.*/#include "partition_mbox_ab.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
		fi
	done

	echo "================================="

	cd ${MAIN_FOLDER}
	./device/amlogic/common/kernelbuild/build.sh
}
function build_anning() {
	if [ $KERNEL_A32_SUPPORT ]; then
		echo "------device/amlogic/ampere/anning/build.config.meson.arm.trunk_4.9-----"
	else
		echo "------device/amlogic/ampere/anning/build.config.meson.arm64.trunk_4.9-----"
	fi

	cd ${MAIN_FOLDER}
	if [ $KERNEL_A32_SUPPORT ]; then
		export BUILD_CONFIG=device/amlogic/ampere/anning/build.config.meson.arm.trunk_4.9
	else
		export BUILD_CONFIG=device/amlogic/ampere/anning/build.config.meson.arm64.trunk_4.9
	fi

	export TARGET_BUILD_KERNEL_VERSION=4.9
        export TARGET_BUILD_KERNEL_4_9=true
	. ${MAIN_FOLDER}/${BUILD_CONFIG}
	export $(sed -n -e 's/\([^=]\)=.*/\1/p' ${MAIN_FOLDER}/${BUILD_CONFIG})
	echo "KERNEL_DEVICETREE: ${KERNEL_DEVICETREE}"
	if [ $CONFIG_AB_UPDATE ]; then
		echo "=====ab update mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			if [ $KERNEL_A32_SUPPORT ]; then
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic_ab.dtsi"/' ${KERNEL_DIR}/arch/arm/boot/dts/amlogic/$aDts.dts;
			else
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic_ab.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
			fi
		done
	else
		echo "=====normal mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			if [ $KERNEL_A32_SUPPORT ]; then
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic.dtsi"/' ${KERNEL_DIR}/arch/arm/boot/dts/amlogic/$aDts.dts;
			else
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
			fi
		done
	fi
	echo "================================="
    echo "KERNEL_DEVICETREE === ${KERNEL_DEVICETREE}"
	cd ${MAIN_FOLDER}
	./device/amlogic/common/kernelbuild/build_kernel_4.9.sh
}
function build_common_4.9() {
	if [ $KERNEL_A32_SUPPORT ]; then
		echo "------device/${device_project}/$1/build.config.meson.arm.trunk_4.9-----"
	else
		echo "------device/${device_project}/$1/build.config.meson.arm64.trunk_4.9-----"
	fi
	cd ${MAIN_FOLDER}
	if [ $KERNEL_A32_SUPPORT ]; then
		export BUILD_CONFIG=device/${device_project}/$1/build.config.meson.arm.trunk_4.9
	else
		export BUILD_CONFIG=device/${device_project}/$1/build.config.meson.arm64.trunk_4.9
	fi
	export TARGET_BUILD_KERNEL_VERSION=4.9
        export TARGET_BUILD_KERNEL_4_9=true

	. ${MAIN_FOLDER}/${BUILD_CONFIG}
	export $(sed -n -e 's/\([^=]\)=.*/\1/p' ${MAIN_FOLDER}/${BUILD_CONFIG})
	echo "KERNEL_DEVICETREE: ${KERNEL_DEVICETREE}"
	if [ $CONFIG_AB_UPDATE ]; then
		echo "=====ab update mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			if [ $KERNEL_A32_SUPPORT ]; then
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic_ab.dtsi"/' ${KERNEL_DIR}/arch/arm/boot/dts/amlogic/$aDts.dts;
			else
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic_ab.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
			fi
		done
	else
		echo "=====normal mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			if [ $KERNEL_A32_SUPPORT ]; then
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic.dtsi"/' ${KERNEL_DIR}/arch/arm/boot/dts/amlogic/$aDts.dts;
			else
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_normal_dynamic.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
			fi
		done
	fi
	echo "================================="

	cd ${MAIN_FOLDER}
	./device/amlogic/common/kernelbuild/build_kernel_4.9.sh
}

function build_common_5.4() {
	if [ $KERNEL_A32_SUPPORT ]; then
		echo "------device/${device_project}/$1/build.config.meson.arm.trunk-----"
	else
		echo "------device/${device_project}/$1/build.config.meson.arm64.trunk-----"
	fi

	cd ${MAIN_FOLDER}
	if [ $KERNEL_A32_SUPPORT ]; then
		export BUILD_CONFIG=device/${device_project}/$1/build.config.meson.arm.trunk
	else
		export BUILD_CONFIG=device/${device_project}/$1/build.config.meson.arm64.trunk
	fi
	export TARGET_BUILD_KERNEL_VERSION=5.4
        export TARGET_BUILD_KERNEL_4_9=false
	. ${MAIN_FOLDER}/${BUILD_CONFIG}
	export $(sed -n -e 's/\([^=]\)=.*/\1/p' ${MAIN_FOLDER}/${BUILD_CONFIG})

	if [ $CONFIG_KERNEL_DDR_1G ]; then
		export KERNEL_DEVICETREE=${KERNEL_DEVICETREE_DDR_1G}
	fi

	if [ $CONFIG_KERNEL_FCC_PIP ]; then
		export KERNEL_DEVICETREE=${KERNEL_DEVICETREE_FCC_PIP}
		export CONFIG_KERNEL_FCC_PIP=true
	fi

	echo "KERNEL_DEVICETREE: ${KERNEL_DEVICETREE}"
	if [ $CONFIG_NONGKI ]; then
		echo "=====normal mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			if [ $KERNEL_A32_SUPPORT ]; then
				sed -i 's/^#include \"partition_.*/#include "partition_mbox.dtsi"/' ${KERNEL_DIR}/arch/arm/boot/dts/amlogic/$aDts.dts;
			else
				sed -i 's/^#include \"partition_.*/#include "partition_mbox.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
			fi
		done
	else
		echo "=====ab update & vendor boot mode====="
		for aDts in ${KERNEL_DEVICETREE}; do
			if [ $KERNEL_A32_SUPPORT ]; then
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_ab.dtsi"/' ${KERNEL_DIR}/arch/arm/boot/dts/amlogic/$aDts.dts;
			else
				sed -i 's/^#include \"partition_.*/#include "partition_mbox_ab.dtsi"/' ${KERNEL_DIR}/arch/arm64/boot/dts/amlogic/$aDts.dts;
			fi
		done
	fi
	echo "================================="

	cd ${MAIN_FOLDER}
	./device/amlogic/common/kernelbuild/build.sh
}

function build_config_to_bzl() {
	#[[ -f ${PROJECT_DIR}/BUILD.bazel ]] || touch ${PROJECT_DIR}/BUILD.bazel
	#echo "# SPDX-License-Identifier: GPL-2.0" 	> ${PROJECT_DIR}/BUILD.bazel
	#echo 						>> ${PROJECT_DIR}/BUILD.bazel
	#echo "package(" 				>> ${PROJECT_DIR}/BUILD.bazel
	#echo "    default_visibility = [" 		>> ${PROJECT_DIR}/BUILD.bazel
	#echo "        "//visibility:public"," 		>> ${PROJECT_DIR}/BUILD.bazel
	#echo "    ]," 					>> ${PROJECT_DIR}/BUILD.bazel
	#echo ")" 					>> ${PROJECT_DIR}/BUILD.bazel

	[[ -f ${PROJECT_DIR}/project.bazel ]] || touch ${PROJECT_DIR}/project.bzl
	echo "# SPDX-License-Identifier: GPL-2.0" 	> ${PROJECT_DIR}/project.bzl
	echo 						>> ${PROJECT_DIR}/project.bzl

	echo "AMLOGIC_MODULES_ANDROID = [" 		>> ${PROJECT_DIR}/project.bzl
	echo "    \"common_drivers/drivers/tty/serial/amlogic-uart.ko\","	>> ${PROJECT_DIR}/project.bzl
	echo "]" 					>> ${PROJECT_DIR}/project.bzl

	echo 						>> ${PROJECT_DIR}/project.bzl
	echo "EXT_MODULES_ANDROID = [" 			>> ${PROJECT_DIR}/project.bzl
	export FILES_COPY=
	local ext_modules
	for ext_module in ${EXT_MODULES_ANDROID}; do
		if [[ "${ext_module}" =~ "hardware/amlogic/media_modules" ]]; then
			echo "    \"//driver_modules/media_modules:media\"," 		>> ${PROJECT_DIR}/project.bzl
			ext_modules="${MAIN_FOLDER}/${KERNEL_REPO}/driver_modules/media_modules ${ext_modules}"
			FILES_COPY="${KERNEL_REPO}/driver_modules/media_modules/firmware/*+firmware/video/ ${FILES_COPY}"
		elif [[ "${ext_module}" =~ "vendor/amlogic/common/gpu/bifrost" ]]; then
			echo "    \"//driver_modules/gpu/bifrost:gpu\"," 		>> ${PROJECT_DIR}/project.bzl
			ext_modules="${MAIN_FOLDER}/${KERNEL_REPO}/driver_modules/gpu/bifrost ${ext_modules}"
		elif [[ "${ext_module}" =~ "vendor/amlogic/reference/external/DTVKit/AFD" ]]; then
			echo "    \"//driver_modules/DTVKit/AFD:afd\"," 		>> ${PROJECT_DIR}/project.bzl
			ext_modules="${MAIN_FOLDER}/${KERNEL_REPO}/driver_modules/DTVKit/AFD ${ext_modules}"
		#elif [[ "${ext_module}" =~ "vendor/amlogic/common/wifi_bt/bluetooth/configs/5_15" ]]; then
		#	echo "    \"//driver_modules/wifi_bt/bt:bt\"," 	>> ${PROJECT_DIR}/project.bzl
		#	ext_modules="${MAIN_FOLDER}/${KERNEL_REPO}/driver_modules/wifi_bt/bt/configs/5_15 ${ext_modules}"
		#elif [[ "${ext_module}" =~ "vendor/amlogic/common/wifi_bt/wifi/configs/5_15" ]]; then
		#	echo "    \"//driver_modules/wifi_bt/wifi:wlan\"," 		>> ${PROJECT_DIR}/project.bzl
		#	ext_modules="${MAIN_FOLDER}/${KERNEL_REPO}/driver_modules/wifi_bt/wifi/configs/5_15 ${ext_modules}"
		else
			echo "${ext_module} cna't support bazle build"
			ext_modules="${ext_module} ${ext_modules}"
			#exit
		fi
	done
	echo "]" 					>> ${PROJECT_DIR}/project.bzl
	EXT_MODULES_ANDROID=${ext_modules}
}

function build_config_to_build_config() {
	[[ -f ${PROJECT_DIR}/build.config.project ]] || touch ${PROJECT_DIR}/build.config.project
	echo "# SPDX-License-Identifier: GPL-2.0" 	> ${PROJECT_DIR}/build.config.project
	echo 						>> ${PROJECT_DIR}/build.config.project

	echo "PRODUCT_DIR=${PRODUCT_DIR}" >> ${PROJECT_DIR}/build.config.project
	[[ -n ${GPU_DRV_VERSION} ]] && echo "GPU_DRV_VERSION=${GPU_DRV_VERSION}" >> ${PROJECT_DIR}/build.config.project
}

function build_common_5.15() {
	export KERNEL_VERSION=${CONFIG_KERNEL_VERSION##*-}
	export TARGET_BUILD_KERNEL_VERSION=${KERNEL_VERSION}
	export TARGET_BUILD_KERNEL_4_9=false
	if [ ${CONFIG_KERNEL_VERSION} = "5.15" ]; then
		export KERNEL_REPO=common-${CONFIG_KERNEL_VERSION}
		export FULL_KERNEL_VERSION="common13-5.15"
	else
		export FULL_KERNEL_VERSION=${CONFIG_KERNEL_VERSION}
		export KERNEL_REPO=${CONFIG_KERNEL_VERSION}
	fi
	export KERNEL_DIR=common
	export COMMON_DRIVERS_DIR=common_drivers
	export BOARD_DEVICENAME=$1
	export BOARD_MANUFACTURER=${device_project}
	export PRODUCT_DIRNAME=device/amlogic/${BOARD_DEVICENAME}

	if [ ${SKIP_MRPROPER} = "true" ]; then
		SKIP_MRPROPER=1
	fi
	cd ${MAIN_FOLDER}
	if [ $KERNEL_A32_SUPPORT ]; then
		BUILD_CONFIG_ANDROID=device/${device_project}/$1/build.config.meson.arm.trunk.5.15
	else
		BUILD_CONFIG_ANDROID=device/${device_project}/$1/build.config.meson.arm64.trunk.5.15
	fi
	. ${MAIN_FOLDER}/${BUILD_CONFIG_ANDROID}

	local ext_modules
	for ext_mod in ${EXT_MODULES_ANDROID}; do
		ext_modules="${MAIN_FOLDER}/${ext_mod} ${ext_modules}"
	done
	EXT_MODULES_ANDROID=${ext_modules}

	local prebuilt_modules_path
	local module_path
	for module_path in ${PREBUILT_MODULES_PATH}; do
		prebuilt_modules_path="${prebuilt_modules_path} ${MAIN_FOLDER}/${module_path}"
	done
	export PREBUILT_MODULES_PATH=${prebuilt_modules_path}

	export $(sed -n -e 's/\([^=]\)=.*/\1/p' ${MAIN_FOLDER}/${BUILD_CONFIG_ANDROID})

	if [ $CONFIG_KERNEL_FCC_PIP ]; then
		export KERNEL_DEVICETREE=${KERNEL_DEVICETREE_FCC_PIP}
		export CONFIG_KERNEL_FCC_PIP=true
	fi

	if [[ "${FULL_KERNEL_VERSION}" != "common13-5.15" ]]; then
		local common_drivers=${KERNEL_REPO}/common/common_drivers
		PROJECT_DIR=${common_drivers}/project
		[[ ! -d ${common_drivers} ]] && echo "no common_drivers: ${common_drivers}" && exit
		[[ -d ${PROJECT_DIR} ]] || mkdir -p ${PROJECT_DIR}

		build_config_to_bzl
		build_config_to_build_config
	fi

	./device/amlogic/common/kernelbuild/build_kernel_5.15.sh $sub_parameters
}

function build_common() {
	if [ "$CONFIG_KERNEL_VERSION" = "4.9" ]; then
		build_common_4.9 $@
	elif [ "$CONFIG_KERNEL_VERSION" = "5.4" ]; then
		build_common_5.4 $@
	elif [[ "$CONFIG_KERNEL_VERSION" =~ "5.15" ]]; then
		build_common_5.15 $@
	fi
}

function build() {
	# parser
	bin_path_parser $@

	export SKIP_MRPROPER=true
	unset SKIP_BUILD_KERNEL
	unset BUILD_ONE_MODULES
	unset SKIP_CP_KERNEL_HDR
	unset BUILD_KERNEL_ONLY
	unset SKIP_EXT_MODULES
	export PRODUCT_DIR=$1

	if [ "${CONFIG_KERNEL_VERSION}" == "" ]; then
		if [ "$1" = "franklin" -o "$1" = "ohm" -o "$1" = "elektra" -o "$1" = "newton" ]; then
			CONFIG_KERNEL_VERSION=4.9
			echo "CONFIG_KERNEL_VERSION: ${CONFIG_KERNEL_VERSION}"
		else
			CONFIG_KERNEL_VERSION=5.4
		fi
	fi

	if [ "${CONFIG_ONE_MODULES}" != "" ]; then
		export SKIP_BUILD_KERNEL=true
		export BUILD_ONE_MODULES=${CONFIG_ONE_MODULES}
		export SKIP_CP_KERNEL_HDR=true
	fi

	if [ "${CONFIG_KERNEL_ONLY}" != "" ]; then
		export SKIP_EXT_MODULES=true
	fi

	option="${1}"
	case ${option} in
		deadpool)
			build_deadpool
			;;
		boreal)
			build_boreal
			;;
		anning)
		    build_anning
			;;
		heavenly)
			device_project="google"
			build_common $@
			;;
		adt4)
			device_project="sei"
			build_common $@
			;;
		*)
			device_project="amlogic"
			build_common $@
			;;
	esac

	if [ $? -ne 0 ]; then
		echo "build kernel error"
		exit 1
	fi

	if [ "$CONFIG_KERNEL_VERSION" = "4.9" ]; then
		KERNEL_OFFSET=0x1080000
		BOOT_HEADER_VERSION=2
		if [ $CONFIG_AB_UPDATE ]; then
			BOOT_IMGSIZE=25165824
		else
			BOOT_IMGSIZE=16777216
		fi
	else
		KERNEL_OFFSET=0x2080000
		BOOT_IMGSIZE=67108864
		BOOT_HEADER_VERSION=4
	fi

	if [ "$1" = "ohm" -o "$1" = "ohmcas" -o "$1" = "oppen" \
		-o "$1" = "smith" -o "$1" = "calla" -o "$1" = "oppencas" -o "$1" = "planck" ]; then
		if [ "$CONFIG_KERNEL_VERSION" = "4.9" ]; then
			BOOT_DEVICES="androidboot.boot_devices=fe08c000.emmc"
		else
			BOOT_DEVICES="androidboot.boot_devices=soc/fe08c000.mmc"
		fi
	fi

	if [ "$1" = "galilei" -o "$1" = "newton" -o "$1" = "dalton" \
		-o "$1" = "elektra" -o "$1" = "redi" -o "$1" = "franklin" ]; then
		if [ "$CONFIG_KERNEL_VERSION" = "4.9" ]; then
			BOOT_DEVICES="androidboot.boot_devices=ffe07000.emmc"
		else
			BOOT_DEVICES="androidboot.boot_devices=soc/ffe07000.mmc"
		fi
	fi

	if [ "$1" = "ampere" ]; then
		BOOT_DEVICES="androidboot.boot_devices=d0074000.emmc"
	fi

	if [ "${CONFIG_Ramdisk}" != "" ]; then
		echo "CONFIG_Ramdisk: ${CONFIG_Ramdisk}"
		if [ $KERNEL_A32_SUPPORT ]; then
			KERNEL_FILE=device/${device_project}/$1-kernel/${CONFIG_KERNEL_VERSION}/uImage
		else
			KERNEL_FILE=device/${device_project}/$1-kernel/${CONFIG_KERNEL_VERSION}/Image.gz
		fi
		./device/amlogic/common/kernelbuild/mkbootimg --kernel ${KERNEL_FILE} \
		--ramdisk ${CONFIG_Ramdisk} \
		--os_version 12 --kernel_offset ${KERNEL_OFFSET} \
		--header_version ${BOOT_HEADER_VERSION} \
		--output out/$1_boot.img
		./device/amlogic/common/kernelbuild/avbtool add_hash_footer --image out/$1_boot.img \
		--partition_size ${BOOT_IMGSIZE} --partition_name boot  \
		--prop com.android.build.boot.os_version:12
	fi

	if [ "${CONFIG_VENDOR_Ramdisk}" != "" -a "${CONFIG_RECOVERY_Ramdisk}" != "" ]; then
		echo "CONFIG_VENDOR_Ramdisk: ${CONFIG_VENDOR_Ramdisk}"
		echo "CONFIG_RECOVERY_Ramdisk: ${CONFIG_RECOVERY_Ramdisk}"
		VENDOR_CMDLINE="androidboot.dynamic_partitions=true androidboot.dtbo_idx=0"
		VENDOR_CMDLINE="$VENDOR_CMDLINE $BOOT_DEVICES"
		VENDOR_CMDLINE="$VENDOR_CMDLINE use_uvm=1 buildvariant=userdebug"
		echo "VENDOR_CMDLINE: $VENDOR_CMDLINE"

		./device/amlogic/common/kernelbuild/mkbootimg \
		--dtb device/${device_project}/$1-kernel/${CONFIG_KERNEL_VERSION}/$1.dtb --base 0x0 \
		--vendor_cmdline "$VENDOR_CMDLINE" \
		--kernel_offset ${KERNEL_OFFSET} --header_version ${BOOT_HEADER_VERSION} \
		--vendor_ramdisk ${CONFIG_VENDOR_Ramdisk} \
		--ramdisk_type RECOVERY --ramdisk_name recovery \
		--vendor_ramdisk_fragment  ${CONFIG_RECOVERY_Ramdisk} \
		--vendor_boot out/$1_vendor_boot.img
		./device/amlogic/common/kernelbuild/avbtool add_hash_footer \
		--image out/$1_vendor_boot.img \
		--partition_size 25165824 --partition_name vendor_boot
	fi
}

function usage() {
  cat << EOF
  Usage:
    $(basename $0) --help

    kernel & modules standalone build script.

    you must use -v ** params

    command list:
    1. build kernel & modules for 5.4 GKI:
        ./$(basename $0) [config_name] -v 5.4

    2. build kernel & modules for 5.4 normal:
        ./$(basename $0) [config_name] -v 5.4 --nonGKI

    3. build kernel & modules for 4.9 normal:
        ./$(basename $0) [config_name] -v 4.9

    4. build kernel & modules for 4.9 virtual ab:
        ./$(basename $0) [config_name] -v 4.9 --ab

    5. clean
        ./$(basename $0) clean

    6. build one modules only
        ./$(basename $0) [config_name] -v 5.4 --modules module_path

    7. build kernel only
        ./$(basename $0) [config_name] -v 5.4 --kernel_only

    8. build kernel with different config
        ./$(basename $0) [config_name] -t [userdebug|user|eng]

    you can use different params at the same time

    Example:
    1) ./mk newton -v 5.4 //5.4 GKI

    2) ./mk newton -v 5.4 --nonGKI   //5.4 nonGKI

    2) ./mk franklin -v 4.9   //4.9 normal

    3) ./mk clean

    4) ./mk newton -v 5.4 -t user   //5.4 GKI with additional meson64_a64_r_user_diffconfig

    5) ./mk franklin -v 4.9 --ab    //4.9 virtual_ab

    6) ./mk ohm -v 5.4 --modules hardware/amlogic/media_modules

    7) ./mk ohm -v 5.4 --kernel_only

EOF
  exit 1
}

function parser() {
	local i=0
	local j=0
	local argv=()
	for arg in "$@" ; do
		argv[$i]="$arg"
		i=$((i + 1))
	done
	i=0
	j=0
	while [ $i -lt $# ]; do
		arg="${argv[$i]}"
		i=$((i + 1)) # must place here
		case "$arg" in
			-h|--help|help)
				usage
				exit ;;
			-v)
				j=1 ;;
			clean|distclean|-distclean|--distclean)
				clean
				exit ;;
			*)
		esac
	done
	if [ "$j" == "0" ]; then
		usage
		exit
	fi
}

function bin_path_parser() {

	local para=$@
	local main_parameters
	if [[ $para =~ "--sp" ]]; then
		sub_parameters=${para#*--sp}
		main_parameters=${para%%--sp*}
	else
		main_parameters=$para
	fi
	sub_parameters=`echo $sub_parameters | awk '$1=$1'`
	main_parameters=`echo $main_parameters | awk '$1=$1'`

	local i=0
	local argv=()
	for arg in $main_parameters ; do
		argv[$i]="$arg"
		i=$((i + 1))
	done
	i=0

	num=${#argv[@]}
	while [ $i -lt $num ]; do
		arg="${argv[$i]}"
		i=$((i + 1)) # must pleace here
		case "$arg" in
			-t)
				CONFIG_BOOTIMAGE="${argv[$i]}"
				echo "CONFIG_BOOTIMAGE: ${CONFIG_BOOTIMAGE}"
				export CONFIG_BOOTIMAGE
				continue ;;
			-v)
				CONFIG_KERNEL_VERSION="${argv[$i]}"
				echo "CONFIG_KERNEL_VERSION: ${CONFIG_KERNEL_VERSION}"
				continue ;;
			--ab|--ab_update)
				CONFIG_AB_UPDATE=true
				continue ;;
			--fccpip)
				CONFIG_KERNEL_FCC_PIP=true
				continue ;;
			--nonGKI)
				CONFIG_NONGKI=true
				continue ;;
			--upgrade)
				CONFIG_UPGRADE=true
				continue ;;
			--modules)
				CONFIG_ONE_MODULES="${argv[$i]}"
				continue ;;
			--kernel_only)
				CONFIG_KERNEL_ONLY=true
				continue ;;
			--ramdisk)
				CONFIG_Ramdisk="${argv[$i]}"
				continue ;;
			--vendor_ramdisk)
				CONFIG_VENDOR_Ramdisk="${argv[$i]}"
				continue ;;
			--recovery_ramdisk)
				CONFIG_RECOVERY_Ramdisk="${argv[$i]}"
				continue ;;
			--1g)
				export CONFIG_KERNEL_DDR_1G=true
				continue ;;
			--builtin_modules)
				CONFIG_BUILTIN_MODULES=true
				echo "CONFIG_BUILTIN_MODULES: true"
				export CONFIG_BUILTIN_MODULES
				continue ;;
				*)
		esac
	done
}

function main() {
	if [ -z $1 ]
	then
		usage
		return
	fi

	export MAIN_FOLDER=`pwd`
	parser $@
	build $@
}

main $@ # parse all paras to function
