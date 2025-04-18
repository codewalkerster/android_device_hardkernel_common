$(info build update_boot.scr with update_boot.cmd...)

intermediates := $(call intermediates-dir-for,FAKE,hardkernel_update_bootscript)

common_path := device/hardkernel/common
update_bootscript := $(common_path)/update/update_boot.cmd
build_bootscr := $(intermediates)/update_boot.scr
BOOT_SCRIPT_TOOL := $(common_path)/boot_script/mkbootscript.sh

$(build_bootscr) : $(update_bootscript)
	$(BOOT_SCRIPT_TOOL) $^ $@

INSTALLED_HK_UPDATE_BOOTSCR := $(PRODUCT_OUT)/$(notdir $(build_bootscr))
$(INSTALLED_HK_UPDATE_BOOTSCR) : $(build_bootscr)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_HK_UPDATE_BOOTSCR)
