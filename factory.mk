PRODUCT_UPGRADE_OUT := $(PRODUCT_OUT)/upgrade
AML_EMMC_BIN_GENERATOR := $(BOARD_AML_VENDOR_PATH)/tools/aml_upgrade/amlogic_emmc_bin_maker.sh
PRODUCT_COMMON_DIR := device/hardkernel/common/products/$(PRODUCT_TYPE)

ifeq ($(TARGET_NO_RECOVERY),true)
BUILT_IMAGES := boot.img bootloader.img
else
BUILT_IMAGES := boot.img recovery.img bootloader.img
endif
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	BUILT_IMAGES := $(addsuffix .encrypt, $(BUILT_IMAGES))
endif#ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

BUILT_IMAGES += system.img userdata.img

ifneq ($(AB_OTA_UPDATER),true)
BUILT_IMAGES += cache.img
endif

BUILT_IMAGES += vendor.img
ifeq ($(BOARD_USES_ODMIMAGE),true)
BUILT_IMAGES += odm.img
# Adds the image and the matching map file to <product>-target_files-<build number>.zip, to allow
# generating OTA from target_files.zip (b/111128214).
INSTALLED_RADIOIMAGE_TARGET += $(PRODUCT_OUT)/odm.img $(PRODUCT_OUT)/odm.map
# Adds to <product name>-img-<build number>.zip so can be flashed.  b/110831381
BOARD_PACK_RADIOIMAGES += odm.img odm.map
endif

ifeq ($(BOARD_USES_PRODUCTIMAGE),true)
BUILT_IMAGES += product.img
endif

ifeq ($(BUILD_WITH_AVB),true)
BUILT_IMAGES += vbmeta.img
endif

ifeq ($(strip $(HAS_BUILD_NUMBER)),false)
  # BUILD_NUMBER has a timestamp in it, which means that
  # it will change every time.  Pick a stable value.
  FILE_NAME := eng.$(USER)
else
  FILE_NAME := $(file <$(BUILD_NUMBER_FILE))
endif

AML_TARGET := $(PRODUCT_OUT)/obj/PACKAGING/target_files_intermediates/$(TARGET_PRODUCT)-target_files-$(FILE_NAME)

# -----------------------------------------------------------------
# odm partition image
ifdef BOARD_ODMIMAGE_FILE_SYSTEM_TYPE
INTERNAL_ODMIMAGE_FILES := \
    $(filter $(TARGET_OUT_ODM)/%,$(ALL_DEFAULT_INSTALLED_MODULES))

odmimage_intermediates := \
    $(call intermediates-dir-for,PACKAGING,odm)
BUILT_ODMIMAGE_TARGET := $(PRODUCT_OUT)/odm.img
# We just build this directly to the install location.
INSTALLED_ODMIMAGE_TARGET := $(BUILT_ODMIMAGE_TARGET)

# odm.img currently is a stub impl
$(INSTALLED_ODMIMAGE_TARGET) : $(INTERNAL_ODMIMAGE_FILES) $(PRODUCT_OUT)/system.img
	$(call pretty,"Target odm fs image: $(INSTALLED_ODMIMAGE_TARGET)")
	@mkdir -p $(TARGET_OUT_ODM)
	@mkdir -p $(odmimage_intermediates) && rm -rf $(odmimage_intermediates)/odm_image_info.txt
	$(call generate-userimage-prop-dictionary, $(odmimage_intermediates)/odm_image_info.txt, skip_fsck=true)
	PATH=$(HOST_OUT_EXECUTABLES):$$PATH \
	 mkuserimg_mke2fs.sh -s $(PRODUCT_OUT)/odm $(INSTALLED_ODMIMAGE_TARGET) $(BOARD_ODMIMAGE_FILE_SYSTEM_TYPE) \
	 odm $(BOARD_ODMIMAGE_PARTITION_SIZE) -j 0 -T 1230739200 -B $(PRODUCT_OUT)/odm.map -L odm -M 0 \
	 $(PRODUCT_OUT)/obj/ETC/file_contexts.bin_intermediates/file_contexts.bin
	#mke2fs -s -T -1 -S $(PRODUCT_OUT)/obj/ETC/file_contexts.bin_intermediates/file_contexts.bin -L odm -l $(BOARD_ODMIMAGE_PARTITION_SIZE) -a odm $(INSTALLED_ODMIMAGE_TARGET) $(PRODUCT_OUT)/odm $(PRODUCT_OUT)/system
	$(hide) $(call assert-max-image-size,$(INSTALLED_ODMIMAGE_TARGET),$(BOARD_ODMIMAGE_PARTITION_SIZE))
	-cp $(PRODUCT_OUT)/odm.map $(AML_TARGET)/IMAGES/
	-cp $(PRODUCT_OUT)/odm.img $(AML_TARGET)/IMAGES/

