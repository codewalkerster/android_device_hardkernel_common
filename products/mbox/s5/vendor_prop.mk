# Copyright (C) 2011 Amlogic Inc
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
# This file is the build configuration for a full Android
# build for Meson reference board.
#

# Set display related config
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.has.mbxuimode=true \
    ro.vendor.platform.has.realoutputmode=true \
    ro.vendor.platform.need.display.hdmicec=true

#camera
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.usehwh264=true \
    vendor.media.camera.dec.mediahalsdk = true

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
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.dolbyvision=true \
    vendor.media.support.dolbyvision = true

# Define drm for this device
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=1

#set memory upper limit for extractor process
PRODUCT_PRODUCT_PROPERTIES += \
    ro.media.maxmem=629145600

#adb
PRODUCT_PROPERTY_OVERRIDES += \
    service.adb.tcp.port=5555

#enable/disable afbc
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.afbcd.enable=1

#s5 invalid pid
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.fake_pid=0x2fff

# low memory for 1G
#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.config.low_ram=true

# crypto volume
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.filenames_mode=aes-256-cts

# default enable sdr to hdr
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.sdr2hdr.enable=true

ifeq ($(TARGET_BUILD_LIVETV), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.has.tuner=1
else ifeq ($(TARGET_BUILD_IRDETO), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.has.tuner=1
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.has.tuner=0
endif

ifeq ($(filter true,$(PRODUCT_SUPPORT_DTVKIT) $(SUPPORT_CBS)),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.is.tv=1
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.is.tv=0
endif

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
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.media.bootvideo=0050

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.hdmi.device_type=4
#disable timeshift
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.tv.dtv.tf.disable=false

#enable video and audio sync show
PRODUCT_PROPERTY_OVERRIDES += \
     vendor.media.audio.syncshow=1

#support mvc
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.support.mvc=true

#codec2
ifeq ($(VENDOR_MEDIA_CODEC2_SUPPORT),true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.media.codec2.support=true \
    vendor.media.codec2.disable_secure=false \
    debug.c2.use_dmabufheaps=1 \
    debug.stagefright.c2inputsurface=-1 \
    debug.vendor.media.c2.vdec.support_10bit=false \
    vendor.media.c2.disp.nr.enable=true \
    vendor.media.c2.disp.di.localbuf_enable=true \
    vendor.media.c2.vdec.enable_h264_4k_mmu=true \
    ro.vendor.platform.support.8k=true \
    ro.vendor.platform.support.4k=true \
    ro.vendor.platform.support.4k_fps_max=125
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.is.dualspdif=true

#support hardware av1 decoder
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.support.av1=true

#usb controller
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.usb.controller=fdd00000.crgudc2

ifeq ($(TARGET_BUILD_NAGRA),true)
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.nagracas.emi=0x4020 \
    vendor.cas.type=nagra \
    vendor.tv.dtv.tf.save_dmx=false
endif

#enable aisr
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.aisr_enable=1

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.locale=en-US

#aisr  check I/P input source
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.aisr_check_interlace=1
#aipq  nn input frame option
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.aipq.nn_input_frame_width=224 \
    vendor.hwc.aipq.nn_input_frame_height=224

#S5 8k support
PRODUCT_PROPERTY_OVERRIDES += \
    media.resolution.limit.32bit=8192

# for SF performance
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.auto_latch_unsignaled=false