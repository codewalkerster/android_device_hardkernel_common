$(call inherit-product, device/hardkernel/common/core_amlogic.mk)

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
PRODUCT_PACKAGES += \
    inputsource \
    libdtvkit_jni \
    droidlogic-dtvkit \
    droidlogic.dtvkit.software.core.xml \

ifeq ($(PRODUCT_SUPPORT_TUNER_FRAMEWORK),true)
PRODUCT_PACKAGES += \
    libdtvkitserver \
    libdvbserver \
    libisdbserver \
    libatscserver \
    libdtvkit_tuner_jni \
    dtvkitserver_releaseinfo.txt
else
PRODUCT_PACKAGES += \
    dtvkitserver \
    isdb_server \
    dvb_server \
    atsc_server \
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
#PRODUCT_AAPT_CONFIG := mdpi
#PRODUCT_AAPT_PREF_CONFIG := mdpi

PRODUCT_AAPT_CONFIG ?= normal large xlarge hdpi tvdpi xhdpi xxhdpi$
PRODUCT_AAPT_PREF_CONFIG ?= xhdpi$

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
ifeq ($(ODROID_BOARD), true)
PRODUCT_PACKAGES += \
    TvSettingsTwoPanel \
    OdroidSettingsResOverlay \
else
ifeq ($(ATV_LAUNCHER),amati)
PRODUCT_PACKAGES += \
    TvSettingsTwoPanel \
    DroidTvSettingsTwoPanel \
    GTVSettingsResOverlay
else
PRODUCT_PACKAGES += \
    TvSettings \
    DroidTvSettings
endif
endif # ODROID_BOARD

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

#MESONHWC CONFIG
ifeq ($(ATV_LAUNCHER),amati)
HWC_FILTER_16_9MODE :=true
endif

DISPLAY_BUILD_NUMBER := true

ifeq ($(VENDOR_MEDIA_OMX_SUPPORT),true)
#TV project,set omx to video layer,or PQ hasn't effect
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.omx.display_mode=3
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.set_menu_language=false \
    persist.sys.hdmi.keep_awake=false

ifneq ($(TARGET_BUILD_TYPE_SOUNDBAR),true)
# cec device types
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.cec_device_types=playback_device \
    ro.hdmi.device_type=4 \
    ro.vendor.hdmi.auto_otp=true \
    ro.config.media_vol_steps=25
else
PRODUCT_PACKAGE_OVERLAYS += \
    device/hardkernel/common/soundbar/overlay
PRODUCT_SUPPORT_CEC_EARC?=true
ifeq ($(PRODUCT_SUPPORT_CEC_EARC), true)
$(warning "cec supported")
PRODUCT_PACKAGES += \
    android.hardware.tv.hdmi.earc-service.droidlogic
endif
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.cec_device_types=audio_system,playback_device \
    ro.hdmi.device_type=5,4 \
    ro.vendor.platform.hdmi.device_type=5,4 \
    ro.hdmi.property_is_device_hdmi_cec_switch=true \
    ro.config.media_vol_steps=100 \
    persist.vendor.sys.soundbar_mode=1
endif

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.media_vol_default=20

PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/display_config_aosp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/default.xml

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

ifeq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), true)
PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/hdcp_tx22_oem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hdcp_tx22.rc
else
PRODUCT_COPY_FILES += \
    device/hardkernel/common/products/mbox/hdcp_tx22.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hdcp_tx22.rc
endif
