$(call inherit-product, device/amlogic/common/core_amlogic.mk)

ifeq ($(TARGET_BUILD_LIVETV),true)
#TV input HAL
PRODUCT_PACKAGES += \
    tv_input.amlogic \
    vendor.amlogic.hardware.tvserver@1.0_vendor \
    android.hardware.tv.input-service

# TV
PRODUCT_PACKAGES += \
    libtv \
    libtv_linker \
    libtvbinder \
    libtv_jni \
    tvserver \
    libtvplay \
    libvendorfont \
    libTVaudio \
    libntsc_decode \
    libzvbi \
    droidlogic-tv \
    droidlogic.tv.software.core.xml \
    TvProvider \
    DroidLogicTvInput \
    libjnidtvepgscanner \
    DroidLogicFactoryMenu \
    libjnidtvsubtitle
# CTC subtitle
PRODUCT_PACKAGES += \
    libsubtitlebinder

# DTV
PRODUCT_PACKAGES += \
    libam_adp \
    libam_mw \
    libam_ver \
    libam_sysfs \
    libdmxresconf

#IRDETO need
ifeq ($(TARGET_BUILD_IRDETO), true)
PRODUCT_PACKAGES += \
    libam_adp_adec_vendor
endif

# LiveTv
PRODUCT_PACKAGES += \
    DroidLiveTvSettings \
    DroidLogicLiveTv

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.build.livetv=true

endif  #endof TARGET_BUILD_LIVETV

# DTVKit
ifeq ($(PRODUCT_SUPPORT_DTVKIT), true)
PRODUCT_PACKAGES += \
    inputsource \
    libdtvkit_jni \
    droidlogic-dtvkit \
    droidlogic.dtvkit.software.core.xml \

ifeq ($(PRODUCT_SUPPORT_TUNER_FRAMEWORK),true)
PRODUCT_PACKAGES += \
    libdtvkitserver \
    libdtvkit_tuner_jni
else
PRODUCT_PACKAGES += \
    dtvkitserver \
    isdb_server \
    dvb_server \
    dtvkitserver_releaseinfo.txt
endif

SUPPORT_CAS = true
endif

ifeq ($(SUPPORT_CAS), true)
PRODUCT_PACKAGES += \
    cas_hal_test \
    libdmx_client \
    b472711b-3ada-4c37-8c2a-7c64d8af0223
endif

#HbbTV
ifeq ($(PRODUCT_SUPPORT_HBBTV), true)
PRODUCT_PACKAGES += \
    amlogic-vewd-service \
    tias
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.hbbtv.enable = false \
    vendor.tv.dtv.hbbtv.keyremap = true
endif

PRODUCT_PACKAGES += \
    remotecfg

ifeq ($(CONFIG_DEVICE_LOW_RAM_OTT_1G),true)
# DvbAudioService
#PRODUCT_PACKAGES += \
    DvbAudioService \
    com.droidlogic.dvbaudioservice.permissions.xml

# Include drawables for all densities
PRODUCT_AAPT_CONFIG := mdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi

#screencontrol
#PRODUCT_PACKAGES += \
    screencontrol \
    libscreencontrolservice \
    videomediaconvertortest \
    tspacktest \
    screencatch
else

#screencontrol
PRODUCT_PACKAGES += \
    screencontrol \
    libscreencontrolservice \
    libscreencontrolclient \
    libscreencontrol_jni \
    videomediaconvertortest \
    tspacktest \
    screencatch
endif

#TvSettings
ifeq ($(ATV_LAUNCHER),amati)
PRODUCT_PACKAGES += \
    TvSettingsTwoPanel \
    DroidTvSettingsTwoPanel \
    DroidGTVTvSettingsResOverlay
else
PRODUCT_PACKAGES += \
    TvSettings \
    DroidTvSettings \
    DroidATVTvSettingsResOverlay
endif

ifeq ($(SUPPORT_TUNERHAL), true)
$(call inherit-product, hardware/amlogic/tuner/1.1/droidlogic_tuner_hal.mk)
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

#GPS donnot need in aosp
ifeq ($(BOARD_COMPILE_ATV), false)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/aosp_excluded_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/aosp_excluded_hardware.xml
endif

