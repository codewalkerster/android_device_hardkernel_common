#
# Copyright (C) 2015 The Android Open Source Project
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
#

#======================================================================================
# 1.for tcon_alg ko file copy
#======================================================================================

ifeq ($(strip $(TCON_FW_MODULE)),true)
    ifeq ($(TARGET_BUILD_KERNEL_VERSION),4.9)

    else ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.4)
        ifeq ($(KERNEL_A32_SUPPORT),true)
            PRODUCT_COPY_FILES += \
                device/amlogic/common/tcon/A32_5_4/tcon_fw.ko:$(PRODUCT_OUT)/obj/lib_vendor/tcon_fw.ko \
                device/amlogic/common/initscripts/tcon.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/tcon.rc
        else
            PRODUCT_COPY_FILES += \
                device/amlogic/common/tcon/A64_5_4/tcon_fw.ko:$(PRODUCT_OUT)/obj/lib_vendor/tcon_fw.ko \
                device/amlogic/common/initscripts/tcon.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/tcon.rc
        endif
    else
        ifeq ($(KERNEL_A32_SUPPORT),true)

        else
            ifeq ($(filter $(LAUNCH_VERSION),S R Q P),$(LAUNCH_VERSION))
                PRODUCT_COPY_FILES += \
                    device/amlogic/common/tcon/A64_5_15_upgrade/tcon_fw.ko:$(PRODUCT_OUT)/obj/lib_vendor/tcon_fw.ko \
                    device/amlogic/common/initscripts/tcon.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/tcon.rc
            else
                PRODUCT_COPY_FILES += \
                    device/amlogic/common/tcon/A64_5_15/tcon_fw.ko:$(PRODUCT_OUT)/obj/lib_vendor/tcon_fw.ko \
                    device/amlogic/common/initscripts/tcon.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/tcon.rc
            endif
        endif
    endif
endif
