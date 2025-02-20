#!/bin/bash
usage()
{
   echo "USAGE: [-U] [-CK] [-A] [-p] [-o] [-u] [-v VERSION_NAME]  "
    echo "No ARGS means use default build option                  "
    echo "WHERE: -U = build uboot                                 "
    echo "       -K = build kernel                                "
    echo "       -A = build android                               "
    echo "       -o = build OTA package                           "
    echo "       -v = build android with 'user' or 'userdebug'    "
    echo "       -d = huild kernel dts name    "
    echo "       -V = build version    "
    echo "       -J = build jobs    "
    echo "       -S = build self install image    "
    echo "       -r = package resource.img    "
    exit 1
}

source build/envsetup.sh >/dev/null
BUILD_UBOOT=false
BUILD_KERNEL=false
BUILD_ANDROID=false
BUILD_AB_IMAGE=`get_build_var BOARD_USES_AB_IMAGE`
BUILD_OTA=false
BUILD_VARIANT=`get_build_var TARGET_BUILD_VARIANT`
KERNEL_DTS=""
BUILD_VERSION=""
BUILD_JOBS=16
BUILD_SELF=false

# check pass argument
while getopts "UKABSpov:d:V:J:" arg
do
    case $arg in
        U)
            echo "will build u-boot"
            BUILD_UBOOT=true
            ;;
        K)
            echo "will build kernel"
            BUILD_KERNEL=true
            ;;
        A)
            echo "will build android"
            BUILD_ANDROID=true
            ;;
        B)
            echo "will build AB Image"
            BUILD_AB_IMAGE=true
            ;;
        S)
            echo "will build selfinstall iamge"
            BUILD_SELF=true
            ;;
        o)
            echo "will build ota package"
            BUILD_OTA=true
            ;;
        v)
            BUILD_VARIANT=$OPTARG
            ;;
        V)
            BUILD_VERSION=$OPTARG
            ;;
        d)
            KERNEL_DTS=$OPTARG
            ;;
        J)
            BUILD_JOBS=$OPTARG
            ;;
        ?)
            usage ;;
    esac
done

TARGET_PRODUCT=`get_build_var TARGET_PRODUCT`
TARGET_BOARD_PLATFORM=`get_build_var TARGET_BOARD_PLATFORM`

#set jdk version
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$ANDROID_BUILD_TOP/prebuilts/clang/host/linux-x86/clang-r450784d/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar

# source environment and chose target product
BUILD_NUMBER=`get_build_var BUILD_NUMBER`
BUILD_ID=`get_build_var BUILD_ID`
# only save the version code
SDK_VERSION=`get_build_var CURRENT_SDK_VERSION`
ANDROID_VERSION=`get_build_var PRODUCT_ANDROID_VERSION`
UBOOT_DEFCONFIG=`get_build_var PRODUCT_UBOOT_CONFIG`
KERNEL_TARGET=`get_build_var PRODUCT_KERNEL_TARGET`
KERNEL_VERSION=`get_build_var PRODUCT_KERNEL_VERSION`
KERNEL_ARCH=`get_build_var PRODUCT_KERNEL_ARCH`
KERNEL_DEFCONFIG=`get_build_var PRODUCT_KERNEL_CONFIG`
PRODUCT_OUT=`get_build_var PRODUCT_OUT`
if [ "$KERNEL_DTS" = "" ] ; then
KERNEL_DTS=`get_build_var PRODUCT_KERNEL_DTS`
fi
LOCAL_KERNEL_PATH=common
echo "-------------------KERNEL_VERSION:$KERNEL_VERSION"
echo "-------------------KERNEL_DTS:$KERNEL_DTS"

PACK_TOOL_DIR=RKTools/linux/Linux_Pack_Firmware
IMAGE_PATH=odroidev/Image-$TARGET_PRODUCT
export PROJECT_TOP=`gettop`

rm -rf $IMAGE_PATH
mkdir -p $IMAGE_PATH

lunch $TARGET_PRODUCT-$BUILD_VARIANT

DATE=$(date  +%Y%m%d.%H%M)
STUB_PATH=Image/"$TARGET_PRODUCT"_"$BUILD_VARIANT"_"$KERNEL_DTS"_"$BUILD_VERSION"_"$DATE"
STUB_PATH="$(echo $STUB_PATH | tr '[:lower:]' '[:upper:]')"
export STUB_PATH=$PROJECT_TOP/$STUB_PATH
export STUB_PATCH_PATH=$STUB_PATH/PATCHES