ifeq ($(TARGET_BUILD_LIVETV),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.live_tv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.live_tv.xml
endif

#copy lowmemorykiller.txt
ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),true)
PRODUCT_COPY_FILES += \
	device/amlogic/common/config/lowmemorykiller_2G.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_2G.txt \
	device/amlogic/common/config/lowmemorykiller.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller.txt \
	device/amlogic/common/config/lowmemorykiller_512M.txt:$(TARGET_COPY_OUT_VENDOR)/etc/lowmemorykiller_512M.txt
endif

#DDR LOG
PRODUCT_COPY_FILES += \
    device/amlogic/common/scripts/ddrtest.sh:$(TARGET_COPY_OUT_VENDOR)/bin/ddrtest.sh

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip

#bootvideo
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootvideo.zip:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo.zip \
    $(LOCAL_PATH)/mbox.mp4:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo

# copy fulldump
PRODUCT_COPY_FILES += \
    device/amlogic/common/fulldump.sh:$(TARGET_COPY_OUT_VENDOR)/bin/fulldump.sh

# Save memory
# dumpsys SurfaceFlinger | grep com.android.systemui.ImageWallpaper
# 16.00 KiB |   64 (  64) x   64 |    1 |       2B | 0x40000000000b00 | com.android.systemui.ImageWallpaper#0
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/default_wallpaper.png:$(TARGET_COPY_OUT_VENDOR)/etc/default_wallpaper.png

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.wallpaper=vendor/etc/default_wallpaper.png

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
#ifeq ($(VERSION_ID),)
#export BUILD_NUMBER := $(shell date +%Y%m%d)
#else
#$(call inherit-product, $(VERSION_ID))
#endif

#MESONHWC CONFIG
ifeq ($(ATV_LAUNCHER),amati)
HWC_FILTER_16_9MODE :=true
endif

DISPLAY_BUILD_NUMBER := true

#TV project,set omx to video layer,or PQ hasn't effect
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.omx.display_mode=3

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.hdmi.keep_awake=false

# cec device types
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.cec_device_types=playback_device \
    ro.hdmi.device_type=4

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.media_vol_steps=25 \
    ro.config.media_vol_default=20


#AOSP userdebug and eng version default disable AVB
ifeq ($(BOARD_COMPILE_ATV), false)
    ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
        BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 1
    endif
endif

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

ifeq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), true)
PRODUCT_COPY_FILES += \
    device/amlogic/common/products/mbox/hdcp_tx22_oem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hdcp_tx22.rc
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/products/mbox/hdcp_tx22.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hdcp_tx22.rc
endif

#copy all the audio policy xml file
PRODUCT_COPY_FILES += \
    device/amlogic/common/audio/mbox/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_default.xml \
    device/amlogic/common/audio/mbox/audio_policy_configuration_ms12.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12.xml \
    device/amlogic/common/audio/mbox/audio_policy_configuration_ms12_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12_v1.xml \
    device/amlogic/common/audio/mbox/audio_policy_configuration_ms12_v1_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12_v1_dtshd.xml \
    device/amlogic/common/audio/mbox/audio_policy_configuration_ms12_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12_dtshd.xml \
    device/amlogic/common/audio/mbox/audio_policy_configuration_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_dtshd.xml \
    device/amlogic/common/audio/mbox/audio_policy_configuration_ddp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ddp.xml \
    device/amlogic/common/audio/mbox/audio_policy_configuration_ddp_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ddp_dtshd.xml

ifeq ($(PRODUCT_SUPPORT_TUNER_FRAMEWORK),true)
#DEBUG FOR TUNER SDK JNI
# jasplayer
#add jasplayer library
PRODUCT_PACKAGES += \
    droidlogic.jasplayer \
    droidlogic.jasplayer.xml \
    droidlogic.jniasplayer \
    libjniasplayer-jni \
    droidlogic.jniasplayer.xml

# JDvrLib core packages
PRODUCT_PACKAGES += \
    JDvrLib \
    libjdvrlib-jni

# JDvrLib test app related packages
PRODUCT_PACKAGES += \
    JDvrLibTest \
    libjdvrlib-ref-native-client
endif


###########################AtvAxel########################################
PRODUCT_PACKAGES += \
     AtvAxel
