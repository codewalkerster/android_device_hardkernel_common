
###########################################################################################
# 1. project[x]          project name, as title only
# 2. soc[x]              soc name, as title only
# 3. hardware[x]         hardware platform name, as title only
# 4. module[x]           lunch name
# 5. uboot_path[x]       bootloader store path
# 6. uboot_exec_aosp[x]  build uboot aosp command
# 7. uboot_exec_drm[x]   build uboot drm command
# 8. kernel_exec[x]      build kernel command(do not include -t user)
#     remove 5.4/4.9 and dynamic select 5.15/5.4/4.9
# //9. android_exec[x]="TARGET_BUILD_KERNEL_VERSION=4.9"  only if build 4.9 kernel need it.
#     remove it and read kernel type.
# 10. kernel_addr[x]="export KERNEL_A32_SUPPORT=true"  only if build 32bit kernel need it.
###########################################################################################

###########################################################################################
# Ohm
project[1]="Ohm-GTV-OTT"
soc[1]="S905X4"
hardware[1]="AH212"
module[1]="ohm_gtv"
uboot_path[1]="device/amlogic/ohm"
uboot_exec_aosp[1]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
uboot_exec_drm[1]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
kernel_exec[1]="./mk ohm --gki_image -v "
###########################################################################################

###########################################################################################
# Ohm
project[2]="Ohm-GTV-DVB"
soc[2]="S905X4"
hardware[2]="AH212"
module[2]="ohm_hybrid"
uboot_path[2]="device/amlogic/ohm"
uboot_exec_aosp[2]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
uboot_exec_drm[2]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
kernel_exec[2]="./mk ohm --gki_image -v "
###########################################################################################

###########################################################################################
# Ohm
project[3]="Ohm-GTV-CBS"
soc[3]="S905X4"
hardware[3]="AH212"
module[3]="ohm_cbs"
uboot_path[3]="device/amlogic/ohm"
uboot_exec_aosp[3]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
uboot_exec_drm[3]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
kernel_exec[3]="./mk ohm --gki_image -v "
###########################################################################################

###########################################################################################
# Ohm atv
project[4]="Ohm-ATV"
soc[4]="S905X4"
hardware[4]="AH212"
module[4]="ohm"
uboot_path[4]="device/amlogic/ohm"
uboot_exec_aosp[4]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
uboot_exec_drm[4]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
kernel_exec[4]="./mk ohm --gki_image -v "
###########################################################################################

###########################################################################################
# OHM MXL258C
project[5]="Ohm-mxl258c"
soc[5]="S905X4"
hardware[5]="AH212"
module[5]="ohm_mxl258c"
uboot_path[5]="device/amlogic/ohm"
uboot_exec_aosp[5]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
uboot_exec_drm[5]="./mk sc2_ah212  --vab --avb2 --fastboot-write"
kernel_exec[5]="./mk ohm --gki_image --fccpip -v"
###########################################################################################

###########################################################################################
# OHMCAS GTV
project[6]="Ohmcas-GTV"
soc[6]="S905C2"
hardware[6]="AH232"
module[6]="ohmcas_gtv"
uboot_path[6]="device/amlogic/ohmcas"
uboot_exec_aosp[6]="./mk sc2_ah232  --vab --avb2 --fastboot-write"
uboot_exec_drm[6]="./mk sc2_ah232  --vab --avb2 --fastboot-write"
kernel_exec[6]="./mk ohmcas --gki_image -v "
###########################################################################################

###########################################################################################
# OHMCAS ATV
project[7]="Ohmcas-ATV"
soc[7]="S905C2"
hardware[7]="AH232"
module[7]="ohmcas"
uboot_path[7]="device/amlogic/ohmcas"
uboot_exec_aosp[7]="./mk sc2_ah232  --vab --avb2 --fastboot-write"
uboot_exec_drm[7]="./mk sc2_ah232  --vab --avb2 --fastboot-write"
kernel_exec[7]="./mk ohmcas --gki_image -v "
###########################################################################################

