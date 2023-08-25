#
# Copyright (C) 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

####################### INPUT PARAMS ######################

#TARGET_PREBUILT_KERNEL

#PREBUILT_KERNEL_PATH

#DEVICE_PRODUCT_PATH

###########################################################
ifeq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
ifeq ($(KERNEL_A32_SUPPORT),true)
TARGET_KERNEL_DIR := 32/4.9
else
TARGET_KERNEL_DIR := 4.9
endif
else ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.4)
ifeq ($(KERNEL_A32_SUPPORT),true)
TARGET_KERNEL_DIR := 32/5.4
else
TARGET_KERNEL_DIR := 5.4
endif
else ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.15)
ifeq ($(KERNEL_A32_SUPPORT),true)
TARGET_KERNEL_DIR := 32/5.15
else
TARGET_KERNEL_DIR := 5.15
endif
endif
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/dtbo.img

###########################################################
ifeq ($(TARGET_BUILD_KERNEL_VERSION),5.15)
RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/vendor_boot.modules.load))
ifeq ($(strip $(RAMDISK_KERNEL_MODULES_LOAD)),)
endif

RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/vendor_recovery.modules.load))
ifeq ($(strip $(RECOVERY_KERNEL_MODULES_LOAD)),)
endif

BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/vendor_dlkm.modules.load))
ifeq ($(strip $(BOARD_VENDOR_KERNEL_MODULES_LOAD)),)
endif

RAMDISK_KERNEL_MODULES_LOAD_EXCLUDELIST +=

