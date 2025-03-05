# -----------------------------------------------------------------
# odm_ext partition image
ifdef BOARD_ODM_EXTIMAGE_FILE_SYSTEM_TYPE
TARGET_COPY_OUT_ODM_EXT := odm_ext
TARGET_OUT_ODM_EXT := $(PRODUCT_OUT)/$(TARGET_COPY_OUT_ODM_EXT)

INTERNAL_ODM_EXTIMAGE_FILES := \
    $(filter $(TARGET_OUT_ODM_EXT)/%,\
      $(ALL_DEFAULT_INSTALLED_MODULES)\
      $(ALL_PDK_FUSION_FILES)) \
    $(PDK_FUSION_SYMLINK_STAMP)
# platform.zip depends on $(INTERNAL_ODM_EXTIMAGE_FILES).
$(INSTALLED_PLATFORM_ZIP) : $(INTERNAL_ODM_EXTIMAGE_FILES)

TARGET_COPY_ODM_EXT_FILES += $(wildcard $(TVCONFIG_FILES))
TARGET_COPY_ODM_EXT_FILES += $(foreach dir, $(shell find $(TVCONFIG_FILES) -type d), $(wildcard $(dir)/*))
TARGET_COPY_ODM_EXT_FILES += $(PQ_FILES)

INSTALLED_FILES_FILE_ODM_EXT := $(PRODUCT_OUT)/installed-files-odm_ext.txt
INSTALLED_FILES_JSON_ODM_EXT := $(INSTALLED_FILES_FILE_ODM_EXT:.txt=.json)
$(INSTALLED_FILES_FILE_ODM_EXT): .KATI_IMPLICIT_OUTPUTS := $(INSTALLED_FILES_JSON_ODM_EXT)
$(INSTALLED_FILES_FILE_ODM_EXT) : $(INTERNAL_ODM_EXTIMAGE_FILES) $(FILESLIST) $(FILESLIST_UTIL) $(TARGET_COPY_ODM_EXT_FILES)
	@echo Installed file list**: $@
	mkdir -p $(TARGET_OUT_ODM_EXT)/etc/tvconfig
	-cp -rf $(TVCONFIG_FILES) $(TARGET_OUT_ODM_EXT)/etc/tvconfig/
	mkdir -p $(TARGET_OUT_ODM_EXT)/etc/tvconfig/pq
	cp -rf $(PQ_FILES) $(TARGET_OUT_ODM_EXT)/etc/tvconfig/pq/
	@mkdir -p $(dir $@)
	@rm -f $@
	$(hide) $(FILESLIST) $(TARGET_OUT_ODM_EXT) > $(@:.txt=.json)
	$(hide) $(FILESLIST_UTIL) -c $(@:.txt=.json) > $@

odm_extimage_intermediates := \
    $(call intermediates-dir-for,PACKAGING,odm_ext)
BUILT_ODM_EXTIMAGE_TARGET := $(PRODUCT_OUT)/odm_ext.img
# We just build this directly to the install location.
INSTALLED_ODM_EXTIMAGE_TARGET := $(BUILT_ODM_EXTIMAGE_TARGET)

# odm_ext.img currently is a stub impl
$(INSTALLED_ODM_EXTIMAGE_TARGET) : $(INTERNAL_ODM_EXTIMAGE_FILES) $(INTERNAL_USERIMAGES_DEPS) $(INSTALLED_FILES_FILE_ODM_EXT) $(PRODUCT_OUT)/system.img
	$(call pretty,"Target odm_ext fs image::::: $(INSTALLED_ODM_EXTIMAGE_TARGET)")
	@mkdir -p $(TARGET_OUT_ODM_EXT)
	@mkdir -p $(odm_extimage_intermediates) && rm -rf $(odm_extimage_intermediates)/odm_ext_image_info.txt
	mkdir -p $(odm_extimage_intermediates)
	$(hide) echo "# odm_ext info" > $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "mount_point=/mnt/vendor/odm_ext" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "partition_name=odm_ext" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "fs_type=$(BOARD_ODM_EXTIMAGE_FILE_SYSTEM_TYPE)" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "partition_size=$(BOARD_ODM_EXTIMAGE_PARTITION_SIZE)" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "ext_mkuserimg=$(notdir $(MKEXTUSERIMG))" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "avb_avbtool=$(PRIVATE_AVB_AVBTOOL)" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "skip_fsck=true" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) echo "selinux_fc=$(PRODUCT_OUT)/obj/ETC/file_contexts.bin_intermediates/file_contexts.bin" >> $(odm_extimage_intermediates)/odm_ext_image_info.txt
	$(hide) PATH=$(INTERNAL_USERIMAGES_BINARY_PATHS):$$PATH \
		$(BUILD_IMAGE) \
		$(PRODUCT_OUT)/$(TARGET_COPY_OUT_ODM_EXT) $(odm_extimage_intermediates)/odm_ext_image_info.txt $@ $(TARGET_OUT)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_ODM_EXTIMAGE_TARGET)

endif