# We need a (implicit) rule for odm.map, in order to support the INSTALLED_RADIOIMAGE_TARGET above.
$(INSTALLED_ODMIMAGE_TARGET): .KATI_IMPLICIT_OUTPUTS := $(PRODUCT_OUT)/odm.map

.PHONY: odm_image
odm_image : $(INSTALLED_ODMIMAGE_TARGET)
$(call dist-for-goals, odm_image, $(INSTALLED_ODMIMAGE_TARGET))

endif

UPGRADE_FILES := \
        aml_sdc_burn.ini \
        ddr_init.bin \
	u-boot.bin.sd.bin  u-boot.bin.usb.bl2 u-boot.bin.usb.tpl \
        u-boot-comp.bin

ifneq ($(TARGET_USE_SECURITY_MODE),true)
UPGRADE_FILES += \
        platform.conf
else # secureboot mode
UPGRADE_FILES += \
        u-boot-usb.bin.aml \
        platform_enc.conf
endif

UPGRADE_FILES := $(addprefix $(TARGET_DEVICE_DIR)/upgrade/,$(UPGRADE_FILES))
UPGRADE_FILES := $(wildcard $(UPGRADE_FILES)) #extract only existing files for burnning

PACKAGE_CONFIG_FILE := aml_upgrade_package
ifeq ($(AB_OTA_UPDATER),true)
	PACKAGE_CONFIG_FILE := $(PACKAGE_CONFIG_FILE)_AB
endif # ifeq ($(AB_OTA_UPDATER),true)
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	PACKAGE_CONFIG_FILE := $(PACKAGE_CONFIG_FILE)_enc
endif # ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
ifeq ($(BUILD_WITH_AVB),true)
	PACKAGE_CONFIG_FILE := $(PACKAGE_CONFIG_FILE)_avb
endif
PACKAGE_CONFIG_FILE := $(TARGET_DEVICE_DIR)/upgrade/$(PACKAGE_CONFIG_FILE).conf

ifeq ($(wildcard $(PACKAGE_CONFIG_FILE)),)
	PACKAGE_CONFIG_FILE := $(PRODUCT_COMMON_DIR)/upgrade_4.9/$(notdir $(PACKAGE_CONFIG_FILE))
endif ## ifeq ($(wildcard $(TARGET_DEVICE_DIR)/upgrade/$(PACKAGE_CONFIG_FILE)))
UPGRADE_FILES += $(PACKAGE_CONFIG_FILE)

BOARD_AUTO_COLLECT_MANIFEST := false
ifneq ($(BOARD_AUTO_COLLECT_MANIFEST),false)
BUILD_TIME := $(shell date +%Y-%m-%d--%H-%M)
INSTALLED_MANIFEST_XML := $(PRODUCT_OUT)/manifests/manifest-$(BUILD_TIME).xml
$(INSTALLED_MANIFEST_XML):
	$(hide) mkdir -p $(PRODUCT_OUT)/manifests
	$(hide) mkdir -p $(PRODUCT_OUT)/upgrade
	# Below fails on google build servers, perhaps because of older version of repo installed
	repo manifest -r -o $(INSTALLED_MANIFEST_XML)
	$(hide) cp $(INSTALLED_MANIFEST_XML) $(PRODUCT_OUT)/upgrade/manifest.xml

.PHONY:build_manifest
build_manifest:$(INSTALLED_MANIFEST_XML)
else
INSTALLED_MANIFEST_XML :=
endif

