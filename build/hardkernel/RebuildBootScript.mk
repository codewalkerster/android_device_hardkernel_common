ifdef PRODUCT_BOOTSCRIPT_TEMPLATE
ifdef PRODUCT_BOOTSCRIPT_DTB_TEMPLATE
ifdef PRODUCT_BOOTSCRIPT_INI_TEMPLATE

$(info build boot.cmd with $(PRODUCT_BOOTSCRIPT_TEMPLATE), $(PRODUCT_BOOTSCRIPT_DTB_TEMPLATE) and $(PRODUCT_BOOTSCRIPT_INI_TEMPLATE)...)

recovery_part := 7
wifi_country := US
mtd := "sfc_nor:0x20000@0xe0000(env),0x200000@0x100000(uboot),0x100000@0x300000(splash),0xc00000@0x400000(firmware)"
target_board := $(PRODUCT_MODEL)
target_dtb := `echo $(PRODUCT_KERNEL_DTS) | sed s/"_android"//g`
emmc_boot_device := $(PRODUCT_BOOT_DEVICE)
sd_boot_device := $(PRODUCT_SDMMC_DEVICE)

ifeq ($(AB_OTA_UPDATER), true)
active_slot := _a
else
active_slot := normal
endif

intermediates := $(call intermediates-dir-for,FAKE,hardkernel_bootscript)
rebuild_bootscript := $(intermediates)/boot.cmd
rebuild_bootscr := $(intermediates)/boot.scr

HARDKERNEL_BOOTSCRIP_TOOLS := $(SOONG_HOST_OUT_EXECUTABLES)/bootscript_tools
BOOT_SCRIPT_TOOL := device/hardkernel/common/boot_script/mkbootscript.sh

$(rebuild_bootscript) : $(PRODUCT_BOOTSCRIPT_TEMPLATE) $(HARDKERNEL_BOOTSCRIP_TOOLS)
	@echo "Building boot.cmd $@."
	$(HARDKERNEL_BOOTSCRIP_TOOLS) --input $(PRODUCT_BOOTSCRIPT_TEMPLATE) \
	--input_dtb_subscript $(PRODUCT_BOOTSCRIPT_DTB_TEMPLATE) \
	--input_ini_subscript $(PRODUCT_BOOTSCRIPT_INI_TEMPLATE) \
	--variant $(TARGET_BUILD_VARIANT) \
	--recovery-part $(recovery_part) \
	--wifi-country $(wifi_country) \
	--mtd $(mtd) \
	--target-dtb $(target_dtb) \
	--target-board $(target_board) \
	--output $(rebuild_bootscript) \
	--emmc-boot-device $(emmc_boot_device) \
	--sd-boot-device $(sd_boot_device) \
	--active-slot $(active_slot)

$(rebuild_bootscr) : $(rebuild_bootscript)
	$(BOOT_SCRIPT_TOOL) $^ $(rebuild_bootscr)

INSTALLED_HK_BOOTSCRIPT := $(PRODUCT_OUT)/$(notdir $(rebuild_bootscript))
$(INSTALLED_HK_BOOTSCRIPT) : $(rebuild_bootscript)
	$(call copy-file-to-new-target-with-cp)

INSTALLED_HK_BOOTSCR := $(PRODUCT_OUT)/$(notdir $(rebuild_bootscr))
$(INSTALLED_HK_BOOTSCR) : $(rebuild_bootscr)
	$(call copy-file-to-new-target-with-cp)

INSTALLED_HK_VENDOR_BOOTSCR := $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/$(notdir $(rebuild_bootscr))
$(INSTALLED_HK_VENDOR_BOOTSCR) : $(rebuild_bootscr)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_HK_BOOTSCRIPT) $(INSTALLED_HK_BOOTSCR) $(INSTALLED_HK_VENDOR_BOOTSCR)
endif #PRODUCT_BOOTSCRIPT_DTB_TEMPLATE
endif #PRODUCT_BOOTSCRIPT_INI_TEMPLATE
endif #PRODUCT_BOOTSCRIPT_TEMPLATE
