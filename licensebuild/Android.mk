ifeq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), true)
ifeq ($(filter adt2 adt3 deadpool sabrina boreal,$(TARGET_DEVICE)),)
LOCAL_PATH := $(my-dir)
##############################

include $(CLEAR_VARS)

LOCAL_MODULE :=  oem_license_build
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0 SPDX-license-identifier-BSD SPDX-license-identifier-LGPL legacy_by_exception_only
LOCAL_LICENSE_CONDITIONS := by_exception_only notice restricted
LOCAL_MODULE_CLASS := ETC

LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES := oem_license_build

LOCAL_INIT_RC := oem_license.rc


LOCAL_POST_INSTALL_CMD += \
    mkdir -p $(TARGET_OUT_ODM)/bin; \
    mkdir -p $(TARGET_OUT_ODM)/etc/firmware; \
    mkdir -p $(TARGET_OUT_VENDOR)/bin; \
    ln -sf /oem/etc/audio_policy_configuration.xml $(TARGET_OUT_ODM)/etc/audio_policy_configuration.xml; \
    ln -sf /vendor/etc/usb_audio_policy_configuration.xml $(TARGET_OUT_ODM)/etc/usb_audio_policy_configuration.xml; \
    ln -sf /vendor/etc/a2dp_audio_policy_configuration.xml $(TARGET_OUT_ODM)/etc/a2dp_audio_policy_configuration.xml; \
    ln -sf /vendor/etc/r_submix_audio_policy_configuration.xml $(TARGET_OUT_ODM)/etc/r_submix_audio_policy_configuration.xml;  \
    ln -sf /vendor/etc/hearing_aid_audio_policy_configuration.xml $(TARGET_OUT_ODM)/etc/hearing_aid_audio_policy_configuration.xml; \
    ln -sf /vendor/etc/msd_audio_policy_configuration.xml $(TARGET_OUT_ODM)/etc/msd_audio_policy_configuration.xml; \
    ln -sf /vendor/etc/default_volume_tables.xml $(TARGET_OUT_ODM)/etc/default_volume_tables.xml; \
    ln -sf /vendor/etc/audio_policy_volumes.xml $(TARGET_OUT_ODM)/etc/audio_policy_volumes.xml; \
    ln -sf /oem/etc/media_codecs.xml $(TARGET_OUT_ODM)/etc/media_codecs.xml; \
    ln -sf /oem/etc/media_codecs_amlogic_video.xml $(TARGET_OUT_ODM)/etc/media_codecs_amlogic_video.xml; \
    ln -sf /oem/etc/media_codecs_amlogic_encoder.xml $(TARGET_OUT_ODM)/etc/media_codecs_amlogic_encoder.xml; \
    ln -sf /oem/etc/media_codecs_amlogic_dolby_vision.xml $(TARGET_OUT_ODM)/etc/media_codecs_amlogic_dolby_vision.xml; \
    ln -sf /oem/etc/media_codecs_performance.xml $(TARGET_OUT_ODM)/etc/media_codecs_performance.xml; \
    ln -sf /oem/etc/firmware/firmware.le $(TARGET_OUT_ODM)/etc/firmware/firmware.le;

include $(BUILD_PREBUILT)
endif
endif
