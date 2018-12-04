#
# Copyright (C) 2012 The Android Open Source Project
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

WIFI_DRIVER             := rtl8812au
BOARD_WIFI_VENDOR       := realtek
WIFI_DRIVER_MODULE_PATH := /vendor/lib/modules/8812au.ko
WIFI_DRIVER_MODULE_NAME := 8812au
WIFI_DRIVER_MODULE_ARG  := "ifname=wlan0"

WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_rtl

BOARD_WLAN_DEVICE := rtl8812au
LIB_WIFI_HAL := libwifi-hal-rtl

WIFI_FIRMWARE_LOADER      := ""
WIFI_DRIVER_FW_PATH_PARAM := ""

PRODUCT_COPY_FILES += hardware/amlogic/wifi/realtek/config/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf

PRODUCT_COPY_FILES += device/hardkernel/$(TARGET_PRODUCT)/init.$(TARGET_PRODUCT).wifi_rtk.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.odroid.wifi.rc

PRODUCT_PACKAGES += \
	wpa_supplicant_overlay.conf \

# 89976: Add Realtek USB WiFi support
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

PRODUCT_COPY_FILES += \
	device/hardkernel/common/wifi/rt2870.bin:root/lib/firmware/rt2870.bin \
	device/hardkernel/common/wifi/rtl8192cufw_TMSC.bin:root/lib/firmware/rtlwifi/rtl8192cufw_TMSC.bin \
	device/hardkernel/common/wifi/wifi_id_list.txt:vendor/etc/wifi_id_list.txt \
	device/hardkernel/common/wifi/8192cu:vendor/etc/modprobe.d/8192cu \
	device/hardkernel/common/wifi/8812au:vendor/etc/modprobe.d/8812au \
	device/hardkernel/common/wifi/rt2800usb:vendor/etc/modprobe.d/rt2800usb
