KERNEL_ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
CONFIG_DHD_USE_STATIC_BUF ?= y
PRODUCT_OUT=out/target/product/$(TARGET_PRODUCT)
TARGET_OUT=$(PRODUCT_OUT)/obj/lib_vendor

multiwifi:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/rtl8812au ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/rtl8812au/8812au.ko $(TARGET_OUT)/
