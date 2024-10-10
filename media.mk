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

ifeq ($(BOARD_COMPILE_CTS),true)
  BOARD_WIDEVINE_OEMCRYPTO_LEVEL ?= 1
endif

ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL),)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif

ifeq ($(BOARD_COMPILE_CTS),true)
ifeq ($(filter U,$(LAUNCH_VERSION)),)
BOARD_PLAYREADY_LEVEL ?= 1
endif
endif

ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)
TARGET_USE_OPTEEOS := true
TARGET_ENABLE_TA_SIGN := true
TARGET_USE_HW_KEYMASTER := true
endif

ifeq ($(BOARD_COMPILE_CTS), false)
TARGET_USE_HW_KEYMASTER := false
endif

#
#media related config for amlogic &
#some dynamic shared libraries
#
ifneq ($(wildcard vendor/amlogic/common/auto_patch/),)
TARGET_WITH_MEDIA_EXT_LEVEL ?= 4
endif

#for amlogicplayer& liblayer related.
#TARGET_WITH_AMLOGIC_EXTRATORS :=true
#TARGET_WITH_AMLOGIC_SCREEN_MEDIASOURCE :=true
#TARGET_WITH_AMLOGIC_RETRIEVER :=true
#TARGET_WITH_AMLOGIC_PLAYERS :=true
#move TARGET_WITH_MEDIA_EXT_LEVEL to platform mk
#set on some products,used libplayer.
BUILD_WITH_BOOT_PLAYER :=true
BUILD_WITH_ES_PLAYER := true
BUILD_WITH_DEC_INFO_TEST := true

#########################################################################
#
#                     media ext
#
#########################################################################
MEDIAEXTRACTOR_FILECONTEXTS := system/sepolicy/apex/com.amlogic.mediaextractor-file_contexts
ifeq (,$(wildcard $(MEDIAEXTRACTOR_FILECONTEXTS)))
    $(shell rm vendor/amlogic/common/prebuilt/libmedia/libavenhancements/apex/com.amlogic.mediaextractor/Android.bp)
endif

ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 1)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT := true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 2)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_CODEC_EXT := true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 3)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT := true
    TARGET_WITH_CODEC_EXT := true
else
ifeq ($(TARGET_WITH_MEDIA_EXT_LEVEL), 4)
    TARGET_WITH_MEDIA_EXT :=true
    TARGET_WITH_SWCODEC_EXT := true
    TARGET_WITH_CODEC_EXT := true
    TARGET_WITH_PLAYERS_EXT := true
endif
endif
endif
endif
ifeq ($(TARGET_WITH_MEDIA_EXT), true)
PRODUCT_PACKAGES += \
    libammediaext \
    libammediaext.vendor \
    libamffmpeg \
    libamffmpeg.vendor \
    libamffmpegcodec

    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.media.support.ffmpeg.adec=true
else
    PRODUCT_PROPERTY_OVERRIDES += ro.vendor.media.support.ffmpeg.adec=false
endif

#soft codec related.
#
ifeq ($(TARGET_WITH_SWCODEC_EXT), true)
PRODUCT_PACKAGES += \
    libOmxCoreSw \
    libstagefright_soft_amsoftdec \
    libmediavendor_ext

endif

#mediahal_videodec
PRODUCT_PACKAGES += libmediahal_videodec

ifeq ($(BOARD_BUILD_DRMPLAYER), true)
PRODUCT_PACKAGES += libmediahal_videodec.system
endif

#mediahal_mediasync
PRODUCT_PACKAGES += \
    libmediahal_mediasync

ifeq ($(BOARD_BUILD_DRMPLAYER), true)
PRODUCT_PACKAGES += libmediahal_mediasync.system
endif
#mediahal_tunnelrenderer
PRODUCT_PACKAGES += \
    libmediahal_tunnelrenderer\

#mediahal_passthrough
PRODUCT_PACKAGES += \
    libmediahal_passthrough\

#mediahal_hwdemux
PRODUCT_PACKAGES += \
    libmediahal_hardware_demux\

