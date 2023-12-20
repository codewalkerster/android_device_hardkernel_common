PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=Ring_Synth_04.ogg \
    ro.config.notification_sound=pixiedust.ogg

PRODUCT_PRODUCT_PROPERTIES += \
    debug.sf.disable_backpressure=1 \
    debug.sf.latch_unsignaled=1 \
    debug.sf.vsync_reactor_ignore_present_fences=1 \
    debug.sf.enable_gl_backpressure=0

PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.enable_frame_rate_override=false

# config of surfaceflinger
ifneq ($(CONFIG_DEVICE_LOW_RAM),true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.disable_triple_buffer=0

ifneq ($(TARGET_BUILD_GMS), true)
ifeq ($(PRODUCT_SUPPORT_4K_UI), true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.surface_flinger.max_graphics_width?=3840 \
        ro.surface_flinger.max_graphics_height?=2160 \
        ro.surface_flinger.max_frame_buffer_acquired_buffers?=3 \
        dalvik.vm.heapgrowthlimit=384m
else
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.surface_flinger.max_graphics_width?=1920 \
        ro.surface_flinger.max_graphics_height?=1080 \
        ro.surface_flinger.max_frame_buffer_acquired_buffers?=3 \
        dalvik.vm.heapgrowthlimit=256m
endif
endif

endif

# gfx: mode policy config
ifeq ($(HWC_ENABLE_AIDL), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.hwc.default.config?=true
endif

#config vsync offset
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.vsync_event_phase_offset_ns=2000000 \
    ro.surface_flinger.vsync_sf_event_phase_offset_ns=4000000 \
    debug.sf.early_gl_phase_offset_ns=1000000 \
    debug.sf.early_gl_app_phase_offset_ns=1000000

PRODUCT_PRODUCT_PROPERTIES += \
    camera.disable_zsl_mode=1

# USB camera default face
#PRODUCT_PRODUCT_PROPERTIES += \
#    rw.camera.usb.faceback=true

# ro.product.first_api_level indicates the first api level the device has commercially launched on.
#PRODUCT_PRODUCT_PROPERTIES += \
#    ro.product.first_api_level=26


#Enforce privapp-permissions whitelist
PRODUCT_PROPERTY_OVERRIDES += \
     ro.control_privapp_permissions=enforce

# for device RAM <= 2G, which need use minfree levels
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.kill_timeout_ms=100

ifneq ($(CONFIG_DEVICE_LOW_RAM),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.kill_heaviest_task=true
endif

# Set clientid
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=android-droid-tv

# A new solution for oemkey as build param
# if someone want to use the unify key solution
# pls comment next 2 line2
PRODUCT_PRODUCT_PROPERTIES += \
    ro.oem.key1=ATV00100021

#CONFIG_INCREMENTAL_FS=y
PRODUCT_PROPERTY_OVERRIDES += \
    ro.incremental.enable=yes

# for AAudio support
PRODUCT_PROPERTY_OVERRIDES += \
    aaudio.mmap_exclusive_policy=2 \
    aaudio.mmap_policy=2 \
    aaudio.mixer_bursts=1

# for Hdmi cec
PRODUCT_PRODUCT_PROPERTIES +=  \
  ro.hdmi.cec.source.playback_device_action_on_routing_control=wake_up_and_send_active_source \
  ro.hdmi.cec.source.send_standby_on_sleep=broadcast

#llkd will recycle zombie process by killing parent process,
#if the parent not recycle it. Antutu folk some process to run
#gpu bench, and do not recycle these processes until exit.
#so we need add antutu to the ignore list of llkd.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.llk.ignorelist.parent=com.antutu.ABenchMark

#for early suspend
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.earlysuspend=false

#for apexd ,the property value is from cpu cores num
PRODUCT_PROPERTY_OVERRIDES += \
    apexd.config.boot_activation.threads=4

#Use FUSE passthrough
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.fuse.passthrough.enable=true
