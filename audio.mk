#
# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Use parameter-framework
PRODUCT_SOONG_NAMESPACES += \
    device/amlogic/common/audio/audio_policy
PRODUCT_PACKAGES += \
    parameter-framework.policy

PRODUCT_PACKAGES += \
    audio_policy.default \
    audio.primary.amlogic \
    audio.hdmi.amlogic \
    audio.r_submix.default \
    acoustics.default \
    audio_firmware \
    droidaudio \
    droidaudio_tester \
    libdroidaudioclient \
    vendor.amlogic.hardware.droidaudio \
    libdroidaudiospdif \
    libparameter \
    libamadec_omx_api \
    libfaad    \
    libmad     \
    libamadec_wfd_out \
    libbalance \
    libhpeqwrapper \
    libtreblebasswrapper \
    libms12v2dapwrapper \
    libvirtualsurround \
    libvirtualx \
    libdpe\
    libaudiopolicymanagercustom \
    param_set \
    AudioEffectTool \
    libAmlAudioOutPort \

#########################################################################################
###                          Dolby MS12 ASDK control
#########################################################################################
OPTION_AUTO_PATCH_SHELL_FILE_ASDK := vendor/amlogic/restricted_libs/dolby/enable_asdk.mk
HAVE_OPTION_WRITE_SHELL_FILE_ASDK := $(shell test -f $(OPTION_AUTO_PATCH_SHELL_FILE_ASDK) && echo yes)
AUTO_PATCH_SHELL_FILE_ASDK := vendor/dolby/enable_asdk.mk
HAVE_WRITE_SHELL_FILE_ASDK := $(shell test -f $(AUTO_PATCH_SHELL_FILE_ASDK) && echo yes)
#No matter ms12_v2 is built or not,
#Only if the $DOLBY_ASDK_PATH file exist, project builds the Dolby ASDK.
#ifeq ($(TARGET_DOLBY_VERSION), ms12_v2)
    ifeq ($(HAVE_OPTION_WRITE_SHELL_FILE_ASDK),yes)
        DOLBY_ASDK_PATH := vendor/amlogic/restricted_libs/dolby
        TARGET_BUILD_DOLBY_ASDK :=true
        $(warning 'Dolby ASDK(vendor/amlogic/restricted_libs/dolby) will be installed')
        $(call inherit-product, $(DOLBY_ASDK_PATH)/enable_asdk.mk)
    else
        ifeq ($(HAVE_WRITE_SHELL_FILE_ASDK),yes)
            DOLBY_ASDK_PATH := vendor/dolby
            TARGET_BUILD_DOLBY_ASDK :=true
            $(warning 'Dolby ASDK(vendor/dolby) will be installed')
            $(call inherit-product, $(DOLBY_ASDK_PATH)/enable_asdk.mk)
        endif
    endif
#endif
########################################################################################

ifneq (,$(wildcard device/amlogic/$(PRODUCT_DIR)/files/aml_audio_config.json))
PRODUCT_COPY_FILES += device/amlogic/$(PRODUCT_DIR)/files/aml_audio_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/aml_audio_config.json
endif


ifneq (,$(wildcard device/amlogic/$(PRODUCT_DIR)/files/aml_audio_config.json))
PRODUCT_COPY_FILES += device/amlogic/$(PRODUCT_DIR)/files/aml_audio_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/aml_audio_config.json
endif
#configurable audio policy
USE_XML_AUDIO_POLICY_CONF := 1
ifeq ($(USE_XML_AUDIO_POLICY_CONF),1)
AUDIO_FEATURE_TYPE := _
#for ms12 v2 case, it should use default one in /vendor/etc
ifeq ($(TARGET_DOLBY_VERSION), ms12_v2)
    # without oem, is should use ms12 policy xml in /vendor/etc/
    ifeq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), false)
        AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12_
    endif
else ifeq ($(TARGET_DOLBY_VERSION), ms12_v1)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12v1_
else ifeq ($(TARGET_DOLBY_VERSION), ddp_only)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ddp_
endif

TARGET_DTS_VERSION ?= non_dts
ifeq ($(TARGET_DTS_VERSION), dtsx)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)dtsx_
else ifeq ($(TARGET_DTS_VERSION), dtshd)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)dtshd_
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

