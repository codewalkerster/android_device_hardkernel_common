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

set -e
cd $(dirname $0)

lflag="unlock"
if [[ $# -gt 0 ]]; then
    lflag="$1"
fi

target_zip=""
if [[ $# -gt 1 ]]; then
    target_zip="$2"
fi

sern=""
if [[ $# -gt 2 ]]; then
    sern="-s $3"
fi

skipreboot=""
if [[ $# -gt 3 ]]; then
    skipreboot="$4"
fi

if [ "$skipreboot" != "skip" ]
then
    # Ignore failure, in case we are already in fastboot.
    adb $sern reboot bootloader || true
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

fastboot $sern flashing unlock
fastboot $sern flash bootloader bootloader.img
fastboot $sern reboot-bootloader

sleep 5
fastboot $sern flashing unlock
flash_with_retry logo logo.img
flash_with_retry odm_ext odm_ext.img
flash_with_retry oem_a oem.img
flash_with_retry oem_b oem.img

fastboot $sern -w --skip-reboot update $target_zip

fastboot $sern reboot-bootloader
sleep 5

if [ $lflag = "lock" ]
then
	echo "fastboot $sern flashing lock"
    fastboot $sern flashing lock
fi

fastboot $sern reboot
