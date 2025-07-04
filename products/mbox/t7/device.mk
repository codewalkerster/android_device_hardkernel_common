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

CHIP_DIR := device/hardkernel/common/products/mbox/t7

PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/Vendor_1b8e_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1b8e_Product_0001.kl \
    device/hardkernel/common/products/mbox/Vendor_1915_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_1915_Product_0001.kl


#########################################################################
#
# Init config
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/init.amlogic.system.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.rc

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


########################################################################
# the wifi chip doesn't support mdns offload wake up
# ########################################################################
TARGET_BUILD_MDNS := false


# tv config file
ifeq ($(TARGET_BUILD_TYPE_SOUNDBAR), true)
TVCONFIG_FILES := \
    $(CHIP_DIR)/files/tv/tvconfig_soundbar/*
else
TVCONFIG_FILES := \
    $(CHIP_DIR)/files/tv/tvconfig/*
endif


PQ_FILES := \
    $(CHIP_DIR)/files/PQ/pq.db \
    $(CHIP_DIR)/files/PQ/overscan.db \
    $(CHIP_DIR)/files/PQ/pq_default.ini

#thermal 2.0 config file
ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.15)
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/thermal_info_config_5_15.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json
else
PRODUCT_COPY_FILES += \
    $(CHIP_DIR)/files/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json
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

#########################################################################
#
# Soundbar
#
#########################################################################
ifeq ($(TARGET_BUILD_TYPE_SOUNDBAR),true)
PRODUCT_COPY_FILES += \
    device/hardkernel/common/audio/sadConfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sadConfig.xml
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.media.support_earc=true
$(warning 'This platform supports EARC and uses soundbar audio config and tv config!')
endif
