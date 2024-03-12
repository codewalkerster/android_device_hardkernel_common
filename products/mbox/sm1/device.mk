#
# Copyright (C) 2013 The Android Open-Source Project
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

CHIP_DIR := device/amlogic/common/products/mbox/sm1

PRODUCT_COPY_FILES += \
    device/amlogic/common/products/mbox/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl

#use tv remote layout for mbox if livetv is built
ifeq ($(TARGET_BUILD_LIVETV), true)
    PRODUCT_COPY_FILES += \
       device/amlogic/common/products/mbox/Vendor_0001_Product_0002.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl
else
    PRODUCT_COPY_FILES += \
       device/amlogic/common/products/mbox/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl
endif


#########################################################################
#
# Init config
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/amlogic/common/products/mbox/init.amlogic.system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.rc

ifneq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    device/amlogic/common/recovery/init.recovery.amlogic.rc:recovery/root/init.recovery.amlogic.rc
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/recovery/init.recovery.amlogic_ab.rc:recovery/root/init.recovery.amlogic.rc
endif

#########################################################################
#
# Media codec
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/amlogic/common/products/mbox/sm1/files/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    device/amlogic/common/products/mbox/sm1/files/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml


#########################################################################
#
# PQ
#
#########################################################################
ifneq ($(BOARD_USES_ODM_EXTIMAGE),true)
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/PQ/pq.db:$(TARGET_COPY_OUT_ODM)/etc/tvconfig/pq/pq.db \
    $(CHIP_DIR)/files/PQ/pq_default.ini:$(TARGET_COPY_OUT_ODM)/etc/tvconfig/pq/pq_default.ini \
    $(call find-copy-subdir-files,*,$(CHIP_DIR)/files/tv/tvconfig/,/$(TARGET_COPY_OUT_ODM)/etc/tvconfig)
else
TVCONFIG_FILES := \
    $(CHIP_DIR)/files/tv/tvconfig/*
PQ_FILES := \
    $(CHIP_DIR)/files/PQ/pq.db \
    $(CHIP_DIR)/files/PQ/pq_default.ini
endif

#########################################################################
#
# Workaround bluetooth schedtune (b/170507876)
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/amlogic/common/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json \
    device/amlogic/common/cgroups.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json

