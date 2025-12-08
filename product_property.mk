PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=Ring_Synth_04.ogg \
    ro.config.notification_sound=pixiedust.ogg

PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.disable_backpressure=1 \
    debug.sf.latch_unsignaled=1 \
    debug.sf.vsync_reactor_ignore_present_fences=1 \
    debug.sf.enable_gl_backpressure=0

PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.enable_frame_rate_override=false

# config of surfaceflinger
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.max_frame_buffer_acquired_buffers?=3 \
    dalvik.vm.heapgrowthlimit=384m

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

#for early suspend
ifneq ($(SUPPORT_EARLY_SUSPEND), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.earlysuspend=false
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.earlysuspend=true
endif

#for apexd ,the property value is from cpu cores num
PRODUCT_PROPERTY_OVERRIDES += \
    apexd.config.boot_activation.threads=4

#Use FUSE passthrough
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.fuse.passthrough.enable=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.lowmem_min_oom_score=1001

#add dualspdif
ifeq ($(SUPPORT_DUALSPDIF), false)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.is.dualspdif=false
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.platform.is.dualspdif=true
endif
