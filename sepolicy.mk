BOARD_SEPOLICY_DIRS += \
    device/hardkernel/common/sepolicy

PRODUCT_PRIVATE_SEPOLICY_DIRS += device/hardkernel/common/sepolicy/product/private

ifeq (,$(filter boreal boreal_%,$(TARGET_PRODUCT)))
BOARD_SEPOLICY_DIRS += device/hardkernel/common/sepolicy/factory
endif

ifeq ($(BUILD_WITH_APPLE_AIRPLAY), true)
BOARD_SEPOLICY_DIRS += device/hardkernel/common/sepolicy/airplay
endif
