
###########################################################################################
# 1. project[x]          project name, as title only
# 2. soc[x]              soc name, as title only
# 3. hardware[x]         hardare platform name, as title only
# 4. module[x]           lunch name
# 5. uboot_path[x]       bootloader store path
# 6. uboot_exec_aosp[x]  build uboot aosp command
# 7. uboot_exec_drm[x]   build uboot drm command
# 8. kernel_exec[x]      build kernel command(do not include -t user)
# 9. android_exec[x]="TARGET_BUILD_KERNEL_4_9=true"  only if build 4.9 kernel need it.
# 10. kernel_addr[x]="export KERNEL_A32_SUPPORT=true"  only if build 32bit kernel need it.
###########################################################################################

###########################################################################################
# Ohm
project[1]="Ohm-GTV"
soc[1]="S905X4"
hardware[1]="AH212"
module[1]="ohm"
uboot_path[1]="device/amlogic/ohm"
uboot_exec_aosp[1]="./mk sc2_ah212  --vab --avb2"
uboot_exec_drm[1]="./mk sc2_ah212  --vab --avb2"
kernel_exec[1]="./mk ohm -v 5.4"
###########################################################################################

###########################################################################################
# Ohm atv
project[2]="Ohm-ATV"
soc[2]="S905X4"
hardware[2]="AH212"
module[2]="ohm"
uboot_path[2]="device/amlogic/ohm"
uboot_exec_aosp[2]="./mk sc2_ah212  --vab --avb2"
uboot_exec_drm[2]="./mk sc2_ah212  --vab --avb2"
kernel_exec[2]="./mk ohm -v 5.4"
###########################################################################################

###########################################################################################
# OHM MXL258C
project[3]="Ohm-mxl258c"
soc[3]="S905X4"
hardware[3]="AH212"
module[3]="ohm_mxl258c"
uboot_path[3]="device/amlogic/ohm"
uboot_exec_aosp[3]="./mk sc2_ah212  --vab --avb2"
uboot_exec_drm[3]="./mk sc2_ah212  --vab --avb2"
kernel_exec[3]="./mk ohm -v 5.4 --fccpip"
###########################################################################################

###########################################################################################
# OHMCAS GTV
project[4]="Ohmcas-GTV"
soc[4]="S905C2"
hardware[4]="AH232"
module[4]="ohmcas_gtv"
uboot_path[4]="device/amlogic/ohmcas"
uboot_exec_aosp[4]="./mk sc2_ah232  --vab --avb2"
uboot_exec_drm[4]="./mk sc2_ah232  --vab --avb2"
kernel_exec[4]="./mk ohmcas -v 5.4"
###########################################################################################

###########################################################################################
# OHMCAS ATV
project[5]="Ohmcas-ATV"
soc[5]="S905C2"
hardware[5]="AH232"
module[5]="ohmcas_atv"
uboot_path[5]="device/amlogic/ohmcas"
uboot_exec_aosp[5]="./mk sc2_ah232  --vab --avb2"
uboot_exec_drm[5]="./mk sc2_ah232  --vab --avb2"
kernel_exec[5]="./mk ohmcas -v 5.4"
###########################################################################################

###########################################################################################
# OPPEN GTV
project[6]="Oppen-GTV"
soc[6]="S905Y4"
hardware[6]="AP222"
module[6]="oppen_gtv"
uboot_path[6]="device/amlogic/oppen"
uboot_exec_aosp[6]="./mk s4_ap222  --vab --avb2"
uboot_exec_drm[6]="./mk s4_ap222  --vab --avb2"
kernel_exec[6]="./mk oppen -v 5.4"
###########################################################################################

###########################################################################################
# OPPEN ATV
project[7]="Oppen-ATV"
soc[7]="S905Y4"
hardware[7]="AP222"
module[7]="oppen"
uboot_path[7]="device/amlogic/oppen"
uboot_exec_aosp[7]="./mk s4_ap222  --vab --avb2"
uboot_exec_drm[7]="./mk s4_ap222  --vab --avb2"
kernel_exec[7]="./mk oppen -v 5.4"
###########################################################################################

###########################################################################################
# AP223
project[8]="Oppen-GTV"
soc[8]="S905Y4"
hardware[8]="AP223"
module[8]="oppen"
uboot_path[8]="device/amlogic/oppen"
uboot_path[8]="device/amlogic/oppen"
uboot_exec_aosp[8]="./mk s4_ap223  --vab --avb2"
uboot_exec_drm[8]="./mk s4_ap223  --vab --avb2"
kernel_exec[8]="./mk oppen -v 5.4"
###########################################################################################

