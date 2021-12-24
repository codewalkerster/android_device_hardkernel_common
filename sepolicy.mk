$(warning current build platform is $(PLATFORM_VERSION))
BOARD_SEPOLICY_DIRS += \
    device/amlogic/common/sepolicy

PRODUCT_PRIVATE_SEPOLICY_DIRS += device/amlogic/common/sepolicy/product/private

ifeq (,$(filter boreal boreal_%,$(TARGET_PRODUCT)))
BOARD_SEPOLICY_DIRS += device/amlogic/common/sepolicy/factory
endif