# tsplayer for bootvideo
ifneq ($(BOARD_COMPILE_ATV),true)
PRODUCT_PACKAGES += \
    bootvideo \
    libmediahal_tsplayer.system \
    libmediahal_mediasync.system \
    libmediahal_videodec.system \
    libmediahal_resman.system \
    libfaad_sys

endif

#codec ext related.
#
ifeq ($(TARGET_WITH_CODEC_EXT), true)
PRODUCT_PACKAGES += \
   libavenhancements \
   libavenhancements_vendor \
   libamffmpegadapter \
   com.amlogic.mediaextractor

endif

#codec ext related.
#
ifeq ($(TARGET_WITH_PLAYERS_EXT), true)
BOARD_USE_CUSTOM_MEDIASERVEREXTENSIONS:=true
TARGET_WITH_AMNUPLAYER :=true
endif

#resource manage
PRODUCT_PACKAGES += libmediahal_resman

ifeq ($(BOARD_BUILD_DRMPLAYER), true)
PRODUCT_PACKAGES += libmediahal_resman.system
endif

PRODUCT_PACKAGES += libdsm

#bin
PRODUCT_PACKAGES += EsVideoDecPlayer

#dmabuf manage
PRODUCT_PACKAGES += libmediahal_dmabufmanage

ifeq ($(BOARD_BUILD_DRMPLAYER), true)
PRODUCT_PACKAGES += libmediahal_dmabufmanage.system
endif

#mediametrics
PRODUCT_PACKAGES += libmediahal_mediametrics

ifeq ($(BOARD_BUILD_DRMPLAYER), true)
PRODUCT_PACKAGES += libmediahal_mediametrics.system
endif

#########################################################################
#
#                                                PlayReady DRM
#
#########################################################################
ifeq ($(BOARD_PLAYREADY_LEVEL),1)
    BUILD_WITH_PLAYREADY_DRM := true
    BOARD_PLAYREADY_TVP := true
    TARGET_USE_OPTEEOS := true
endif

ifeq ($(BUILD_WITH_PLAYREADY_DRM),true)

ifeq ($(LAUNCH_VERSION),U)
PRODUCT_PACKAGES += \
  android.hardware.drm-service.playready
else
PRODUCT_PACKAGES += \
  android.hardware.drm@1.4-service.playready
endif

PRODUCT_PACKAGES += \
  9a04f079-9840-4286-ab92-e65be0885f95
endif

#########################################################################
#
#                                     Verimatrix
#
#########################################################################
ifeq ($(BOARD_BUILD_DRMPLAYER),true)
#for drmplayer vmx
PRODUCT_PACKAGES += \
       libDrmPlayer\
       libdrmp\
       libdec_ca

 ifeq ($(BUILD_WITH_VIEWRIGHT_IPTV),true)
 #for vmx iptv
 PRODUCT_PACKAGES += \
       libdec_ca_vmx_iptv\
       libvmlogger\
       libvmxca_iptvclient_sys
 endif

ifeq ($(BUILD_WITH_VIEWRIGHT_WEB),true)
 #for vmx web
 PRODUCT_PACKAGES += \
       libdec_ca_vmx_web \
       libOTTlogger\
       libvmxca_webclient_sys
endif

ifeq ($(BUILD_WITH_WIDEVINECAS),true)
PRODUCT_PACKAGES += \
    libdec_ca_wvcas.system \
    wvcas_iptv_test_sys
endif

 PRODUCT_PACKAGES += libamgralloc_ext
 PRODUCT_PACKAGES += arm.graphics-V1-ndk_platform.so
 PRODUCT_PACKAGES += libteec_sys
 PRODUCT_PACKAGES += libamavutils_sys
 PRODUCT_PACKAGES += libdsm.system
endif