###########################################################################################
# OPPEN GTV OTT
project[8]="Oppen-GTV-OTT"
soc[8]="S905Y4"
hardware[8]="AP222"
module[8]="oppen_gtv"
uboot_path[8]="device/amlogic/oppen"
uboot_exec_aosp[8]="./mk s4_ap222  --vab --avb2 --fastboot-write"
uboot_exec_drm[8]="./mk s4_ap222  --vab --avb2 --fastboot-write"
kernel_exec[8]="./mk oppen -v "
###########################################################################################

###########################################################################################
# OPPEN GTV DVB
project[9]="Oppen-GTV-DVB"
soc[9]="S905Y4"
hardware[9]="AP222"
module[9]="oppen_hybrid"
uboot_path[9]="device/amlogic/oppen"
uboot_exec_aosp[9]="./mk s4_ap222  --vab --avb2 --fastboot-write"
uboot_exec_drm[9]="./mk s4_ap222  --vab --avb2 --fastboot-write"
kernel_exec[9]="./mk oppen -v "
###########################################################################################

###########################################################################################
# OPPEN GTV CBS
project[10]="Oppen-GTV-CBS"
soc[10]="S905Y4"
hardware[10]="AP222"
module[10]="oppen_cbs"
uboot_path[10]="device/amlogic/oppen"
uboot_exec_aosp[10]="./mk s4_ap222  --vab --avb2 --fastboot-write"
uboot_exec_drm[10]="./mk s4_ap222  --vab --avb2 --fastboot-write"
kernel_exec[10]="./mk oppen -v "
###########################################################################################

###########################################################################################
# OPPEN ATV
project[11]="Oppen-ATV"
soc[11]="S905Y4"
hardware[11]="AP222"
module[11]="oppen"
uboot_path[11]="device/amlogic/oppen"
uboot_exec_aosp[11]="./mk s4_ap222  --vab --avb2 --fastboot-write"
uboot_exec_drm[11]="./mk s4_ap222  --vab --avb2 --fastboot-write"
kernel_exec[11]="./mk oppen -v "
###########################################################################################

###########################################################################################
# AP223
project[12]="Oppen-GTV"
soc[12]="S905Y4"
hardware[12]="AP223"
module[12]="oppen"
uboot_path[12]="device/amlogic/oppen"
uboot_path[12]="device/amlogic/oppen"
uboot_exec_aosp[12]="./mk s4_ap223  --vab --avb2 --fastboot-write"
uboot_exec_drm[12]="./mk s4_ap223  --vab --avb2 --fastboot-write"
kernel_exec[12]="./mk oppen -v "
###########################################################################################

###########################################################################################
# OPPENCAS
project[13]="Oppencas-ATV"
soc[13]="S905C3"
hardware[13]="AP232"
module[13]="oppencas"
uboot_path[13]="device/amlogic/oppencas"
uboot_exec_aosp[13]="./mk s4_ap232  --vab --avb2 --fastboot-write"
uboot_exec_drm[13]="./mk s4_ap232  --vab --avb2 --fastboot-write"
kernel_exec[13]="./mk oppencas -v "
###########################################################################################

###########################################################################################
# OPPENCAS
project[14]="Oppencas-GTV"
soc[14]="S905C3"
hardware[14]="AP232"
module[14]="oppencas_gtv"
uboot_path[14]="device/amlogic/oppencas"
uboot_exec_aosp[14]="./mk s4_ap232  --vab --avb2 --fastboot-write"
uboot_exec_drm[14]="./mk s4_ap232  --vab --avb2 --fastboot-write"
kernel_exec[14]="./mk oppencas -v "
###########################################################################################