###########################################################################################
# OPPENCAS
project[9]="Oppencas-ATV"
soc[9]="S905C3"
hardware[9]="AP232"
module[9]="oppencas_atv"
uboot_path[9]="device/amlogic/oppencas"
uboot_exec_aosp[9]="./mk s4_ap232  --vab --avb2"
uboot_exec_drm[9]="./mk s4_ap232  --vab --avb2"
kernel_exec[9]="./mk oppencas -v 5.4"
###########################################################################################

###########################################################################################
# OPPENCAS
project[10]="Oppencas-GTV"
soc[10]="S905C3"
hardware[10]="AP232"
module[10]="oppencas_gtv"
uboot_path[10]="device/amlogic/oppencas"
uboot_exec_aosp[10]="./mk s4_ap232  --vab --avb2"
uboot_exec_drm[10]="./mk s4_ap232  --vab --avb2"
kernel_exec[10]="./mk oppencas -v 5.4"
###########################################################################################


###########################################################################################
# OPPENCAS MXL258C
project[11]="Oppencas_mxl258c"
soc[11]="S905C3"
hardware[11]="AP232"
module[11]="oppencas_mxl258c"
uboot_path[11]="device/amlogic/oppencas"
uboot_exec_aosp[11]="./mk s4_ap232  --vab --avb2"
uboot_exec_drm[11]="./mk s4_ap232  --vab --avb2"
kernel_exec[11]="./mk oppencas -v 5.4 --fccpip"
###########################################################################################

###########################################################################################
# PLANCK
project[12]="Planck-GTV"
soc[12]="S805X2"
hardware[12]="AQ222"
module[12]="planck_gtv"
uboot_path[12]="device/amlogic/planck"
uboot_exec_aosp[12]="./mk s4_aq222  --vab --avb2"
uboot_exec_drm[12]="./mk s4_aq222  --vab --avb2"
kernel_exec[12]="./mk planck -v 5.4"
###########################################################################################

###########################################################################################
# PLANCK
project[13]="Planck-ATV"
soc[13]="S805X2"
hardware[13]="AQ222"
module[13]="planck"
uboot_path[13]="device/amlogic/planck"
uboot_exec_aosp[13]="./mk s4_aq222  --vab --avb2"
uboot_exec_drm[13]="./mk s4_aq222  --vab --avb2"
kernel_exec[13]="./mk planck -v 5.4"
kernel_addr[13]="export KERNEL_A32_SUPPORT=true"
###########################################################################################

###########################################################################################
# REDI
project[14]="Redi"
soc[14]="T950D4/T950X4"
hardware[14]="AM301/AM311"
module[14]="redi"
uboot_path[14]="device/amlogic/redi"
uboot_exec_aosp[14]="./mk t5d_am301_v1 --vab "
uboot_exec_drm[14]="./mk t5d_am301_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/t5d/bl32.img --vab --avb2"
kernel_exec[14]="./mk redi -v 5.4"
###########################################################################################

###########################################################################################
# Smith
project[15]="Smith"
soc[15]="S905X4"
hardware[15]="AR321"
module[15]="smith"
uboot_path[15]="device/amlogic/smith"
uboot_exec_aosp[15]="./mk t3_t965d4  --vab"
uboot_exec_drm[15]="./mk t3_t965d4  --vab --avb2"
kernel_exec[15]="./mk smith -v 5.4"
###########################################################################################

###########################################################################################
# Soddy
project[16]="Soddy"
soc[16]="T962D4"
hardware[16]="AT301"
module[16]="soddy"
uboot_path[16]="device/amlogic/soddy"
uboot_exec_aosp[16]="./mk t5w_at301_v1  --vab"
uboot_exec_drm[16]="./mk t5w_at301_v1  --vab --avb2"
kernel_exec[16]="./mk soddy -v 5.4"
###########################################################################################

###########################################################################################
# Marconi
project[17]="Marconi"
soc[17]="T962X2"
hardware[17]="X301"
module[17]="marconi"
uboot_path[17]="device/amlogic/marconi"
uboot_exec_aosp[17]="./mk tl1_x301_v1  --vab"
uboot_exec_drm[17]="./mk tl1_x301_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/tl1/bl32.img --vab --avb2"
kernel_exec[17]="./mk marconi -v 5.4"
###########################################################################################

