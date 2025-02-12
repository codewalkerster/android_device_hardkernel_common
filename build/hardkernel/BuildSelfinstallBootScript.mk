$(info build selfinstall_boot.scr with self_boot.cmd...)

intermediates := $(call intermediates-dir-for,FAKE,hardkernel_selfinstall_bootscript)

common_path := device/hardkernel/common
selfinstall_bootscript := $(common_path)/selfinstall/self_boot.cmd
build_bootscr := $(intermediates)/selfinstall_boot.scr
BOOT_SCRIPT_TOOL := $(common_path)/boot_script/mkbootscript.sh

$(build_bootscr) : $(selfinstall_bootscript)
	$(BOOT_SCRIPT_TOOL) $^ $@

INSTALLED_HK_SELFINSTALL_BOOTSCR := $(PRODUCT_OUT)/$(notdir $(build_bootscr))
$(INSTALLED_HK_SELFINSTALL_BOOTSCR) : $(build_bootscr)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_HK_SELFINSTALL_BOOTSCR)