# build uboot
if [ "$BUILD_UBOOT" = true ] ; then
	echo "start build uboot"
	pushd u-boot
	./mk $UBOOT_DEFCONFIG --vab --fastboot-write  && cd -

	popd

	if [ $? -eq 0 ]; then
		echo "Build uboot ok!"
	else
		echo "Build uboot failed!"
		exit 1
	fi
fi

if [ "$BUILD_KERNEL" = true ] ; then
	echo "Start build kernel"
	pushd $LOCAL_KERNEL_PATH
	./mk clean
	./mk $KERNEL_TARGET -v common$ANDROID_VERSION-$KERNEL_VERSION

	popd

	if [ $? -eq 0 ]; then
	    echo "Build kernel ok!"
	else
	    echo "Build kernel failed!"
	    exit 1
	fi
fi

# build android
if [ "$BUILD_ANDROID" = true ] ; then
	# build OTA
	if [ "$BUILD_OTA" = true ] ; then
		INTERNAL_OTA_PACKAGE_OBJ_TARGET=obj/PACKAGING/target_files_intermediates/$TARGET_PRODUCT-target_files-*.zip
		INTERNAL_OTA_PACKAGE_TARGET=$TARGET_PRODUCT-ota-*.zip
		if [ "$BUILD_AB_IMAGE" = true ] ; then
			echo "make ab image and generate ota package"
			make installclean
			make -j$BUILD_JOBS
			# check the result of make
			if [ $? -eq 0 ]; then
				echo "Build android ok!"
			else
				echo "Build android failed!"
				exit 1
			fi

			make dist -j$BUILD_JOBS
			# check the result of make
			if [ $? -eq 0 ]; then
				echo "Build android ok!"
			else
				echo "Build android failed!"
				exit 1
			fi
			./mkimage_ab.sh ota
			# check the result of make
			if [ $? -eq 0 ]; then
				echo "Build android ok!"
			else
				echo "Build android failed!"
				exit 1
			fi
		else
			echo "generate ota package"
			make installclean
			make -j$BUILD_JOBS
			# check the result of make
			if [ $? -eq 0 ]; then
				echo "Build android ok!"
			else
				echo "Build android failed!"
				exit 1
			fi
			make dist -j$BUILD_JOBS
			# check the result of make
			if [ $? -eq 0 ]; then
				echo "Build android ok!"
			else
				echo "Build android failed!"
				exit 1
			fi
			./mkimage.sh ota
			# check the result of make
			if [ $? -eq 0 ]; then
				echo "Build android ok!"
			else
				echo "Build android failed!"
				exit 1
			fi
		fi
		cp $OUT/$INTERNAL_OTA_PACKAGE_TARGET $IMAGE_PATH/
		cp $OUT/$INTERNAL_OTA_PACKAGE_OBJ_TARGET $IMAGE_PATH/
	else # regular build without OTA
		echo "start build android"
		make installclean
		make -j$BUILD_JOBS
		# check the result of make
		if [ $? -eq 0 ]; then
			echo "Build android ok!"
		else
			echo "Build android failed!"
			exit 1
		fi
	fi
else # repack v2 boot
	echo "Repacking header 2 boot..."
#	BOOT_CMDLINE=`get_build_var BOARD_KERNEL_CMDLINE`
#	SECURITY_LEVEL=`get_build_var PLATFORM_SECURITY_PATCH`
#	mkbootfs -d $OUT/system $OUT/ramdisk | minigzip > $OUT/ramdisk.img
#	mkbootimg --kernel $OUT/kernel --ramdisk $OUT/ramdisk.img --dtb $OUT/dtb.img --cmdline "$BOOT_CMDLINE" --os_version 12 --os_patch_level $SECURITY_LEVEL --second $LOCAL_KERNEL_PATH/resource.img --header_version 2 --output $OUT/boot.img
fi

#if [ "$BUILD_OTA" != true ] ; then
#	# mkimage.sh
#	echo "make and copy android images"
#	./mkimage.sh
#	if [ $? -eq 0 ]; then
#		echo "Make image ok!"
#	else
#		echo "Make image failed!"
#		exit 1
#	fi
#fi

if [ "$BUILD_SELF" = true ] ; then
	echo "Start make self install image"
	$PROJECT_TOP/device/hardkernel/common/selfinstall/selfinstall.sh $IMAGE_PATH
fi
