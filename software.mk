#PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1

ifeq ($(TARGET_BUILD_CTS), true)

#ADDITIONAL_DEFAULT_PROPERTIES += ro.vold.forceencryption=1
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:system/etc/permissions/android.software.voice_recognizers.xml \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:system/etc/permissions/android.hardware.screen.landscape.xml

ifeq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_COPY_FILES += \
    device/hardkernel/common/android.software.google_atv.xml:system/etc/permissions/android.software.google_atv.xml
PRODUCT_PACKAGE_OVERLAYS += device/hardkernel/common/gms_overlay
PRODUCT_PACKAGES += \
    GooglePackageInstaller

$(call add-clean-step, rm -rf $(OUT_DIR)/system/priv-app/DLNA)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.app.rotation=original \
    media.amplayer.widevineenable=true

#WITH_DEXPREOPT := true
#WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += \
    Contacts \
    TvProvider \
    Bluetooth \
    PrintSpooler \
    DownloadProviderUi \
    Calendar \
    QuickSearchBox
else
PRODUCT_PACKAGES += \
    libfwdlockengine

endif

ifeq ($(TARGET_BUILD_NETFLIX), true)
PRODUCT_COPY_FILES += \
	device/hardkernel/common/droidlogic.software.netflix.xml:system/etc/permissions/droidlogic.software.netflix.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.nrdp.modelgroup=P212ATV
endif
