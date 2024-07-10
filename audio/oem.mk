ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)

AUDIO_FEATURE_TYPE := _
ifeq ($(TARGET_DOLBY_VERSION), ms12_v2)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12_
    CUSTOM_IMAGE_COPY_FILES += \
        device/amlogic/common/dolby_ms12/install/encrypted_lib/libdolbyms12.so:lib/ms12/libdolbyms12.so \
        device/amlogic/common/audio/media_codecs_xml/media_codecs_amlogic_audio_ac4.xml:/etc/media_codecs_amlogic_audio_ac4.xml
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

ifeq ($(BOARD_COMPILE_ATV),false)
    AUDIO_POLICY_BUILD_PARAM_ATV_VERSION := aosp
else
    AUDIO_POLICY_BUILD_PARAM_ATV_VERSION := atv
endif

ifeq ($(PRODUCT_TYPE),)
    AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE := tv
$(warning "PRODUCT_TYPE is null, set default param: tv")
else
    AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE := $(PRODUCT_TYPE)
endif

ifeq ($(ODM_DIR),)
    AUDIO_POLICY_BUILD_PARAM_ODM := amlogic
else
    AUDIO_POLICY_BUILD_PARAM_ODM := $(ODM_DIR)
endif

ifneq ($(AUDIO_FEATURE_TYPE),_)
AML_AUDIO_POLICY_CONFIGURATION_XML_DIR := out/aml/audio/
$(shell mkdir -p AML_AUDIO_POLICY_CONFIGURATION_XML_DIR)
configurable_audiopolicy_xmls := device/amlogic/common/audio/
# auto generate audio_policy_configuration.xml
    $(shell python device/amlogic/common/audio/tools/buildAudioPolicyConfigurationXml.py \
        --odmDirName $(AUDIO_POLICY_BUILD_PARAM_ODM) \
        --chipDeviceType $(PRODUCT_DIR) \
        --audioBuildType $(AUDIO_FEATURE_TYPE) \
        --soundbarProduct $(AUDIO_POLICY_BUILD_PARAM_SOUNDBAR) \
        --atvVersion $(AUDIO_POLICY_BUILD_PARAM_ATV_VERSION) \
        --productType $(AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE))
    CUSTOM_IMAGE_COPY_FILES += $(AML_AUDIO_POLICY_CONFIGURATION_XML_DIR)audio_policy_configuration.xml:etc/audio_policy_configuration.xml
endif
endif # USE_XML_AUDIO_POLICY_CONF
