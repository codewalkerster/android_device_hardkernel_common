#
# Copyright 2022 Rockchip Limited
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

ifeq ($(BOARD_BLUETOOTH_SUPPORT),true)
# Bluetooth HAL
# if use on chip Bluetooth
ifeq ($(strip $(BOARD_HAVE_ON_BOARD_BLUETOOTH)), true)
PRODUCT_PACKAGES += \
    libbt-vendor \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service \
    android.hardware.bluetooth@1.0-service.rc
else
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-service.btlinux
endif

PRODUCT_PACKAGES += \
    libbluetooth_audio_session \
    libbluetooth_audio_session_aidl \
    android.hardware.bluetooth.audio-impl \
    audio.bluetooth.default


# Set supported Bluetooth profiles to enabled
PRODUCT_PRODUCT_PROPERTIES += \
	bluetooth.profile.asha.central.enabled?=true \
	bluetooth.profile.a2dp.source.enabled?=true \
	bluetooth.profile.avrcp.target.enabled?=true \
	bluetooth.profile.bas.client.enabled?=true \
	bluetooth.profile.gatt.enabled?=true \
	bluetooth.profile.hfp.ag.enabled?=true \
	bluetooth.profile.hid.device.enabled?=true \
	bluetooth.profile.hid.host.enabled?=true \
	bluetooth.profile.map.server.enabled?=true \
	bluetooth.profile.opp.enabled?=true \
	bluetooth.profile.pan.nap.enabled?=true \
	bluetooth.profile.pan.panu.enabled?=true \
	bluetooth.profile.pbap.server.enabled?=true \
	bluetooth.profile.sap.server.enabled?=true

ifneq ($(filter atv box, $(strip $(TARGET_BOARD_PLATFORM_PRODUCT))), )
override PRODUCT_PRODUCT_PROPERTIES += bluetooth.core.gap.le.privacy.enabled=false
override PRODUCT_PRODUCT_PROPERTIES += bluetooth.profile.hfp.ag.enabled=false
override PRODUCT_PRODUCT_PROPERTIES += bluetooth.profile.map.server.enabled=false
override PRODUCT_PRODUCT_PROPERTIES += bluetooth.profile.pbap.server.enabled=false
endif

ifeq ($(strip $(BOARD_HAVE_BLUETOOTH)),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.bt_enable=true
else
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.bt_enable=false
endif

ifeq ($(strip $(MT6622_BT_SUPPORT)),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.btchip=mt6622
endif

ifeq ($(strip $(BLUETOOTH_USE_BPLUS)),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.btchip=broadcom.bplus
endif

ifeq ($(strip $(BOARD_HAVE_BLUETOOTH_RTK)), true)
include hardware/realtek/rtkbt/rtkbt.mk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/../bluetooth/rtl8192ee_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8192ee_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8192eu_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8192eu_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8723a_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723a_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8723b_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723b_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8723bs_config-OBDA8723.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723bs_config-OBDA8723.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8723bs_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723bs_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8723d_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723d_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8723d_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723d_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8761a_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8761a_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8761b_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8761b_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8761b_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8761b_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8761bu_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8761bu_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8761bu_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8761bu_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8812ae_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8812ae_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8821a_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8821a_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8821a_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8821a_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8821c_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8821c_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8821c_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8821c_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8821cs_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8821cs_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8821cs_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8821cs_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8822b_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8822b_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8822b_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8822b_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8822cs_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8822cs_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8822cs_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8822cs_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8822cu_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8822cu_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8822cu_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8822cu_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8851bu_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8851bu_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8851bu_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8851bu_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8852au_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8852au_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8852au_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8852au_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8852bu_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8852bu_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8852bu_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8852bu_fw.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8852cu_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8852cu_config.bin \
    $(LOCAL_PATH)/../bluetooth/rtl8852cu_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8852cu_fw.bin

endif

ifeq ($(strip $(BOARD_HAVE_BLUETOOTH_AIC)), true)
PRODUCT_PACKAGES += libbt-vendor-aic
endif

# A2DP audio policy
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration_7_0.xml

# bluetooth audio policy
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml

# bt config for ap bt
PRODUCT_COPY_FILES += \
    $(TARGET_DEVICE_DIR)/bt_vendor.conf:/vendor/etc/bluetooth/bt_vendor.conf

# Feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml
ifeq ($(BOARD_BLUETOOTH_LE_SUPPORT),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml
endif
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/../bluetooth/mt7610e.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/mediatek/mt7610e.bin \
    $(LOCAL_PATH)/../bluetooth/mt7610u.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/mediatek/mt7610u.bin
