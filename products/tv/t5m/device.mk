
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

CHIP_DIR := device/hardkernel/common/products/tv/t5m

#########################################################################
#
# Remote config
#
#########################################################################
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/remote.conf:$(TARGET_COPY_OUT_VENDOR)/etc/remote.conf \
    $(CHIP_DIR)/files/remote.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/remote.cfg \
    $(CHIP_DIR)/files/remote.tab:$(TARGET_COPY_OUT_VENDOR)/etc/remote.tab \

PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/tv/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl \
    device/hardkernel/common/products/tv/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl

# recovery
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/recovery/recovery.kl:recovery/root/sbin/recovery.kl \
    $(CHIP_DIR)/recovery/remotecfg:recovery/root/sbin/remotecfg \
    $(CHIP_DIR)/files/remote.cfg:recovery/root/sbin/remote.cfg \
    $(CHIP_DIR)/files/remote.tab:recovery/root/sbin/remote.tab

#########################################################################
#
# Init config
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/tv/init.amlogic.system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.rc

ifneq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    device/hardkernel/common/recovery/init.recovery.amlogic.rc:recovery/root/init.recovery.amlogic.rc
else
PRODUCT_COPY_FILES += \
    device/hardkernel/common/recovery/init.recovery.amlogic_ab.rc:recovery/root/init.recovery.amlogic.rc
endif

#########################################################################
#
# Media codec
#
#########################################################################
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    $(CHIP_DIR)/files/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml


#HDCP 1.4 file
#PRODUCT_COPY_FILES += \
#    $(CHIP_DIR)/files/tv/dec:$(TARGET_COPY_OUT_ODM)/bin/dec

#dv config file
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/tv/tvconfig/panel/Amlogic_dv.cfg:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/amdv/Amlogic_dv.cfg \
    $(CHIP_DIR)/files/tv/tvconfig/panel/dv_config.bin:$(TARGET_COPY_OUT_VENDOR)/lib/firmware/amdv/dv_config.bin

# tv config file
TVCONFIG_FILES := \
    $(CHIP_DIR)/files/tv/tvconfig/*
PQ_FILES := \
    $(CHIP_DIR)/files/PQ/overscan.db \
    $(CHIP_DIR)/files/PQ/pq_default.ini

ifneq ($(PRODUCT_SUPPORT_COMPRESS_DB),true)
PQ_FILES += $(CHIP_DIR)/files/PQ/pq.db
else
PQ_FILES += $(CHIP_DIR)/files/PQ/pq.bin
endif

#########################################################################
#
# tunerhal
#
#########################################################################
ifeq ($(SUPPORT_TUNERHAL), true)
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/tunerhal/frontendinfos.json:$(TARGET_COPY_OUT_VENDOR)/etc/tuner_hal/frontendinfos.json
endif
