$(call inherit-product, device/amlogic/common/core_amlogic.mk)

BOARD_SEPOLICY_DIRS += device/google/atv/sepolicy/vendor

# Get some sounds
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackageGo.mk)

PRODUCT_PACKAGES += \
    LatinIME \
    Settings \
    ThemesStub \
    ThemePicker

PRODUCT_COPY_FILES += \
    device/amlogic/common/products/tablet/permissions/com.android.wallpaper.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.android.wallpaper.xml

PRODUCT_COPY_FILES += \
    frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png:$(TARGET_COPY_OUT_VENDOR)/etc/default_wallpaper.png

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.wallpaper=vendor/etc/default_wallpaper.png

# These libraries are empty and have been combined into libhidlbase, but are still depended
# on by things off /system.
# TODO(b/135686713): remove these
PRODUCT_PACKAGES += \
    libhidltransport \
    libhwbinder

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

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
    libam_sysfs

PRODUCT_PACKAGES += \
    busybox \
    utility_busybox

# LiveTv
PRODUCT_PACKAGES += \
    DroidLiveTvSettings \
    DroidLogicLiveTv \
    DroidTvSettingsEdla

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.build.livetv=true

endif  #endof TARGET_BUILD_LIVETV

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
    screencatch

#lcd/tconless tools
PRODUCT_PACKAGES += \
    tcondump \
    lcdhelper

ifneq ($(BOARD_COMPILE_ATV), false)
PRODUCT_PACKAGES += \
    OTAUpgrade
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

MKDIR=$(shell mkdir $(TARGET_COPY_OUT_VENDOR)/usr/icu/)
$(MKDIR)
PRODUCT_COPY_FILES += \
    vendor/amlogic/common/prebuilt/icu/icudt60l.dat:$(TARGET_COPY_OUT_VENDOR)/usr/icu/icudt60l.dat

ifeq ($(TARGET_BUILD_LIVETV),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.live_tv.xml:system/etc/permissions/android.software.live_tv.xml
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
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
#ifeq ($(VERSION_ID),)
#export BUILD_NUMBER := $(shell date +%Y%m%d)
#else
#$(call inherit-product, $(VERSION_ID))
#endif

DISPLAY_BUILD_NUMBER := true

#TV project,set omx to video layer,or PQ hasn't effect
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.omx.display_mode=3

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

# props for Dalvik heap
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=384m

#TV project, need use 8 ch 32 bit output.
TARGET_WITH_TV_AUDIO_MODE := true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.hdmi.keep_awake=false

# cec device types
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.cec_device_types=tv \
    ro.hdmi.device_type=0

#userdebug, eng, AOSP version default disable AVB
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
    BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 1
endif

#copy all the audio policy xml file
PRODUCT_COPY_FILES += \
    device/amlogic/common/audio/tv/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_default.xml \
    device/amlogic/common/audio/tv/audio_policy_configuration_ms12.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12.xml \
    device/amlogic/common/audio/tv/audio_policy_configuration_ms12_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12_v1.xml \
    device/amlogic/common/audio/tv/audio_policy_configuration_ms12_v1_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12_v1_dtshd.xml \
    device/amlogic/common/audio/tv/audio_policy_configuration_ms12_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ms12_dtshd.xml \
    device/amlogic/common/audio/tv/audio_policy_configuration_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_dtshd.xml \
    device/amlogic/common/audio/tv/audio_policy_configuration_ddp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ddp.xml \
    device/amlogic/common/audio/tv/audio_policy_configuration_ddp_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_ddp_dtshd.xml

#########################################################################
#
# Audio
#
#########################################################################
ifneq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), true)
ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
AUDIO_FEATURE_TYPE :=
ifeq ($(TARGET_BUILD_DOLBY_MS12_V2),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_ms12
endif

ifeq ($(TARGET_BUILD_DOLBY_MS12_V1),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_ms12_v1
endif

ifeq ($(TARGET_BUILD_DOLBY_DDP),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_ddp
endif

ifeq ($(TARGET_BUILD_DTSHD),true)
AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_dtshd
endif

PRODUCT_COPY_FILES += \
    device/amlogic/common/audio/tv/audio_policy_configuration$(AUDIO_FEATURE_TYPE).xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
$(warning 'using audio_policy_configuration$(AUDIO_FEATURE_TYPE).xml')
endif  ###end USE_XML_AUDIO_POLICY_CONF
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/audio/tv/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
endif  ###end TARGET_BUILD_OEM_WITH_LICENSE_FILES