###########################################################################################
# OPPENCAS MXL258C
project[15]="Oppencas_mxl258c"
soc[15]="S905C3"
hardware[15]="AP232"
module[15]="oppencas_mxl258c"
uboot_path[15]="device/amlogic/oppencas"
uboot_exec_aosp[15]="./mk s4_ap232  --vab --avb2 --fastboot-write"
uboot_exec_drm[15]="./mk s4_ap232  --vab --avb2 --fastboot-write"
kernel_exec[15]="./mk oppencas --fccpip -v"
###########################################################################################

###########################################################################################
# PLANCK
project[16]="Planck-GTV"
soc[16]="S805X2"
hardware[16]="AQ222"
module[16]="planck_gtv"
uboot_path[16]="device/amlogic/planck"
uboot_exec_aosp[16]="./mk s4_aq222  --vab --avb2 --fastboot-write"
uboot_exec_drm[16]="./mk s4_aq222  --vab --avb2 --fastboot-write"
kernel_exec[16]="./mk planck -v "
###########################################################################################

###########################################################################################
# PLANCK
project[17]="Planck-ATV"
soc[17]="S805X2"
hardware[17]="AQ222"
module[17]="planck"
uboot_path[17]="device/amlogic/planck"
uboot_exec_aosp[17]="./mk s4_aq222  --vab --avb2 --fastboot-write"
uboot_exec_drm[17]="./mk s4_aq222  --vab --avb2 --fastboot-write"
kernel_exec[17]="./mk planck -v "
kernel_addr[17]="export KERNEL_A32_SUPPORT=true"
###########################################################################################

###########################################################################################
# REDI
project[18]="Redi"
soc[18]="T950D4/T950X4"
hardware[18]="AM301/AM311"
module[18]="redi"
uboot_path[18]="device/amlogic/redi"
uboot_exec_aosp[18]="./mk t5d_am301_v1 --vab --fastboot-write"
uboot_exec_drm[18]="./mk t5d_am301_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/t5d/bl32.img --vab --avb2 --fastboot-write"
kernel_exec[18]="./mk redi -v "
kernel_addr[18]="export KERNEL_A32_SUPPORT=true"
###########################################################################################

###########################################################################################
# Smith
project[19]="Smith"
soc[19]="T965D4"
hardware[19]="AR321"
module[19]="smith"
uboot_path[19]="device/amlogic/smith"
uboot_exec_aosp[19]="./mk t3_t965d4  --vab --fastboot-write"
uboot_exec_drm[19]="./mk t3_t965d4  --vab --avb2 --fastboot-write"
kernel_exec[19]="./mk smith -v "
###########################################################################################

###########################################################################################
# Soddy
project[20]="Soddy"
soc[20]="T962D4"
hardware[20]="AT301"
module[20]="soddy"
uboot_path[20]="device/amlogic/soddy"
uboot_exec_aosp[20]="./mk t5w_at301_v1  --vab --fastboot-write"
uboot_exec_drm[20]="./mk t5w_at301_v1  --vab --avb2 --fastboot-write"
kernel_exec[20]="./mk soddy -v "
kernel_addr[20]="export KERNEL_A32_SUPPORT=true"
###########################################################################################

###########################################################################################
# Marconi
project[21]="Marconi"
soc[21]="T962X2"
hardware[21]="X301"
module[21]="marconi"
uboot_path[21]="device/amlogic/marconi"
uboot_exec_aosp[21]="./mk tl1_x301_v1  --vab --fastboot-write"
uboot_exec_drm[21]="./mk tl1_x301_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/tl1/bl32.img --vab --avb2 --fastboot-write"
kernel_exec[21]="./mk marconi -v "
###########################################################################################

###########################################################################################
# Dalton
project[22]="Dalton"
soc[22]="T962E2"
hardware[22]="AB311"
module[22]="dalton"
uboot_path[22]="device/amlogic/marconi"
uboot_exec_aosp[22]="./mk tm2_t962e2_ab311_v1  --vab --fastboot-write"
uboot_exec_drm[22]="./mk tm2_t962e2_ab311_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/tm2/bl32.img --vab --avb2 --fastboot-write"
kernel_exec[22]="./mk dalton -v "
###########################################################################################

