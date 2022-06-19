#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2020.04.15

function clean() {
	echo "Clean up"
	cd ${MAIN_FOLDER}
	rm -rf  freeze_build/*
	return
}

function build() {
	# parser
	bin_path_parser $@

	TARGET_ZIP1=$1
	TARGET_ZIP2=$2
	CUR_DIR=$(pwd)
	echo $CUR_DIR

	TARGET_DIR=freeze_build/target_T

	mkdir -p freeze_build
	echo "unzip $TARGET_ZIP1"
	unzip -o -q $TARGET_ZIP1 -d freeze_build/target_S
	if [ $? -ne 0 ]; then
		echo "unzip error"
		exit 1
	fi

	echo "unzip $TARGET_ZIP2"
	unzip -o -q $TARGET_ZIP2 -d $TARGET_DIR
	if [ $? -ne 0 ]; then
		echo "unzip error"
		exit 1
	fi

	cd $CUR_DIR
	CONFIG_BOAED_NAME_S=$(grep "ro.build.product=" freeze_build/target_S/SYSTEM/build.prop | cut -f 2 -d "=")
	CONFIG_BOAED_NAME_T=$(grep "ro.build.product=" freeze_build/target_T/SYSTEM/build.prop | cut -f 2 -d "=")
	echo "board: $CONFIG_BOAED_NAME_S ... $CONFIG_BOAED_NAME_T "
	if [ $CONFIG_BOAED_NAME_S != $CONFIG_BOAED_NAME_T ]; then
		echo "board name $CONFIG_BOAED_NAME_S != $CONFIG_BOAED_NAME_T"
		exit 1
	fi
	CONFIG_BOAED_NAME=$CONFIG_BOAED_NAME_T

	cd $CUR_DIR
	export PATH=$CUR_DIR/out/host/linux-x86/bin/:$CUR_DIR/out/soong/host/linux-x86/bin/:$CUR_DIR/system/extras/ext4_utils/:$CUR_DIR/prebuilts/build-tools/path/linux-x86:$CUR_DIR/out/.path:$PATH
	export LD_LIBRARY_PATH=$CUR_DIR/out/host/linux-x86/lib64:$LD_LIBRARY_PATH
	echo $PATH
	echo $LD_LIBRARY_PATH

	cd $CUR_DIR
	echo "prepare target files"
	cd $TARGET_DIR/IMAGES
	rm -rf boot.img vendor_boot.img dtbo.img odm.img odm.map product.img product.map recovery.img recovery-two-step.img system.img system.map vbmeta.img vendor.img vendor.map system_ext.img *.img *.map
	cd $CUR_DIR
	cd $TARGET_DIR/
	rm -rf BOOT INIT_BOOT VENDOR ODM

	cd $CUR_DIR
	cp -a freeze_build/target_S/BOOT $TARGET_DIR/
	cp -a freeze_build/target_S/VENDOR $TARGET_DIR/
	cp -a freeze_build/target_S/ODM $TARGET_DIR/

	cp freeze_build/target_S/META/vendor_filesystem_config.txt $TARGET_DIR/META/vendor_filesystem_config.txt
	cp freeze_build/target_S/META/odm_filesystem_config.txt $TARGET_DIR/META/odm_filesystem_config.txt
	cp freeze_build/target_S/META/boot_filesystem_config.txt $TARGET_DIR/META/boot_filesystem_config.txt

	cd $TARGET_DIR/IMAGES
	rm -rf bootloader.img dt.img dtbo.img logo.img odm_ext* odm*
	cd $CUR_DIR
	cd $TARGET_DIR/RADIO
	rm -rf bootloader.img dt.img dtbo.img logo.img odm_ext*
	cd $CUR_DIR
	cp -a freeze_build/target_S/RADIO/* $TARGET_DIR/RADIO/
	cp -a freeze_build/target_S/PREBUILT_IMAGES/* $TARGET_DIR/PREBUILT_IMAGES/
	cp -a freeze_build/target_S/IMAGES/bootloader.img $TARGET_DIR/IMAGES/
	cp -a freeze_build/target_S/IMAGES/dt.img $TARGET_DIR/IMAGES/
	cp -a freeze_build/target_S/IMAGES/dtbo.img $TARGET_DIR/IMAGES/
	cp -a freeze_build/target_S/IMAGES/logo.img $TARGET_DIR/IMAGES/
	cp -a freeze_build/target_S/IMAGES/odm_ext* $TARGET_DIR/IMAGES/

	if [ -d $TARGET_DIR/VENDOR_BOOT ]; then
		rm -rf $TARGET_DIR/VENDOR_BOOT
		cp -a freeze_build/target_S/VENDOR_BOOT $TARGET_DIR/
		cp freeze_build/target_S/META/vendor_boot_filesystem_config.txt $TARGET_DIR/META/vendor_boot_filesystem_config.txt
	fi

	if [ -d $TARGET_DIR/RECOVERY ]; then
		cp -a freeze_build/target_S/RECOVERY/base $TARGET_DIR/RECOVERY/
		cp -a freeze_build/target_S/RECOVERY/cmdline $TARGET_DIR/RECOVERY/
		cp -a freeze_build/target_S/RECOVERY/dtb $TARGET_DIR/RECOVERY/
		cp -a freeze_build/target_S/RECOVERY/kernel $TARGET_DIR/RECOVERY/
		cp -a freeze_build/target_S/RECOVERY/recovery_dtbo $TARGET_DIR/RECOVERY/
		cp -a freeze_build/target_S/RECOVERY/second $TARGET_DIR/RECOVERY/
		cp -a freeze_build/target_S/RECOVERY/RAMDISK/init.recovery.amlogic.rc $TARGET_DIR/RECOVERY/RAMDISK/
		cp -a freeze_build/target_S/RECOVERY/RAMDISK/sbin/* $TARGET_DIR/RECOVERY/RAMDISK/sbin/
	fi

	cd $CUR_DIR
	echo "make imgs..."
	MKBOOTIMG=out/host/linux-x86/bin/mkbootimg ./out/host/linux-x86/bin/add_img_to_target_files -a -r -v $TARGET_DIR

	if [ $? -ne 0 ]; then
		echo "add_img_to_target_files ERROR"
		exit 1
	fi

	echo "mk img ok"

	find $TARGET_DIR/META/ | sort > freeze_build/${CONFIG_BOAED_NAME}.zip.list
	find $TARGET_DIR/ -path $TARGET_DIR/META -prune -o -print | sort >> freeze_build/${CONFIG_BOAED_NAME}.zip.list

	echo "start to soong_zip"

	if [ -f ./out/host/linux-x86/bin/soong_zip ]; then
		./out/host/linux-x86/bin/soong_zip -d -o freeze_build/${CONFIG_BOAED_NAME}.zip -C $TARGET_DIR -r freeze_build/${CONFIG_BOAED_NAME}.zip.list
	else
		./out/soong/host/linux-x86/bin/soong_zip -d -o freeze_build/${CONFIG_BOAED_NAME}.zip -C $TARGET_DIR -r freeze_build/${CONFIG_BOAED_NAME}.zip.list
	fi

	if [ $? -ne 0 ]; then
		echo "soong_zip ERROR"
		exit 1
	fi

	if [ $KEY_DIR ]; then
		echo "sign_target_files_apks by $KEY_DIR"
		./out/host/linux-x86/bin/sign_target_files_apks -o --default_key_mappings $KEY_DIR freeze_build/${CONFIG_BOAED_NAME}.zip freeze_build/signed-${CONFIG_BOAED_NAME}.zip

		if [ $? -ne 0 ]; then
			echo "sign apk ERROR"
			exit 1
		fi
		echo "sign apk OK"
	else
		mv freeze_build/${CONFIG_BOAED_NAME}.zip freeze_build/signed-${CONFIG_BOAED_NAME}.zip
	fi

	echo "CONFIG_BUILD_OTA: $CONFIG_BUILD_OTA"
	if [ "$CONFIG_BUILD_OTA" = "true" ]; then
		echo "generate signed-ota-update-${CONFIG_BOAED_NAME}.zip"

		./out/host/linux-x86/bin/ota_from_target_files freeze_build/signed-${CONFIG_BOAED_NAME}.zip freeze_build/signed-ota-update-${CONFIG_BOAED_NAME}.zip

		if [ $? -ne 0 ]; then
			echo "build signed ota ERROR"
			exit 1
		fi

		echo "build signed ota ok"
	fi

	echo "generate signed-img-${CONFIG_BOAED_NAME}.zip"

	./out/host/linux-x86/bin/img_from_target_files freeze_build/signed-${CONFIG_BOAED_NAME}.zip freeze_build/signed-img-${CONFIG_BOAED_NAME}.zip

	if [ $? -ne 0 ]; then
		echo "build signed img ERROR"
		exit 1
	fi
	echo "build signed img OK"

	unzip -o -q freeze_build/signed-img-${CONFIG_BOAED_NAME}.zip -d freeze_build/signed-img-${CONFIG_BOAED_NAME}
	rm freeze_build/signed-img-${CONFIG_BOAED_NAME}.zip
	cp out/target/product/${CONFIG_BOAED_NAME}/fastboot_auto/flash-all.* freeze_build/signed-img-${CONFIG_BOAED_NAME}/
	cd freeze_build/signed-img-${CONFIG_BOAED_NAME}
	zip -1 -r ../signed-fastboot-${CONFIG_BOAED_NAME}.zip *
	cd ../
	rm -rf signed-img-${CONFIG_BOAED_NAME}
	rm -rf signed-${CONFIG_BOAED_NAME}.zip
	rm -rf ${CONFIG_BOAED_NAME}.zip.list

	cd $CUR_DIR

	if [ $? -ne 0 ]; then
		echo "build zip ERROR"
		exit 1
	fi

	echo "build zip OK"

	exit_log
	exit 0
}

function usage() {
cat << EOF
	Usage:
	$(basename $0) --help

	command list:
	./vendor_freeze_build.sh clean   ### clean intermediate file
	./vendor_freeze_build.sh -v   ### show version

	#build fastboot.zip
	./vendor_freeze_build.sh target_S.zip target_T.zip
	#build fastboot.zip & ota.zip
	./vendor_freeze_build.sh target_S.zip target_T.zip --ota
	# use release keys and sign apk again
	./vendor_freeze_build.sh target_S.zip target_T.zip --key key_path

EOF
  exit 1
}

function show_version() {
cat << EOF
	20220618.01

EOF
  exit 1
}

function exit_log() {
	if [[ "$CONFIG_BOAED_NAME" =~ "google" ]]; then
		echo "****** dele google keys ***"
		rm -rf vendor/google/certs
		rm -rf vendor/google/dev-keystore
		rm -rf vendor/unbundled_google
	fi
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

function bin_path_parser() {
	local i=0
	local argv=()
	for arg in "$@" ; do
		argv[$i]="$arg"
		i=$((i + 1))
	done
	i=0

	while [ $i -lt $# ]; do
		arg="${argv[$i]}"
		i=$((i + 1)) # must pleace here
		case "$arg" in
			--board)
				CONFIG_BOAED_NAME="${argv[$i]}"
				echo "CONFIG_BOAED_NAME: ${CONFIG_BOAED_NAME}"
				export CONFIG_BOAED_NAME
				continue ;;
			--build_v)
				CONFIG_BUILD_VERSION="${argv[$i]}"
				echo "CONFIG_BUILD_VERSION: ${CONFIG_BUILD_VERSION}"
				export CONFIG_BUILD_VERSION
				continue ;;
			--kernel_v)
				CONFIG_KERNEL_VERSION="${argv[$i]}"
				echo "CONFIG_KERNEL_VERSION: ${CONFIG_KERNEL_VERSION}"
				export CONFIG_KERNEL_VERSION
				continue ;;
			--type)
				CONFIG_BUILD_TYPE="${argv[$i]}"
				echo "CONFIG_BUILD_TYPE: ${CONFIG_BUILD_TYPE}"
				export CONFIG_BUILD_TYPE
				continue ;;
			--key)
				KEY_DIR="${argv[$i]}"
				echo "KEY_DIR: ${KEY_DIR}"
				export KEY_DIR
				continue ;;
			--ota)
				CONFIG_BUILD_OTA=true
				echo "CONFIG_BUILD_OTA: ${CONFIG_BUILD_OTA}"
				export CONFIG_BUILD_OTA
				continue ;;
			--android_v)
				CONFIG_ANDROID_VERSION="${argv[$i]}"
				echo "CONFIG_ANDROID_VERSION: ${CONFIG_ANDROID_VERSION}"
				export CONFIG_ANDROID_VERSION
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

	MAIN_FOLDER=`pwd`
	parser $@
	build $@
}

main $@ # parse all paras to function

