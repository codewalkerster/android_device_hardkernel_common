ifdef PRODUCT_DTB_TARGET
ifdef PRODUCT_DTBO_TARGET
ifdef PRODUCT_UBOOT_TARGET

$(info build update fat image with $(PRODUCT_DTB_TARGET), $(PRODUCT_DTBO_TARGET) and $(PRODUCT_UBOOT_TARGET)...)
update_intermediates := $(call intermediates-dir-for,FAKE,hardkernel_update_fat)

update_source_dir := $(update_intermediates)/update_fat
build_update_fat_img := $(update_intermediates)/fat.img
boot_scr := $(PRODUCT_OUT)/boot.scr
selfinstall_boot_scr := $(PRODUCT_OUT)/selfinstall_boot.scr
update_boot_scr := $(PRODUCT_OUT)/update_boot.scr
logo_bmp := $(PRODUCT_OUT)/boot-logo.bmp.gz

dtb_target_file := `echo $(PRODUCT_KERNEL_DTS) | sed s/"_android"//g`

target_partition_size := 19456

MKFS_FAT= device/hardkernel/proprietary/bin/mkfs.fat
AOSP_FAT16COPY := build/make/tools/fat16copy.py

$(build_update_fat_img) : $(boot_scr) $(logo_bmp) $(PRODUCT_DTB_TARGET) $(PRODUCT_UBOOT_TARGET)
	@echo "Build update fat image file $@."
	dd if=/dev/zero of=$(build_update_fat_img) bs=1024 count=$(target_partition_size)
	$(MKFS_FAT) -F16 -n VFAT $(build_update_fat_img)
	mkdir -p $(update_source_dir)/scripts
	cp $(selfinstall_boot_scr) $(update_source_dir)/scripts/selfinstall_boot.scr
	cp $(update_boot_scr) $(update_source_dir)/scripts/update_boot.scr
	cp $(boot_scr) $(update_source_dir)/scripts/boot.scr
	cp $(update_boot_scr) $(update_source_dir)/boot.scr
	cp $(PRODUCT_UBOOT_TARGET) $(update_source_dir)/u-boot.img
	mkdir -p $(update_source_dir)/amlogic
	cp $(PRODUCT_DTB_TARGET) $(update_source_dir)/amlogic/$(dtb_target_file).dtb
	mkdir -p $(update_source_dir)/amlogic/overlays/$(PRODUCT_MODEL)
	cp $(PRODUCT_DTBO_TARGET) $(update_source_dir)/amlogic/overlays/$(PRODUCT_MODEL)
	$(AOSP_FAT16COPY) $(build_update_fat_img) \
		$(update_source_dir)/scripts \
		$(update_source_dir)/boot.scr \
		$(update_source_dir)/u-boot.img \
		$(logo_bmp) \
		$(update_source_dir)/amlogic

INSTALLED_HK_UPDATE_FAT_IMAGE := $(PRODUCT_OUT)/$(notdir $(build_update_fat_img))
$(INSTALLED_HK_UPDATE_FAT_IMAGE) : $(build_update_fat_img)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_HK_UPDATE_FAT_IMAGE)

endif
endif
endif
