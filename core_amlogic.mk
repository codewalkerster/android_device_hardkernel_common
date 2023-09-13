#ATV version, need compile DRM related modules
ifneq ($(BOARD_COMPILE_ATV),false)
  BOARD_COMPILE_CTS := true
endif

# To prevent from including GMS twice in Google's internal source.
ifeq ($(wildcard vendor/unbundled_google),)
ifneq ($(BOARD_COMPILE_ATV), false)
PRODUCT_USE_PREBUILT_GTVS := yes
PRODUCT_USE_PREBUILT_GTVS_GTV := yes
DONT_DEXPREOPT_PREBUILTS := true
endif
endif

ifneq ($(wildcard vendor/google_gtvs),)
ifneq ($(BOARD_COMPILE_ATV), false)
include vendor/amlogic/common/gms/google/gms.mk
endif
endif
# Inherit from those products. Most specific first.
# Get the TTS language packs
$(call inherit-product-if-exists, external/svox/pico/lang/all_pico_languages.mk)


# Get IRDETO middleware framework.
ifeq ($(TARGET_BUILD_IRDETO), true)
$(call inherit-product-if-exists, vendor/irdeto/hal/irdeto.mk)
$(call inherit-product-if-exists, vendor/irdeto/irdeto-sdk/irdeto-sdk.mk)
endif

# Define the host tools and libs that are parts of the SDK.
ifneq ($(filter sdk win_sdk sdk_addon,$(MAKECMDGOALS)),)
-include sdk/build/product_sdk.mk
-include development/build/product_sdk.mk

PRODUCT_PACKAGES += \
    EmulatorSmokeTests
endif

PRODUCT_PACKAGES += \
    droidlogic-res
# 1p device without vendor/amlogic/reference code
# reference device with vendor/amlogic/reference code
ifneq ($(wildcard vendor/amlogic/reference/tv),)
## for reference device
include vendor/amlogic/reference/prebuilt/kernel-modules/tuner/tuner.mk
PRODUCT_PACKAGES += \
    amazon_av_target_permissions
#subtitle related
PRODUCT_PACKAGES += \
    subtitleserver \
    libSubtitleClient \
    libsubtitlebinder \
    vendor.amlogic.hardware.subtitleserver@1.0 \
    libsubtitlemanager_jni \
    libsubtitlemanagerproduct_jni

#add tv library
PRODUCT_PACKAGES += \
    droidlogic-tv \
    droidlogic.tv.software.core.xml \
    libtv_jni

endif

#add ASPlayer library
PRODUCT_PACKAGES += \
    droidlogic.jasplayer \
    droidlogic.jasplayer.xml \
    droidlogic.jniasplayer \
    libjniasplayer-jni \
    droidlogic.jniasplayer.xml

KERNEL_AUTO_PATCH := $(shell ls common/common*/mk.sh)
KERNEL_AUTO_PATCH_RESULT := $(foreach patch_shell, $(KERNEL_AUTO_PATCH), \
    $(shell cd $(shell dirname $(patch_shell)); ./mk.sh --patch lunch))
ifeq ($(filter Error,$(KERNEL_AUTO_PATCH_RESULT)), Error)
$(error end to am kernel patches, the result: $(KERNEL_AUTO_PATCH_RESULT))
endif

BOARD_DO_NOT_STRIP_VENDOR_RAMDISK_MODULES := true
BOARD_DO_NOT_STRIP_VENDOR_MODULES := true
BOARD_DO_NOT_STRIP_RECOVERY_MODULES := true
BOARD_DO_NOT_STRIP_VENDOR_KERNEL_RAMDISK_MODULES := true

# Net:
#   Vendors can use the platform-provided network configuration utilities (ip,
#   iptable, etc.) to configure the Linux networking stack, but these utilities
#   do not yet include a HIDL interface wrapper. This is a solution on
#   Android O.
PRODUCT_PACKAGES += \
    netutils-wrapper-1.0

ifneq ($(BOARD_COMPILE_ATV), false)
PRODUCT_PACKAGES += \
    PlayAutoInstallStub \
    LauncherCustomization

