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

ifeq ($(strip $(ALGORITHM_MODULE)),true)
    $(warning ALGORITHM_MODULE is $(ALGORITHM_MODULE))
	ifeq ($(TARGET_BUILD_KERNEL_USING_14_5.15),true)
		ifeq ($(KERNEL_A32_SUPPORT),true)
			PRODUCT_COPY_FILES += \
				device/amlogic/common/video_algorithm/algorithm/14_5.15/32/amlogic-algorithm_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic-algorithm.ko \
				device/amlogic/common/initscripts/amlogic-algorithm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-algorithm.rc
		else
			PRODUCT_COPY_FILES += \
				device/amlogic/common/video_algorithm/algorithm/14_5.15/64/amlogic-algorithm_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic-algorithm.ko \
				device/amlogic/common/initscripts/amlogic-algorithm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-algorithm.rc
		endif
	else
		ifeq ($(KERNEL_A32_SUPPORT),true)
			PRODUCT_COPY_FILES += \
				device/amlogic/common/video_algorithm/algorithm/13_5.15/32/amlogic-algorithm_32.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic-algorithm.ko \
				device/amlogic/common/initscripts/amlogic-algorithm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-algorithm.rc
		else
			PRODUCT_COPY_FILES += \
				device/amlogic/common/video_algorithm/algorithm/13_5.15/64/amlogic-algorithm_64.ko:$(PRODUCT_OUT)/obj/lib_vendor/amlogic-algorithm.ko \
				device/amlogic/common/initscripts/amlogic-algorithm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/amlogic-algorithm.rc
		endif
	endif
endif
