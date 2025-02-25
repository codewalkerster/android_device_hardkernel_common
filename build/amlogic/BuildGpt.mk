ifdef TARGET_GPT_PART
ifdef AML_GPT_PART

$(info build gpt binary with $(AML_GPT_PART)...)
intermediates := $(call intermediates-dir-for,FAKE,amlogic_gpt)

build_gpt_img := $(intermediates)/gpt.img
makegpt_bin := out/host/linux-x86/bin/makegpt

$(build_gpt_img) : $(makegpt_bin) $(AML_GPT_PART)
	@echo "generate $@."
	$< -o $@ -v 2 --partitions $(AML_GPT_PART)
	@echo "Installed $@."

INSTALL_GPT_IMAGE := $(PRODUCT_OUT)/$(notdir $(build_gpt_img))
$(INSTALL_GPT_IMAGE) : $(build_gpt_img)
	$(call copy-file-to-new-target-with-cp)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALL_GPT_IMAGE)

endif
endif
