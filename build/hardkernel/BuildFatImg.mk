ifdef PRODUCT_DTB_TARGET
ifdef PRODUCT_DTBO_TARGET

$(info build fat image with $(PRODUCT_DTB_TARGET) and $(PRODUCT_DTBO_TARGET)...)
intermediates := $(call intermediates-dir-for,FAKE,hardkernel_fat)

source_dir := $(intermediates)/fat
build_fat_img := $(intermediates)/fat.img
build_boot_scr := $(intermediates)/boot.scr

target_partition_size := 16384

MKFS_FAT= device/hardkernel/proprietary/bin/mkfs.fat
AOSP_FAT16COPY := build/make/tools/fat16copy.py
BOOT_SCRIPT_TOOL := device/hardkernel/common/boot_script/mkbootscript.sh

$(build_boot_scr) : $(PRODUCT_OUT)/boot.cmd
	$(BOOT_SCRIPT_TOOL) $^ $(build_boot_scr)

$(build_fat_img) : $(build_boot_scr) $(PRODUCT_DTB_TARGET)
	@echo "Build dtb image file $@."
	dd if=/dev/zero of=$(build_fat_img) bs=1024 count=$(target_partition_size)
	$(MKFS_FAT) -F16 -n VFAT $(build_fat_img)
	mkdir -p $(source_dir)/rockchip
	cp  $(PRODUCT_DTB_TARGET) $(source_dir)/rockchip
	mkdir -p $(source_dir)/rockchip/overlays/$(PRODUCT_MODEL)
	cp $(PRODUCT_DTBO_TARGET) $(source_dir)/rockchip/overlays/$(PRODUCT_MODEL)
	$(AOSP_FAT16COPY) $(build_fat_img) \
		$(build_boot_scr) \
		$(source_dir)/rockchip

INSTALLED_HK_FAT_IMAGE := $(PRODUCT_OUT)/$(notdir $(build_fat_img))
$(INSTALLED_HK_FAT_IMAGE) : $(build_fat_img)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_HK_FAT_IMAGE)

endif
endif