###########################################################################################
# Franklin
project[23]="Franklin"
soc[23]="S905X2"
hardware[23]="U212"
module[23]="franklin"
uboot_path[23]="device/amlogic/franklin"
uboot_exec_aosp[23]="./mk g12a_u212_v1  --vab --avb2 --fastboot-write"
uboot_exec_drm[23]="./mk g12a_u212_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2 --fastboot-write"
kernel_exec[23]="./mk franklin -v "
###########################################################################################

###########################################################################################
# Newton
project[24]="Newton"
soc[24]="S905X3"
hardware[24]="AC215"
module[24]="newton"
uboot_path[24]="device/amlogic/newton"
uboot_exec_aosp[24]="./mk sm1_ac215_v1  --vab --avb2 --fastboot-write"
uboot_exec_drm[24]="./mk sm1_ac215_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2 --fastboot-write"
kernel_exec[24]="./mk newton -v "
###########################################################################################

###########################################################################################
# Franklin_Hybrid
project[25]="Franklin_Hybrid"
soc[25]="S905X2"
hardware[25]="U215"
module[25]="franklin_hybrid"
uboot_path[25]="device/amlogic/franklin/franklin_hybrid"
uboot_exec_aosp[25]="./mk g12a_u215_v1  --vab --avb2 --fastboot-write"
uboot_exec_drm[25]="./mk g12a_u215_v1 --bl32 ../../vendor/amlogic/common/tdk/secureos/g12a/bl32.img --vab --avb2 --fastboot-write"
kernel_exec[25]="./mk franklin -v "
###########################################################################################

###########################################################################################
# T7_AN400
project[26]="BDS-T7-64bit"
soc[26]="A311D2"
hardware[26]="AN400"
module[26]="t7_an400_arm64"
uboot_path[26]="device/amlogic/t7_an400"
uboot_exec_aosp[26]="./mk t7_an400_lpddr4x --vab --avb2 --fastboot-write"
uboot_exec_drm[26]="./mk t7_an400_lpddr4x --vab --avb2 --fastboot-write"
kernel_exec[26]="./mk t7_an400 -v "
###########################################################################################

###########################################################################################
# T982_AR301
project[27]="T982"
soc[27]="T982X9"
hardware[27]="AR301"
module[27]="t982_ar301_arm64"
uboot_path[27]="device/amlogic/t982_ar301"
uboot_exec_aosp[27]="./mk t3_t982 --vab --avb2 --fastboot-write"
uboot_exec_drm[27]="./mk t3_t982 --vab --avb2 --fastboot-write"
kernel_exec[27]="./mk t982_ar301 -v "
###########################################################################################

###########################################################################################
# calla
project[28]="Calla"
soc[28]="t5m_ay301"
hardware[28]="AY301"
module[28]="calla_gtv"
uboot_path[28]="device/amlogic/calla"
uboot_exec_aosp[28]="./mk t5m_ay301 --vab --avb2 --fastboot-write"
uboot_exec_drm[28]="./mk t5m_ay301 --vab --avb2 --fastboot-write"
kernel_exec[28]="./mk calla -v "
###########################################################################################

###########################################################################################
# AP201
project[29]="AP201"
soc[29]="S905W2"
hardware[29]="AP201"
module[29]="ap201"
uboot_path[29]="device/amlogic/ap201"
uboot_exec_aosp[29]="./mk s4_ap201  --vab --avb2 --fastboot-write"
uboot_exec_drm[29]="./mk s4_ap201  --vab --avb2 --fastboot-write"
kernel_exec[29]="./mk ap201 -v"
###########################################################################################