###########################################################################################
# Dalton
project[18]="Dalton"
soc[18]="T962E2"
hardware[18]="AB311"
module[18]="dalton"
uboot_path[18]="device/amlogic/marconi"
uboot_exec_aosp[18]="./mk tm2_t962e2_ab311_v1  --vab"
uboot_exec_drm[18]="./mk tm2_t962e2_ab311_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/tm2/bl32.img --vab --avb2"
kernel_exec[18]="./mk dalton -v 5.4"
###########################################################################################

###########################################################################################
# Franklin
project[19]="Franklin"
soc[19]="S905X2"
hardware[19]="U212"
module[19]="franklin"
uboot_path[19]="device/amlogic/franklin"
uboot_exec_aosp[19]="./mk g12a_u212_v1  --vab --avb2"
uboot_exec_drm[19]="./mk g12a_u212_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2"
kernel_exec[19]="./mk franklin -v 4.9"
android_exec[19]="TARGET_BUILD_KERNEL_4_9=true"
###########################################################################################

###########################################################################################
# Newton
project[20]="Newton"
soc[20]="S905X3"
hardware[20]="AC215"
module[20]="newton"
uboot_path[20]="device/amlogic/newton"
uboot_exec_aosp[20]="./mk sm1_ac215_v1  --vab --avb2"
uboot_exec_drm[20]="./mk sm1_ac215_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2"
kernel_exec[20]="./mk newton -v 4.9"
android_exec[20]="TARGET_BUILD_KERNEL_4_9=true"
###########################################################################################

###########################################################################################
# Franklin_Hybrid
project[21]="Franklin_Hybrid"
soc[21]="S905X2"
hardware[21]="U215"
module[21]="franklin_hybrid"
uboot_path[21]="device/amlogic/franklin/franklin_hybrid"
uboot_exec_aosp[21]="./mk g12a_u215_v1  --vab --avb2"
uboot_exec_drm[21]="./mk g12a_u215_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2"
kernel_exec[21]="./mk franklin -v 4.9"
android_exec[21]="TARGET_BUILD_KERNEL_4_9=true"
###########################################################################################

usage() {
    echo -e \
    "Usage: Build Android image or sub-modules.\n" \
    "       1. No Params: build android image(through select platform and android).\n" \
    "       1. 1  Params: build android sub-image(through select platform and android).\n" \
    "             params: uboot\n" \
    "                     all-uboot\n" \
    "                     bootimage\n" \
    "                     vendorimage\n" \
    "                     vendorbootimage\n" \
    "                     logoimage\n" \
    "                     odmimage\n" \
    "                     odmextimage\n" \
    "                     systemimage\n" \
    "                     systemextimage\n" \
    "       2. 3  Params: [project-name][android-type][user/userdebug].\n" \
    "                  ./xxxx.sh ohm GTVS userdebug.\n" \

}

