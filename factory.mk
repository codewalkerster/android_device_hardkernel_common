IMGPACK := $(BUILD_OUT_EXECUTABLES)/logo_img_packer$(BUILD_EXECUTABLE_SUFFIX)
TARGET_PRODUCT_DIR := device/hardkernel/$(TARGET_PRODUCT)
PRODUCT_UPGRADE_OUT := $(PRODUCT_OUT)/upgrade

BUILT_IMAGES := boot.img recovery.img system.img userdata.img cache.img

UPGRADE_FILES := aml_upgrade_package.conf \
        aml_upgrade_package_enc.conf \
        aml_sdc_burn.ini \
        ddr_init.bin \
        u-boot-comp.bin \
        u-boot.bin \
        platform.conf

ifneq ($(TARGET_AMLOGIC_RES_PACKAGE),)
INSTALLED_AML_LOGO := $(PRODUCT_UPGRADE_OUT)/logo.img
$(INSTALLED_AML_LOGO): $(IMGPACK)
	@echo
	@echo "generate $(INSTALLED_AML_LOGO)"
	@echo
	mkdir -p $(PRODUCT_UPGRADE_OUT)
	$(IMGPACK) -r $(TARGET_AMLOGIC_RES_PACKAGE) $(INSTALLED_AML_LOGO)
else
INSTALLED_AML_LOGO :=
endif

.PHONY: logoimg
logoimg: $(INSTALLED_AML_LOGO)

ifneq ($(BOARD_AUTO_COLLECT_MANIFEST),false)
BUILD_TIME := $(shell date +%Y-%m-%d--%H-%M)
INSTALLED_MANIFEST_XML := $(PRODUCT_OUT)/manifests/manifest-$(BUILD_TIME).xml
$(INSTALLED_MANIFEST_XML):
	$(hide) mkdir -p $(PRODUCT_OUT)/manifests
	$(hide) mkdir -p $(PRODUCT_OUT)/upgrade
	repo manifest -r -o $(INSTALLED_MANIFEST_XML)
	$(hide) cp $(INSTALLED_MANIFEST_XML) $(PRODUCT_OUT)/upgrade/manifest.xml

.PHONY:build_manifest
build_manifest:$(INSTALLED_MANIFEST_XML)
else
INSTALLED_MANIFEST_XML :=
endif

ifeq ($(TARGET_SUPPORT_USB_BURNING_V2),true)
INSTALLED_AML_UPGRADE_PACKAGE_TARGET := $(PRODUCT_OUT)/aml_upgrade_package.img

ifeq ($(TARGET_USE_SECURITY_MODE),true)
  PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/aml_upgrade_package_enc.conf
else
  PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/aml_upgrade_package.conf
endif

ifeq ($(KERNEL_DEVICETREE),)
$(warning KERNEL_DEVICETREE is empty)
define update-aml_upgrade-conf
endef
else
ifneq ($(words $(KERNEL_DEVICETREE)),1)
define update-aml_upgrade-conf
	@echo "update-aml_upgrade_conf for multi-dtd";
	@sed -i "/meson.*\.dtd/d" $(PACKAGE_CONFIG_FILE);
	@sed -i "s/meson.*\.dtb/dt.img/" $(PACKAGE_CONFIG_FILE);
	$(hide) $(foreach dtd_file,$(KERNEL_DEVICETREE), \
		sed -i "0,/aml_sdc_burn\.ini/ s/file=\"aml_sdc_burn\.ini\".*/&\n&/" $(PACKAGE_CONFIG_FILE); \
		sed -i "0,/aml_sdc_burn\.ini/ s/ini\"/dtd\"/g" $(PACKAGE_CONFIG_FILE); \
		sed -i "0,/aml_sdc_burn\.dtd/ s/aml_sdc_burn/$(dtd_file)/g" $(PACKAGE_CONFIG_FILE); \
	)
endef
else
define update-aml_upgrade-conf
endef
endif
endif

.PHONY:aml_upgrade
aml_upgrade:$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET): \
	$(addprefix $(PRODUCT_OUT)/,$(BUILT_IMAGES)) \
	$(INSTALLED_AML_LOGO) \
	$(INSTALLED_MANIFEST_XML) \
	$(TARGET_USB_BURNING_V2_DEPEND_MODULES)
	mkdir -p $(PRODUCT_UPGRADE_OUT)
	$(hide) $(foreach file,$(UPGRADE_FILES), \
		if [ -f "$(TARGET_DEVICE_DIR)/upgrade/$(file)" ]; then \
			echo cp $(TARGET_DEVICE_DIR)/upgrade/$(file) $(PRODUCT_UPGRADE_OUT); \
			cp $(TARGET_DEVICE_DIR)/upgrade/$(file) $(PRODUCT_UPGRADE_OUT); \
		fi;)
	-cp $(TARGET_DEVICE_DIR)/u-boot.bin $(PRODUCT_UPGRADE_OUT)
	$(hide) $(foreach file,$(BUILT_IMAGES), \
		if [ -f "$(PRODUCT_OUT)/$(file)" ]; then \
			echo ln -s $(PRODUCT_OUT)/$(file) $(PRODUCT_UPGRADE_OUT)/$(file); \
			rm $(PRODUCT_UPGRADE_OUT)/$(file); \
			ln -s $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/$(file) $(PRODUCT_UPGRADE_OUT)/$(file); \
		fi;)
	$(update-aml_upgrade-conf)
	@echo "Package: $@"
	@echo ./vendor/amlogic/tools/aml_upgrade/aml_image_v2_packer -r \
		$(PACKAGE_CONFIG_FILE) \
		$(PRODUCT_UPGRADE_OUT)/ \
		$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
	$(hide) ./vendor/amlogic/tools/aml_upgrade/aml_image_v2_packer -r \
		$(PACKAGE_CONFIG_FILE) \
		$(PRODUCT_UPGRADE_OUT)/ \
		$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
	@echo " $@ installed"
else
#none
INSTALLED_AML_UPGRADE_PACKAGE_TARGET :=
endif

droidcore: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML)
otapackage: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML)