RAMDISK_KERNEL_MODULES := $(wildcard $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/*.ko)

RAMDISK_KERNEL_MODULES_LOAD := $(foreach module, $(RAMDISK_KERNEL_MODULES_LOAD), $(wildcard $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/$(module)))

RECOVERY_KERNEL_MODULES := $(wildcard $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/*.ko)
RECOVERY_KERNEL_MODULES_LOAD := $(foreach module, $(RECOVERY_KERNEL_MODULES_LOAD), $(wildcard $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/$(module)))

__LOAD_EXCLUDELIST := $(foreach module, $(RAMDISK_KERNEL_MODULES_LOAD_EXCLUDELIST), $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/$(module))
RAMDISK_KERNEL_MODULES_LOAD := $(filter-out $(__LOAD_EXCLUDELIST), $(RAMDISK_KERNEL_MODULES_LOAD))
RECOVERY_KERNEL_MODULES_LOAD := $(filter-out $(__LOAD_EXCLUDELIST), $(RECOVERY_KERNEL_MODULES_LOAD))

ifeq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES ?= $(RAMDISK_KERNEL_MODULES)
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD ?= $(RAMDISK_KERNEL_MODULES_LOAD)
  BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES ?= $(RECOVERY_KERNEL_MODULES)
  BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD ?= $(RECOVERY_KERNEL_MODULES_LOAD)
else
  BOARD_GENERIC_RAMDISK_KERNEL_MODULES ?= $(RAMDISK_KERNEL_MODULES)
  BOARD_GENERIC_RAMDISK_KERNEL_MODULES_LOAD ?= $(RAMDISK_KERNEL_MODULES_LOAD)
  BOARD_RECOVERY_KERNEL_MODULES ?= $(RAMDISK_KERNEL_MODULES)
  BOARD_RECOVERY_KERNEL_MODULES_LOAD ?= $(RAMDISK_KERNEL_MODULES_LOAD)
endif

else
RAMDISK_KERNEL_MODULES_LOAD_FIRSTLIST += aml_i2c.ko \
					 aml_media.ko \
					 snd-soc-dummy_codec.ko \
					 snd-soc-aml_t9015.ko \
					 snd_soc.ko

RAMDISK_KERNEL_MODULES_LOAD_EXCLUDELIST += dvb_demux.ko \
					 aml_spicc.ko \
					 aml_spifc.ko \
					 meson_spi_nand.ko \
					 meson_mtd_reserve.ko \
					 meson_mtd_nfc.ko \
					 spinand.ko \
					 spi-nor.ko \
					 aml_aucpu.ko

ifneq ($(TARGET_BUILD_KERNEL_VERSION),4.9)
  ifneq ($(KERNEL_A32_SUPPORT),true)
      RAMDISK_KERNEL_MODULES := $(wildcard $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/*.ko)
      RAMDISK_KERNEL_MODULES_LOAD := $(RAMDISK_KERNEL_MODULES)

      __LOAD_FIRSTLIST := $(foreach module, $(RAMDISK_KERNEL_MODULES_LOAD_FIRSTLIST), $(wildcard $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/$(module)))
      RAMDISK_KERNEL_MODULES_LOAD := $(filter-out $(__LOAD_FIRSTLIST), $(RAMDISK_KERNEL_MODULES_LOAD))
      RAMDISK_KERNEL_MODULES_LOAD := $(__LOAD_FIRSTLIST) $(RAMDISK_KERNEL_MODULES_LOAD)

      __LOAD_EXCLUDELIST := $(foreach module, $(RAMDISK_KERNEL_MODULES_LOAD_EXCLUDELIST), $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)/ramdisk/lib/modules/$(module))
      RAMDISK_KERNEL_MODULES_LOAD := $(filter-out $(__LOAD_EXCLUDELIST), $(RAMDISK_KERNEL_MODULES_LOAD))

      ifeq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
        BOARD_VENDOR_RAMDISK_KERNEL_MODULES ?= $(RAMDISK_KERNEL_MODULES)
	BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD ?= $(RAMDISK_KERNEL_MODULES_LOAD)
      else
        BOARD_GENERIC_RAMDISK_KERNEL_MODULES ?= $(RAMDISK_KERNEL_MODULES)
        BOARD_GENERIC_RAMDISK_KERNEL_MODULES_LOAD ?= $(RAMDISK_KERNEL_MODULES_LOAD)
        BOARD_RECOVERY_KERNEL_MODULES ?= $(RAMDISK_KERNEL_MODULES)
        BOARD_RECOVERY_KERNEL_MODULES_LOAD ?= $(RAMDISK_KERNEL_MODULES_LOAD)
      endif
  endif
endif
endif

ifneq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
INSTALLED_2NDBOOTLOADER_TARGET := $(PRODUCT_OUT)/2ndbootloader
endif
ifneq ($(TARGET_GPT_PART),true)
INSTALLED_BOARDDTB_TARGET := $(PRODUCT_OUT)/dt.img
else
INSTALLED_BOARDDTB_TARGET := $(PRODUCT_OUT)/dtb
endif



ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
ifneq ($(PRODUCT_BUILD_SECURE_BOOTLOADER_ONLY),true)
	INSTALLED_BOARDDTB_TARGET := $(INSTALLED_BOARDDTB_TARGET).encrypt
endif #ifneq ($(PRODUCT_BUILD_SECURE_BOOTLOADER_ONLY),true)
endif


INSTALLED_DTBIMAGE_TARGET := $(PRODUCT_OUT)/dtb.img


############ build prebuilt kernel ###############################
PREBUILT_KERNEL_PATH := $(DEVICE_PRODUCT_PATH)-kernel/$(TARGET_KERNEL_DIR)

ifneq ($(TARGET_NO_KERNEL),true)
ifeq ($(KERNEL_A32_SUPPORT), true)
TARGET_PREBUILT_KERNEL :=$(PREBUILT_KERNEL_PATH)/uImage
else
TARGET_PREBUILT_KERNEL :=$(PREBUILT_KERNEL_PATH)/Image.lz4
endif
endif

ifeq ($(TARGET_PRODUCT),ohm_mxl258c)
LOCAL_DTB := $(PREBUILT_KERNEL_PATH)/ohm_mxl258c.dtb
else ifeq ($(TARGET_PRODUCT),oppen_mxl258c)
LOCAL_DTB := $(PREBUILT_KERNEL_PATH)/oppen_mxl258c.dtb
else ifeq ($(TARGET_PRODUCT),oppencas_mxl258c)
LOCAL_DTB := $(PREBUILT_KERNEL_PATH)/oppencas_mxl258c.dtb
else
ifdef PRODUCT_DTB_NAME
LOCAL_DTB := $(PREBUILT_KERNEL_PATH)/$(PRODUCT_DTB_NAME).dtb
else
LOCAL_DTB := $(PREBUILT_KERNEL_PATH)/$(PRODUCT_DIR).dtb
endif
endif
INSTALLED_AVB_DTBIMAGE_TARGET := $(PRODUCT_OUT)/dtb-avb.img

VENDOR_KERNEL_MODULES += \
    $(wildcard $(PREBUILT_KERNEL_PATH)/lib/modules/*.ko)

-include vendor/amlogic/reference/prebuilt/kernel-modules/tuner/tuner_modules.mk
include device/amlogic/common/tcon/tcon_modules.mk
include device/amlogic/common/ldim/ldim_modules.mk
include device/amlogic/common/video_algorithm/dnlp/dnlp_modules.mk
include device/amlogic/common/video_algorithm/hdr10_tmo/hdr10_tmo_modules.mk
include device/amlogic/common/video_algorithm/frc/frc_modules.mk
include device/amlogic/common/soft_afbc/soft_afbc_modules.mk
include device/amlogic/common/video_algorithm/gdc/gdc_modules.mk

BOARD_VENDOR_KERNEL_MODULES ?= $(VENDOR_KERNEL_MODULES)

SOURCE_OPTEE_FILES := $(wildcard $(PREBUILT_KERNEL_PATH)/lib/*.ko)
ifeq ($(BOARD_AML_SOC_TYPE),)
	SOURCE_FIRMWARE_FILES += $(wildcard $(PREBUILT_KERNEL_PATH)/lib/firmware/video/*.bin)
else
	SOURCE_FIRMWARE_FILES += $(wildcard $(PREBUILT_KERNEL_PATH)/lib/firmware/video/$(BOARD_AML_SOC_TYPE)/*.bin)
endif

INSTALLED_FIRMWARE_TARGET := \
    $(PRODUCT_OUT)/vendor/lib/firmware/video/*.bin

$(INSTALLED_FIRMWARE_TARGET): $(SOURCE_FIRMWARE_FILES)
	@echo "cp kernel modules"
	mkdir -p $(PRODUCT_OUT)/vendor/lib/firmware/video
	cp $(PREBUILT_KERNEL_PATH)/lib/firmware/video/checkmsg $(PRODUCT_OUT)/vendor/lib/firmware/video/
ifeq ($(BOARD_AML_SOC_TYPE),)
	cp $(PREBUILT_KERNEL_PATH)/lib/firmware/video/*.bin $(PRODUCT_OUT)/vendor/lib/firmware/video/
 else
	cp $(PREBUILT_KERNEL_PATH)/lib/firmware/video/$(BOARD_AML_SOC_TYPE)/*.bin $(PRODUCT_OUT)/vendor/lib/firmware/video/
endif

ifeq ($(TARGET_BUILD_KERNEL_4_9),true)
INSTALLED_OPTEE_TARGET := \
    $(PRODUCT_OUT)/vendor/lib/optee*.ko

$(INSTALLED_OPTEE_TARGET): $(SOURCE_OPTEE_FILES)
	@echo "cp kernel modules"
	mkdir -p $(PRODUCT_OUT)/vendor/lib/
	cp $(PREBUILT_KERNEL_PATH)/lib/optee_armtz.ko $(PRODUCT_OUT)/vendor/lib/
	cp $(PREBUILT_KERNEL_PATH)/lib/optee.ko $(PRODUCT_OUT)/vendor/lib/
endif

ifneq ($(TARGET_NO_KERNEL),true)
$(INSTALLED_KERNEL_TARGET): $(INSTALLED_BOARDDTB_TARGET) $(TARGET_PREBUILT_KERNEL) $(INSTALLED_FIRMWARE_TARGET) $(INSTALLED_OPTEE_TARGET)
	@echo "cp kernel modules"
	rm -f $(INSTALLED_KERNEL_TARGET)
	cp $(TARGET_PREBUILT_KERNEL) $(INSTALLED_KERNEL_TARGET)
endif

$(INSTALLED_BOARDDTB_TARGET): $(AVBTOOL) $(LOCAL_DTB) $(MINIGZIP) $(INSTALLED_FIRMWARE_TARGET) $(INSTALLED_OPTEE_TARGET) | $(ACP)
	@echo "dtb installed"
	cp $(LOCAL_DTB) $@
	if [ -n "$(shell find $@ -size +180)" ]; then \
		echo "gzip $@ as > 180k"; \
		mv $@ $@.orig && $(MINIGZIP) -c $@.orig > $@; \
	fi;
	$(hide) $(call aml-secureboot-sign-bin, $@)
	@echo "Instaled $@"
ifeq ($(BOARD_AVB_ENABLE),true)
ifneq ($(TARGET_GPT_PART),true)
	$(AVBTOOL) add_hash_footer \
	  --image $@ \
	  --partition_size $(BOARD_DTBIMAGE_PARTITION_SIZE) \
	  --partition_name dt
endif
endif

ifneq ($(BUILDING_VENDOR_BOOT_IMAGE),true)
$(INSTALLED_2NDBOOTLOADER_TARGET): $(LOCAL_DTB) $(BOARD_PREBUILT_DTBOIMAGE) | $(ACP)
	@echo "2ndbootloader installed"
	$(transform-prebuilt-to-target)
endif

$(INSTALLED_DTBIMAGE_TARGET): $(LOCAL_DTB)
	$(transform-prebuilt-to-target)

ifneq ($(KERNEL_A32_SUPPORT),true)
ifeq ($(BOARD_USES_VENDOR_DLKMIMAGE),true)
AML_VENDOR_COPY_FILES := $(PRODUCT_OUT)/vendor_dlkm/lib/modules/system_dlkm.modules.load
LOCAL_SYSTEM_PROP := $(PREBUILT_KERNEL_PATH)/system_dlkm.modules.load
$(AML_VENDOR_COPY_FILES): $(LOCAL_SYSTEM_PROP)
	mkdir -p $(PRODUCT_OUT)/vendor_dlkm/lib/modules/
	$(transform-prebuilt-to-target)
endif

ifeq ($(BOARD_USES_SYSTEM_DLKMIMAGE),true)
AML_SYSTEM_DLKM_COPY_FILES := $(PRODUCT_OUT)/system_dlkm/lib/modules/system_dlkm.modules.load
LOCAL_SYSTEM_PROP := $(PREBUILT_KERNEL_PATH)/system_dlkm.modules.load
$(AML_SYSTEM_DLKM_COPY_FILES): $(LOCAL_SYSTEM_PROP)
	mkdir -p $(PRODUCT_OUT)/system_dlkm/lib/modules/
	cp -a $(PREBUILT_KERNEL_PATH)/gki/lib/modules/* $(PRODUCT_OUT)/system_dlkm/lib/modules/
	$(transform-prebuilt-to-target)
endif
endif

####  Modules depends for build kernel ####
ifneq ($(TARGET_NO_KERNEL),true)
$(PRODUCT_OUT)/ramdisk.img: $(INSTALLED_KERNEL_TARGET)
$(PRODUCT_OUT)/boot.img: $(INSTALLED_KERNEL_TARGET)
# The ko is copied to vendor, must depends on kernel modules
$(PRODUCT_OUT)/vendor.img: $(INSTALLED_KERNEL_TARGET) $(AML_VENDOR_COPY_MODULES)
else
$(PRODUCT_OUT)/ramdisk.img: $(INSTALLED_BOARDDTB_TARGET)
$(PRODUCT_OUT)/boot.img: $(INSTALLED_BOARDDTB_TARGET)
$(PRODUCT_OUT)/vendor.img: $(AML_VENDOR_COPY_MODULES) $(INSTALLED_BOARDDTB_TARGET)
endif

ifneq ($(KERNEL_A32_SUPPORT),true)
ifeq ($(BOARD_USES_VENDOR_DLKMIMAGE),true)
target-files-package: $(AML_VENDOR_COPY_FILES)
$(PRODUCT_OUT)/vendor_dlkm.img: $(AML_VENDOR_COPY_FILES)
endif

ifeq ($(BOARD_USES_SYSTEM_DLKMIMAGE),true)
target-files-package: $(AML_SYSTEM_DLKM_COPY_FILES)
$(PRODUCT_OUT)/installed-files-system_dlkm.txt: $(AML_SYSTEM_DLKM_COPY_FILES)
endif
endif