#for vmx mediadrm
ifeq ($(BUILD_WITH_VERIMATRIX_DRM),true)
 PRODUCT_PACKAGES += \
       libverimatrixplugin_aidl \
       android.hardware.drm-service.verimatrix \
       libverimatrixadaptor \
       vendor.amlogic.hardware.vmx_webclient-V1-ndk \
       vmx_webclient

 PRODUCT_COPY_FILES += \
       vendor/amlogic/common/prebuilt/libmediadrm/verimatrix-drm/common/libOTTlogger.so:vendor/lib/libOTTlogger.so

endif

#########################################################################
#
#                                    AmTsplayer
#
#########################################################################
PRODUCT_PACKAGES += libmediahal_tsplayer

ifeq ($(BOARD_BUILD_DRMPLAYER), true)
PRODUCT_PACKAGES += libmediahal_tsplayer.system
endif


PRODUCT_PACKAGES += ca-certificates.crt
#aml_mp_sdk
ifeq ($(TARGET_BUILD_LIVETV),true)
PRODUCT_PACKAGES += \
    libaml_mp_sdk \
    amlMpPlayerDemo \
    libamlMpTestSupporterJni \

PRODUCT_PACKAGES += \
    libaml_mp_sdk.vendor \
    amlMpPlayerDemo.vendor \
    libamlMpTestSupporterJni.vendor

endif

#support vvc
ifeq ($(TARGET_VENDOR_MEDIA_VVC_SUPPORT),true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.mediahal.tsplayer.vvc_support=1
else ifeq ($(TARGET_VENDOR_MEDIA_VVC_SUPPORT), false)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.mediahal.tsplayer.vvc_support=0
else
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.mediahal.tsplayer.vvc_support=1
endif

#########################################################################
#
#                                    Resman json
#
#########################################################################
#enable resman config from json
BUILD_WITH_RESMAN_JSON := true

ifeq ($(BUILD_WITH_RESMAN_JSON), true)

PRODUCT_PACKAGES += resmanload
PRODUCT_COPY_FILES += \
    device/amlogic/common/resman.json:$(TARGET_COPY_OUT_VENDOR)/etc/resman.json

endif

#########################################################################
#
#                                Miracast Application
##########################################################################

ifeq ($(BUILD_WITH_MIRACAST), true)
PRODUCT_PACKAGES += \
    Miracast
ifeq ($(BOARD_COMPILE_CTS),true)
PRODUCT_PACKAGES += \
    libstagefright_hdcp \
    807798e0-f011-11e5-a5fe-0002a5d5c51b
PRODUCT_PACKAGES += \
    libwfd_hdcp_adaptor \
    vendor.amlogic.hardware.miracast_hdcp2-V1-ndk \
    miracast_hdcp2
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.miracast.hdcp2=true
endif
endif

#for Netflix MGKID
ifeq ($(TARGET_BUILD_NETFLIX_MGKID),true)
PRODUCT_PACKAGES += \
  00d1ca22-1764-4e35-90aa-5b8c12630764 \
  libtee-hal \
  NfxTokenManager
include vendor/amlogic/common/prebuilt/libmediadrm/netflix/netflix.mk
endif

#for Widevine CAS
ifeq ($(BUILD_WITH_WIDEVINECAS),true)
PRODUCT_PACKAGES += libwvmediacas \
                    libdec_ca_wvcas \
                    e043cde0-61d0-11e5-9c26-0002a5d5c5ca
endif

#for drm widevine.

PRODUCT_PROPERTY_OVERRIDES += vendor.drm.service.enable=true
ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL),1)
    TARGET_USE_SECUREOS := true
    CONFIG_SECURE_OS_BDK := true
endif

ifeq ($(TARGET_USE_OPTEEOS), true)
    BOARD_OMX_WITH_OPTEE_TVP := true
    BUILD_WITH_TEEVIDEOFIRM_LOAD :=true
else
ifeq ($(TARGET_USE_SECUREOS), true)
    BOARD_OMX_WITH_TVP := true
endif
endif

ifneq ($(BUILD_WITHOUT_WIDEVINE), true)
ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL),1)
PRODUCT_PACKAGES += \
    liboemcrypto \
    e043cde0-61d0-11e5-9c26-0002a5d5c51b
