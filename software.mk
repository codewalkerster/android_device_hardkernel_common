
PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1

ifeq ($(TARGET_BUILD_CTS), true)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.app.rotation=original

WITH_DEXPREOPT := true
WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += \
    Contacts \
    Bluetooth \
    DownloadProviderUi \
    Calendar \
    QuickSearchBox
endif

