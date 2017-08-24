#!/bin/bash
echo "$1 $2 $3 $4 $5"
TARGET_PRODUCT=$1
PRODUCT_OUT=$2
TARGET_BOARD_PLATFORM=$3
TARGET_ROCKCHIP_PCBATEST=$4
TARGET_ARCH=$5

############################################################################################
#rk recovery contents
############################################################################################
mkdir -p $PRODUCT_OUT/recovery/root/system/bin/
cp -f vendor/rockchip/common/bin/$TARGET_ARCH/sh $PRODUCT_OUT/recovery/root/system/bin/
cp -f vendor/rockchip/common/bin/$TARGET_ARCH/busybox $PRODUCT_OUT/recovery/root/system/bin/

cp -f vendor/rockchip/common/bin/$TARGET_ARCH/busybox $PRODUCT_OUT/recovery/root/sbin/
cp -f vendor/rockchip/common/bin/$TARGET_ARCH/newfs_msdos $PRODUCT_OUT/recovery/root/sbin/
cp -f vendor/rockchip/common/bin/$TARGET_ARCH/sh $PRODUCT_OUT/recovery/root/sbin/
cp -f vendor/rockchip/common/bin/$TARGET_ARCH/e2fsck $PRODUCT_OUT/recovery/root/sbin/
