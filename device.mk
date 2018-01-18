#
# Copyright 2014 Rockchip Limited
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

# Prebuild apps
ifneq ($(strip $(TARGET_PRODUCT)), )
    TARGET_DEVICE_DIR=$(shell test -d device && find device -maxdepth 4 -path '*/$(TARGET_PRODUCT)/BoardConfig.mk')
    TARGET_DEVICE_DIR := $(patsubst %/,%,$(dir $(TARGET_DEVICE_DIR)))
#    $(info device-rockchip-common TARGET_DEVICE_DIR: $(TARGET_DEVICE_DIR))
    $(shell python $(LOCAL_PATH)/auto_generator.py $(TARGET_DEVICE_DIR) preinstall bundled_persist-app)
    $(shell python $(LOCAL_PATH)/auto_generator.py $(TARGET_DEVICE_DIR) preinstall_del bundled_uninstall_back-app)
    $(shell python $(LOCAL_PATH)/auto_generator.py $(TARGET_DEVICE_DIR) preinstall_del_forever bundled_uninstall_gone-app)
    -include $(TARGET_DEVICE_DIR)/preinstall/preinstall.mk
    -include $(TARGET_DEVICE_DIR)/preinstall_del/preinstall.mk
    -include $(TARGET_DEVICE_DIR)/preinstall_del_forever/preinstall.mk
endif

#add for Nougat Bring Up
#$(call inherit-product, device/hardkernel/common/copy.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)


#SDK Version
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rksdk.version=RK30_ANDROID$(PLATFORM_VERSION)-SDK-v1.00.00

# Filesystem management tools
PRODUCT_PACKAGES += \
    fsck.f2fs \
    mkfs.f2fs \
    fsck_f2fs

# PCBA tools
PRODUCT_PACKAGES += \
    pcba_core

PRODUCT_COPY_FILES += \
	device/hardkernel/common/init.rockchip.rc:root/init.rockchip.rc \
    $(call add-to-product-copy-files-if-exists,device/hardkernel/common/init.$(TARGET_BOARD_HARDWARE).bootmode.emmc.rc:root/init.$(TARGET_BOARD_HARDWARE).bootmode.emmc.rc) \
    $(call add-to-product-copy-files-if-exists,device/hardkernel/common/init.$(TARGET_BOARD_HARDWARE).bootmode.unknown.rc:root/init.$(TARGET_BOARD_HARDWARE).bootmode.unknown.rc) \
    $(call add-to-product-copy-files-if-exists,device/hardkernel/common/init.$(TARGET_BOARD_HARDWARE).bootmode.nvme.rc:root/init.$(TARGET_BOARD_HARDWARE).bootmode.nvme.rc) \
    device/hardkernel/common/media_profiles_default.xml:system/etc/media_profiles_default.xml \
    device/hardkernel/common/rk29-keypad.kl:system/usr/keylayout/rk29-keypad.kl \
	device/hardkernel/common/alarm_filter.xml:system/etc/alarm_filter.xml

PRODUCT_PACKAGES += \
    libiconv \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \
    dhcpcd.conf

PRODUCT_PACKAGES += \
    libpppoe-jni \
    pppoe-service \
    librp-pppoe

PRODUCT_SYSTEM_SERVER_JARS += \
    pppoe-service

ifeq ($(filter MediaTek_mt7601 MediaTek RealTek Espressif, $(strip $(BOARD_CONNECTIVITY_VENDOR))), )
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.connectivity.rc:root/init.connectivity.rc
endif

ifeq ($(findstring car,$(PRODUCT_BUILD_MODULE)),car)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio_policy_$(PRODUCT_BUILD_MODULE).conf:system/etc/audio_policy.conf
else
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio_policy_$(TARGET_BOARD_HARDWARE).conf:system/etc/audio_policy.conf
endif

# For audio-recoard 
PRODUCT_PACKAGES += \
    libsrec_jni

# For tts test
PRODUCT_PACKAGES += \
    libwebrtc_audio_coding

