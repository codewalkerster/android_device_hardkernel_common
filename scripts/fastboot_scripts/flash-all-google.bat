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
ping -n 5 127.0.0.1 >nul
fastboot flashing unlock
fastboot -w
fastboot flash bootloader bootloader.img
fastboot reboot-bootloader

ping -n 5 127.0.0.1 >nul
fastboot flashing unlock

fastboot flash logo logo.img
fastboot flash odm_ext odm_ext.img
fastboot flash oem oem.img

fastboot --skip-reboot update ***.zip

fastboot reboot-bootloader
ping -n 5 127.0.0.1 >nul

fastboot flashing lock
fastboot reboot

echo Press any key to exit...
pause >nul
exit
