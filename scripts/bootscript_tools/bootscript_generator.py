#!/usr/bin/env python
import sys
import getopt
import os
from string import Template

usage = 'Invalid arguments. Example:\nbootscript_generator --variant userdebug --boot-part 7 --recovery-part 8 --wifi-country US --output boot.scr'

def main(argv):
    infile = 'bootscript.in'
    boot_part = '7'
    recovery_part = '8'
    wifi_country = 'US'
    outfile = 'boot.cmd'
    try:
        opts, args = getopt.getopt(argv, "h", ["input=","variant=","boot-part=","recovery-part=","wifi-country=","output="])
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

    line = template_in_t.substitute(_variant=variant,_boot_part=boot_part,_recovery_part=recovery_part,_wifi_country=wifi_country)

    if outfile != '':
        with open (outfile,"w") as f:
            f.write(line)
    else:
        print(line)

if __name__=="__main__":
    main(sys.argv[1:])
