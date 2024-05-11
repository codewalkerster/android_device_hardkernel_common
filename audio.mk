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

PRODUCT_PACKAGES += \
    audio_policy.default \
    audio.primary.amlogic \
    audio.hdmi.amlogic \
    audio.r_submix.default \
    acoustics.default \
    audio_firmware \
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
    param_set \
    AudioEffectTool \
    libAmlAudioOutPort \

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
ifeq ($(TARGET_DOLBY_VERSION), ms12_v2)
    AUDIO_FEATURE_TYPE := $(AUDIO_FEATURE_TYPE)ms12_
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

ifneq ($(BOARD_COMPILE_ATV),false)
    AUDIO_POLICY_BUILD_PARAM_ATV_VERSION := atv
else
    AUDIO_POLICY_BUILD_PARAM_ATV_VERSION := aosp
endif

configurable_audiopolicy_xmls := device/amlogic/common/audio/
# auto generate audio_policy_configuration.xml
$(shell python device/amlogic/common/audio/tools/buildAudioPolicyConfigurationXml.py \
    --chipDeviceType $(PRODUCT_DIR) \
    --audioBuildType $(AUDIO_FEATURE_TYPE) \
    --soundbarProduct $(AUDIO_POLICY_BUILD_PARAM_SOUNDBAR) \
    --atvVersion $(AUDIO_POLICY_BUILD_PARAM_ATV_VERSION))

PRODUCT_COPY_FILES += \
    $(configurable_audiopolicy_xmls)tools/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    $(configurable_audiopolicy_xmls)usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)hearing_aid_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/hearing_aid_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)msd_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/msd_audio_policy_configuration.xml \
    $(configurable_audiopolicy_xmls)default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(configurable_audiopolicy_xmls)audio_policy_engine_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_engine_configuration.xml \
    $(configurable_audiopolicy_xmls)audio_engine/audio_policy_engine_product_strategies.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_engine/audio_policy_engine_product_strategies.xml \
    $(configurable_audiopolicy_xmls)audio_engine/audio_policy_engine_stream_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_engine/audio_policy_engine_stream_volumes.xml \
    $(configurable_audiopolicy_xmls)bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml

endif
################################################################################## alsa

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
