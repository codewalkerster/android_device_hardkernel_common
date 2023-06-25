#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2023.06.25

function clean() {
	echo "Clean up"
	CUR_DIR=$(pwd)
	cd $CUR_DIR
	rm -rf signed-* whole_target* normal_* signed_* normal-*
	rm -rf aml_upgrade_package*.img out_publish/
	echo "Clean OK"
	return
}

function build() {
	TARGET_ZIP=$1
	KERNEL_DIR=$2
	BOARD_NAME=$3
	KEY_DIR=$4
	#TOOLS_ZIP=$3
	#BOARD_NAME=$4
	CUR_DIR=$(pwd)
	BOARD_AML_SOC_TYPE=false

	cd $CUR_DIR
	rm -rf normal_target
	echo "unzip $TARGET_ZIP"
	unzip -o -q $TARGET_ZIP -d $CUR_DIR/normal_target

	if [[ "$KERNEL_DIR" =~ "5.15" ]]; then
		TARGET_BUILD_KERNEL_VERSION=5.15
	fi

	if [[ "$KERNEL_DIR" =~ "32" ]]; then
		KERNEL_A32_SUPPORT=true
	else
		KERNEL_A32_SUPPORT=false
	fi

	if [[ "$BOARD_NAME" = "ohm" ]]; then
		BOARD_AML_SOC_TYPE=S905X4
	elif [[ "$BOARD_NAME" = "adt4" ]]; then
		BOARD_AML_SOC_TYPE=S905X4
	elif [[ "$BOARD_NAME" = "calla" ]]; then
		BOARD_AML_SOC_TYPE=T963D4
	elif [[ "$BOARD_NAME" = "ohmcas" ]]; then
		BOARD_AML_SOC_TYPE=S905C2
	elif [[ "$BOARD_NAME" = "ohmcas2" ]]; then
		BOARD_AML_SOC_TYPE=S905C2L
	elif [[ "$BOARD_NAME" = "planck" ]]; then
		BOARD_AML_SOC_TYPE=S805X2
	elif [[ "$BOARD_NAME" = "oppencas" ]]; then
		BOARD_AML_SOC_TYPE=S905C3
	elif [[ "$BOARD_NAME" = "tyson" ]]; then
		BOARD_AML_SOC_TYPE=S928X
	elif [[ "$BOARD_NAME" = "oppen" ]]; then
		BOARD_AML_SOC_TYPE=S905Y4
	elif [[ "$BOARD_NAME" = "boreal" ]]; then
		BOARD_AML_SOC_TYPE=S805X2G
	fi

	echo "BOARD_AML_SOC_TYPE: $BOARD_AML_SOC_TYPE"

	if [[ "$BOARD_NAME" = "adt4" ]]; then
		DEVICE_DIR=device/sei/$BOARD_NAME
	else
		DEVICE_DIR=device/amlogic/$BOARD_NAME
	fi

	cd $CUR_DIR/normal_target/IMAGES/
	rm -rf boot.img bootloader.img dtbo.img init_boot.img system_dlkm.* vendor_boot.img vendor_dlkm.* *.img *.map

	cd $CUR_DIR/normal_target/PREBUILT_IMAGES/
	rm -rf boot.img dtbo.img

	cd $CUR_DIR

	if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" -a "$KERNEL_A32_SUPPORT" = "false" ]; then
		echo "copy boot.img & dtbo.img"
		cp -a $KERNEL_DIR/gki/boot-gz.img $CUR_DIR/normal_target/PREBUILT_IMAGES/boot.img
		cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/PREBUILT_IMAGES/dtbo.img
	fi

	rm -rf $CUR_DIR/normal_target/RADIO/bootloader.img
	if [ -f out/target/product/$BOARD_NAME/gpt.bin ]; then
		echo "patch gbt to bootloader"
		dd if=$DEVICE_DIR/bootloader.img of=$CUR_DIR/normal_target/RADIO/bootloader.img
		dd if=out/target/product/$BOARD_NAME/gpt.bin of=$CUR_DIR/normal_target/RADIO/bootloader.img bs=512 seek=7935
	else
		echo "cp $DEVICE_DIR/bootloader.img $CUR_DIR/normal_target/RADIO/bootloader.img"
		cp $DEVICE_DIR/bootloader.img $CUR_DIR/normal_target/RADIO/bootloader.img
	fi

	echo "copy $CUR_DIR/normal_target/SYSTEM_DLKM"
	rm -rf $CUR_DIR/normal_target/SYSTEM_DLKM/lib/modules/*
	cp -a $KERNEL_DIR/gki/lib/modules/* $CUR_DIR/normal_target/SYSTEM_DLKM/lib/modules/
	cp -a $KERNEL_DIR/system_dlkm.modules.load $CUR_DIR/normal_target/SYSTEM_DLKM/lib/modules/
	cp -a $KERNEL_DIR/system_dlkm.modules.load $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/

	echo "copy $CUR_DIR/normal_target/VENDOR_BOOT"
	rm -rf $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/*.ko
	cp -a $KERNEL_DIR/ramdisk/lib/modules/* $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/
	cp -a $KERNEL_DIR/vendor_boot.modules.load $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/modules.load
	cp -a $KERNEL_DIR/vendor_recovery.modules.load $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/modules.load.recovery
	cp -a $KERNEL_DIR/$BOARD_NAME.dtb $CUR_DIR/normal_target/VENDOR_BOOT/dtb
	cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/VENDOR_BOOT/recovery_dtbo

	rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
	mkdir -p $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules
	cp -a $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/*.ko $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules/
	./out/host/linux-x86/bin/depmod -b $CUR_DIR/out_tmp/depmod_vendor_intermediates 0.0
	sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.dep > $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/modules.dep
	cp $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.alias $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/
	rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates

	echo "copy $CUR_DIR/normal_target/VENDOR_DLKM"
	cp -a $KERNEL_DIR/lib/modules/* $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/
	cp -a $KERNEL_DIR/vendor_dlkm.modules.load $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/modules.load

	mkdir -p $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/vendor/lib/modules
	cp -a $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/*.ko $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/vendor/lib/modules/
	./out/host/linux-x86/bin/depmod -b $CUR_DIR/out_tmp/depmod_vendor_intermediates 0.0
	sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.dep > $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/modules.dep
	cp $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.alias $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/
	rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates

	echo "copy $CUR_DIR/normal_target/VENDOR"
	rm -rf $CUR_DIR/normal_target/VENDOR/lib/firmware/video/*
	cp -a $KERNEL_DIR/lib/firmware/video/checkmsg $CUR_DIR/normal_target/VENDOR/lib/firmware/video/
	if [ "$BOARD_AML_SOC_TYPE" = "false" ]; then
		cp -a $KERNEL_DIR/lib/firmware/video/*.bin $CUR_DIR/normal_target/VENDOR/lib/firmware/video/
	else
		cp -a $KERNEL_DIR/lib/firmware/video/$BOARD_AML_SOC_TYPE/*.bin $CUR_DIR/normal_target/VENDOR/lib/firmware/video/
	fi

	cd $CUR_DIR

	(cd  normal_target/VENDOR; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,vendor/,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R vendor/ >  normal_target/META/vendor_filesystem_config.txt

	(cd  normal_target/VENDOR_BOOT/RAMDISK; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R '' >  normal_target/META/vendor_boot_filesystem_config.txt

	(cd  normal_target/VENDOR_DLKM; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,vendor_dlkm/,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R vendor_dlkm/ >  normal_target/META/vendor_dlkm_filesystem_config.txt

	(cd  normal_target/SYSTEM_DLKM; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,system_dlkm/,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R system_dlkm/ >  normal_target/META/system_dlkm_filesystem_config.txt

	echo "mkbootimg..."
	MKBOOTIMG=out/host/linux-x86/bin/mkbootimg ./out/host/linux-x86/bin/add_img_to_target_files -a -r -v normal_target

	if [ $? -ne 0 ]; then
		echo "build img ERROR"
		exit 1
	fi
	echo "build img OK"

	find  normal_target/META/ | sort > normal_target.zip.list
	find  normal_target/ -path  normal_target/META -prune -o -print | sort >>normal_target.zip.list

	echo "soongzip..."
	./out/host/linux-x86/bin/soong_zip -d -o normal_target.zip -C normal_target -r normal_target.zip.list

	if [ $? -ne 0 ]; then
		echo "build zip ERROR"
		exit 1
	fi
	echo "build soong zip OK"

	mkdir -p out_publish

	if [ $CONFIG_SIGN ]; then
		./device/amlogic/common/scripts/generate_ota_zip.sh normal $BOARD_NAME &
		./device/amlogic/common/scripts/generate_firmware.sh normal $BOARD_NAME $DEVICE_DIR $KERNEL_DIR &

		echo "need sign"
		./out/host/linux-x86/bin/sign_target_files_apks -o --default_key_mappings $KEY_DIR normal_target.zip signed_target.zip

		if [ $? -ne 0 ]; then
			echo "sign ERROR"
			exit 1
		fi
		echo "sign OK"

		./device/amlogic/common/scripts/generate_ota_zip.sh signed $BOARD_NAME &
		./device/amlogic/common/scripts/generate_firmware.sh signed $BOARD_NAME $DEVICE_DIR $KERNEL_DIR &
	else
		./device/amlogic/common/scripts/generate_ota_zip.sh normal $BOARD_NAME &
		./device/amlogic/common/scripts/generate_firmware.sh normal $BOARD_NAME $DEVICE_DIR $KERNEL_DIR &
	fi

	echo "build zip OK"

	exit 0
}

function usage() {
	cat << EOF
Usage:
$(basename $0) --help

command list:
./build_imgs.sh clean   ### clean intermediate file
./build_imgs.sh -v   ### show version
./build_imgs.sh target.zip kernel_dir board_name keys --sign true

EOF
	exit 1
}

function show_version() {
cat << EOF
20230625.01

EOF
	exit 1
}

function parser() {
	local i=0
	local argv=()
	for arg in "$@" ; do
		argv[$i]="$arg"
		i=$((i + 1))
	done
	i=0
	while [ $i -lt $# ]; do
		arg="${argv[$i]}"
		i=$((i + 1)) # must place here
		case "$arg" in
			-h|--help|help)
				usage
				exit ;;
			--sign)
				CONFIG_SIGN=true
				continue ;;
			-v)
				show_version
				exit ;;
			clean|distclean|-distclean|--distclean)
				clean
				exit ;;
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

	export MAIN_FOLDER=$(realpath $(dirname $(readlink $0))/../../../..)
	parser $@
	build $@
}

main $@ # parse all paras to function
