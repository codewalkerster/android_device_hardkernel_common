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
# 1.for cuva_hdr_alg ko file copy
#======================================================================================

ifeq ($(strip $(CUVA_MODULE)),true)
    ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
        ifeq ($(KERNEL_A32_SUPPORT),true)
           PRODUCT_COPY_FILES += \
               device/hardkernel/common/video_algorithm/cuva/32_4_9/cuva_hdr_alg_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/cuva_hdr_alg.ko \
               device/hardkernel/common/initscripts/cuva.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/cuva.rc
        else
           PRODUCT_COPY_FILES += \
                device/hardkernel/common/video_algorithm/cuva/64_4_9/cuva_hdr_alg_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/cuva_hdr_alg.ko \
                device/hardkernel/common/initscripts/cuva.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/cuva.rc
        endif
    else
        ifeq ($(KERNEL_A32_SUPPORT),true)
            ifneq ($(filter P Q R S,$(LAUNCH_VERSION)),)
                PRODUCT_COPY_FILES += \
                    device/hardkernel/common/video_algorithm/cuva/32_upgrade/cuva_hdr_alg_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/cuva_hdr_alg.ko \
                    device/hardkernel/common/initscripts/cuva.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/cuva.rc
            else
	    	PRODUCT_COPY_FILES += \
                    device/hardkernel/common/video_algorithm/cuva/32/cuva_hdr_alg_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/cuva_hdr_alg.ko \
                    device/hardkernel/common/initscripts/cuva.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/cuva.rc
	    endif
        else
            ifneq ($(filter P Q R S,$(LAUNCH_VERSION)),)
                PRODUCT_COPY_FILES += \
                    device/hardkernel/common/video_algorithm/cuva/64_upgrade/cuva_hdr_alg_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/cuva_hdr_alg.ko \
                    device/hardkernel/common/initscripts/cuva.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/cuva.rc
            else
                PRODUCT_COPY_FILES += \
                    device/hardkernel/common/video_algorithm/cuva/64/cuva_hdr_alg_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/cuva_hdr_alg.ko \
                    device/hardkernel/common/initscripts/cuva.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/cuva.rc
            endif
        endif
    endif
endif
