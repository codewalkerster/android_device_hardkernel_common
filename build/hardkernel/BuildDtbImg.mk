ifdef PRODUCT_DTB_TARGET

$(info build dtb image with $(PRODUCT_DTB_TARGET)...)
intermediates := $(call intermediates-dir-for,FAKE,hardkernel_dtb)

source_dir := $(intermediates)/dtb
build_dtb_img := $(intermediates)/dtb.img
target_partition_size := 4194304

AOSP_MK2FS_TOOL := $(SOONG_HOST_OUT_EXECUTABLES)/mke2fs
AOSP_E2FSDROID_TOOL := $(SOONG_HOST_OUT_EXECUTABLES)/e2fsdroid

$(build_dtb_img) : $(PRODUCT_DTB_TARGET)
	@echo "Build dtb image file $@."
	$(AOSP_MK2FS_TOOL) -M /dtb -t ext4 -b 4096 $(build_dtb_img) 1024
	mkdir $(source_dir)
	cp  $(PRODUCT_DTB_TARGET) $(source_dir)
	$(AOSP_E2FSDROID_TOOL) -e -f $(source_dir) -a /dtb $(build_dtb_img)

INSTALLED_HK_DTB_IMAGE := $(PRODUCT_OUT)/$(notdir $(build_dtb_img))
$(INSTALLED_HK_DTB_IMAGE) : $(build_dtb_img)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_HK_DTB_IMAGE)
endif
