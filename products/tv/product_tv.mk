$(call inherit-product, device/amlogic/common/core_amlogic.mk)

# TV
PRODUCT_PACKAGES += \
    libtv \
    libtv_linker \
    libtvbinder \
    libtv_jni \
    tvserver \
    libtvplay \
    libTVaudio \
    libntsc_decode \
    libtinyxml \
    libzvbi \
    tv_input.amlogic \
    TvProvider \
    DroidLogicTvInput \
    DroidLogicTvSource \
    libhpeq.so \
    libjnidtvsubtitle \
    libjnidtvepgscanner

# DTV
PRODUCT_PACKAGES += \
	libam_adp \
	libam_mw \
	libam_ver \
	libam_sysfs

PRODUCT_PACKAGES += \
    imageserver \
    busybox \
    utility_busybox

# DLNA
PRODUCT_PACKAGES += \
    DLNA

PRODUCT_PACKAGES += \
    remotecfg

# HDMITX CEC HAL
PRODUCT_PACKAGES += \
    hdmi_cec.amlogic

USE_CUSTOM_AUDIO_POLICY := 1

# NativeImagePlayer
PRODUCT_PACKAGES += \
    NativeImagePlayer

#RemoteControl Service
PRODUCT_PACKAGES += \
    RC_Service

# Camera Hal
PRODUCT_PACKAGES += \
    camera.amlogic

#MboxLauncher
PRODUCT_PACKAGES += \
    MboxLauncher

#Tvsettings
PRODUCT_PACKAGES += \
    TvSettings

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.live_tv.xml:system/etc/permissions/android.software.live_tv.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:system/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml

#copy lowmemorykiller.txt
ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),true)
PRODUCT_COPY_FILES += \
	device/amlogic/common/config/lowmemorykiller_2G.txt:system/etc/lowmemorykiller_2G.txt \
	device/amlogic/common/config/lowmemorykiller.txt:system/etc/lowmemorykiller.txt \
	device/amlogic/common/config/lowmemorykiller_512M.txt:system/etc/lowmemorykiller_512M.txt
endif

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

custom_keylayouts := $(wildcard $(LOCAL_PATH)/keyboards/*.kl)
PRODUCT_COPY_FILES += $(foreach file,$(custom_keylayouts),\
    $(file):system/usr/keylayout/$(notdir $(file)))

# hdcp_rx key tools and firmware
PRODUCT_COPY_FILES += \
    device/amlogic/common/hdcp_rx22/hdcp_rx22:system/bin/hdcp_rx22 \
    device/amlogic/common/hdcp_rx22/arm_tools/aictool:system/bin/aictool \
    device/amlogic/common/hdcp_rx22/arm_tools/esm_swap:system/bin/esm_swap \
    device/amlogic/common/hdcp_rx22/arm_tools/hdcprxkeys:system/bin/hdcprxkeys \
    device/amlogic/common/hdcp_rx22/firmware/esm_config.i:system/etc/firmware/hdcp_rx22/esm_config.i \
    device/amlogic/common/hdcp_rx22/firmware/firmware.rom:system/etc/firmware/hdcp_rx22/firmware.rom \
    device/amlogic/common/hdcp_rx22/firmware/firmware.aic:system/etc/firmware/hdcp_rx22/firmware.aic

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip


PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/tv.mp4:system/etc/bootvideo

# default wallpaper for mbox to fix bug 106225
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/default_wallpaper.png:system/etc/default_wallpaper.png

ADDITIONAL_BUILD_PROPERTIES += \
    ro.config.wallpaper=/system/etc/default_wallpaper.png

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
$(call inherit-product, $(VERSION_ID))

DISPLAY_BUILD_NUMBER := true

# default timezone
PRODUCT_PROPERTY_OVERRIDES += \
        persist.sys.timezone=Asia/Shanghai
