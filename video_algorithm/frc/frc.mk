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
# 1.for frc_alg ko file copy
#======================================================================================
$(warning frc.mk)
$(warning TARGET_BUILD_KERNEL_VERSION=$(TARGET_BUILD_KERNEL_VERSION))
$(warning TARGET_PRODUCT=$(TARGET_PRODUCT))
$(warning PLATFORM_SUPPORT_MEMC_CHIP=$(PLATFORM_SUPPORT_MEMC_CHIP))
ifeq ($(strip $(FRC_FW_MODULE)),true)
    $(warning FRC_FW_MODULE is $(FRC_FW_MODULE))
    ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.4)
        ifneq ($(KERNEL_A32_SUPPORT),true)
            PRODUCT_COPY_FILES += \
                device/amlogic/common/video_algorithm/frc/64_5_4/frc_fw.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                device/amlogic/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
        endif
    else
		ifeq ($(TARGET_BUILD_KERNEL_USING_14_5.15),true)
			ifneq ($(KERNEL_A32_SUPPORT),true)
				ifeq ($(TARGET_PRODUCT), T5M)
					$(warning copy frc_fw_t5m.ko)
					PRODUCT_COPY_FILES += \
						device/amlogic/common/video_algorithm/frc/14_5.15/64/frc_fw_t5m.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
						device/amlogic/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
				endif
			endif
		else
			ifneq ($(KERNEL_A32_SUPPORT),true)
				ifeq ($(TARGET_PRODUCT), T5M)
					$(warning copy frc_fw_t5m.ko)
					PRODUCT_COPY_FILES += \
						device/amlogic/common/video_algorithm/frc/14_5.15/64/frc_fw_t5m.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
						device/amlogic/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
				endif
			endif
		endif
    endif
endif
