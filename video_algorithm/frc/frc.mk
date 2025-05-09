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
ifeq ($(strip $(FRC_FW_MODULE)),true)
    ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.4)
        ifneq ($(KERNEL_A32_SUPPORT),true)
            PRODUCT_COPY_FILES += \
                device/hardkernel/common/video_algorithm/frc/64_5_4/frc_fw.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
        endif
    else
        ifneq ($(filter P Q R S,$(LAUNCH_VERSION)),)
            ifneq ($(KERNEL_A32_SUPPORT),true)
                ifneq ($(filter calla_gtv calla calla_wv4_gtv calla_wv4, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15_upgrade/64/frc_fw_t5m.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                else ifneq ($(filter smith t982_ar301 t982_ar301_arm64 t982_ar301_arm64_gms, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15_upgrade/64/frc_fw_t3.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                else ifneq ($(filter anemone anemone_multidisplay anemone_gtv, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15_upgrade/64/frc_fw_t3x.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                endif
	    else
                ifneq ($(filter calla_gtv calla_wv4_gtv calla calla_wv4, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15_upgrade/32/frc_fw_t5m.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                endif
            endif
        else
            ifneq ($(KERNEL_A32_SUPPORT),true)
                ifneq ($(filter calla_gtv calla calla_wv4_gtv calla_wv4, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15/64/frc_fw_t5m.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                else ifneq ($(filter smith t982_ar301 t982_ar301_arm64 t982_ar301_arm64_gms, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15/64/frc_fw_t3.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                else ifneq ($(filter anemone anemone_multidisplay anemone_gtv, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15/64/frc_fw_t3x.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                endif
            else
                ifneq ($(filter calla_gtv calla_wv4_gtv calla calla_wv4, $(TARGET_PRODUCT)),)
                    PRODUCT_COPY_FILES += \
                        device/hardkernel/common/video_algorithm/frc/14_5.15/32/frc_fw_t5m.ko:$(PRODUCT_OUT)/obj/lib_vendor/frc_fw.ko \
                        device/hardkernel/common/initscripts/frc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/frc.rc
                endif
            endif
        endif
    endif
endif
