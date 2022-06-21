#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2020.04.15

function clean() {
	echo "Clean up"
	cd ${MAIN_FOLDER}
	rm -rf  out/freeze_build/*
	return
}

function build() {
	# parser
	bin_path_parser $@

	TARGET_ZIP1=$1
	TARGET_ZIP2=$2
	CUR_DIR=$(pwd)
	echo $CUR_DIR

	mkdir -p out/freeze_build

	cd $CUR_DIR
	export PATH=$CUR_DIR/out/host/linux-x86/bin/:$CUR_DIR/out/soong/host/linux-x86/bin/:$CUR_DIR/system/extras/ext4_utils/:$CUR_DIR/prebuilts/build-tools/path/linux-x86:$CUR_DIR/out/.path:$PATH
	export LD_LIBRARY_PATH=$CUR_DIR/out/host/linux-x86/lib64:$LD_LIBRARY_PATH
	echo $PATH
	echo $LD_LIBRARY_PATH

	echo "copy readonly $TARGET_ZIP1 $TARGET_ZIP2"
	cp $TARGET_ZIP1 out/freeze_build/target_S.zip
	cp $TARGET_ZIP2 out/freeze_build/target_T.zip

	cd $CUR_DIR
	CONFIG_BOAED_NAME_S=${TARGET_ZIP1##*/}
	CONFIG_BOAED_NAME_T=${TARGET_ZIP2##*/}
	echo "board: $CONFIG_BOAED_NAME_S ... $CONFIG_BOAED_NAME_T "
	CONFIG_BOAED_NAME_S=$(echo $CONFIG_BOAED_NAME_S | cut -f 1 -d "-")
	CONFIG_BOAED_NAME_T=$(echo $CONFIG_BOAED_NAME_T | cut -f 1 -d "-")
	echo "board: $CONFIG_BOAED_NAME_S ... $CONFIG_BOAED_NAME_T "
	if [ $CONFIG_BOAED_NAME_S != $CONFIG_BOAED_NAME_T ]; then
		echo "board name $CONFIG_BOAED_NAME_S != $CONFIG_BOAED_NAME_T"
		exit 1
	fi
	CONFIG_BOAED_NAME=$CONFIG_BOAED_NAME_T

	cd $CUR_DIR
	EXTRA_FLAGS=""
	if [ -d "device/amlogic/common/vf" ]; then
		EXTRA_FLAGS+=" --framework-item-list device/amlogic/common/vf/framework_item_list.txt \
		--framework-misc-info-keys device/amlogic/common/vf/framework_misc_info_keys.txt \
		--vendor-item-list device/amlogic/common/vf/vendor_item_list.txt"
	fi

	cd $CUR_DIR
	echo "start to merge_target_files"
	./out/host/linux-x86/bin/merge_target_files \
		--framework-target-files out/freeze_build/target_T.zip \
		--vendor-target-files out/freeze_build/target_S.zip \
		--allow-duplicate-apkapex-keys \
		--output-target-files out/freeze_build/${CONFIG_BOAED_NAME}-target_files.zip \
		--output-img  out/freeze_build/${CONFIG_BOAED_NAME}-img.zip \
		--output-ota  out/freeze_build/${CONFIG_BOAED_NAME}-ota.zip \
		${EXTRA_FLAGS}

	if [ $? -ne 0 ]; then
		echo "merge_target_files ERROR"
		exit 1
	fi

	echo "merge_target_files OK"

	unzip -o -q out/freeze_build/${CONFIG_BOAED_NAME}-img.zip -d out/freeze_build/fastboot_auto
	cp out/target/product/${CONFIG_BOAED_NAME}/fastboot_auto/flash-all.* out/freeze_build/fastboot_auto/
	cd out/freeze_build/fastboot_auto/
	zip -1 -r ../vendor-freeze-build-${CONFIG_BOAED_NAME}.zip *
	cd ../
	rm ${CONFIG_BOAED_NAME}-img.zip
	mv ${CONFIG_BOAED_NAME}-ota.zip vendor-freeze-ota-update-${CONFIG_BOAED_NAME}.zip

	cd $CUR_DIR

	if [ $? -ne 0 ]; then
		echo "build zip ERROR"
		exit 1
	fi

	echo "build zip OK"

	exit 0
}

function usage() {
cat << EOF
	Usage:
	$(basename $0) --help

	command list:
	./vendor_freeze_build.sh clean   ### clean intermediate file
	./vendor_freeze_build.sh -v   ### show version

	#build fastboot.zip & ota.zip
	./vendor_freeze_build.sh target_S.zip target_T.zip


EOF
  exit 1
}

function show_version() {
cat << EOF
	20220618.01

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