INSTALLED_AML_USER_IMAGES :=
ifeq ($(TARGET_BUILD_USER_PARTS),true)
define aml-mk-user-img-template
INSTALLED_AML_USER_IMAGES += $(2)
$(eval tempUserSrcDir := $$($(strip $(1))_PART_DIR))
$(2): $(call intermediates-dir-for,ETC,file_contexts.bin)/file_contexts.bin $(MAKE_EXT4FS) $(shell find $(tempUserSrcDir) -type f)
	@echo $(MAKE_EXT4FS) -s -S $$< -l $$($(strip $(1))_PART_SIZE) -a $(1) $$@  $(tempUserSrcDir) && \
	$(MAKE_EXT4FS) -s -S $$< -l $$($(strip $(1))_PART_SIZE) -a $(1) $$@  $(tempUserSrcDir)
endef
.PHONY:contexts_add
contexts_add:$(TARGET_ROOT_OUT)/file_contexts
	$(foreach userPartName, $(BOARD_USER_PARTS_NAME), \
		$(shell sed -i "/\/$(strip $(userPartName))/d" $< && \
		echo -e "/$(strip $(userPartName))(/.*)?      u:object_r:system_file:s0" >> $<))
$(foreach userPartName, $(BOARD_USER_PARTS_NAME), \
	$(eval $(call aml-mk-user-img-template, $(userPartName),$(PRODUCT_OUT)/$(userPartName).img)))

define aml-user-img-update-pkg
	ln -sf $(TOP)/$(PRODUCT_OUT)/$(1).img $(PRODUCT_UPGRADE_OUT)/$(1).img && \
	sed -i "/file=\"$(1)\.img\"/d" $(2) && \
	echo -e "file=\"$(1).img\"\t\tmain_type=\"PARTITION\"\t\tsub_type=\"$(1)\"" >> $(2) ;
endef

.PHONY: aml_usrimg
aml_usrimg :$(INSTALLED_AML_USER_IMAGES)
endif # ifeq ($(TARGET_BUILD_USER_PARTS),true)

INSTALLED_AMLOGIC_BOOTLOADER_TARGET := $(PRODUCT_OUT)/bootloader.img
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	INSTALLED_AMLOGIC_BOOTLOADER_TARGET := $(INSTALLED_AMLOGIC_BOOTLOADER_TARGET).encrypt
endif# ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

INSTALLED_AML_FASTBOOT_ZIP := $(PRODUCT_OUT)/$(TARGET_PRODUCT)-fastboot-flashall-$(BUILD_NUMBER).zip
$(warning will keep $(INSTALLED_AML_FASTBOOT_ZIP))
$(call dist-for-goals, droidcore, $(INSTALLED_AML_FASTBOOT_ZIP))

FASTBOOT_IMAGES := boot.img
ifneq ($(TARGET_NO_RECOVERY),true)
	FASTBOOT_IMAGES += recovery.img
endif
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	FASTBOOT_IMAGES := $(addsuffix .encrypt, $(FASTBOOT_IMAGES))
endif#ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

FASTBOOT_IMAGES += android-info.txt system.img

FASTBOOT_IMAGES += vendor.img dt.img

ifeq ($(BOARD_USES_PRODUCTIMAGE),true)
FASTBOOT_IMAGES += product.img
endif

ifeq ($(BUILD_WITH_AVB),true)
	FASTBOOT_IMAGES += vbmeta.img
endif

FASTBOOT_IMAGES += u-boot.bin odm.img

.PHONY:aml_fastboot_zip
aml_fastboot_zip:$(INSTALLED_AML_FASTBOOT_ZIP)
$(INSTALLED_AML_FASTBOOT_ZIP): $(addprefix $(PRODUCT_OUT)/,$(FASTBOOT_IMAGES)) $(BUILT_ODMIMAGE_TARGET)
	echo "install $@"
	rm -rf $(PRODUCT_OUT)/fastboot
	mkdir -p $(PRODUCT_OUT)/fastboot
	cd $(PRODUCT_OUT); cp $(FASTBOOT_IMAGES) fastboot/;
