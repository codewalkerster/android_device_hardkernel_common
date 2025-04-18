ifdef PRODUCT_DTB_TARGET
ifdef PRODUCT_DTBO_TARGET

$(info build fat image with $(PRODUCT_DTB_TARGET) and $(PRODUCT_DTBO_TARGET)...)
intermediates := $(call intermediates-dir-for,FAKE,hardkernel_fat)

source_dir := $(intermediates)/selfinstall_fat
build_fat_img := $(intermediates)/selfinstall_fat.img
boot_scr := $(PRODUCT_OUT)/boot.scr
selfinstall_boot_scr := $(PRODUCT_OUT)/selfinstall_boot.scr
update_boot_scr := $(PRODUCT_OUT)/update_boot.scr
logo_bmp := $(PRODUCT_OUT)/boot-logo.bmp.gz
gpt_img := $(PRODUCT_OUT)/gpt.img

dtb_target_file := `echo $(PRODUCT_KERNEL_DTS) | sed s/"_android"//g`

target_partition_size := 19456

MKFS_FAT= device/hardkernel/proprietary/bin/mkfs.fat
AOSP_FAT16COPY := build/make/tools/fat16copy.py

$(build_fat_img) : $(boot_scr) $(logo_bmp) $(PRODUCT_DTB_TARGET) $(gpt_img)
	@echo "Build fat image file $@."
	dd if=/dev/zero of=$(build_fat_img) bs=1024 count=$(target_partition_size)
	$(MKFS_FAT) -F16 -n VFAT $(build_fat_img)
	mkdir -p $(source_dir)/scripts
	cp $(selfinstall_boot_scr) $(source_dir)/scripts/selfinstall_boot.scr
	cp $(update_boot_scr) $(source_dir)/scripts/update_boot.scr
	cp $(boot_scr) $(source_dir)/scripts/boot.scr
	cp $(selfinstall_boot_scr) $(source_dir)/boot.scr
	mkdir -p $(source_dir)/amlogic
	cp  $(PRODUCT_DTB_TARGET) $(source_dir)/amlogic/$(dtb_target_file).dtb
	mkdir -p $(source_dir)/amlogic/overlays/$(PRODUCT_MODEL)
	cp $(PRODUCT_DTBO_TARGET) $(source_dir)/amlogic/overlays/$(PRODUCT_MODEL)
	$(AOSP_FAT16COPY) $(build_fat_img) \
		$(source_dir)/scripts \
		$(source_dir)/boot.scr \
		$(gpt_img) \
		$(logo_bmp) \
		$(source_dir)/amlogic

INSTALLED_HK_FAT_IMAGE := $(PRODUCT_OUT)/$(notdir $(build_fat_img))
$(INSTALLED_HK_FAT_IMAGE) : $(build_fat_img)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_HK_FAT_IMAGE)

endif
endif
