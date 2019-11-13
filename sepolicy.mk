BOARD_SEPOLICY_DIRS += \
    device/hardkernel/common/sepolicy \
    device/hardkernel/common/sepolicy/aml_core
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
BOARD_SEPOLICY_DIRS += \
    device/google/atv/sepolicy
endif
