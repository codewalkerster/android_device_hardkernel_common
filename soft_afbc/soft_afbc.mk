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
# 1.for amlogic-algorithm ko file copy
#======================================================================================

ifeq ($(strip $(SOFT_AFBC_MODULE)),true)
    ifeq ($(TARGET_BUILD_KERNEL_USING_14_5.15),true)
        ifeq ($(KERNEL_A32_SUPPORT),true)
            ifneq ($(filter P Q R S,$(LAUNCH_VERSION)),)
                PRODUCT_COPY_FILES += \
                    device/hardkernel/common/soft_afbc/14_5.15/32_upgrade/amlogic_fbc_lib_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic_fbc_lib.ko
            else
	    	PRODUCT_COPY_FILES += \
                	device/hardkernel/common/soft_afbc/14_5.15/32/amlogic_fbc_lib_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic_fbc_lib.ko 
	    endif
	    PRODUCT_COPY_FILES += \
                device/hardkernel/common/initscripts/amlogic-fbc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-fbc.rc
        else
            ifneq ($(filter P Q R S,$(LAUNCH_VERSION)),)
                PRODUCT_COPY_FILES += \
                    device/hardkernel/common/soft_afbc/14_5.15/64_upgrade/amlogic_fbc_lib_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic_fbc_lib.ko
            else
                PRODUCT_COPY_FILES += \
                    device/hardkernel/common/soft_afbc/14_5.15/64/amlogic_fbc_lib_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic_fbc_lib.ko
            endif
            PRODUCT_COPY_FILES += \
                device/hardkernel/common/initscripts/amlogic-fbc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-fbc.rc
        endif
    else
        ifeq ($(KERNEL_A32_SUPPORT),true)
            PRODUCT_COPY_FILES += \
                device/hardkernel/common/soft_afbc/13_5.15/32/amlogic_fbc_lib.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic_fbc_lib.ko \
                device/hardkernel/common/initscripts/amlogic-fbc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-fbc.rc
        else
            PRODUCT_COPY_FILES += \
                device/hardkernel/common/soft_afbc/13_5.15/64/amlogic_fbc_lib.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic_fbc_lib.ko \
                device/hardkernel/common/initscripts/amlogic-fbc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-fbc.rc
        endif
    endif
endif
