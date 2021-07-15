if test "${devtype}" = mmc ; then
	setenv media emmc
else
	setenv media sd
fi

setenv pre_args storagemedia=$media androidboot.storagemedia=$media androidboot.mode=normal androidboot.dtb_idx=0 androidboot.dtbo_idx=0

setenv bootargs ${pre_args} androidboot.boot_devices=fe310000.sdhci,fe330000.nandc swiotlb=1 androidboot.selinux=permissive

setenv fdt_addr_r 0x0a100000
setenv kernel_addr_c 0x4080000
setenv kernel_addr_r 0x00280000
setenv ramdisk_addr_r 0x0a200000
setenv loadaddr 0x10000000

setenv partnum 6

setbootdev $devtype $devnum

part start $devtype $devnum $partnum boot_start
part size $devtype $devnum $partnum boot_size

mmc read $loadaddr $boot_start $boot_size

bootm $loadaddr
