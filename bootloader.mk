BUILT_BOOTLOADER_TARGET := $(PRODUCT_OUT)/u-boot.bin

INSTALLED_BOOTLOADER_TARGET := $(BUILT_BOOTLOADER_TARGET)

$(INSTALLED_BOOTLOADER_TARGET): bootloader/uboot/sd_fuse/u-boot.bin
	$(hide) cp -a $< $@
	@echo "make $@: bootloader installed end"

ifeq ($(TARGET_PRODUCT), odroidhc4)
bootloader/uboot/sd_fuse/u-boot.bin:
	make -C bootloader/uboot distclean
	make -C bootloader/uboot odroidc4_config
	make -C bootloader/uboot bootimage
else
bootloader/uboot/sd_fuse/u-boot.bin:
	make -C bootloader/uboot distclean
	make -C bootloader/uboot $(TARGET_PRODUCT)_config
	make -C bootloader/uboot bootimage
endif

.PHONY: build_bootloader
build_bootloader: $(INSTALLED_BOOTLOADER_TARGET)
