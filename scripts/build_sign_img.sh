#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2020.04.15

function clean() {
	echo "Clean up"
	cd ${MAIN_FOLDER}
	rm -rf signed-target.zip signed-ota.zip signed-fastboot.zip
	rm -rf aml_upgrade_package_sign.img
	return
}

function build() {
	#TARGET_DIR=$1_target
	KEY_DIR=$2
	BOARD_NAME=$3
	CUR_DIR=$(pwd)

	./out/host/linux-x86/bin/sign_target_files_apks -o --default_key_mappings $KEY_DIR $1 signed-target.zip

	if [ $? -ne 0 ]; then
		echo "sign ERROR"
		exit 1
	fi

	./out/host/linux-x86/bin/ota_from_target_files signed-target.zip signed-ota.zip

	if [ $? -ne 0 ]; then
		echo "build ota zip ERROR"
		exit 1
	fi

	./out/host/linux-x86/bin/img_from_target_files signed-target.zip signed-img.zip

	if [ $? -ne 0 ]; then
		echo "build img zip ERROR"
		exit 1
	fi

	unzip -o -q signed-img.zip -d signed-img
	rm signed-img.zip
	cp -a out/target/product/$3/fastboot_auto/gpt.bin signed-img/
	cp -a out/target/product/$3/fastboot_auto/flash-all.bat signed-img/
	cp -a out/target/product/$3/fastboot_auto/flash-all.sh signed-img/

	cd signed-img
	zip -1 -r ../signed-fastboot.zip *

	if [ $? -ne 0 ]; then
		echo "build fastboot zip ERROR"
		exit 1
	fi

	cd ../
	rm -rf signed.zip

	cp -a out/target/product/$3/upgrade/aml_sdc_burn.ini signed-img/
	cp -a out/target/product/$3/upgrade/aml_upgrade_package_* signed-img/
	cp -a out/target/product/$3/upgrade/dt.img signed-img/
	cp -a out/target/product/$3/upgrade/platform.conf signed-img/
	cp -a out/target/product/$3/upgrade/u-boot.bin.* signed-img/
	cp -a out/target/product/$3/upgrade/usb_flow.aml signed-img/

	unzip -o -q signed-target.zip -d signed-target
	./out/host/linux-x86/bin/build_super_image -v signed-target signed-img/super.img

	if [ $? -ne 0 ]; then
		echo "build super.img ERROR"
		exit 1
	fi

	vendor/amlogic/common/tools/aml_upgrade/aml_image_v2_packer -r out/target/product/$3/upgrade/aml_upgrade_package_AB_vendor_boot.conf signed-img aml_upgrade_package_sign.img

	if [ $? -ne 0 ]; then
		echo "build usb burn fw ERROR"
		exit 1
	fi

	rm -rf signed-img
	rm -rf signed-target

	echo "build zip OK"

	exit 0
}

function usage() {
	cat << EOF
Usage:
$(basename $0) --help

command list:
./build_sign_img.sh clean   ### clean intermediate file
./build_sign_img.sh -v   ### show version
./build_sign_img.sh target.zip keys board_name

EOF
	exit 1
}

function show_version() {
cat << EOF
20230531.01

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