#No need a2dp sink now,remove it #
ifeq ($(BOARD_ENABLE_A2DP_SINK),true)
PRODUCT_PACKAGES += \
    BlueOverlay
PRODUCT_PRODUCT_PROPERTIES += persist.bluetooth.enablenewavrcp=false
endif

endif

#overlay config_wifi5ghzSupport #
BOARD_ENABLE_WIFI_5G ?= true
ifeq ($(BOARD_ENABLE_WIFI_5G),true)
PRODUCT_PACKAGES += \
    WiFiTetheringOverlay
endif

ifneq ($(filter T U,$(LAUNCH_VERSION)),)
TARGET_RECOVERY_FSTAB := device/amlogic/common/recovery/recovery_newlaunch.fstab
else
TARGET_RECOVERY_FSTAB := device/amlogic/common/recovery/recovery_upgrade.fstab
endif

TARGET_RELEASETOOLS_EXTENSIONS := device/amlogic/common/scripts
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
TARGET_RECOVERY_UI_LIB += libamlogic_ui librecovery_amlogic
TARGET_RECOVERY_UI_LIB += \
    libsystemcontrol_static \
    libcutils \
    libz \
    liblog \
    libenv_droid

ifneq ($(AB_OTA_UPDATER),true)
TARGET_RECOVERY_UPDATER_LIBS := libinstall_amlogic
TARGET_RECOVERY_UPDATER_EXTRA_LIBS += libsystemcontrol_static libfdt libtinyxml2
endif

ifneq ($(CONFIG_DEVICE_LOW_RAM),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density?=320
endif

ifeq ($(TARGET_BUILD_LIVETV),true)
    USE_OEM_TV_APP := true
else
    BOARD_DISABLE_DVB_AUDIO := true
endif

ifneq ($(TARGET_BUILD_GMS), true)
$(call inherit-product, device/google/atv/products/atv_base.mk)
endif

$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioTv.mk)

PRODUCT_PRODUCT_VNDK_VERSION := current

PRODUCT_ENFORCE_PRODUCT_PARTITION_INTERFACE := true

# Put en_US first in the list, so make it default.
PRODUCT_LOCALES := en_US

AMLOGIC_PRODUCT := true

# If want kernel build with KASAN, set it to true
ENABLE_KASAN := false

# PPPoE Feature
ifeq ($(BUILD_WITH_PPPOE),true)
PRODUCT_PACKAGES += \
    PPPoE \
    libpppoejni \
    libpppoe \
    pppoe_wrapper \
    pppoe \
    droidlogic.frameworks.pppoe \
    droidlogic.external.pppoe \
    droidlogic.software.pppoe.xml
PRODUCT_PROPERTY_OVERRIDES += \
   ro.vendor.platform.has.pppoe=true
endif

PRODUCT_PACKAGES += \
    gsi_tool \
    gsid

#Get some property
$(call inherit-product, device/amlogic/common/product_property.mk)

PRODUCT_HOST_PACKAGES += \
    dtc \
    mkdtimg \
    imgdiff \
    makegpt

PRODUCT_PACKAGES += \
    liblz4

PRODUCT_SUPPORTS_CAMERA := true

#default hardware composer version is 2.0
TARGET_USES_HWC2 := true

ifneq ($(wildcard $(BOARD_AML_VENDOR_PATH)/frameworks/av/LibPlayer),)
    WITH_LIBPLAYER_MODULE := true
else
    WITH_LIBPLAYER_MODULE := false
endif

ifeq ($(BOARD_COMPILE_ATV), false)
ifneq ($(TARGET_BUILD_GMS), true)
PRODUCT_PACKAGES += \
    WifiOverlay \
    AppInstaller \
    RemoteIME \
    NativeImagePlayer \
    imageserver \
    DLNA \
    BluetoothRemote \
    OTAUpgrade \
    Gallery2 \
    MusicFX \
    Music \
    webview \
    Browser2 \
    DeskClock \
    FileBrower \

ifeq ($(PRODUCT_SUPPORT_ATK_UI),true)
    PRODUCT_PACKAGES += \
        TVLauncher \
        FileBrowser2 \
        SetupWizard
