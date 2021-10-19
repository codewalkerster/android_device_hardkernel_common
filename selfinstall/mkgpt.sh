#! /bin/sh

UPGRADE_TOOL=RKTools/linux/Linux_Upgrade_Tool/Linux_Upgrade_Tool_v1.59/upgrade_tool
PARAMETER=odroidev/Image-odroidm1/parameter.txt
GPT=device/hardkernel/common/selfinstall/gpt.img

$UPGRADE_TOOL gpt $PARAMETER $GPT
