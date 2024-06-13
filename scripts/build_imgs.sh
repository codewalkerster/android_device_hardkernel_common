#!/bin/bash
#
#  author: xindong.xu@amlogic.com
#  2023.06.25

function clean() {
	echo "Clean up"
	CUR_DIR=$(pwd)
	cd $CUR_DIR
	rm -rf signed-* whole_target* normal_* signed_* normal-*
	rm -rf aml_upgrade_package*.img out_publish/ out_tmp
	echo "Clean OK"
	return
}

function build() {
	TARGET_ZIP=$1
	KERNEL_DIR=$2
	BOARD=$3
	KEY_DIR=$4
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

	echo "BOARD in build_imgs.sh: $BOARD"

	if [[ $BOARD =~ t7_an400|t982_ar301|t950s_be311|^anemone_arm64$|mercury ]]; then
		ORIGINAL_BOARD=$BOARD
		REAL_BOARD=$BOARD
		BOARD_NAME=${ORIGINAL_BOARD%_arm64*}
	elif [[ $BOARD =~ _wv4 ]]; then
		ORIGINAL_BOARD=$BOARD
		[[ $BOARD =~ _hybrid_|_mxl258c_|ohm_wv4_cbs_ ]] && REAL_BOARD=${ORIGINAL_BOARD%_*} || REAL_BOARD=${BOARD}
		BOARD_NAME=${ORIGINAL_BOARD%%_*}_wv4
	elif [[ $BOARD =~ _hybrid_|_mxl258c_|ohm_cbs_ ]]; then
		ORIGINAL_BOARD=$BOARD
		REAL_BOARD=${ORIGINAL_BOARD%_*}
		BOARD_NAME=${ORIGINAL_BOARD%%_*}
	else
		ORIGINAL_BOARD=$BOARD
		REAL_BOARD=$ORIGINAL_BOARD
		BOARD_NAME=${ORIGINAL_BOARD%%_*}
	fi

	if [[ $REAL_BOARD =~ _mxl258c|franklin_hybrid|newton_hybrid ]]; then
		ANDROID_OUTPUT_PATH="out/target/product/$REAL_BOARD"
	else
		ANDROID_OUTPUT_PATH="out/target/product/$BOARD_NAME"
	fi

	echo "ORIGINAL_BOARD: $ORIGINAL_BOARD"
	echo "REAL_BOARD: $REAL_BOARD"
	echo "BOARD_NAME: $BOARD_NAME"
	echo "ANDROID_OUTPUT_PATH: $ANDROID_OUTPUT_PATH"

	if [[ "$BOARD_NAME" = "ohm" ]] || [[ "$BOARD_NAME" = "ohm_wv4" ]]; then
		BOARD_AML_SOC_TYPE=S905X4
	elif [[ "$BOARD_NAME" = "adt4" ]]; then
		BOARD_AML_SOC_TYPE=S905X4
	elif [[ "$BOARD_NAME" = "calla" ]]; then
		BOARD_AML_SOC_TYPE=T963D4
	elif [[ "$BOARD_NAME" = "ohmcas" ]]; then
		BOARD_AML_SOC_TYPE=S905C2
	elif [[ "$BOARD_NAME" = "ohmcas2" ]]; then
		BOARD_AML_SOC_TYPE=S905C2L
	elif [[ "$BOARD_NAME" = "planck" ]] || [[ "$BOARD_NAME" = "planck_wv4" ]]; then
		BOARD_AML_SOC_TYPE=S805X2
	elif [[ "$BOARD_NAME" = "oppencas" ]]; then
		BOARD_AML_SOC_TYPE=S905C3
	elif [[ "$BOARD_NAME" = "tyson" ]]; then
		BOARD_AML_SOC_TYPE=S928X
	elif [[ "$BOARD_NAME" = "oppen" ]] || [[ "$BOARD_NAME" = "oppen_wv4" ]]; then
		BOARD_AML_SOC_TYPE=S905Y4
	elif [[ "$BOARD_NAME" = "boreal" ]]; then
		BOARD_AML_SOC_TYPE=S805X2G
	elif [[ "$BOARD_NAME" =~ t7_an400|bluebell|mercury ]]; then
		BOARD_AML_SOC_TYPE=A311D2
	elif [[ "$BOARD_NAME" =~ t982_ar301 ]]; then
		BOARD_AML_SOC_TYPE=T982
	elif [[ "$BOARD_NAME" = "soddy" ]]; then
		BOARD_AML_SOC_TYPE=T962D4
	elif [[ "$BOARD_NAME" =~ newton ]]; then
		LAUNCH_VERSION=Q
	elif [[ "$BOARD_NAME" = "qurra" ]]; then
		BOARD_AML_SOC_TYPE=S905Y5
	elif [[ "$BOARD_NAME" = "pascal" ]]; then
		BOARD_AML_SOC_TYPE=S805X3
	elif [[ "$BOARD_NAME" = "t950s_be311" ]]; then
		BOARD_AML_SOC_TYPE=T950S
	elif [[ "$BOARD_NAME" = "ross" ]]; then
		BOARD_AML_SOC_TYPE=S905X5M
	elif [[ "$BOARD_NAME" = "raman" ]]; then
		BOARD_AML_SOC_TYPE=S905X5
	fi

	echo "BOARD_AML_SOC_TYPE: $BOARD_AML_SOC_TYPE"

	if [[ "$BOARD_NAME" = "adt4" ]]; then
		DEVICE_DIR=device/sei/$BOARD_NAME
	elif [ "$REAL_BOARD" = "franklin_hybrid" ];then
		DEVICE_DIR=device/amlogic/$BOARD_NAME/$REAL_BOARD
	else
		DEVICE_DIR=device/amlogic/$BOARD_NAME
	fi

	cd $CUR_DIR/normal_target/IMAGES/
	rm -rf boot.img bootloader.img dtbo.img init_boot.img system_dlkm.* vendor_boot.img vendor_dlkm.* *.img *.map

	cd $CUR_DIR/normal_target/PREBUILT_IMAGES/
	rm -rf boot.img dtbo.img

	cd $CUR_DIR

	echo "LAUNCH_VERSION: $LAUNCH_VERSION"
	if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" ]; then
		if [ "$LAUNCH_VERSION" = "S" -o "$LAUNCH_VERSION" = "R" ]; then
			echo "launch on S, copy Image.gz & dtbo.img"
			cp -a $KERNEL_DIR/Image.gz $CUR_DIR/normal_target/BOOT/kernel
			cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/PREBUILT_IMAGES/dtbo.img
		elif [ "$LAUNCH_VERSION" = "Q" ]; then
			echo "***** copy kernel"
			cp -a $KERNEL_DIR/gki/Image.lzma $CUR_DIR/normal_target/BOOT/kernel
			cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/PREBUILT_IMAGES/dtbo.img
			if [ -f $CUR_DIR/normal_target/RECOVERY/kernel ]; then
				cp -a $KERNEL_DIR/gki/Image.lzma $CUR_DIR/normal_target/RECOVERY/kernel
			fi
		else
			if [ "$KERNEL_A32_SUPPORT" = "false" ]; then
				echo "copy boot.img & dtbo.img"
				cp -a $KERNEL_DIR/gki/boot-gz.img  $CUR_DIR/normal_target/PREBUILT_IMAGES/boot.img
				cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/PREBUILT_IMAGES/dtbo.img
			fi

			if [ "$KERNEL_A32_SUPPORT" = "true" ]; then
				echo "copy dtbo.img"
				cp -a $KERNEL_DIR/uImage $CUR_DIR/normal_target/BOOT/kernel
				cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/PREBUILT_IMAGES/dtbo.img
			fi
		fi
	else
		echo "kernel 5.4"
		cp -a $KERNEL_DIR/Image.gz $CUR_DIR/normal_target/BOOT/kernel
		cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/PREBUILT_IMAGES/dtbo.img
	fi

	rm -rf $CUR_DIR/normal_target/RADIO/bootloader.img
	if [ -f $ANDROID_OUTPUT_PATH/gpt.bin ]; then
		echo "patch gbt to bootloader"
		dd if=$DEVICE_DIR/bootloader.img of=$CUR_DIR/normal_target/RADIO/bootloader.img
		dd if=$ANDROID_OUTPUT_PATH/gpt.bin of=$CUR_DIR/normal_target/RADIO/bootloader.img bs=512 seek=7935
	else
		echo "cp $DEVICE_DIR/bootloader.img $CUR_DIR/normal_target/RADIO/bootloader.img"
		cp $DEVICE_DIR/bootloader.img $CUR_DIR/normal_target/RADIO/bootloader.img
	fi

	if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" -a "$KERNEL_A32_SUPPORT" = "false" ]; then
		echo "copy $CUR_DIR/normal_target/SYSTEM_DLKM"
		rm -rf $CUR_DIR/normal_target/SYSTEM_DLKM/lib/modules/*
		cp -a $KERNEL_DIR/gki/lib/modules/* $CUR_DIR/normal_target/SYSTEM_DLKM/lib/modules/
		cp -a $KERNEL_DIR/system_dlkm.modules.load $CUR_DIR/normal_target/SYSTEM_DLKM/lib/modules/
		if [ -d $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/ ]; then
			cp -a $KERNEL_DIR/system_dlkm.modules.load $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/
		else
			cp -a $KERNEL_DIR/system_dlkm.modules.load $CUR_DIR/normal_target/VENDOR/lib/modules/
		fi
	fi

	if [[ "$REAL_BOARD" == *"mxl258c"* ]]; then
		LOCAL_DTB=$REAL_BOARD
	elif [[ "$BOARD_NAME" == *"1gb"* ]]; then
		LOCAL_DTB=$REAL_BOARD
	else
		LOCAL_DTB=$BOARD_NAME
	fi

	dtb_size=`du -b $KERNEL_DIR/$LOCAL_DTB.dtb | awk '{print $1}'`

	if [ $dtb_size -ge 184320  ]; then
	    echo "gzip $KERNEL_DIR/$LOCAL_DTB.dtb as >= 180k";
	    mv $KERNEL_DIR/$LOCAL_DTB.dtb $KERNEL_DIR/$LOCAL_DTB.dtb.orig
	    ./out/host/linux-x86/bin/minigzip -c $KERNEL_DIR/$LOCAL_DTB.dtb.orig > $KERNEL_DIR/$LOCAL_DTB.dtb
	fi

	echo "LOCAL_DTB: $LOCAL_DTB"

	if [ -d $CUR_DIR/normal_target/VENDOR_BOOT ]; then
		echo "copy $CUR_DIR/normal_target/VENDOR_BOOT"
		rm -rf $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/*.ko

		if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" ]; then
			cp -a $KERNEL_DIR/ramdisk/lib/modules/* $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/
			cp -a $KERNEL_DIR/vendor_boot.modules.load $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/modules.load
			cp -a $KERNEL_DIR/vendor_recovery.modules.load $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/modules.load.recovery
		else
			for file in $KERNEL_DIR/ramdisk/lib/modules/*.ko; do
				file=$(basename "$file")
				./prebuilts/clang/host/linux-x86/clang-r487747c/bin/llvm-strip \
				-o $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/$file \
				--strip-debug $KERNEL_DIR/ramdisk/lib/modules/$file
			done
		fi

		cp -a $KERNEL_DIR/$LOCAL_DTB.dtb $CUR_DIR/normal_target/VENDOR_BOOT/dtb
		cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/VENDOR_BOOT/recovery_dtbo

		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
		mkdir -p $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules
		cp -a $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/*.ko $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules/
		./out/host/linux-x86/bin/depmod -b $CUR_DIR/out_tmp/depmod_vendor_intermediates 0.0
		sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.dep > $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/modules.dep
		cp $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.alias $CUR_DIR/normal_target/VENDOR_BOOT/RAMDISK/lib/modules/
		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
	else
		echo "copy $CUR_DIR/normal_target/BOOT"
		rm -rf $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/*.ko

		if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" ]; then
			cp -a $KERNEL_DIR/ramdisk/lib/modules/* $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/
			cp -a $KERNEL_DIR/vendor_boot.modules.load $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/modules.load
		else
			for file in $KERNEL_DIR/ramdisk/lib/modules/*.ko; do
				file=$(basename "$file")
				./prebuilts/clang/host/linux-x86/clang-r487747c/bin/llvm-strip \
				-o $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/$file \
				--strip-debug $KERNEL_DIR/ramdisk/lib/modules/$file
			done
		fi

		cp -a $KERNEL_DIR/$LOCAL_DTB.dtb $CUR_DIR/normal_target/BOOT/dtb
		if [ -f $CUR_DIR/normal_target/BOOT/second ]; then
			cp -a $KERNEL_DIR/$LOCAL_DTB.dtb $CUR_DIR/normal_target/BOOT/second
		fi

		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
		mkdir -p $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules
		cp -a $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/*.ko $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules/
		./out/host/linux-x86/bin/depmod -b $CUR_DIR/out_tmp/depmod_vendor_intermediates 0.0
		sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.dep > $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/modules.dep
		cp $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.alias $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/
		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
	fi

	if [ -d $CUR_DIR/normal_target/RECOVERY ]; then
		echo "copy $CUR_DIR/normal_target/RECOVERY"
		rm -rf $CUR_DIR/normal_target/RECOVERY/RAMDISK/lib/modules/*.ko

		if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" ]; then
			cp -a $KERNEL_DIR/ramdisk/lib/modules/* $CUR_DIR/normal_target/RECOVERY/RAMDISK/lib/modules/
			cp -a $KERNEL_DIR/vendor_recovery.modules.load $CUR_DIR/normal_target/RECOVERY/RAMDISK/lib/modules/modules.load.recovery
		else
			for file in $KERNEL_DIR/ramdisk/lib/modules/*.ko; do
				file=$(basename "$file")
				./prebuilts/clang/host/linux-x86/clang-r487747c/bin/llvm-strip \
				-o $CUR_DIR/normal_target/RECOVERY/RAMDISK/lib/modules/$file \
				--strip-debug $KERNEL_DIR/ramdisk/lib/modules/$file
			done
		fi

		cp -a $KERNEL_DIR/$LOCAL_DTB.dtb $CUR_DIR/normal_target/RECOVERY/dtb
		if [ -f $CUR_DIR/normal_target/RECOVERY/second ]; then
			cp -a $KERNEL_DIR/$LOCAL_DTB.dtb $CUR_DIR/normal_target/RECOVERY/second
		fi
		cp -a $KERNEL_DIR/dtbo.img $CUR_DIR/normal_target/RECOVERY/recovery_dtbo

		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
		mkdir -p $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules
		cp -a $CUR_DIR/normal_target/BOOT/RAMDISK/lib/modules/*.ko $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/lib/modules/
		./out/host/linux-x86/bin/depmod -b $CUR_DIR/out_tmp/depmod_vendor_intermediates 0.0
		sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.dep > $CUR_DIR/normal_target/RECOVERY/RAMDISK/lib/modules/modules.dep
		cp $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.alias $CUR_DIR/normal_target/RECOVERY/RAMDISK/lib/modules/
		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
	fi

	if [ -d $CUR_DIR/normal_target/VENDOR_DLKM ]; then
		echo "copy $CUR_DIR/normal_target/VENDOR_DLKM"
		cp -a $KERNEL_DIR/lib/modules/* $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/

		if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" ]; then
			cp -a $KERNEL_DIR/vendor_dlkm.modules.load $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/modules.load
		fi

		mkdir -p $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/vendor/lib/modules
		cp -a $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/*.ko $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/vendor/lib/modules/
		./out/host/linux-x86/bin/depmod -b $CUR_DIR/out_tmp/depmod_vendor_intermediates 0.0
		sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.dep > $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/modules.dep
		cp $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.alias $CUR_DIR/normal_target/VENDOR_DLKM/lib/modules/
		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
	else
		echo "copy $CUR_DIR/normal_target/VENDOR"

		if [ "$TARGET_BUILD_KERNEL_VERSION" = "5.15" ]; then
			cp -a $KERNEL_DIR/lib/modules/* $CUR_DIR/normal_target/VENDOR/lib/modules/
			cp -a $KERNEL_DIR/vendor_dlkm.modules.load $CUR_DIR/normal_target/VENDOR/lib/modules/modules.load
		else
			for file in $KERNEL_DIR/lib/modules/*.ko; do
				file=$(basename "$file")
				./prebuilts/clang/host/linux-x86/clang-r487747c/bin/llvm-strip \
				-o $CUR_DIR/normal_target/VENDOR/lib/modules/$file \
				--strip-debug $KERNEL_DIR/lib/modules/$file
			done
		fi

		mkdir -p $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/vendor/lib/modules
		cp -a $CUR_DIR/normal_target/VENDOR/lib/modules/*.ko $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/vendor/lib/modules/
		./out/host/linux-x86/bin/depmod -b $CUR_DIR/out_tmp/depmod_vendor_intermediates 0.0
		sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.dep > $CUR_DIR/normal_target/VENDOR/lib/modules/modules.dep
		cp $CUR_DIR/out_tmp/depmod_vendor_intermediates/lib/modules/0.0/modules.alias $CUR_DIR/normal_target/VENDOR/lib/modules/
		rm -rf $CUR_DIR/out_tmp/depmod_vendor_intermediates
	fi

	echo "copy $CUR_DIR/normal_target/VENDOR"
	rm -rf $CUR_DIR/normal_target/VENDOR/lib/firmware/video/*
	cp -a $KERNEL_DIR/lib/firmware/video/checkmsg $CUR_DIR/normal_target/VENDOR/lib/firmware/video/
	if [ "$BOARD_AML_SOC_TYPE" = "false" ]; then
		cp -a $KERNEL_DIR/lib/firmware/video/*.bin $CUR_DIR/normal_target/VENDOR/lib/firmware/video/
	else
		if [ -d $KERNEL_DIR/lib/firmware/video/$BOARD_AML_SOC_TYPE ]; then
			cp -a $KERNEL_DIR/lib/firmware/video/$BOARD_AML_SOC_TYPE/*.bin $CUR_DIR/normal_target/VENDOR/lib/firmware/video/
		else
			cp -a $KERNEL_DIR/lib/firmware/video/*.bin $CUR_DIR/normal_target/VENDOR/lib/firmware/video/
		fi
	fi

	cd $CUR_DIR

	if [ -f $CUR_DIR/normal_target/BOOT/RAMDISK ]; then
		(cd  normal_target/BOOT/RAMDISK; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R '' >  normal_target/META/boot_filesystem_config.txt
	fi

	if [ -f $CUR_DIR/normal_target/RECOVERY/RAMDISK ]; then
		(cd  normal_target/RECOVERY/RAMDISK; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R '' >  normal_target/META/recovery_filesystem_config.txt
	fi

	(cd  normal_target/VENDOR; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,vendor/,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R vendor/ >  normal_target/META/vendor_filesystem_config.txt

	if [ -d normal_target/VENDOR_BOOT ]; then
	(cd  normal_target/VENDOR_BOOT/RAMDISK; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R '' >  normal_target/META/vendor_boot_filesystem_config.txt
	fi

	if [ -d normal_target/VENDOR_DLKM ]; then
	(cd  normal_target/VENDOR_DLKM; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,vendor_dlkm/,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R vendor_dlkm/ >  normal_target/META/vendor_dlkm_filesystem_config.txt
	fi

	if [ -d normal_target/SYSTEM_DLKM ]; then
	(cd  normal_target/SYSTEM_DLKM; find . -type d | sed 's,$,/,'; find . \! -type d) | cut -c 3- | sort | sed 's,^,system_dlkm/,' | out/host/linux-x86/bin/fs_config -C -D  normal_target/SYSTEM -S  normal_target/META/file_contexts.bin -R system_dlkm/ >  normal_target/META/system_dlkm_filesystem_config.txt
	fi

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
		./device/amlogic/common/scripts/generate_ota_zip.sh normal $BOARD_NAME $REAL_BOARD $DEVICE_DIR $ANDROID_OUTPUT_PATH &
		./device/amlogic/common/scripts/generate_firmware.sh normal $BOARD_NAME $DEVICE_DIR $KERNEL_DIR $ANDROID_OUTPUT_PATH $REAL_BOARD $LOCAL_DTB &

		echo "need sign"
		./out/host/linux-x86/bin/sign_target_files_apks -o --default_key_mappings $KEY_DIR \
			--extra_apks com.android.ondevicepersonalization.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.scheduling.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.tethering.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.media.swcodec.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.media.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.conscrypt.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.resolv.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.tzdata.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.uwb.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.i18n.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.rkpd.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.runtime.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.appsearch.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.wifi.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.healthfitness.apex=$KEY_DIR/releasekey \
			--extra_apks com.dolby.android.audio.service=$KEY_DIR/releasekey \
			--extra_apks com.android.adservices.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.ipsec.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.btservices.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.adbd.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.devicelock.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.virt.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.os.statsd.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.mediaprovider.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.neuralnetworks.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.art.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.vndk.current.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.configinfrastructure.apex=$KEY_DIR/releasekey \
			--extra_apks com.android.sdkext.apex=$KEY_DIR/releasekey \
			--extra_apks AdServicesApk.apk=$KEY_DIR/releasekey \
			--extra_apks ServiceConnectivityResources.apk=$KEY_DIR/releasekey \
			--extra_apks OsuLogin.apk=$KEY_DIR/releasekey \
			--extra_apks SdkSandbox.apk=$KEY_DIR/releasekey \
			--extra_apks ServiceUwbResources.apk=$KEY_DIR/releasekey \
			--extra_apks WifiDialog.apk=$KEY_DIR/releasekey \
			--extra_apks ServiceWifiResources.apk=$KEY_DIR/releasekey \
                        --extra_apks Bluetooth.apk=$KEY_DIR/releasekey \
                        --key_mapping packages/modules/Bluetooth/android/app/certs/com.android.bluetooth=$KEY_DIR/releasekey \
			--extra_apex_payload_key com.android.btservices.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.runtime.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.i18n.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.tzdata.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.sdkext.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.adservices.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.ondevicepersonalization.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.conscrypt.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.os.statsd.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.tethering.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.neuralnetworks.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.media.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.virt.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.vndk.current.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.uwb.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.mediaprovider.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.appsearch.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.ipsec.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.scheduling.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.wifi.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.resolv.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.adbd.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.rkpd.apex=$KEY_DIR/avb/amlogic.pem \
			--extra_apex_payload_key com.android.art.apex=$KEY_DIR/avb/amlogic.pem \
			normal_target.zip signed_target.zip

		if [ $? -ne 0 ]; then
			echo "sign ERROR"
			exit 1
		fi
		echo "sign OK"

		echo "unzip -o -q ${TARGET_NAME}_target.zip -d ${TARGET_NAME}_target"
		unzip -o -q signed_target.zip -d signed_target

		./device/amlogic/common/scripts/generate_ota_zip.sh signed $BOARD_NAME $REAL_BOARD $DEVICE_DIR $ANDROID_OUTPUT_PATH &
		./device/amlogic/common/scripts/generate_firmware.sh signed $BOARD_NAME $DEVICE_DIR $KERNEL_DIR $ANDROID_OUTPUT_PATH $REAL_BOARD $LOCAL_DTB &
	else
		./device/amlogic/common/scripts/generate_ota_zip.sh normal $BOARD_NAME $REAL_BOARD $DEVICE_DIR $ANDROID_OUTPUT_PATH &
		./device/amlogic/common/scripts/generate_firmware.sh normal $BOARD_NAME $DEVICE_DIR $KERNEL_DIR $ANDROID_OUTPUT_PATH $REAL_BOARD $LOCAL_DTB &
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