else
    PRODUCT_PACKAGES += \
        MboxLauncher \
        FileBrowser
endif
#add camera app
PRODUCT_PACKAGES += Camera2
endif
endif

PRODUCT_PACKAGES += \
    Bluetooth \
    PrintSpooler \
    SubTitle

ifneq ($(TARGET_BUILD_GMS), true)
PRODUCT_PACKAGES += \
    DroidOverlay \
    ABUpdater\
    ExoPlayer
endif

PRODUCT_PACKAGES += \
    SystemUIOverlay \
    TvProviderOverlay \
    TetheringOverlay \
    libufdt

ifeq ($(PRODUCT_IS_ATV_MAINLINE), true)
PRODUCT_PACKAGES += \
    GoogleTetheringOverlay
endif
ifeq ($(TARGET_LIVETV_BUILT_FROM_SOURCE), true)
    PRODUCT_PACKAGES += \
        LiveTv
endif

PRODUCT_PACKAGES += \
    droidlogic.software.core \
    systemcontrol \
    systemcontrol_static \
    libsystemcontrolservice \
    vendor.amlogic.hardware.systemcontrol@1.0

PRODUCT_PACKAGES += \
    pppd \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libds_jni \
    libsrec_jni \
    system_key_server \
    libwpa_client \
    network \
    sdptool \
    e2fsck \
    mkfs.exfat \
    mount.exfat \
    fsck.exfat \
    libxml2 \
	meson_display_client

#add camera feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.external.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.external.xml

ifeq ($(ATV_LAUNCHER), amati)
# Keymaster configuration
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml \
    frameworks/native/data/etc/android.hardware.device_unique_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.device_unique_attestation.xml \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    hardware/amlogic/keymaster/keymint/rkp_extract.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/rkp_extract.rc

PRODUCT_PRODUCT_PROPERTIES += \
    remote_provisioning.hostname=remoteprovisioning.googleapis.com

#amlogic HALs
PRODUCT_PACKAGES += \
    libGLES_meson_mali \
    libgpudataproducer \
    libamgralloc_ext \
    hwcomposer.amlogic \
    screen_source.amlogic

#glscaler and 3d format api
PRODUCT_PACKAGES += \
    libdisplaysetting

#native image player surface overlay so
PRODUCT_PACKAGES += \
    libsurfaceoverlay_jni

ifneq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), true)
PRODUCT_PACKAGES += \
    libHwAudio_dcvdec \
    libHwAudio_dtshd
else
PRODUCT_PACKAGES += \
    libHwAudio_dcvdec \
    libHwAudio_dtshd \
    oem_license_build

endif

ifeq ($(BOARD_COMPILE_CTS),true)
PRODUCT_PACKAGES += \
    libsecmem \
    libsecmem_sys \
    secmem \
    2c1a33c0-44cc-11e5-bc3b-0002a5d5c51b
endif

#Bluetooth idc config file
PRODUCT_COPY_FILES += \
    device/amlogic/common/keyboards/Vendor_1d5a_Product_c082.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_1d5a_Product_c082.idc \
    device/amlogic/common/keyboards/Vendor_7545_Product_0180.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_7545_Product_0180.idc \
    device/amlogic/common/keyboards/Vendor_0508_Product_0110.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_0508_Product_0110.idc \
    device/amlogic/common/keyboards/Vendor_18d1_Product_0100.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_18d1_Product_0100.idc