###########################################################################################
# OHMCAS2 GTV
project[30]="Ohmcas2-GTV"
soc[30]="S905C2L"
hardware[30]="AH221"
module[30]="ohmcas2_gtv"
uboot_path[30]="device/amlogic/ohmcas2"
uboot_exec_aosp[30]="./mk sc2_ah221  --vab --avb2 --fastboot-write"
uboot_exec_drm[30]="./mk sc2_ah221  --vab --avb2 --fastboot-write"
kernel_exec[30]="./mk ohmcas2 --gki_image -v "
###########################################################################################

###########################################################################################
# OHMCAS2 ATV
project[31]="Ohmcas2-ATV"
soc[31]="S905C2L"
hardware[31]="AH221"
module[31]="ohmcas2"
uboot_path[31]="device/amlogic/ohmcas2"
uboot_exec_aosp[31]="./mk sc2_ah221  --vab --avb2 --fastboot-write"
uboot_exec_drm[31]="./mk sc2_ah221  --vab --avb2 --fastboot-write"
kernel_exec[31]="./mk ohmcas2 --gki_image -v "
###########################################################################################

###########################################################################################
# Tyson
project[32]="Tyson"
soc[32]="S928X"
hardware[32]="AX201"
module[32]="tyson"
uboot_path[32]="device/amlogic/tyson"
uboot_exec_aosp[32]="./mk s5_ax201  --vab --avb2 --fastboot-write"
uboot_exec_drm[32]="./mk s5_ax201  --vab --avb2 --fastboot-write"
kernel_exec[32]="./mk tyson -v "
###########################################################################################

