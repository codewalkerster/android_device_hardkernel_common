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
    ro.vendor.platform.has.tvuimode=true \
    ro.vendor.platform.customize_tvsetting=true \
    ro.vendor.platform.has.realoutputmode=true \
    ro.vendor.platform.need.display.hdmicec=true

#platform support dolby vision
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dolbyvision=true

#media
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.media.dv.standalone.component=true

#need support screen capture
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.screencontrol.maxbufsize=104857600

#if wifi Only
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.media_vol_steps=100

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


#platform support dolby vision
#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.vendor.platform.support.dolbyvision=true \
#    vendor.media.support.dolbyvision = true

# Define drm for this device
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=1

#set memory upper limit for extractor process
PRODUCT_PROPERTY_OVERRIDES += \
    ro.media.maxmem=629145600

#map volume
PRODUCT_PROPERTY_OVERRIDES += \
    ro.audio.mapvalue=0,0,0,0

#enable/disable afbc
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.afbcd.enable=1

# low memory for 1G
#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.config.low_ram=true \
#    ro.config.max_starting_bg=8

#disable timeshift
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.tf.disable=false

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.tsplayer.enable=true

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.fake_pid=0x1ffc

# crypto volume
PRODUCT_PROPERTY_OVERRIDES +=  \
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
ifeq ($(BOARD_COMPILE_ATV), false)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.media.bootvideo=3050
else
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.media.bootvideo=0050
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.hdmi.device_type=0

# platform digital tv standards
# atsc/dvb/isdb/sbtvd
# ro.vendor.platform.digitaltv.standards
#
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.digitaltv.standards=dtmb

#support hardware av1 decoder
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.av1=true

#unsupport 4k
#PRODUCT_PROPERTY_OVERRIDES += \
#	media.amplayer.videolimiter=true \
#        ro.vendor.platform.support.4k=false

#used for controlling reference board's preview window,
#project's need disable it or can refer its implementation method.
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.need.droidlogic.preview_window=true
endif

ifeq ($(BOARD_COMPILE_ATV), false)
#USB wifi need to be disabled when suspending
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.wifi.suspend=true
endif

# for playback of audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true \
    audio.offload.min.duration.secs=5

# secure playback enable di
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.omx.enable_secure_di=1 \
    vendor.media.omx.enable_tunnel_di=1 \
    vendor.media.omx.fhd_di_size=0 \
    vendor.media.omx.fhd_di_size=0

#omx2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.media.support.omx2=true \
    vendor.media.omx.use.omx2=true \
    vendor.media.omx2.in_buffer=5 \
    vendor.media.omx2.support_mpeg=true \
    vendor.ionvideo.enable=1 \
    vendor.media.omx.dibypass.enable=false \
    vendor.media.omx.videolayerrotation.enable=false \
    vendor.media.omx.dec.enable_h264_4k_mmu=true

#codec2
ifeq ($(VENDOR_MEDIA_CODEC2_SUPPORT),true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.codec2.support=true \
    vendor.media.codec2.disable_secure=false \
    debug.c2.use_dmabufheaps=1 \
    vendor.media.c2.disp.nr.enable=true \
    vendor.media.c2.disp.di.loacalbuf_enable=true \
    vendor.media.c2.vdec.enable_h264_4k_mmu=true
endif

#usb controller
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.usb.controller=fe350000.crgudc3
#audio dual spdif setting
PRODUCT_PROPERTY_OVERRIDES += \
     ro.vendor.platform.is.dualspdif=true

#support video_composer
PRODUCT_PROPERTY_OVERRIDES += \
    media.omx.display_mode=3

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.disable_rescue=true

#tv path use video_tunnel
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.fixed_tunnel=1
#enable aisr
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.aisr_enable=1
#aisr default config
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.sys.aisr=true
#aisr  check I/P input source
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.aisr_check_interlace=1
