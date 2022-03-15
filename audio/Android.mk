LOCAL_PATH := $(my-dir)
##############################

include $(CLEAR_VARS)

LOCAL_MODULE := audio_effects.xml
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0 SPDX-license-identifier-BSD SPDX-license-identifier-LGPL legacy_by_exception_only
LOCAL_LICENSE_CONDITIONS := by_exception_only notice restricted
LOCAL_MODULE_CLASS := ETC

LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES := audio_effects.xml

ifeq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), true)
LOCAL_POST_INSTALL_CMD += \
    ln -sf /oem/etc/audio_policy_configuration.xml $(TARGET_OUT_VENDOR)/etc/audio_policy_configuration.xml; \
    ln -sf /oem/etc/media_codecs.xml $(TARGET_OUT_VENDOR)/etc/media_codecs.xml; \
    ln -sf /oem/etc/media_codecs_performance.xml $(TARGET_OUT_VENDOR)/etc/media_codecs_performance.xml;
endif

include $(BUILD_PREBUILT)
