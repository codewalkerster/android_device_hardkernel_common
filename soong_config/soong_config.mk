#for system control
$(call soong_config_set,amlogic_vendorconfig,board_platform,$(TARGET_BOARD_PLATFORM))
$(call soong_config_set,amlogic_vendorconfig,hwc_dynamic_switch_viu,$(HWC_DYNAMIC_SWITCH_VIU))
$(call soong_config_set,amlogic_vendorconfig,build_livetv,$(TARGET_BUILD_LIVETV))

# for alsa library
$(call soong_config_set,amlogic_vendorconfig,build_alsa_audio,$(BOARD_ALSA_AUDIO))


#SUPPORT_HDMIIN := true
$(call soong_config_set,amlogic_vendorconfig,support_hdmiin,$(SUPPORT_HDMIIN))

$(call soong_config_set,amlogic_vendorconfig,custom_mediaserver_extensions,$(BOARD_USE_CUSTOM_MEDIASERVEREXTENSIONS))

$(call soong_config_set,amlogic_vendorconfig,ddlib_from_customer,$(TARGET_DDLIB_BUILT_FROM_CUSTOMER))

$(call soong_config_set,amlogic_vendorconfig,build_livetv_from_source,$(TARGET_LIVETV_BUILT_FROM_SOURCE))

$(call soong_config_set,amlogic_vendorconfig,netflix_mgkid,$(TARGET_BUILD_NETFLIX_MGKID))

# for ta sign related

ifeq ($(PLATFORM_TDK_VERSION),)
PLATFORM_TDK_VERSION := 24
endif
$(call soong_config_set,amlogic_vendorconfig,tdk_version,TDK$(PLATFORM_TDK_VERSION))

$(call soong_config_set,amlogic_vendorconfig,enable_ta_sign,$(TARGET_ENABLE_TA_SIGN))

$(call soong_config_set,amlogic_vendorconfig,enable_ta_encrypt,$(TARGET_ENABLE_TA_ENCRYPT))

$(call soong_config_set,amlogic_vendorconfig,omx_with_optee_tvp,$(BOARD_OMX_WITH_OPTEE_TVP))

$(call soong_config_set,amlogic_vendorconfig,widevine_oemcrypto_level,$(BOARD_WIDEVINE_OEMCRYPTO_LEVEL))

$(call soong_config_set,amlogic_vendorconfig,with_playready_drm,$(BUILD_WITH_PLAYREADY_DRM))

$(call soong_config_set,amlogic_vendorconfig,playready_tvp,$(BOARD_PLAYREADY_TVP))

# for media_ext
$(call soong_config_set,amlogic_vendorconfig,enable_swcodec,$(TARGET_WITH_SWCODEC_EXT))

# for pq compress db
$(call soong_config_set,amlogic_vendorconfig,support_pq_compress_db,$(PRODUCT_SUPPORT_COMPRESS_DB))

# for microphone lights
$(call soong_config_set,amlogic_vendorconfig,build_lights_microphone,$(BOARD_HAS_MICROPHONE_LED))