###########################################################################################
# Bluebell
project[33]="Bluebell"
soc[33]="A311D2"
hardware[33]="AN400"
module[33]="bluebell_arm64"
uboot_path[33]="device/amlogic/bluebell"
uboot_exec_aosp[33]="./mk t7_an400_lpddr4x_bluebell --vab --avb2 --fastboot-write"
uboot_exec_drm[33]="./mk t7_an400_lpddr4x_bluebell --vab --avb2 --fastboot-write"
kernel_exec[33]="./mk bluebell -v "
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
    "       2. 4  Params: [project-name][android-type][kernel-type][user/userdebug].\n" \
    "                  ./xxxx.sh ohm_gtv GTVS 5.15 userdebug.\n" \

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
        printf "[%3s]   [%18s]  [%15s]  [%15s]\n" "NUM" "PROJECT" "SOC TYPE" "HARDWARE TYPE"
        echo "-----------------------------------------------------------------"
        for i in `seq ${#project[@]}`;do
            printf "[%3d]   [%18s]  [%15s]  [%15s]\n" $i ${project[i]} ${soc[i]} ${hardware[i]}
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
        "Select compile Android version type lists:\n"\
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
# Get Kernel Type: common14-5.15/5.4/4.9
########################################################################################################################################################################
read_kernel_type() {
    while true :
    do
        echo -e \
        "Select kernel version type lists:\n"\
        "[NUM]   [Kernel Version]\n" \
        "[  1]   [common14-5.15]\n" \
        "[  2]   [5.4 ]\n" \
        "[  3]   [4.9 ]\n" \
        "--------------------------------------------\n"

        default=1
        read -p "Please input Kernel Version (default $default):" kernel_type
        if [ ${#kernel_type} -eq 0 ]; then
            kernel_type=$default
            break
        fi
        if [[ $kernel_type -lt 1 || $kernel_type -gt 3 ]];then
            echo -e "\nError: The Kernel Version is illegal, please Input again [1 ~ 3]}\n"
            echo -e "Please click Enter to continue"
            read
        else
            break
        fi
    done
}
########################################################################################################################################################################
#
# Compile Uboot through params
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
    if [ -d "bootloader/uboot-repo/bl2/bin/" ];then
    cd bootloader/uboot-repo/bl2/bin/
    echo "bl2       : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/bl30/bin/" ];then
    cd bootloader/uboot-repo/bl30/bin/
    echo "bl30      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/bl30/src_ao/" ];then
    cd bootloader/uboot-repo/bl30/src_ao/
    echo "bl30 src  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/bl31/bin/" ];then
    cd bootloader/uboot-repo/bl31/bin/
    echo "bl31      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/bl31_1.3/bin/" ];then
    cd bootloader/uboot-repo/bl31_1.3/bin/
    echo "bl31_1.3  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/bl32_3.8/bin/" ];then
    cd bootloader/uboot-repo/bl32_3.8/bin/
    echo "bl32_3.8  : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/bl33/v2015" ];then
    cd bootloader/uboot-repo/bl33/v2015
    echo "bl33      : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/bl33/v2019" ];then
    cd bootloader/uboot-repo/bl33/v2019
    echo "bl33_v2019: "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "bootloader/uboot-repo/fip/" ];then
    cd bootloader/uboot-repo/fip/
    echo "fip       : "$(git log --pretty=format:"%H" -1); cd ../../../
    fi
    if [ -d "vendor/amlogic/common/tdk/" ];then
    cd vendor/amlogic/common/tdk/
    echo "tdk       : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
    if [ -d "vendor/amlogic/common/tdk_v3/" ];then
    cd vendor/amlogic/common/tdk_v3/
    echo "tdk_v3    : "$(git log --pretty=format:"%H" -1); cd ../../../../
    fi
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
    if [ $kernel_type -eq 1 ]; then
        kernel_version="common14-5.15"
		android_kernel_version="5.15"
    elif [ $kernel_type -eq 2 ]; then
        kernel_version="5.4"
		android_kernel_version="5.4"
    elif [ $kernel_type -eq 3 ]; then
        kernel_version="4.9"
		android_kernel_version="4.9"
    else
        echo "Kernel Version is illegal\n"
        exit
    fi
    usermode="userdebug"
    ${kernel_addr[platform_type]}
    if [ $# -eq 1 ]; then usermode="$1"; fi
    echo "${kernel_exec[platform_type]} ${kernel_version} -t ${usermode}"
    ${kernel_exec[platform_type]} ${kernel_version} -t ${usermode}
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
    elif [ $1 == "oemimage" ]; then
        make custom_images -j8
    fi
    exit
}
########################################################################################################################################################################
# Main Function
########################################################################################################################################################################
if [[ $# -eq 1 && $1 == *"help"* ]] || [ $# -eq 2 ] || [ $# -gt 4 ]; then
    usage
    exit
fi
# Select and build all image.
if [ $# -eq 0 ]; then
    read_platform_type
    read_android_type
    read_kernel_type
    compile_uboot
    compile_kernel
    lunch_env
    make "TARGET_BUILD_KERNEL_VERSION=${android_kernel_version}" -j8
fi

if [ $# -eq 1 ]; then
    read_platform_type
    read_android_type
    read_kernel_type
    if [[ $1 == *"uboot"* ]]; then
        compile_sub_uboot $1
    fi
    compile_sub_system $1
fi

if [ $# -eq 4 ]; then
    if [ -d "vendor/google_gtvs" ];then
        default=3
    else
        default=2
    fi
    uboot_drm_type=$default
    platform_type=0
    usermode="userdebug"
    kernel_type="1"
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
    if [[ $@ == *"5.15"* ]]; then
        kernel_type="1"
    elif [[ $@ == *"5.4"* ]]; then
        kernel_type="2"
    elif [[ $@ == *"4.9"* ]]; then
        kernel_type="3"
    else
        echo -e "please add params:Kernel version common14-5.15/5.4/4.9\n"
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
        echo -e "please add params:platform like ohm/ohm_gtv/redi\n"
        exit
    fi
    echo $platform_type $uboot_drm_type $kernel_type $usermode
    compile_uboot
    compile_kernel $usermode
    lunch_env $usermode
    make "TARGET_BUILD_KERNEL_VERSION=${android_kernel_version}" -j8
fi