#camera
$(call inherit-product-if-exists, hardware/rockchip/camera/Config/rk32xx_camera.mk)
$(call inherit-product-if-exists, hardware/rockchip/camera/Config/user.mk)

#audio
$(call inherit-product-if-exists, hardware/rockchip/audio/tinyalsa_hal/codec_config/rk_audio.mk)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml

# opengl aep feature
ifeq ($(BOARD_OPENGL_AEP),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml
endif

# CAMERA
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml

# USB HOST
ifeq ($(BOARD_USB_HOST_SUPPORT),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml
endif

# USB ACCESSORY
ifeq ($(BOARD_USB_ACCESSORY_SUPPORT),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    NoiseField \
    PhaseBeam \
    librs_jni \
    libjni_pinyinime

# HAL
PRODUCT_PACKAGES += \
    power.$(TARGET_BOARD_PLATFORM) 

PRODUCT_PACKAGES += \
    sensors.$(TARGET_BOARD_HARDWARE) \
    gralloc.$(TARGET_BOARD_HARDWARE) \
    hwcomposer.$(TARGET_BOARD_HARDWARE) \
    camera.$(TARGET_BOARD_HARDWARE) \
    Camera \
    libvpu \
    libstagefrighthw \
    libgralloc_priv_omx \
    akmd 

# iep
ifneq ($(filter rk3188 rk3190 rk3026 rk3288 rk312x rk3368 rk3328 rk3366 rk3399, $(strip $(TARGET_BOARD_PLATFORM))), )
BUILD_IEP := true
PRODUCT_PACKAGES += \
    libiep
else
BUILD_IEP := false
endif

# charge
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Allows healthd to boot directly from charger mode rather than initiating a reboot.
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.enable_boot_charger_mode=0

# Add board.platform default property to parsing related rc
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.board.platform=$(strip $(TARGET_BOARD_PLATFORM))

PRODUCT_CHARACTERISTICS := tablet

# audio lib
PRODUCT_PACKAGES += \
    audio_policy.$(TARGET_BOARD_HARDWARE) \
    audio.primary.$(TARGET_BOARD_HARDWARE) \
    audio.alsa_usb.$(TARGET_BOARD_HARDWARE) \
	audio.a2dp.default\
    audio.r_submix.default\
    libaudioroute\
    audio.usb.default

# Filesystem management tools
# EXT3/4 support
PRODUCT_PACKAGES += \
    mke2fs \
    e2fsck \
    tune2fs \
    resize2fs

# audio lib
PRODUCT_PACKAGES += \
    libasound \
    alsa.default \
    acoustics.default \
    libtinyalsa \
    tinymix \
    tinyplay \
    tinypcminfo

PRODUCT_PACKAGES += \
	alsa.audio.primary.$(TARGET_BOARD_HARDWARE)\
	alsa.audio_policy.$(TARGET_BOARD_HARDWARE)

$(call inherit-product-if-exists, external/alsa-lib/copy.mk)
$(call inherit-product-if-exists, external/alsa-utils/copy.mk)


PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.strictmode.visual=false 

PRODUCT_TAGS += dalvik.gc.type-precise

########################################################
# build with drmservice
########################################################
ifeq ($(strip $(BUILD_WITH_DRMSERVICE)),true)
PRODUCT_PACKAGES += drmservice
endif

########################################################
# build without barrery
########################################################
ifeq ($(strip $(BUILD_WITHOUT_BATTERY)), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.factory.without_battery=true
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.factory.without_battery=false
endif
 
# NTFS support
PRODUCT_PACKAGES += \
    ntfs-3g

# exfat support
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat \
    mount.exfat

PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

$(call inherit-product-if-exists, external/wlan_loader/wifi-firmware.mk)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.rk.screenoff_time=2147483647

# setup dm-verity configs.
# uncomment the two lines if use verity
#PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/platform/ff0f0000.rksdmmc/by-name/system
#$(call inherit-product, build/target/product/verity.mk)
$(call inherit-product-if-exists, vendor/widevine/widevine.mk)

#ro.product.first_api_level indicates the first api level, device has been commercially launced on.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=23

$(call inherit-product-if-exists, vendor/rockchip/common/device-vendor.mk)

########################################################
# this product has support remotecontrol or not
########################################################
ifeq ($(strip $(BOARD_HAS_REMOTECONTROL)),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.enable.remotecontrol=true
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.enable.remotecontrol=false
endif

ifeq ($(strip $(BUILD_WITH_SKIPVERIFY)),true)
PRODUCT_PROPERTY_OVERRIDES +=               \
    ro.config.enable.skipverify=true
endif

ifneq ($(filter rk%, $(TARGET_BOARD_PLATFORM)), )
PRODUCT_COPY_FILES += \
        device/hardkernel/common/performance_info.xml:system/etc/performance_info.xml
endif

# hdmi cec
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml
PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4
PRODUCT_PACKAGES += \
	hdmi_cec.$(TARGET_BOARD_HARDWARE)

PRODUCT_PACKAGES += \
	abc
# boot optimization
PRODUCT_COPY_FILES += \
        device/hardkernel/common/boot_boost/libboot_optimization.so:system/lib/libboot_optimization.so

# mem optimization
ifeq ($(strip $(BOARD_WITH_MEM_OPTIMISE)),true)
PRODUCT_COPY_FILES += \
	device/hardkernel/common/lowmem_package_filter.xml:system/etc/lowmem_package_filter.xml 
PRODUCT_PROPERTY_OVERRIDES += \
	ro.mem_optimise.enable=true
endif


# lowmem mode
ifeq ($(strip $(BOARD_USE_LOW_MEM)),true)
PRODUCT_COPY_FILES += \
	device/hardkernel/common/lowmem_package_filter.xml:system/etc/lowmem_package_filter.xml
PRODUCT_PROPERTY_OVERRIDES += \
	ro.config.low_ram=true
endif

# neon transform library by djw
PRODUCT_COPY_FILES += \
	device/hardkernel/common/neon_transform/lib/librockchipxxx.so:system/lib/librockchipxxx.so \
	device/hardkernel/common/neon_transform/lib64/librockchipxxx.so:system/lib64/librockchipxxx.so

#if disable safe mode to speed up booting time
ifeq ($(strip $(BOARD_DISABLE_SAFE_MODE)),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.safemode.disabled=true
endif

ifeq ($(strip $(BOARD_ENABLE_3G_DONGLE)),true)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.enable.3g.dongle=true \
    rild.libpath=/system/lib64/libril-rk29-dataonly.so
endif

#boot and shutdown animation, ringing
ifeq ($(strip $(BOOT_SHUTDOWN_ANIMATION_RINGING)),true)
include device/hardkernel/common/bootshutdown/bootshutdown.mk
endif

#for enable optee support
ifeq ($(strip $(PRODUCT_HAVE_OPTEE)),true)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.enable.optee=true		
endif

ifeq ($(strip $(BOARD_ENABLE_PMS_MULTI_THREAD_SCAN)), true)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.pms.multithreadscan=true		
endif

#add for hwui property
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hwui.texture_cache_size=72 \
    ro.hwui.layer_cache_size=48 \
    ro.hwui.r_buffer_cache_size=8 \
    ro.hwui.path_cache_size=32 \
    ro.hwui.gradient_cache_size=1 \
    ro.hwui.drop_shadow_cache_size=6 \
    ro.hwui.texture_cache_flushrate=0.4 \
    ro.hwui.text_small_cache_width=1024 \
    ro.hwui.text_small_cache_height=1024 \
    ro.hwui.text_large_cache_width=2048 \
    ro.hwui.text_large_cache_height=1024 \
    ro.hwui.disable_scissor_opt=true \
    ro.rk.screenshot_enable=true   \
    sys.status.hidebar_enable=false   \
    persist.sys.ui.hw=true
