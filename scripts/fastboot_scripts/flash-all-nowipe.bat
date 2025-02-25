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

::This script (nowipe) is not normally used, only flash-all is used.
::Sometimes when debugging, you only need to burn the img without
::erasing the data and other partitions. This will save you from re-logging
::in to your Google account and other operations.
::Then you can use this script at this time.

PATH=%PATH%;"%SYSTEMROOT%\System32"
adb reboot bootloader
for /f "delims=" %%a in ('fastboot --version') do (
    set firstline=%%a
    goto :breakloop
)
:breakloop
echo %firstline%
for /f "tokens=3 delims= " %%a in ("%firstline%") do (
  set version=%%a
)
::echo %version%

for /f "tokens=1 delims=." %%a in ("%version%") do (
  set num=%%a
)
::echo %num%

if %num% geq 35 (

	fastboot flash bootloader bootloader.img
	if exist gpt.bin (
	fastboot reboot-bootloader
	ping -n 5 127.0.0.1 >nul
	fastboot flash gpt gpt.bin
	)
	if exist dt.img (
	fastboot flash dts dt.img
	)
	fastboot reboot-bootloader
	ping -n 5 127.0.0.1 >nul
	fastboot flash dtbo dtbo.img
	fastboot flash vbmeta vbmeta.img
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
	if exist system_dlkm.img (
	fastboot flash system_dlkm system_dlkm.img
	)
	if exist odm_dlkm.img (
	fastboot flash odm_dlkm odm_dlkm.img
	)
	fastboot flash vendor vendor.img
	fastboot flash product product.img
	fastboot reboot-bootloader
	ping -n 5 127.0.0.1 >nul
	fastboot flash bootloader-boot0 bootloader.img
	fastboot flash bootloader-boot1 bootloader.img
	fastboot reboot
) else (
	echo fastboot tool version is lower and needs to be updated
	echo Download URL : https://developer.android.com/tools/releases/platform-tools?hl=zh-cn
)

echo Press any key to exit...
pause >nul
exit
