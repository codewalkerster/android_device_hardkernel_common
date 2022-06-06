ifeq ($(filter adt2 adt3 deadpool sabrina boreal,$(TARGET_DEVICE)),)
LOCAL_PATH := $(my-dir)
##############################

include $(CLEAR_VARS)

LOCAL_MODULE := audio_effects.xml
LOCAL_LICENSE_KINDS := SPDX-license-identifier-Apache-2.0 SPDX-license-identifier-BSD SPDX-license-identifier-LGPL legacy_by_exception_only
LOCAL_LICENSE_CONDITIONS := by_exception_only notice restricted
LOCAL_MODULE_CLASS := ETC

LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES := audio_effects.xml

include $(BUILD_PREBUILT)
endif
