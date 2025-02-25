#!/bin/bash

# Copyright 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#This script (nowipe) is not normally used, only flash-all is used.
#Sometimes when debugging, you only need to burn the img without
#erasing the data and other partitions. This will save you from re-logging
#in to your Google account and other operations.
#Then you can use this script at this time.

set -e
cd $(dirname $0)

lflag="unlock"
if [[ $# -gt 0 ]]; then
    lflag="$1"
fi

sern=""
if [[ $# -gt 1 ]]; then
    sern="-s $2"
fi

skipreboot=""
if [[ $# -gt 2 ]]; then
    skipreboot="$3"
fi

if [ "$skipreboot" != "skip" ]
then
    # Ignore failure, in case we are already in fastboot.
    adb $sern reboot bootloader || true
fi

wipedata="wipe"
if [[ $# -gt 3 && $4 == "nowipe" ]]; then
    wipedata="nowipe"
fi

function flash_with_retry() {
  local partition=${1};
  local img=${2};
  if [ ! -f ${img} ]; then
    echo "\n ${img} is not existed. Skip it."
    return 0
  fi
  msg=$(fastboot ${sern} flash ${partition} ${img} 2>&1)
  echo "${msg}"
  if [[ ${msg} =~ 'FAILED' ]]; then
    echo "\nFlashing ${img} is not done properly. Do it again."
    fastboot ${sern} reboot-bootloader
    fastboot ${sern} flash ${partition} ${img}
  fi
}

fastboot_version=$(fastboot $sern --version | head -n 1 | awk '{print $3}' | cut -d. -f1)
 
if [[ -z "$fastboot_version" ]]; then
    echo "fail to get version num"
    exit 1
fi
echo $(fastboot $sern --version | head -n 1)

if [[ "$fastboot_version" -ge 35 ]]; then
	echo "version >= 35"

	fastboot $sern flash bootloader bootloader.img

	if [ -f dt.img ]
	then
	fastboot $sern flash dts dt.img
	fi

	if [ -f gpt.bin ]
	then
		fastboot $sern reboot-bootloader
		sleep 5
		fastboot $sern flash gpt gpt.bin
	fi

	fastboot $sern reboot-bootloader
	sleep 5
	fastboot $sern flash dtbo dtbo.img

	flash_with_retry vbmeta vbmeta.img
	flash_with_retry odm_ext odm_ext.img
	if [ -f oem.img ]
	then
		flash_with_retry oem_a oem.img
		flash_with_retry oem_b oem.img
	fi
	if [ -f init_boot.img ]
	then
		flash_with_retry init_boot init_boot.img
	fi
	flash_with_retry vbmeta_system vbmeta_system.img
	flash_with_retry boot boot.img
	flash_with_retry vendor_boot vendor_boot.img
	flash_with_retry super super_empty_all.img
	fastboot $sern reboot-fastboot
	sleep 10

	flash_with_retry odm odm.img
	flash_with_retry system system.img
	flash_with_retry system_ext system_ext.img
	if [ -f vendor_dlkm.img ]
	then
		flash_with_retry vendor_dlkm vendor_dlkm.img
	fi
	if [ -f system_dlkm.img ]
	then
		flash_with_retry system_dlkm system_dlkm.img
	fi
	if [ -f odm_dlkm.img ]
	then
		flash_with_retry odm_dlkm odm_dlkm.img
	fi
	flash_with_retry vendor vendor.img
	flash_with_retry product product.img
	fastboot $sern reboot-bootloader
	sleep 5

	fastboot $sern flash bootloader-boot0 bootloader.img
	fastboot $sern flash bootloader-boot1 bootloader.img

	if [ "$lflag" = "lock" ]
	then
		fastboot $sern flashing lock
	fi

	fastboot $sern reboot
else

    echo "fastboot tool version is lower and needs to be updated"
    echo "Download URL : https://developer.android.com/tools/releases/platform-tools?hl=zh-cn"
    exit 1
fi
