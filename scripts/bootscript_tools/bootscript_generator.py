#!/usr/bin/env python
import sys
import getopt
import os
from string import Template

usage = 'Invalid arguments. Example:\nbootscript_generator --variant userdebug --boot-part 6 --recovery-part 7 --wifi-country US --mtd flash.0:flash.0:0x1000@0x800(uboot),0x800@0x1800(splash),0x6000@0x2000(firmware) --target-dtb rk3568-odroid-m1 --target-board odroidm1 --output boot.scr'

def main(argv):
    infile = 'bootscript.in'
    boot_part = '6'
    recovery_part = '7'
    wifi_country = 'US'
    outfile = 'boot.cmd'
    mtd = "flash.0:0x1000@0x800(uboot),0x800@0x1800(splash),0x6000@0x2000(firmware)"
    target_dtb = 'rk3568-odroid-m1'
    target_board = 'odroidm1'
    try:
        opts, args = getopt.getopt(argv, "h", ["input=","variant=","boot-part=","recovery-part=","wifi-country=","output=","mtd=","target-dtb=","target-board="])
    except getopt.GetoptError:
        print(usage)
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print (usage)
            sys.exit(2)
        elif opt == "--input":
            infile = arg;
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
        elif opt == "--target-dtb":
            target_dtb = arg
        elif opt == "--target-board":
            target_board = arg
        else:
            print (usage)
            sys.exit(2)

    if boot_part== '':
        print (usage)
        sys.exit(2)

    if recovery_part == '':
        print (usage)
        sys.exit(2)

    file_bootscript_in = open(infile)
    template_bootscript_in = file_bootscript_in.read()
    template_in_t = Template(template_bootscript_in)

    line = template_in_t.substitute(_variant=variant,_boot_part=boot_part,_recovery_part=recovery_part,_wifi_country=wifi_country, _mtd=mtd, _target_dtb=target_dtb, _target_board=target_board)

    if outfile != '':
        with open (outfile,"w") as f:
            f.write(line)
    else:
        print(line)

if __name__=="__main__":
    main(sys.argv[1:])
