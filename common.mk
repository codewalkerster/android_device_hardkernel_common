include device/odroidn1/common/BoardConfig.mk
$(call inherit-product, device/odroidn1/common/device.mk)

PRODUCT_BRAND := ODROID
PRODUCT_DEVICE := odroidn1
PRODUCT_NAME := odroidn1
PRODUCT_MODEL := ODROID-N1
PRODUCT_MANUFACTURER := HardKernel Co., Ltd.


PRODUCT_PROPERTY_OVERRIDES += \
			ro.product.version = 1.0.0 \
			ro.product.ota.host = www.rockchip.com:2300
