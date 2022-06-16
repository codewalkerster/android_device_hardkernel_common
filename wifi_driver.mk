KERNEL_ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
CONFIG_DHD_USE_STATIC_BUF ?= y
PRODUCT_OUT=out/target/product/$(TARGET_PRODUCT)
TARGET_OUT=$(PRODUCT_OUT)/obj/lib_vendor

multiwifi:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/rtl8812au ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/rtl8812au ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/rtl8812au/8812au.ko $(TARGET_OUT)/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/rtl8821CU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/rtl8821CU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/rtl8821CU/8821cu.ko $(TARGET_OUT)/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8192cu ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8192cu ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8192cu/8192cu.ko $(TARGET_OUT)/
	$(MAKE) -C $(shell pwd)/hardware/wifi/mediatek/mt7610u ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	$(MAKE) -C $(shell pwd)/hardware/wifi/mediatek/mt7610u ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
	cp $(shell pwd)/hardware/wifi/mediatek/mt7610u/os/linux/mt7610u_sta.ko $(TARGET_OUT)/
