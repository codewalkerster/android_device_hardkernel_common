@ECHO OFF
:: Copyright 2012 The Android Open Source Project
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::      http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

PATH=%PATH%;"%SYSTEMROOT%\System32"
adb reboot bootloader
fastboot flashing unlock
fastboot flash bootloader bootloader.img
fastboot flash bootloader-boot0 bootloader.img
fastboot flash bootloader-boot1 bootloader.img
if exist gpt.bin (
fastboot reboot-bootloader
ping -n 5 127.0.0.1 >nul
fastboot flashing unlock
fastboot flash gpt gpt.bin
)
if exist dt.img (
fastboot flash dts dt.img
)
fastboot erase env
fastboot reboot-bootloader
ping -n 5 127.0.0.1 >nul
fastboot flashing unlock
fastboot erase misc
fastboot flash dtbo dtbo.img
fastboot -w
fastboot erase param
fastboot erase tee
fastboot erase frp
fastboot flash vbmeta vbmeta.img
fastboot flash logo logo.img
if exist odm_ext.img (
fastboot flash odm_ext odm_ext.img
)
if exist oem.img (
fastboot flash oem_a oem.img
fastboot flash oem_b oem.img
)
if exist vbmeta_system.img (
fastboot flash vbmeta_system vbmeta_system.img
)
if exist init_boot.img (
fastboot flash init_boot init_boot.img
)
fastboot flash boot boot.img
fastboot flash vendor_boot vendor_boot.img
fastboot flash super super_empty_all.img
fastboot reboot-fastboot
ping -n 10 127.0.0.1 >nul
fastboot flash odm odm.img
fastboot flash system system.img
if exist system_ext.img (
fastboot flash system_ext system_ext.img
)
if exist vendor_dlkm.img (
fastboot flash vendor_dlkm vendor_dlkm.img
)
if exist odm_dlkm.img (
fastboot flash odm_dlkm odm_dlkm.img
)
fastboot flash vendor vendor.img
fastboot flash product product.img
fastboot reboot-bootloader
ping -n 5 127.0.0.1 >nul
fastboot flashing lock
fastboot reboot

echo Press any key to exit...
pause >nul
exit