endif
endif

ifeq ($(TARGET_WITH_AMLOGIC_PLAYERS), true)
##player related
BUILD_WITH_AMLOGIC_PLAYER := true

PRODUCT_PACKAGES += libmedia_amlogic \
    librtmp \
    libmms_mod \
	libcurl_mod \
    libvhls_mod \
    libprhls_mod.so \
    libdash_mod.so  \
    libbluray.so \
    libbluray_mod.so \

#audio
PRODUCT_PACKAGES += libamadec_omx_api \
    libfaad    \
    libmad     \
    libamadec_wfd_out
else
#no libplayer but have amnuplayer
ifeq ($(TARGET_WITH_AMNUPLAYER), true)
PRODUCT_PACKAGES += libamnuplayer
endif #amnuplayer

endif

ifeq ($(TARGET_WITH_AMLOGIC_RETRIEVER), true)
#retriever
PRODUCT_PACKAGES += libamlogic_metadata_retriever
endif

ifeq ($(TARGET_WITH_AMLOGIC_SCREEN_MEDIASOURCE), true)
#for screensource
PRODUCT_PACKAGES += libstagefright_screenmediasource
endif


ifeq ($(TARGET_WITH_AMLOGIC_EXTRATORS), true)
#for ffmpeg extrator
PRODUCT_PACKAGES += libamffmpegadapter
#for other extrators
PRODUCT_PACKAGES += libstagefright_extrator
endif

ifeq ($(BUILD_WITH_BOOT_PLAYER),true)
PRODUCT_PACKAGES += bootplayer \
    alsalib-alsaconf \
    alsalib-pcmdefaultconf \
    alsalib-cardsaliasesconf

endif

ifeq ($(BUILD_WITH_ES_PLAYER),true)
PRODUCT_PACKAGES += esplayer \
    vdec_debug
endif

ifeq ($(BUILD_WITH_DEC_INFO_TEST),true)
PRODUCT_PACKAGES += DecInfo_test
endif

ifeq ($(BUILD_WITH_TEEVIDEOFIRM_LOAD),true)
PRODUCT_PACKAGES += \
    libtee_load_video_fw \
    tee_preload_fw \
    526fc4fc-7ee6-4a12-96e3-83da9565bce8
endif
#BOARD_SECCOMP_POLICY := device/amlogic/common/seccomp
PRODUCT_COPY_FILES += \
    device/amlogic/common/seccomp/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy \
    device/amlogic/common/seccomp/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/amlogic/common/seccomp/mediaswcodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaswcodec.policy


BOARD_AML_MEDIAHAL_PATH := hardware/amlogic/media/
BOARD_AML_LIBAUDIO_PATH := hardware/amlogic/LibAudio/
BOARD_AML_HARDWARE_PATH := hardware/amlogic/
AMLOGIC_FRAMEWORKS_AV_CONFIG_MK := $(BOARD_AML_VENDOR_PATH)/frameworks/av/mediaextconfig/config.mk
BOARD_AML_MEDIA_HAL_CONFIG := $(BOARD_AML_MEDIAHAL_PATH)/media_base_config.mk

ifeq ($(TARGET_WITH_FB_MEDIA_MODULES),true)
# for media modules
PRODUCT_COPY_FILES += \
	device/amlogic/common/initscripts/init.amlogic.media.s5.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.media.rc
else ifeq ($(TARGET_WITH_S6_MEDIA_MODULES),true)
# for media modules
PRODUCT_COPY_FILES += \
	device/amlogic/common/initscripts/init.amlogic.media.s6.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.media.rc
else
# for media modules
PRODUCT_COPY_FILES += \
	device/amlogic/common/initscripts/init.amlogic.media.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.media.rc
endif

ifeq ($(BOARD_COMPILE_CTS),true)
ifeq ($(ANDROID_BUILD_TYPE), 64)
PRODUCT_PACKAGES += libssl
endif
endif