ifeq ($(TARGET_PRODUCT),ampere)
	echo "board=p212" > $(PRODUCT_OUT)/fastboot/android-info.txt
endif
ifeq ($(TARGET_PRODUCT),braun)
	echo "board=p230" > $(PRODUCT_OUT)/fastboot/android-info.txt
endif
ifeq ($(TARGET_PRODUCT),curie)
	echo "board=p241" > $(PRODUCT_OUT)/fastboot/android-info.txt
endif
ifeq ($(TARGET_PRODUCT),darwin)
	echo "board=txlx_skt" > $(PRODUCT_OUT)/fastboot/android-info.txt
endif
ifeq ($(TARGET_PRODUCT),einstein)
	echo "board=txlx_r311" > $(PRODUCT_OUT)/fastboot/android-info.txt
endif
ifeq ($(TARGET_PRODUCT),galilei)
	echo "board=g12b_w400" > $(PRODUCT_OUT)/fastboot/android-info.txt
endif
ifeq ($(TARGET_PRODUCT),atom)
	echo "board=atom" > $(PRODUCT_OUT)/fastboot/android-info.txt
endif
	cd $(PRODUCT_OUT)/fastboot; zip -r ../$(TARGET_PRODUCT)-fastboot-image-$(BUILD_NUMBER).zip $(FASTBOOT_IMAGES)
	#zipnote $@ | sed 's/@ \([a-z]*.img\).encrypt/&\n@=\1\n/' | zipnote -w $@
	rm -rf $(PRODUCT_OUT)/fastboot_auto
	mkdir -p $(PRODUCT_OUT)/fastboot_auto
	cd $(PRODUCT_OUT); cp $(FASTBOOT_IMAGES) fastboot_auto/
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	cp $(PRODUCT_OUT)/bootloader.img.encrypt $(PRODUCT_OUT)/fastboot_auto/
else
	cp $(PRODUCT_OUT)/bootloader.img $(PRODUCT_OUT)/fastboot_auto/
endif
	cp $(PRODUCT_OUT)/odm.img $(PRODUCT_OUT)/fastboot_auto/
ifeq ($(AB_OTA_UPDATER),true)
	cp device/hardkernel/common/flash-all-ab.sh $(PRODUCT_OUT)/fastboot_auto/flash-all.sh
	cp device/hardkernel/common/flash-all-ab.bat $(PRODUCT_OUT)/fastboot_auto/flash-all.bat
else
	cp device/hardkernel/common/flash-all.sh $(PRODUCT_OUT)/fastboot_auto/
	cp device/hardkernel/common/flash-all.bat $(PRODUCT_OUT)/fastboot_auto/
endif
	sed -i 's/fastboot update fastboot.zip/fastboot update $(TARGET_PRODUCT)-fastboot-image-$(BUILD_NUMBER).zip/' $(PRODUCT_OUT)/fastboot_auto/flash-all.sh
	sed -i 's/fastboot update fastboot.zip/fastboot update $(TARGET_PRODUCT)-fastboot-image-$(BUILD_NUMBER).zip/' $(PRODUCT_OUT)/fastboot_auto/flash-all.bat
	cd $(PRODUCT_OUT)/fastboot_auto; zip -r ../$(TARGET_PRODUCT)-fastboot-flashall-$(BUILD_NUMBER).zip *


name := $(TARGET_PRODUCT)
ifeq ($(TARGET_BUILD_TYPE),debug)
  name := $(name)_debug
endif
name := $(name)-ota-amlogic-$(BUILD_NUMBER)

AMLOGIC_OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/$(name).zip

$(AMLOGIC_OTA_PACKAGE_TARGET): KEY_CERT_PAIR := $(DEFAULT_KEY_CERT_PAIR)

ifeq ($(AB_OTA_UPDATER),true)
$(AMLOGIC_OTA_PACKAGE_TARGET): $(BRILLO_UPDATE_PAYLOAD)
else
$(AMLOGIC_OTA_PACKAGE_TARGET): $(BRO)
endif

EXTRA_SCRIPT := $(TARGET_DEVICE_DIR)/../../../device/hardkernel/common/recovery/updater-script

