ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)

AUDIO_FEATURE_TYPE := _
ifeq ($(TARGET_DOLBY_VERSION), ms12_v2)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12_
    CUSTOM_IMAGE_COPY_FILES += \
        device/amlogic/common/dolby_ms12/install/encrypted_lib/libdolbyms12.so:lib/ms12/libdolbyms12.so \
        device/amlogic/$(PRODUCT_DIR)/files/audio/media_codecs_amlogic_audio_ac4.xml:/etc/media_codecs_amlogic_audio_ac4.xml
else ifeq ($(TARGET_DOLBY_VERSION), ms12_v1)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12v1_
    CUSTOM_IMAGE_COPY_FILES += \
        device/amlogic/common/dolby_ms12/install/encrypted_lib/ms12v1/libdolbyms12.so:lib/libdolbyms12.so
else ifeq ($(TARGET_DOLBY_VERSION), ddp_only)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ddp_
    CUSTOM_IMAGE_COPY_FILES += \
        vendor/amlogic/common/prebuilt/libstagefrighthw/lib/libHwAudio_dcvdec.so:lib/libHwAudio_dcvdec.so
endif

TARGET_DTS_VERSION ?= non_dts
ifeq ($(TARGET_DTS_VERSION), dtsx)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)dtsx_
    CUSTOM_IMAGE_COPY_FILES += \
        vendor/amlogic/common/prebuilt/libstagefrighthw/lib/libHwAudio_dtsx.so:lib/libHwAudio_dtsx.so
else ifeq ($(TARGET_DTS_VERSION), dtshd)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)dtshd_
    CUSTOM_IMAGE_COPY_FILES += \
        vendor/amlogic/common/prebuilt/libstagefrighthw/lib/libHwAudio_dtshd.so:lib/libHwAudio_dtshd.so
endif

ifeq ($(TARGET_BUILD_TYPE_SOUNDBAR),true)
    AUDIO_POLICY_BUILD_PARAM_SOUNDBAR := true
else
    AUDIO_POLICY_BUILD_PARAM_SOUNDBAR := false
endif

ifneq ($(BOARD_COMPILE_ATV),false)
    AUDIO_POLICY_BUILD_PARAM_ATV_VERSION := atv
else
    AUDIO_POLICY_BUILD_PARAM_ATV_VERSION := aosp
endif

ifneq ($(AUDIO_FEATURE_TYPE),_)
configurable_audiopolicy_xmls := device/amlogic/common/audio/
# auto generate audio_policy_configuration.xml
    $(shell python device/amlogic/common/audio/tools/buildAudioPolicyConfigurationXml.py \
        --chipDeviceType $(PRODUCT_DIR) \
        --audioBuildType $(AUDIO_FEATURE_TYPE) \
        --soundbarProduct $(AUDIO_POLICY_BUILD_PARAM_SOUNDBAR) \
        --atvVersion $(AUDIO_POLICY_BUILD_PARAM_ATV_VERSION))
    CUSTOM_IMAGE_COPY_FILES += $(configurable_audiopolicy_xmls)/tools/audio_policy_configuration.xml:etc/audio_policy_configuration.xml
endif
endif # USE_XML_AUDIO_POLICY_CONF
