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

PRODUCT_PACKAGES += \
    busybox \
    utility_busybox

# LiveTv
PRODUCT_PACKAGES += \
    DroidLogicLiveTv

#TvExtras
ifeq ($(ATV_LAUNCHER),amati)
    PRODUCT_PACKAGES += \
        DroidTvExtrasTwoPanel
else
    PRODUCT_PACKAGES += \
        DroidTvExtras
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.build.livetv=true

endif  #endof TARGET_BUILD_LIVETV

# DTVKit
ifeq ($(PRODUCT_SUPPORT_DTVKIT), true)
SUPPORT_CAS = true
PRODUCT_PACKAGES += \
    inputsource \
    libdtvkit_jni \
    libicuuc_vendor \
    libicui18n_vendor \
    droidlogic-dtvkit \
    droidlogic.dtvkit.software.core.xml \

ifeq ($(PRODUCT_SUPPORT_TUNER_FRAMEWORK),true)
PRODUCT_PACKAGES += \
    libdtvkitserver \
    libdvbserver \
    libisdbserver \
    libatscserver \
    dtvkitserver_releaseinfo.txt
else
PRODUCT_PACKAGES += \
    dtvkitserver \
    isdb_server \
    dvb_server \
    dtvkitserver_releaseinfo.txt \
    libicuuc_vendor \
    libicui18n_vendor \
    droidlogic-dtvkit \
    droidlogic.dtvkit.software.core.xml

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.video.show_first_frame_nosync=1

#HbbTV
ifeq ($(PRODUCT_SUPPORT_HBBTV), true)
PRODUCT_PACKAGES += \
    amlogic-vewd-service
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.hbbtv.enable = true \
    vendor.tv.dtv.hbbtv.keyremap = true
endif

#FVP
ifeq ($(PRODUCT_SUPPORT_FVP), true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.fvp.enable=true
endif

endif

PRODUCT_PACKAGES += \
    remotecfg

#screencontrol
PRODUCT_PACKAGES += \
    screencontrol \
    libscreencontrolservice \
    libscreencontrolclient \
    libscreencontrol_jni \
    videomediaconvertortest \
    tspacktest \
    screencatch \
    vadservice

#lcd/tconless tools
PRODUCT_PACKAGES += \
    tcondump \
    lcdhelper

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

ifneq ($(BOARD_COMPILE_ATV), false)
PRODUCT_PACKAGES += \
    OTAUpgrade
endif

ifeq ($(SUPPORT_TUNERHAL), true)
$(call inherit-product, hardware/amlogic/tuner/aidl/droidlogic_tuner_hal_lazy.mk)
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

MKDIR=$(shell mkdir $(TARGET_COPY_OUT_VENDOR)/usr/icu/)
$(MKDIR)
PRODUCT_COPY_FILES += \
    vendor/amlogic/common/prebuilt/icu/icudt60l.dat:$(TARGET_COPY_OUT_VENDOR)/usr/icu/icudt60l.dat

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

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip

#bootvideo
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootvideo.zip:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo.zip \
    $(LOCAL_PATH)/tv.mp4:$(TARGET_COPY_OUT_VENDOR)/etc/bootvideo \
    $(LOCAL_PATH)/tv.ts:$(TARGET_COPY_OUT_SYSTEM)/etc/bootvideo.ts

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

DISPLAY_BUILD_NUMBER := true

ifeq ($(VENDOR_MEDIA_OMX_SUPPORT),true)
#TV project,set omx to video layer,or PQ hasn't effect
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.omx.display_mode=3
endif

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

#TV project, need use 8 ch 32 bit output.
TARGET_WITH_TV_AUDIO_MODE := true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.hdmi.keep_awake=false

# cec device types
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.cec_device_types=tv \
    ro.hdmi.device_type=0

# EArc Hal
PRODUCT_PACKAGES += \
    android.hardware.tv.hdmi.earc-service.droidlogic

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.hdmi.arc_port=2

#userdebug, eng, AOSP version default disable AVB
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
    BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 1
else
#    ifeq ($(BOARD_COMPILE_ATV), false)
#        BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 1
#    endif
endif

ifeq ($(PRODUCT_SUPPORT_TUNER_FRAMEWORK),true)
#DEBUG FOR TUNER SDK JNI
# jasplayer
#add jasplayer library
PRODUCT_PACKAGES += \
    droidlogic.jasplayer \
    droidlogic.jasplayer.xml \
    droidlogic.jniasplayer \
    droidlogic.jniasplayer.xml

#add mediahalserver
PRODUCT_PACKAGES += \
    mediahalserver \
    libamlmediahal-jni \
    droidlogic.mediahal

# JDvrLib core packages
PRODUCT_PACKAGES += \
    JDvrLib \
    libjdvrlib-jni
endif

########################################################################
#
##  overlay for panel TV
#
#########################################################################
ifeq ($(ATV_LAUNCHER), amati)
DEVICE_PACKAGE_OVERLAYS := \
    device/amlogic/common/products/tv/FrameworkOverlay
endif

#TV project, enable hwc uvm dettach
HWC_UVM_DETTACH := true

#TV project, enable hwc pre display calibrate
HWC_ENABLE_PRE_DISPLAY_CALIBRATE := true