$(AMLOGIC_OTA_PACKAGE_TARGET): $(AML_TARGET).zip $(BUILT_ODMIMAGE_TARGET)
	@echo "Package OTA2: $@"
ifeq ($(BOARD_USES_ODMIMAGE),true)
	@echo "copy $(INSTALLED_ODMIMAGE_TARGET)"
	mkdir -p $(AML_TARGET)/IMAGES
	cp $(INSTALLED_ODMIMAGE_TARGET) $(AML_TARGET)/IMAGES/
	cp $(PRODUCT_OUT)/odm.map $(AML_TARGET)/IMAGES/

	mkdir -p $(AML_TARGET)/META
	echo "odm_fs_type=$(BOARD_ODMIMAGE_FILE_SYSTEM_TYPE)" >> $(AML_TARGET)/META/misc_info.txt
	echo "odm_size=$(BOARD_ODMIMAGE_PARTITION_SIZE)" >> $(AML_TARGET)/META/misc_info.txt
	echo "odm_journal_size=$(BOARD_ODMIMAGE_JOURNAL_SIZE)" >> $(AML_TARGET)/META/misc_info.txt
	echo "odm_extfs_inode_count=$(BOARD_ODMIMAGE_EXTFS_INODE_COUNT)" >> $(AML_TARGET)/META/misc_info.txt
	mkdir -p $(AML_TARGET)/ODM
	cp -a $(PRODUCT_OUT)/odm/* $(AML_TARGET)/ODM/
endif
ifneq ($(INSTALLED_AMLOGIC_BOOTLOADER_TARGET),)
	@echo "copy $(INSTALLED_AMLOGIC_BOOTLOADER_TARGET)"
	mkdir -p $(AML_TARGET)/IMAGES
	cp $(INSTALLED_AMLOGIC_BOOTLOADER_TARGET) $(AML_TARGET)/IMAGES/bootloader.img
endif
ifneq ($(INSTALLED_AML_LOGO),)
	@echo "copy $(INSTALLED_AML_LOGO)"
	mkdir -p $(AML_TARGET)/IMAGES
	cp $(INSTALLED_AML_LOGO) $(AML_TARGET)/IMAGES/
endif
ifeq ($(strip $(TARGET_OTA_UPDATE_DTB)),true)
	@echo "copy $(INSTALLED_BOARDDTB_TARGET)"
	mkdir -p $(AML_TARGET)/IMAGES
	cp $(INSTALLED_BOARDDTB_TARGET) $(AML_TARGET)/IMAGES/
endif
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY), true)
	@echo "PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY is $(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY)"
	mkdir -p $(AML_TARGET)/IMAGES
	cp $(INSTALLED_BOOTIMAGE_TARGET)            $(AML_TARGET)/IMAGES/boot.img
	-cp $(INSTALLED_RECOVERYIMAGE_TARGET)        $(AML_TARGET)/IMAGES/recovery.img
else
	-cp $(PRODUCT_OUT)/recovery.img $(AML_TARGET)/IMAGES/recovery.img
endif
	$(hide) PATH=$(foreach p,$(INTERNAL_USERIMAGES_BINARY_PATHS),$(p):)$$PATH MKBOOTIMG=$(MKBOOTIMG) \
	   ./device/hardkernel/common/ota_amlogic.py -v \
	   --block \
	   --extracted_input_target_files $(patsubst %.zip,%,$(BUILT_TARGET_FILES_PACKAGE)) \
	   -p $(HOST_OUT) \
	   -k $(DEFAULT_KEY_CERT_PAIR) \
	   $(if $(OEM_OTA_CONFIG), -o $(OEM_OTA_CONFIG)) \
	   $(BUILT_TARGET_FILES_PACKAGE) $@

.PHONY: ota_amlogic
ota_amlogic: $(AMLOGIC_OTA_PACKAGE_TARGET)

droidcore: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML) $(INSTALLED_AML_FASTBOOT_ZIP)
otapackage: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML) $(INSTALLED_AML_FASTBOOT_ZIP)
ota_amlogic: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML) $(INSTALLED_AML_FASTBOOT_ZIP) otapackage
