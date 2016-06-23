# Copyright (C) 2013 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#for amlogicplayer& liblayer related.
BUILD_WITH_AMLOGIC_PLAYER :=true

PRODUCT_PACKAGES += libmedia_amlogic \
    librtmp \
    libmms_mod \
    libcurl_mod \
    libvhls_mod \
    libprhls_mod \
    libdash_mod.so  \
    ca-certificates.crt \
    libstagefright_wfd_sink

PRODUCT_PACKAGES += libamadec_omx_api \
    libfaad    \
    libape     \
    libmad     \
    libflac    \
    libcook    \
    libraac    \
    libamr     \
    libpcm     \
    libadpcm   \
    libpcm_wfd \
    libamadec_wfd_out

PRODUCT_PACKAGES += \
    libstagefright_soft_aacdec \
    libstagefright_soft_aacenc \
    libstagefright_soft_amrdec \
    libstagefright_soft_amrnbenc \
    libstagefright_soft_amrwbenc \
    libstagefright_soft_flacenc \
    libstagefright_soft_g711dec \
    libstagefright_soft_mp3dec \
    libstagefright_soft_mp2dec \
    libstagefright_soft_vorbisdec \
    libstagefright_soft_rawdec \
    libstagefright_soft_adpcmdec \
    libstagefright_soft_adifdec \
    libstagefright_soft_latmdec \
    libstagefright_soft_adtsdec \
    libstagefright_soft_alacdec \
    libstagefright_soft_dtshd \
    libstagefright_soft_apedec   \
    libstagefright_soft_wmaprodec \
    libstagefright_soft_wmadec    \
    libstagefright_soft_ddpdcv \

#soft codec related.
#
PRODUCT_PACKAGES += \
    libopenHEVC\
    libstagefright_soft_amh265dec\
    libstagefright_soft_amsoftdec\
    libstagefright_soft_amsoftadec \
    libamffmpegadapter

PRODUCT_PACKAGES += com.google.widevine.software.drm.xml \
    com.google.widevine.software.drm \
    libWVStreamControlAPI_L1 \
    libdrmwvmplugin_L1 \
    libwvm_L1 \
    libwvdrm_L1 \
    libWVStreamControlAPI_L3 \
    libdrmwvmplugin \
    libwvm \
    libwvdrm_L3 \
    libotzapi \
    libwvsecureos_api \
    libdrmdecrypt \
    libwvdrmengine \
    liboemcrypto \
    widevine \
    wvcenc