$(shell rm -rf device/amlogic/common/audio/audio_policy_configuration_temp.xml)
ifeq ($(GEN_AUDIO_POLICY_DURING_BUILD_TIME),true)
AML_AUDIO_POLICY_CONFIGURATION_XML_DIR := out/aml/audio/
$(shell mkdir -p $(AML_AUDIO_POLICY_CONFIGURATION_XML_DIR))
# auto generate audio_policy_configuration.xml
$(shell python device/amlogic/common/audio/tools/buildAudioPolicyConfigurationXml.py \
    --odmDirName $(AUDIO_POLICY_BUILD_PARAM_ODM) \
    --chipDeviceType $(PRODUCT_DIR) \
    --audioBuildType $(AUDIO_FEATURE_TYPE) \
    --soundbarProduct $(AUDIO_POLICY_BUILD_PARAM_SOUNDBAR) \
    --atvVersion $(AUDIO_POLICY_BUILD_PARAM_ATV_VERSION) \
    --productType $(AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE))

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,audio_policy_configuration_*,$(AML_AUDIO_POLICY_CONFIGURATION_XML_DIR),$(TARGET_COPY_OUT_VENDOR)/etc)
$(shell cp $(AML_AUDIO_POLICY_CONFIGURATION_XML_DIR)/audio_policy_configuration.xml device/amlogic/common/audio/audio_policy_configuration_temp.xml)
else
ifeq (,$(wildcard device/$(AUDIO_POLICY_BUILD_PARAM_ODM)/$(PRODUCT_DIR)/files/audio_policy_configuration.xml))
    $(error "the static audio_policy_configuration.xml file not found in the device directory")
endif
$(shell cp device/$(AUDIO_POLICY_BUILD_PARAM_ODM)/$(PRODUCT_DIR)/files/audio_policy_configuration.xml device/amlogic/common/audio/audio_policy_configuration_temp.xml)
endif
endif

##################################################################################
ifneq ($(wildcard vendor/amlogic/common/auto_patch/),)
TARGET_WITH_MEDIA_EXT ?= true
endif

configurable_audio_mediacodecs_xmls := device/amlogic/common/audio/media_codecs_xml/
PRODUCT_COPY_FILES += \
    $(configurable_audio_mediacodecs_xmls)media_codecs_amlogic_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_amlogic_audio.xml

ifneq ($(TARGET_DOLBY_VERSION), non_dolby)
    ifeq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), false)
    PRODUCT_COPY_FILES += \
        $(configurable_audio_mediacodecs_xmls)media_codecs_amlogic_audio_ddp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_amlogic_audio_ddp.xml
    endif
endif

ifeq ($(TARGET_DOLBY_VERSION), ms12_v2)
    # without oem, it should ues ac4 xml in /vendor/etc/
    ifeq ($(TARGET_BUILD_OEM_WITH_LICENSE_FILES), false)
    PRODUCT_COPY_FILES += \
        $(configurable_audio_mediacodecs_xmls)media_codecs_amlogic_audio_ac4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_amlogic_audio_ac4.xml
    endif
endif

ifeq ($(TARGET_DTS_VERSION), dtshd)
PRODUCT_COPY_FILES += \
    $(configurable_audio_mediacodecs_xmls)media_codecs_amlogic_audio_dtshd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_amlogic_audio_dts.xml
else ifeq ($(TARGET_DTS_VERSION), dtsx)
PRODUCT_COPY_FILES += \
    $(configurable_audio_mediacodecs_xmls)media_codecs_amlogic_audio_dtsx.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_amlogic_audio_dts.xml
endif

ifeq ($(TARGET_WITH_MEDIA_EXT), true)
PRODUCT_COPY_FILES += \
    $(configurable_audio_mediacodecs_xmls)media_codecs_amlogic_audio_ffmpeg.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_amlogic_audio_ffmpeg.xml \
    $(configurable_audio_mediacodecs_xmls)media_codecs_amlogic_audio_dtsx.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_amlogic_audio_dts.xml
endif
##################################################################################

ifeq ($(BOARD_ALSA_AUDIO),legacy)

PRODUCT_COPY_FILES += \
	$(TARGET_PRODUCT_DIR)/asound.conf:$(TARGET_COPY_OUT_VENDOR)/etc/asound.conf \
	$(TARGET_PRODUCT_DIR)/asound.state:$(TARGET_COPY_OUT_VENDOR)/etc/asound.state

BUILD_WITH_ALSA_UTILS := true

PRODUCT_PACKAGES += \
    alsa.default \
    alsa_aplay \
    alsa_ctl \
    alsa_amixer \
    alsainit-00main \
    alsalib-alsaconf \
    alsalib-pcmdefaultconf \
    alsalib-cardsaliasesconf
endif

################################################################################## tinyalsa

ifeq ($(BOARD_ALSA_AUDIO),tiny)

BUILD_WITH_ALSA_UTILS := false

# Audio
PRODUCT_PACKAGES += \
    audio.usb.default \
    libtinyalsa \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo \
    tinyhostless \
    audio.usb.amlogic
endif

##################################################################################
ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/mixer_paths.xml),)
    PRODUCT_COPY_FILES += \
        $(TARGET_PRODUCT_DIR)/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
else
    ifeq ($(BOARD_AUDIO_CODEC),rt5631)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/rt5631_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),rt5616)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/rt5616_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),wm8960)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/wm8960_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),dummy)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/dummy_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),m8_codec)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/m8codec_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),amlpmu3)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/amlpmu3_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
    endif
endif


##################################################################################
# reduce ms12 schedule run's frequence
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.media.audio.ms12.dynamic_sleep=true


