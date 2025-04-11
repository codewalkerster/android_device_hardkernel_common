PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hardkernel-720.bmp.gz:$(TARGET_OUT)/boot-logo.bmp.gz

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml

#wiringPi
PRODUCT_PACKAGES += \
    libwiringPi \
    libwiringPiDev \
    gpio

PRODUCT_PACKAGES += \
    Things \
    odroidThings \
    com.google.android.things.xml \
    vendor.hardkernel.hardware.odroidthings@1.0-service

PRODUCT_PACKAGES += \
    KIOSK_Demo
