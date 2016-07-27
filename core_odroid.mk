$(call inherit-product, build/target/product/aosp_base.mk)
PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi xxhdpi
ifneq ($(wildcard vendor/amlogic/frameworks/av/LibPlayer),)
    WITH_LIBPLAYER_MODULE := true
else
    WITH_LIBPLAYER_MODULE := false
endif

# set soft stagefright extractor&decoder as defaults
WITH_SOFT_AM_EXTRACTOR_DECODER := true

# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072 \
    camera.disable_zsl_mode=1

PRODUCT_BOOT_JARS += \
    droidlogic \
    droidlogic.frameworks.pppoe

PRODUCT_PACKAGES += \
    droidlogic \
    droidlogic-res \
    systemcontrol \
    systemcontrol_static \
    dig \
    PromptUser

PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libds_jni \
    libsrec_jni \
    system_key_server \
    libwifi-hal \
    libwpa_client \
    libGLES_mali \
    network \
    sdptool \
    e2fsck \
    mkfs.exfat \
    mount.exfat \
    fsck.exfat \
    ntfs-3g \
    ntfsfix \
    mkntfs \
    gralloc.$(TARGET_PRODUCT) \
    power.$(TARGET_PRODUCT) \
    hwcomposer.$(TARGET_PRODUCT) \
    memtrack.$(TARGET_PRODUCT) \
    screen_source.$(TARGET_PRODUCT)

#glscaler and 3d format api
PRODUCT_PACKAGES += \
    libdisplaysetting

#native image player surface overlay so
PRODUCT_PACKAGES += \
    libsurfaceoverlay_jni

PRODUCT_PACKAGES += libomx_av_core_alt \
    libOmxCore \
    libOmxVideo \
    libthreadworker_alt \
    libdatachunkqueue_alt \
    libOmxBase \
    libomx_framework_alt \
    libomx_worker_peer_alt \
    libfpscalculator_alt \
    libomx_clock_utils_alt \
    libomx_timed_task_queue_alt \
    libstagefrighthw \
    libsecmem \
    secmem


#########################################################################
#
#                                                App optimization
#
#########################################################################
#ifeq ($(BUILD_WITH_APP_OPTIMIZATION),true)

PRODUCT_COPY_FILES += \
    device/hardkernel/common/optimization/liboptimization_32.so:system/lib/liboptimization.so \
    device/hardkernel/common/optimization/config:system/package_config/config

PRODUCT_PROPERTY_OVERRIDES += \
    ro.app.optimization=true

ifeq ($(ANDROID_BUILD_TYPE), 64)
PRODUCT_COPY_FILES += \
    device/hardkernel/common/optimization/liboptimization_64.so:system/lib64/liboptimization.so
endif
#endif

#########################################################################
#
#                          Alarm white and black list
#
#########################################################################
PRODUCT_COPY_FILES += \
    device/hardkernel/common/alarm/alarm_blacklist.txt:/system/etc/alarm_blacklist.txt \
    device/hardkernel/common/alarm/alarm_whitelist.txt:/system/etc/alarm_whitelist.txt
