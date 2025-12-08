ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)

AUDIO_FEATURE_TYPE :=
ifeq ($(TARGET_DOLBY_VERSION), ms12_v2)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12_
    CUSTOM_IMAGE_COPY_FILES += \
        device/hardkernel/common/dolby_ms12/install/encrypted_lib/libdolbyms12.so:lib/ms12/libdolbyms12.so \
        device/hardkernel/common/audio/media_codecs_xml/media_codecs_amlogic_audio_ac4.xml:/etc/media_codecs_amlogic_audio_ac4.xml \
        device/hardkernel/common/audio/media_codecs_xml/media_codecs_amlogic_audio_ddp.xml:/etc/media_codecs_amlogic_audio_ddp.xml
else ifeq ($(TARGET_DOLBY_VERSION), ms12_v1)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12v1_
    CUSTOM_IMAGE_COPY_FILES += \
        device/hardkernel/common/dolby_ms12/install/encrypted_lib/ms12v1/libdolbyms12.so:lib/libdolbyms12.so
else ifeq ($(TARGET_DOLBY_VERSION), ddp_only)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ddp_
    CUSTOM_IMAGE_COPY_FILES += \
        vendor/amlogic/common/prebuilt/libstagefrighthw/lib/libHwAudio_dcvdec.so:lib/libHwAudio_dcvdec.so \
        device/hardkernel/common/audio/media_codecs_xml/media_codecs_amlogic_audio_ddp.xml:/etc/media_codecs_amlogic_audio_ddp.xml
endif

TARGET_DTS_VERSION ?= non_dts
ifeq ($(TARGET_DTS_VERSION), dtsx)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_dtsx
    CUSTOM_IMAGE_COPY_FILES += \
        vendor/amlogic/common/prebuilt/libstagefrighthw/lib/libHwAudio_dtsx.so:lib/libHwAudio_dtsx.so
else ifeq ($(TARGET_DTS_VERSION), dtshd)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_dtshd
    CUSTOM_IMAGE_COPY_FILES += \
        vendor/amlogic/common/prebuilt/libstagefrighthw/lib/libHwAudio_dtshd.so:lib/libHwAudio_dtshd.so
endif
TARGET_MPEGH_VERSION ?= non_mpegh
ifeq ($(TARGET_MPEGH_VERSION), mpegh)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)_mpegh
    CUSTOM_IMAGE_COPY_FILES += \
        vendor/amlogic/common/prebuilt/libstagefrighthw/lib/libcdkMpeghDecoder.so:lib/libcdkMpeghDecoder.so
endif

ifeq ($(ODROID_BOARD), true)
    AUDIO_POLICY_BUILD_PARAM_SOUNDBAR := false
    AUDIO_POLICY_BUILD_PARAM_ATV_VERSION := aosp
else

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
endif # ODROID_BOARD

ifeq ($(PRODUCT_TYPE),)
    AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE := tv
$(warning "PRODUCT_TYPE is null, set default param: tv")
else
    AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE := $(PRODUCT_TYPE)
endif

ifeq ($(ODROID_BOARD), true)
ODM_DIR := hardkernel
endif

ifeq ($(ODM_DIR),)
    AUDIO_POLICY_BUILD_PARAM_ODM := amlogic
else
    AUDIO_POLICY_BUILD_PARAM_ODM := $(ODM_DIR)
endif

ifneq ($(AUDIO_FEATURE_TYPE),)
ifeq ($(GEN_AUDIO_POLICY_DURING_BUILD_TIME),true)
$(warning "dynamic audioBuildType:$(AUDIO_FEATURE_TYPE)")
AML_AUDIO_POLICY_CONFIGURATION_XML_DIR := out/aml/audio/
AUDIO_POLICY_XML_PATH := $(AML_AUDIO_POLICY_CONFIGURATION_XML_DIR)
else
$(warning "static audioBuildType:$(AUDIO_FEATURE_TYPE)")
AUDIO_POLICY_XML_PATH := device/$(AUDIO_POLICY_BUILD_PARAM_ODM)/$(PRODUCT_DIR)/files/
endif
CUSTOM_IMAGE_COPY_FILES += $(AUDIO_POLICY_XML_PATH)audio_policy_configuration$(AUDIO_FEATURE_TYPE).xml:etc/audio_policy_configuration.xml
endif # AUDIO_FEATURE_TYPE
endif # USE_XML_AUDIO_POLICY_CONF