### custom keylayouts
custom_keylayouts := $(wildcard device/amlogic/common/keyboards/*.kl)
PRODUCT_COPY_FILES += $(foreach file,$(custom_keylayouts),\
    $(file):$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/$(notdir $(file)))

# AOSP can use modified generic.kl
ifeq ($(BOARD_COMPILE_ATV), false)
PRODUCT_COPY_FILES += device/amlogic/common/keyboards/Generic.kl.aosp:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl
endif



# mali
PRODUCT_VENDOR_PROPERTIES += \
	ro.hardware.egl = mali

#########################################################################
#
#                                                App optimization
#
#########################################################################
ifeq ($(BUILD_WITH_APP_OPTIMIZATION),true)

PRODUCT_COPY_FILES += \
    device/amlogic/common/optimization/liboptimization_32.so:$(TARGET_COPY_OUT_VENDOR)/lib/liboptimization.so \
    device/amlogic/common/optimization/config:$(TARGET_COPY_OUT_VENDOR)/package_config/config

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.app.optimization=true

ifeq ($(ANDROID_BUILD_TYPE), 64)
PRODUCT_COPY_FILES += \
    device/amlogic/common/optimization/liboptimization_64.so:$(TARGET_COPY_OUT_VENDOR)/lib64/liboptimization.so
endif
endif

#######################################################################
#
#                     metadata encryption
#
#######################################################################
ifneq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.metadata.method=dm-default-key \
    ro.crypto.dm_default_key.options_format.version=2 \
    ro.crypto.volume.options=::v2
endif

#########################################################################
#
#                                                Secure OS
#
#########################################################################
ifeq ($(TARGET_USE_OPTEEOS),true)
PRODUCT_PACKAGES += \
	tee-supplicant \
	libteec \
	tee_stest \
	tee_helloworld \
	tee_crypto \
	tee_xtest \
	tdk_auto_test \
	tee_helloworld_ta \
	tee_fail_test_ta \
	tee_crypt_ta \
	tee_os_test_ta \
	tee_rpc_test_ta \
	tee_sims_ta \
	tee_storage_ta \
	tee_storage2_ta \
	tee_storage_benchmark_ta \
	tee_aes_perf_ta \
	tee_sha_perf_ta \
	tee_sdp_basic_ta \
	tee_concurrent_ta \
	tee_concurrent_large_ta \
	tee_provision \
	tee_key_inject \
	libprovision \
	tee_provision_ta \
	tee_efuse_ta \
	tee_fvp_ta \
	tee_hdcp \
	tee_hdcp_ta \
	tee_ciplus_ta

endif

ifneq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
PRODUCT_COPY_FILES += \
       device/amlogic/common/kexec/kernel54_arm64/Image2:$(TARGET_COPY_OUT_SYSTEM)/etc/Image2 \
       device/amlogic/common/kexec/kernel54_arm64/init.amlogic.kexec.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/init.amlogic.kexec.rc
PRODUCT_PACKAGES += kexec
endif

#########################################################################
#
#                                     hardware interfaces
#
#########################################################################

# WiFi AIDL HAL
PRODUCT_PACKAGES += \
     libwifi-hal-aml \
     android.hardware.wifi-service.droidlogic

# healthd aidl hal
ifneq ($(filter T U,$(LAUNCH_VERSION)),)
PRODUCT_PACKAGES += android.hardware.health-service.droidlogic
else
PRODUCT_PACKAGES += android.hardware.health@2.1-service.droidlogic
endif

#
# Bluetooth Audio AIDL HAL
#
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl

#Audio HAL
PRODUCT_PACKAGES += \
     android.hardware.audio@6.0-impl \
     android.hardware.audio@5.0-impl \
     android.hardware.audio@4.0-impl \
     android.hardware.audio.effect@6.0-impl \
     android.hardware.audio.effect@5.0-impl \
     android.hardware.audio.effect@4.0-impl \
     android.hardware.audio@2.0-impl \
     android.hardware.audio.effect@2.0-impl \
     android.hardware.audio@2.0-service-droidlogic

ifneq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
PRODUCT_PACKAGES += \
    android.hardware.audio@7.1-impl \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl
endif

#Camera HAL
ifneq ($(ANDROID_BUILD_TYPE), 64)

ifneq ($(filter U,$(LAUNCH_VERSION)),)
PRODUCT_PACKAGES += \
    camera.amlogic \
    android.hardware.camera.provider-V1-amlogic-service \
    android.hardware.camera.provider-V1-amlogic-impl
else
PRODUCT_PACKAGES += \
     camera.amlogic \
     android.hardware.camera.provider@2.5-legacy-droidlogic \
     android.hardware.camera.provider@2.5-service-droidlogic
endif

else

ifneq ($(filter U,$(LAUNCH_VERSION)),)
PRODUCT_PACKAGES += \
    camera.amlogic \
    android.hardware.camera.provider-V1-amlogic-service_64 \
    android.hardware.camera.provider-V1-amlogic-impl
else
PRODUCT_PACKAGES += \
     camera.amlogic \
     android.hardware.camera.provider@2.5-legacy-droidlogic \
     android.hardware.camera.provider@2.5-service_64-droidlogic
endif

endif

#Power HAL
PRODUCT_PACKAGES += \
    android.hardware.power.aidl-service.droidlogic

#Memtack HAL
PRODUCT_PACKAGES += \
     android.hardware.memtrack-service.droidlogic

# Gralloc HAL
PRODUCT_PACKAGES += \
    mapper.arm \
    android.hardware.graphics.mapper@4.0-impl-arm \
    android.hardware.graphics.allocator-V2-arm \
    android.hardware.graphics.allocator-service

# HW Composer
HWC_ENABLE_AIDL ?= false
ifeq ($(HWC_ENABLE_AIDL),true)
PRODUCT_PACKAGES += \
   android.hardware.graphics.composer@3.2-service.droidlogic
else
PRODUCT_PACKAGES += \
   android.hardware.graphics.composer@2.4-service.droidlogic
endif

# dumpstate binderized
PRODUCT_PACKAGES += \
   android.hardware.dumpstate-service.droidlogic \
   dumpstate_display \
   drminfo

# Keymaster HAL
ifeq ($(TARGET_USE_HW_KEYMASTER),true)
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service.amlogic
else
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service
endif

ifneq ($(TARGET_BUILD_GMS), true)
# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper-service.amlogic
endif

#DRM HAL
ifeq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service
endif

PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey \
    move_widevine_data.sh

ifneq ($(BOARD_COMPILE_ATV), false)
TARGET_BUILD_WIDEVINE := nonupdatable
TARGET_BUILD_WIDEVINE_USE_PREBUILT := true
-include vendor/widevine/libwvdrmengine/apex/device/device.mk
else
PRODUCT_PACKAGES += \
    android.hardware.drm-service.widevine
endif

# CEC HAL
PRODUCT_PACKAGES += \
    android.hardware.tv.hdmi.cec-service.droidlogic
 
# Hdmi Connection Hal
PRODUCT_PACKAGES += \
    android.hardware.tv.hdmi.connection-service.droidlogic

PRODUCT_PROPERTY_OVERRIDES += \
   log.tag.HDMI=DEBUG \
   ro.vendor.platform.hdmi.vendor_id=1877008

#Android new device will use AIDL to instead of HIDL
ifeq ($(BOARD_ENABLE_LIGHT_CONTROL),true)
    PRODUCT_PACKAGES += \
        lights
else
#ifneq ($(CONFIG_DEVICE_LOW_RAM_OTT_1G),true)
PRODUCT_PACKAGES += \
        android.hardware.light@2.0-impl \
        android.hardware.light@2.0-service
#endif
endif

#usb hal
PRODUCT_PACKAGES += \
    android.hardware.usb-service.droidlogic

#usb gadget hal
PRODUCT_PACKAGES += \
    android.hardware.usb.gadget-service.droidlogic

#thermal hal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.droidlogic


ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.15)
PRODUCT_COPY_FILES += \
    device/amlogic/common/initscripts/5_15/init.modules.5_15.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.modules.5.15.rc \
    device/amlogic/common/initscripts/5_15/init.insmod.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.insmod.sh
endif

#normally, every device need a config file, currently all chips are the same
ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.15)
PRODUCT_COPY_FILES += \
    device/amlogic/common/thermal_info_config_5_15.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json
else
PRODUCT_COPY_FILES += \
    device/amlogic/common/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json
endif

#PRODUCT_PACKAGES += \
#    android.hardware.cas@1.2-service

#bt audio hal
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio@2.0-impl \
    android.hardware.bluetooth.audio@2.0-service

#bufferhub hal
PRODUCT_PACKAGES += \
    android.frameworks.bufferhub@1.0-impl \
    android.frameworks.bufferhub@1.0-service

#codec 2 HAL
ifeq ($(VENDOR_MEDIA_CODEC2_SUPPORT),true)
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.2-service \
    libcodec2_aml_video_decoder\
    libcodec2_aml_video_encoder\
    libcodec2_aml_audio_decoder\
    libc2plugin_store
#codec2 soft decoder
ifeq ($(TARGET_WITH_SWCODEC_EXT), true)
PRODUCT_PACKAGES += \
    libcodec2_aml_soft_video_decoder
endif
endif

#omx HAL
ifeq ($(VENDOR_MEDIA_OMX_SUPPORT),true)

PRODUCT_PACKAGES += \
    android.hardware.media.omx@1.0-service

PRODUCT_PACKAGES += \
    libOmxCore \
    libOmxVideo \
    libOmxAudio \
    libHwAudio_dcvdec_passthrough \
    libHwAudio_dtshd_passthrough \
    libthreadworker_alt \
    libdatachunkqueue_alt \
    libOmxBase \
    libomx_av_core_alt \
    libomx_framework_alt \
    libomx_worker_peer_alt \
    libfpscalculator_alt \
    libomx_clock_utils_alt \
    libomx_timed_task_queue_alt \
    libstagefrighthw


endif

ifeq ($(VENDOR_ENCODER_SUPPORT_HCODEC),true)
PRODUCT_PACKAGES += \
    lib_avc_vpcodec
endif

ifeq ($(VENDOR_ENCODER_SUPPORT_WAVE420),true)
PRODUCT_PACKAGES += \
    libvp_hevc_codec
endif

ifeq ($(VENDOR_ENCODER_SUPPORT_WAVE521),true)
PRODUCT_PACKAGES += \
    lib_amvenc \
    lib_encoder_media_process \
    libvpcodec \
    libamvenc_api
endif


#Atrace HAL
#PRODUCT_PACKAGES += \
#     android.hardware.atrace@1.0-service

#oemlock HAL
ifneq ($(filter T U,$(LAUNCH_VERSION)),)
PRODUCT_PACKAGES += \
    android.hardware.oemlock-service.droidlogic
else
PRODUCT_PACKAGES += \
    android.hardware.oemlock@1.0-service.droidlogic
endif


PRODUCT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported = 1

PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot-service.amlogic_recovery
    #android.hardware.fastboot@1.1-impl-amlogic

# install  audio_effects.xml and audio_policy_configuration.xml soft link to oem file.
PRODUCT_PACKAGES += \
    audio_effects.xml

ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
PRODUCT_COPY_FILES += \
    device/amlogic/common/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml
endif

ifneq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
PRODUCT_COPY_FILES += \
    device/amlogic/common/initscripts/fs_5.4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/fs.rc \
    device/amlogic/common/initscripts/power_5.4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/power.rc \
    device/amlogic/common/powerhint5.4.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

else
PRODUCT_COPY_FILES += \
    device/amlogic/common/initscripts/fs.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/fs.rc \
    device/amlogic/common/initscripts/power.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/power.rc \
    device/amlogic/common/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json
endif

PRODUCT_COPY_FILES += \
    device/amlogic/common/initscripts/ueventd.amlogic.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    device/amlogic/common/initscripts/bluetooth.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/bluetooth.rc \
    device/amlogic/common/initscripts/sysfs_permissions.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/sysfs_permissions.rc \
    device/amlogic/common/initscripts/init.amlogic.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.usb.rc \
    device/amlogic/common/initscripts/fulldump.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.fulldump.rc

PRODUCT_COPY_FILES += \
    device/amlogic/common/android.software.cant_save_state.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.cant_save_state.xml

PRODUCT_COPY_FILES += \
    device/amlogic/common/silent_ota.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/silent_ota.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.gamepad.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.gamepad.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml

ifeq ($(TARGET_BUILD_NETFLIX), true)
PRODUCT_COPY_FILES += \
	device/amlogic/common/droidlogic.software.netflix.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/droidlogic.software.netflix.xml
endif

ifeq ($(BOARD_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml
endif

ifneq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
#Factory Reset Protection
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/by-name/frp

#add project id and casefold attribute for data partition and external storage
#PRODUCT_QUOTA_PROJID := 1
#PRODUCT_VENDOR_PROPERTIES += external_storage.projid.enabled=true
PRODUCT_PROPERTY_OVERRIDES += \
    external_storage.projid.enabled=true \
    external_storage.casefold.enabled=true
endif

# Android R and later, use lmkd new strategy, no need cma_shrinker workaround. which may introduce may CTS failure.
PRODUCT_COPY_FILES += \
    device/amlogic/common/initscripts/memory_common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/memory_common.rc
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lmk.use_new_strategy=true

#########################################################################
#
#                    AB UPDATE
#
#########################################################################
ifeq ($(AB_OTA_UPDATER),true)
AB_OTA_PARTITIONS += \
    boot \
    dtbo

AB_OTA_PARTITIONS += \
    system \
    vendor \
    vbmeta \
    odm \
    product \
    bootloader

ifeq ($(BOARD_USES_ODM_EXTIMAGE), true)
AB_OTA_PARTITIONS += \
    odm_ext
endif

ifeq ($(BOARD_USES_DYNAMIC_FINGERPRINT),true)
AB_OTA_PARTITIONS += \
    oem
endif

ifeq ($(BOARD_USES_VBMETA_SYSTEM),true)
AB_OTA_PARTITIONS += \
    vbmeta_system
endif

AB_OTA_PARTITIONS += \
    system_dlkm

ifeq ($(BOARD_USES_VENDOR_DLKMIMAGE),true)
AB_OTA_PARTITIONS += \
    vendor_dlkm
endif

ifeq ($(BOARD_USES_ODM_DLKMIMAGE),true)
AB_OTA_PARTITIONS += \
    odm_dlkm
endif

ifeq ($(BUILDING_INIT_BOOT_IMAGE),true)
AB_OTA_PARTITIONS += \
    init_boot
endif

TARGET_BOOTLOADER_CONTROL_BLOCK := true

ifeq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 25165824
TARGET_NO_RECOVERY := false
AB_OTA_PARTITIONS += recovery
else
AB_OTA_PARTITIONS += system_ext
ifeq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
AB_OTA_PARTITIONS += vendor_boot
TARGET_NO_RECOVERY := true

# GKI-related variables.
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

else
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
TARGET_NO_RECOVERY := false
AB_OTA_PARTITIONS += recovery
endif
endif

else
TARGET_NO_RECOVERY := false

BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
ifeq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 25165824
else
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
endif
endif

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    libsnapshot \
    libsnapshot_init \
    libsnapshot_nobinder \
    snapshotctl \
    libupdate_engine_boot_control

PRODUCT_HOST_PACKAGES += \
    delta_generator \
    brillo_update_payload

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_verifier

ifneq ($(TARGET_GPT_PART),true)
PRODUCT_PACKAGES += \
    android.hardware.boot-bootloader.rc
endif

PRODUCT_PACKAGES += \
    android.hardware.boot-service \
    android.hardware.boot-service_recovery


PRODUCT_PACKAGES += \
    update_engine_sideload \
    otacerts.recovery

endif

################# add for FFM ####################
ifeq ($(BOARD_HAS_MIC_TOGGLE), true)
PRODUCT_PACKAGES += \
    MicToggleProvider
endif

#########################################################################
PRODUCT_PACKAGES += \
    MtpService

# Set supported Bluetooth profiles to enabled
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.profile.asha.central.enabled=true \
    bluetooth.profile.a2dp.source.enabled=true \
    bluetooth.profile.avrcp.target.enabled=true \
    bluetooth.profile.gatt.enabled=true \
    bluetooth.profile.hfp.ag.enabled=true \
    bluetooth.profile.hid.host.enabled=true \
    bluetooth.profile.mcp.server.enabled=true \
    bluetooth.profile.opp.enabled=true \
    bluetooth.profile.pan.nap.enabled=true \
    bluetooth.profile.pan.panu.enabled=true

# Disable Prime Shader Cache in SurfaceFlinger to make it available faster
PRODUCT_PROPERTY_OVERRIDES += \
    service.sf.prime_shader_cache=0