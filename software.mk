ifeq ($(BOARD_SUPPORT_INSTABOOT), true)

PRODUCT_PROPERTY_OVERRIDES += \
    config.disable_instaboot=false

instaboot_config_file := $(wildcard $(LOCAL_PATH)/instaboot_config.xml)

PRODUCT_COPY_FILES += \
    $(instaboot_config_file):system/etc/instaboot_config.xml

WITH_DEXPREOPT := true
WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += instabootserver
endif
