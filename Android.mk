#
# Copyright (C) 2019 The Android Open Source Project
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

# "Beast" to be removed later after s/Beast/beast/ gets done.

ifneq ($(filter anemone adt2 adt3 adt4 ampere braun curie darwin atom beast Beast galilei franklin franklin_hybrid faraday deadpool sabrina fermi newton elektra marconi ohm ohm_wv4 oppen_wv4 planck_wv4 ohmcas redi redi_wv4 oppen oppencas planck einstein smith t982_ar301 soddy t7_an400 ohm_mxl258c ohm_wv4_mxl258c dalton oppencas_mxl258c calla calla_wv4 tyson bluebell_wv4 bluebell_wv4_atv tyson_mxl258c qurra t950s_be311 ross ross_atv raman raman_atv pascal,$(TARGET_DEVICE)),)

include $(all-subdir-makefiles)
endif