########################################################################################################################################################################
# Read Platform config
# Through the input number, to get project-name/project-path/uboot-params
# uboot-params : how to build uboot.
# project-path : how to replace the newest uboot.
# project-name : how to build the code.
########################################################################################################################################################################
read_platform_type() {
    # compile all uboot, no need select platform.
    if [[ $params == "all-uboot" ]]; then
        return
    fi
    while true :
    do
        printf "[%3s]   [%15s]   [%15s]  [%15s]\n" "NUM" "PROJECT" "SOC TYPE" "HARDWARE TYPE"
        echo "-----------------------------------------------------------------"
        for i in `seq ${#project[@]}`;do
            printf "[%3d]   [%15s]  [%15s]  [%15s]\n" $i ${project[i]} ${soc[i]} ${hardware[i]}
        done

        echo "-----------------------------------------------------------------"
        read -p "Please input platform NUM ([1 ~ ${#project[@]}], default 1 ):" platform_type

        if [ ${#platform_type} -eq 0 ]; then
            platform_type=1
            break
        fi

        if [[ $platform_type -lt 1 || $platform_type -gt ${#project[@]} ]]; then
            echo -e "\nError: The platform NUM is illegal!!! Need input again [1 ~ ${#project[@]}]\n"
            echo -e "Please click Enter to continue"
            read
        else
            break
        fi
    done
    echo "Input NUM is [${platform_type}], [${module[platform_type]}]"
}

########################################################################################################################################################################
# Get Android Type: AOSP/DRM/GTVS
########################################################################################################################################################################
read_android_type() {
    while true :
    do
        echo -e \
        "Select compile Android verion type lists:\n"\
        "[NUM]   [Android Version]\n" \
        "[  1]   [AOSP]\n" \
        "[  2]   [DRM ]\n" \
        "[  3]   [GTVS](need google gms zip)\n" \
        "--------------------------------------------\n"

        if [ -d "vendor/google_gtvs" ];then
            default=3
        else
            default=2
        fi
        read -p "Please input Android Version (default $default):" uboot_drm_type
        if [ ${#uboot_drm_type} -eq 0 ]; then
            uboot_drm_type=$default
            break
        fi
        if [[ $uboot_drm_type -lt 1 || $uboot_drm_type -gt 3 ]];then
            echo -e "\nError: The Android Version is illegal, please Input again [1 ~ 3]}\n"
            echo -e "Please click Enter to continue"
            read
        else
            break
        fi
    done
}

########################################################################################################################################################################
#
# Compile Uboot throuth params
# if no params compile userdebug
########################################################################################################################################################################
compile_uboot() {
    cd bootloader/uboot-repo

    if [ $uboot_drm_type -eq 1 ]; then
        echo "${uboot_exec_aosp[platform_type]}"
        ${uboot_exec_aosp[platform_type]}
    else
        echo "${uboot_exec_drm[platform_type]}"
        ${uboot_exec_drm[platform_type]}
    fi
    if [ $? != 0 ]; then echo " Error : Build Uboot error, exit!!!"; exit; fi

    if [ -f "build/u-boot.bin.signed" ];then
        cp build/u-boot.bin.signed ../../${uboot_path[platform_type]}/bootloader.img
        cp build/u-boot.bin.usb.signed ../../${uboot_path[platform_type]}/upgrade/
        cp build/u-boot.bin.sd.bin.signed ../../${uboot_path[platform_type]}/upgrade/
    else
        cp build/u-boot.bin ../../${uboot_path[platform_type]}/bootloader.img;
        cp build/u-boot.bin.usb.bl2 ../../${uboot_path[platform_type]}/upgrade/u-boot.bin.usb.bl2;
        cp build/u-boot.bin.usb.tpl ../../${uboot_path[platform_type]}/upgrade/u-boot.bin.usb.tpl;
        cp build/u-boot.bin.sd.bin ../../${uboot_path[platform_type]}/upgrade/u-boot.bin.sd.bin;
    fi
    cd ../../
    if [ -f "bootloader/uboot-repo/bl33/v2015/build/include/generated/timestamp_autogenerated.h" ]; then
        ./device/amlogic/common/scripts/get_bootloader_version.sh bootloader/uboot-repo/bl33/v2015/ ${uboot_path[platform_type]}
    elif [ -f "bootloader/uboot-repo/bl33/v2019/build/include/generated/timestamp_autogenerated.h" ]; then
        ./device/amlogic/common/scripts/get_bootloader_version.sh bootloader/uboot-repo/bl33/v2019/ ${uboot_path[platform_type]}
    fi
}
print_uboot_info() {
    echo -e "\n\ndevice: update uboot [1/1]\n"
    echo -e "PD#SWPL-19355\n"
    echo -e "Problem:"
    echo -e "source code update, need update bootloader\n"
    echo "Solution:"
    cd bootloader/uboot-repo/bl2/bin/
    echo "bl2       : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl30/bin/
    echo "bl30      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl30/src_ao/
    echo "bl30 src  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl31/bin/
    echo "bl31      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl31_1.3/bin/
    echo "bl31_1.3  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl32_3.8/bin/
    echo "bl32_3.8  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl33/v2015
    echo "bl33      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/bl33/v2019
    echo "bl33_v2019: "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd bootloader/uboot-repo/fip/
    echo "fip       : "$(git log --pretty=format:"%H" -1); cd ../../../
    cd vendor/amlogic/common/tdk/
    echo "tdk       : "$(git log --pretty=format:"%H" -1); cd ../../../../
    cd vendor/amlogic/common/tdk_v3/
    echo "tdk_v3    : "$(git log --pretty=format:"%H" -1); cd ../../../../
    echo -e;
    echo "Verify:"; echo "no need verify"
}

lunch_env() {
    usermode="userdebug"
    if [ $# -eq 1 ]; then usermode="$1"; fi
    source build/envsetup.sh
    # DRM
    if [ $uboot_drm_type -eq 2 ]; then
        export  BOARD_COMPILE_ATV=false
        export  BOARD_COMPILE_CTS=true
    # GTVS
    elif [ $uboot_drm_type -eq 3 ]; then
        if [ ! -d "vendor/google_gtvs" ];then
            echo "==========================================="
            echo "There is not Google GMS in vendor directory"
            echo "==========================================="
            exit
        fi
        export  BOARD_COMPILE_ATV=true
    # AOSP
    else
        export  BOARD_COMPILE_ATV=false
    fi

    ${kernel_addr[platform_type]}
    lunch "${module[platform_type]}-${usermode}"
}

compile_kernel() {
    usermode="userdebug"
    ${kernel_addr[platform_type]}
    if [ $# -eq 1 ]; then usermode="$1"; fi
    echo "${kernel_exec[platform_type]} -t ${usermode}"
    ${kernel_exec[platform_type]} -t ${usermode}
    if [ $? != 0 ]; then echo " Error : Build Kernel error, exit!!!"; exit; fi
}

compile_sub_uboot() {
    params=$1
    if [[ $params == "uboot" ]]; then
        compile_uboot
        print_uboot_info
        exit
    elif [[ $params == "all-uboot" ]]; then
        for platform_type in `seq ${#project[@]}`;do
            compile_uboot
        done
        print_uboot_info
        exit
    fi
    exit
}

compile_sub_system() {
    echo $1
    lunch_env
    if [[ $1 == "bootimage" || $1 == "vendorbootimage" ]]; then
        compile_kernel
        make bootimage -j8
        make vendorbootimage -j8
    elif [ $1 == "logoimage" ]; then
        make logoimg -j8
    elif [ $1 == "odmimage" ]; then
        make odmimage -j8
    elif [ $1 == "odmextimage" ]; then
        make odm_ext_image -j8
    elif [ $1 == "productimage" ]; then
        make productimage -j8
    elif [ $1 == "vendorimage" ]; then
        make vendorimage -j8
    elif [ $1 == "systemimage" ]; then
        make systemimage -j8
    elif [ $1 == "systemextimage" ]; then
        make systemextimage -j8
    elif [ $1 == "vendordlkmimage" ]; then
        make vendor_dlkmimage -j8
    elif [ $1 == "odmdlkmimage" ]; then
        make odm_dlkmimage -j8
    fi
    exit
}
########################################################################################################################################################################
# Main Function
########################################################################################################################################################################
if [[ $# -eq 1 && $1 == *"help"* ]] || [ $# -eq 2 ] || [ $# -gt 3 ]; then
    usage
    exit
fi
# Select and build all image.
if [ $# -eq 0 ]; then
    read_platform_type
    read_android_type
    compile_uboot
    compile_kernel
    lunch_env
    make otapackage ${android_exec[platform_type]} -j8
fi

if [ $# -eq 1 ]; then
    read_platform_type
    read_android_type
    if [[ $1 == *"uboot"* ]]; then
        compile_sub_uboot $1
    fi
    compile_sub_system $1
fi

if [ $# -eq 3 ]; then
    if [ -d "vendor/google_gtvs" ];then
        default=3
    else
        default=2
    fi
    uboot_drm_type=$default
    platform_type=0
    usermode="userdebug"
    shopt -s nocasematch
    if [[ $@ == *"userdebug"* ]]; then
        usermode="userdebug"
    elif [[ $@ == *"user"* ]]; then
        usermode="user"
    else
        echo -e "please add params:user/userdebug\n"
        exit
    fi
    if [[ $@ == *"GTVS"* ]]; then
        uboot_drm_type=3
    elif [[ $@ == *"DRM"* ]]; then
        uboot_drm_type=2
    elif [[ $@ == *"AOSP"* ]]; then
        uboot_drm_type=1
    else
        echo -e "please add params:AOSP/DRM/GTVS\n"
        exit
    fi
    for i in "${!module[@]}"
    do
        if [[ $1 == "${module[i]}" || $2 == "${module[i]}" || $3 == "${module[i]}" ]]; then
            platform_type=$i
            break
        fi
    done
    if [[ $platform_type == 0 ]]; then
        echo -e "please add params:platform like ohm/oppen/redi\n"
        exit
    fi
    echo $platform_type $uboot_drm_type $usermode
    compile_uboot
    compile_kernel $usermode
    lunch_env $usermode
    make otapackage ${android_exec[platform_type]} -j8
fi
########################################################################################################################################################################
