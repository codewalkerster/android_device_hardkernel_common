#!/usr/bin/env python
import sys
import getopt
import os
from string import Template

usage = 'Invalid arguments. Example:\nbootscript_generator --input bootscript.in --input_dtb_subscript bootscript_dtb.in --input_ini_subscript bootscript_ini.in --variant userdebug --boot-part boot --recovery-part 7 --wifi-country US --mtd flash.0:flash.0:0x1000@0x800(uboot),0x800@0x1800(splash),0x6000@0x2000(firmware) --target-board odroidm1 --target-dtb rk3568-odroid-m1 --output boot.scr --emmc-boot-device fe2e0000.mmc --sd-boot-device fe2c0000.mmc --active-slot _a --slot-suffix 0'

def main(argv):
    infile = 'bootscript.in'
    in_dtb_subscript_file = 'bootscript_dtb.in'
    in_ini_subscript_file = 'bootscript_ini.in'
    boot_part = '6'
    recovery_part = '7'
    wifi_country = 'US'
    outfile = 'boot.cmd'
    mtd = "flash.0:0x1000@0x800(uboot),0x800@0x1800(splash),0x6000@0x2000(firmware)"
    target_board = 'odroidm1'
    target_dtb = 'rk3568-odroid-m1'
    emmc_boot_device = 'fe310000.sdhci'
    sd_boot_device = 'fe2b0000.dwmmc'
    load_dtb = ''
    active_slot = '_a'
    slot_suffix = '0'
    try:
        opts, args = getopt.getopt(argv, "h", ["input=","input_dtb_subscript=","input_ini_subscript=","variant=","boot-part=","recovery-part=","wifi-country=","output=","mtd=","target-dtb=","target-board=","emmc-boot-device=","sd-boot-device=","active-slot=","slot-suffix="])
    except getopt.GetoptError:
        print(usage)
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print (usage)
            sys.exit(2)
        elif opt == "--input":
            infile = arg;
        elif opt == "--input_dtb_subscript":
            in_dtb_subscript_file = arg;
        elif opt == "--input_ini_subscript":
            in_ini_subscript_file = arg;
        elif opt == "--variant":
            variant= arg;
        elif opt == "--boot-part":
            boot_part = arg
        elif opt == "--recovery-part":
            recovery_part = arg
        elif opt == "--wifi-country":
            wifi_country = arg
        elif opt == "--output":
            outfile = arg
        elif opt == "--mtd":
            mtd = arg
        elif opt == "--target-board":
            target_board = arg
        elif opt == "--target-dtb":
            target_dtb = arg
        elif opt == "--emmc-boot-device":
            emmc_boot_device = arg
        elif opt == "--sd-boot-device":
            sd_boot_device = arg
        elif opt == "--active-slot":
            active_slot = arg
        elif opt == "--slot-suffix":
            slot_suffix = arg
        else:
            print (usage)
            sys.exit(2)

    if boot_part== '':
        print (usage)
        sys.exit(2)

    if recovery_part == '':
        print (usage)
        sys.exit(2)

    file_subscript_in = open(in_dtb_subscript_file)
    template_subscript_in =  file_subscript_in.read()
    template_dtb_in_t = Template(template_subscript_in)
    load_dtb = template_dtb_in_t.substitute(_target_dtb=target_dtb)

    file_subscript_in = open(in_ini_subscript_file)
    template_subscript_in =  file_subscript_in.read()
    template_ini_in_t = Template(template_subscript_in)
    load_ini = template_ini_in_t.substitute(_target_board=target_board)

    file_bootscript_in = open(infile)
    template_bootscript_in = file_bootscript_in.read()
    template_in_t = Template(template_bootscript_in)

    line = template_in_t.substitute(_variant=variant,_boot_part=boot_part,_recovery_part=recovery_part,_wifi_country=wifi_country, _load_dtb=load_dtb, _load_ini=load_ini, _mtd=mtd, _emmc_boot_device=emmc_boot_device, _sd_boot_device=sd_boot_device, _active_slot=active_slot, _slot_suffix=slot_suffix)

    if outfile != '':
        with open (outfile,"w") as f:
            f.write(line)
    else:
        print(line)

if __name__=="__main__":
    main(sys.argv[1:])
