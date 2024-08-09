# Copyright (C) 2011 Amlogic Inc
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
# This file is the build configuration for a full Android
# build for Meson reference board.
#

# Set display related config
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.has.mbxuimode=true \
    ro.vendor.platform.has.realoutputmode=true \
    ro.vendor.platform.need.display.hdmicec=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.usehwmjpeg=true \
    vendor.media.camera.dec.mediahalsdk=true

#media
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.media.dv.standalone.component=true

# t962x3_ab301 support screen capture
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.screencontrol.porttype=1 \
    ro.vendor.screencontrol.maxbufsize=314572800

#if wifi Only
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=false

#the prop is used for enable or disable
#DD+/DD force output when HDMI EDID is not supported
#by default,the force output mode is enabled.
#Note,please do not set the prop to true by default
#only for netflix,just disable the feature.so set the prop to true
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.disable.audiorawout=false

#Dolby DD+ decoder option
#this prop to for videoplayer display the DD+/DD icon when playback
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dolby=true
#DTS decoder option
#display dts icon when playback
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dts=true
#DTS-HD support prop
#PRODUCT_PROPERTY_OVERRIDES += \
    #ro.vendor.platform.support.dtstrans=true \
    #ro.vendor.platform.support.dtsmulasset=true
#DTS-HD prop end
# Enable player buildin

#audio dual spdif setting
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.is.dualspdif=true

#platform support dolby vision
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dolbyvision=true \
    vendor.media.support.dolbyvision = true

#add for video boot, 1 means use video boot, others not .
PRODUCT_PROPERTY_OVERRIDES += \
    service.bootvideo=0

# Define drm for this device
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=1

#enable/disable afbc
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.afbcd.enable=1

#adb
PRODUCT_PROPERTY_OVERRIDES += \
    service.adb.tcp.port=5555

#fake pid
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.fake_pid=0x2fff

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.tsplayer.enable=true

# crypto volume
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.filenames_mode=aes-256-cts

#this property is used for Android TV audio
PRODUCT_PROPERTY_OVERRIDES +=  \
    ro.vendor.platform.is.tv=1

#bootvideo
#0                      |050
#^                      |
#|                      |
#0:bootanim             |
#1:bootanim + bootvideo |
#2:bootvideo + bootanim |
#3:bootvideo            |
#others:bootanim        |
#-----------------------|050
#050:default volume value, volume range 0~100
#note that the high position 0 can not be omitted
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.media.bootvideo=0050
endif

# platform digital tv standards
# atsc/dvb/isdb/sbtvd
# ro.vendor.platform.digitaltv.standards
#
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.digitaltv.standards=atsc

#support hardware av1 decoder
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.av1=true

#support 4k
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.4k=true

#ifeq ($(TARGET_BUILD_GOOGLE_ATV), false)
#USB wifi need to be disabled when suspending
#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.vendor.platform.wifi.suspend=false
#endif

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

#enable di backend
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.di_channel_number=2 \
    vendor.media.c2.vdec.di.post=true \
    vendor.media.mediahal.tsplayer.vtbuffer_number_limit=1

#codec2
ifeq ($(VENDOR_MEDIA_CODEC2_SUPPORT),true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.codec2.support=true \
    vendor.media.codec2.disable_secure=false \
    debug.c2.use_dmabufheaps=1\
    debug.stagefright.c2inputsurface=-1 \
    debug.vendor.media.c2.vdec.support_10bit=false \
    vendor.media.c2.vdec.enable_h264_4k_mmu=true \
    vendor.media.common.fixed_buffer_slice=1080
endif

#usb controller
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.usb.controller=fdd00000.crgudc2

#support seamless for QMS
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.seamless=true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.disable_rescue=true

#tv path use video_tunnel
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.fixed_tunnel=1

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.locale=en-US

#Global Settings Key
ifeq ($(ATV_LAUNCHER),amati)
PRODUCT_PROPERTY_OVERRIDES += \
    sys.vendor.global.settingskey=dashboard
else
PRODUCT_PROPERTY_OVERRIDES += \
    sys.vendor.global.settingskey=settings
endif

# for SF performance
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.auto_latch_unsignaled=false
