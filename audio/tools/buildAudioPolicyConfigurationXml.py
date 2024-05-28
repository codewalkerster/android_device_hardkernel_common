import sys, shutil, os, sys
import logging
import argparse

import xml.etree.ElementTree as ET

AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE = ''

AUDIO_POLICY_TOOLS_PATH = ''
ANDROID_CODE_ROOT_PATH = ''

license = ET.Comment("""Copyright (C) 2024 The Android Open Source Project

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    """)

def indent(elem, level=0):
    i = "\n" + level*"    "  # use the 4 space
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "    "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for elem in elem:
            indent(elem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i

def modifyProfile(baseXmlRoot, buildTypeXmlRoot):
    for buildTypeXml_profileRoot in buildTypeXmlRoot.findall('.//profile'):
        foundFormat = False
        for profile in baseXmlRoot.findall('.//profile'):
            if profile.get('format') == buildTypeXml_profileRoot.get('format'):
                foundFormat = True
                # Overlay profile
                index = list(baseXmlRoot).index(profile)
                baseXmlRoot.insert(index, buildTypeXml_profileRoot)
                baseXmlRoot.remove(profile)
                break
        if not foundFormat:
            # insert first position, profile
            baseXmlRoot.insert(0, buildTypeXml_profileRoot)
            logging.info('[buildAudioPolicyConfigurationXml:I] add new profile, format: ' + buildTypeXml_profileRoot.get('format'))

def modifyRoute(ports, port, portName, routes, audioPolicyCommonRoutesXmlRoot, mixportPortArray, devicePortArray):
    if port.get('role')  == 'sink':
        foundPortInRoutes = False
        for audioPolicyCommonRoutesXml_routeRoot in audioPolicyCommonRoutesXmlRoot.findall('.//route'):
            if portName == audioPolicyCommonRoutesXml_routeRoot.get('sink'):
                foundPortInRoutes = True
                sourcesArray = audioPolicyCommonRoutesXml_routeRoot.get('sources').split(',')
                sourcesArray = [x for x in sourcesArray if x in mixportPortArray or x in devicePortArray]
                if len(sourcesArray) == 0:
                    # clear redundant port (sink port)
                    ports.remove(port)
                    logging.info('[buildAudioPolicyConfigurationXml:I] unused sink portName:' + portName)
                else:
                    sources = ','.join(sourcesArray)
                    route = ET.SubElement(routes, "route")
                    route.set("type", "mix")
                    route.set("sink", portName)
                    route.set("sources", sources)
                break
        if not foundPortInRoutes:
            ports.remove(port)
            logging.info('[buildAudioPolicyConfigurationXml:I] not find portName:' + portName + ', in audio_policy_common_routes.xml')
    else:
        foundPortInRoutesSource = False
        for audioPolicyCommonRoutesXml_routeRoot in audioPolicyCommonRoutesXmlRoot.findall('.//route'):
            sink = audioPolicyCommonRoutesXml_routeRoot.get('sink')
            if sink in devicePortArray or sink in mixportPortArray:
                sourcesArray = audioPolicyCommonRoutesXml_routeRoot.get('sources').split(',')
                if portName in sourcesArray:
                    foundPortInRoutesSource = True
                    break
        if not foundPortInRoutesSource:
            # clear redundant port (source port)
            ports.remove(port)
            logging.info('[buildAudioPolicyConfigurationXml:I] unused source portName:' + portName)

def genRoutes(routes, mixPorts, devicePorts, audioPolicyCommonRoutesXmlRoot):
    mixportPortArray = []
    devicePortArray = []
    for devicePort in devicePorts.findall('devicePort'):
        devicePortArray.append(devicePort.get('tagName'))
    for mixPort in mixPorts.findall('mixPort'):
        mixportPortArray.append(mixPort.get('name'))
    # 1. routes for devicePort
    for devicePort in devicePorts.findall('devicePort'):
        devicePortName = devicePort.get('tagName')
        modifyRoute(devicePorts, devicePort, devicePortName, routes, audioPolicyCommonRoutesXmlRoot, mixportPortArray, devicePortArray)
    # 2. routes for mixPort
    for mixPort in mixPorts.findall('mixPort'):
        mixPortName = mixPort.get('name')
        modifyRoute(mixPorts, mixPort, mixPortName, routes, audioPolicyCommonRoutesXmlRoot, mixportPortArray, devicePortArray)

# TODO: add 32bit profile for primary output
def modify32BitProfile(mixPorts, devicePorts):
    for mixport in mixPorts.findall('.//mixPort'):
        if mixport.get('name') in ['primary output']:
            for profile in mixport.findall('.//profile'):
                if profile.get('format') == 'AUDIO_FORMAT_PCM_16_BIT':
                    profile.set('format', 'AUDIO_FORMAT_PCM_32_BIT')
                    break
            break

def replaceBuildTypeXml(supportBuildTypes, mixPorts, devicePorts):
    if len(supportBuildTypes) == 0:
        logging.info('[buildAudioPolicyConfigurationXml:I] build type size is 0, do nothing')
        return
    modifyValueByStrIfExistInBuildType = lambda buildTypeport, port, tags: \
        [port.set(tag, buildTypeport.get(tag)) if buildTypeport.get(tag) != None else None for tag in tags]

    for type in supportBuildTypes:
        buildTypeXmlPath = AUDIO_POLICY_TOOLS_PATH + 'audio_policy_common_build_type/audio_policy_common_' + type + '.xml'
        logging.debug('[buildAudioPolicyConfigurationXml:D] process file:' + buildTypeXmlPath + ' <----------------------')

        audioPolicyCommonBuildTypeXmlTree = ET.parse(buildTypeXmlPath)
        audioPolicyCommonBuildTypeXmlRoot = audioPolicyCommonBuildTypeXmlTree.getroot()

        # mixPorts
        logging.debug('[buildAudioPolicyConfigurationXml:D] replaceBuildTypeXml: mixport process >>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
        for audioPolicyCommonBuildTypeXml_mixPortRoot in audioPolicyCommonBuildTypeXmlRoot.findall('.//mixPort'):
            buildTypeMixPortName = audioPolicyCommonBuildTypeXml_mixPortRoot.get('name')
            logging.debug('[buildAudioPolicyConfigurationXml:D] -- name:' + buildTypeMixPortName)
            foundMixPort = False
            compressOffloadMixport = None
            for mixport in mixPorts.findall('.//mixPort'):
                mixportName = mixport.get('name')
                if mixportName == 'compress offload':
                    compressOffloadMixport = mixport
                if mixportName == buildTypeMixPortName:
                    foundMixPort = True
                    logging.debug('[buildAudioPolicyConfigurationXml:D] modifyProfile mixPort name:' + mixportName)
                    modifyValueByStrIfExistInBuildType(audioPolicyCommonBuildTypeXml_mixPortRoot, mixport, ['flags', 'maxOpenCount', 'maxActiveCount'])
                    modifyProfile(mixport, audioPolicyCommonBuildTypeXml_mixPortRoot)
            if not foundMixPort:
                # append mixport
                if (buildTypeMixPortName == 'ms12 direct') and (compressOffloadMixport != None):
                    # TODO: workaround for ADSK. Put 'ms12 direct' profile before 'compress offload' profile.
                    compressOffloadIndex = list(mixPorts).index(compressOffloadMixport)
                    mixPorts.insert(compressOffloadIndex, audioPolicyCommonBuildTypeXml_mixPortRoot)
                else:
                    mixPorts.append(audioPolicyCommonBuildTypeXml_mixPortRoot)
                logging.info('[buildAudioPolicyConfigurationXml:I] add new mixport, profile name: ' + buildTypeMixPortName)

        # devicePorts
        logging.debug('[buildAudioPolicyConfigurationXml:D] replaceBuildTypeXml: devicePort process >>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
        for audioPolicyCommonBuildTypeXml_deviceportRoot in audioPolicyCommonBuildTypeXmlRoot.findall('.//devicePort'):
            foundDevicePort = False
            logging.debug('[buildAudioPolicyConfigurationXml:D]  -- tagName:' + audioPolicyCommonBuildTypeXml_deviceportRoot.get('tagName'))
            for devicePort in devicePorts.findall('.//devicePort'):
                if devicePort.get('tagName') == audioPolicyCommonBuildTypeXml_deviceportRoot.get('tagName'):
                    foundDevicePort = True
                    logging.debug('[buildAudioPolicyConfigurationXml:D] modifyProfile devicePort tagName:' + devicePort.get('tagName'))
                    modifyProfile(devicePort, audioPolicyCommonBuildTypeXml_deviceportRoot)
            if not foundDevicePort:
                logging.info('[buildAudioPolicyConfigurationXml:W] not find devicePort, tagName: ' + audioPolicyCommonBuildTypeXml_deviceportRoot.get('tagName'))
        # TODO: Workaround: Speakers on the OTT platform do not need to support non-stereo PCM format(DD, DDP...) playback. For NTS
        for devicePort in devicePorts.findall('.//devicePort'):
            if devicePort.get('tagName') == 'Speaker':
                if AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE == 'mbox':
                    for profile in devicePort.findall('.//profile'):
                        devicePort.remove(profile)
                else:
                    break

def genXmlFile(outputFilePath, odm, chipDeviceType, audioBuildType, soundbarProduct, version):
    sbrSuffix = ''
    if soundbarProduct == 'true':
        sbrSuffix = '_sbr'
    AUDIO_POLICY_DEVICES_XML_PATH = ANDROID_CODE_ROOT_PATH + '/device/' + odm + '/'+ chipDeviceType + '/files/audio_policy_devices' + sbrSuffix + '.xml'
    supportBuildTypes = [i for i in audioBuildType.split("_") if i]
    logging.info('[buildAudioPolicyConfigurationXml:I] devices xml path:' + AUDIO_POLICY_DEVICES_XML_PATH)
    logging.info('[buildAudioPolicyConfigurationXml:I] audio buildType:' + str(supportBuildTypes))
    for type in supportBuildTypes:
        filepath = AUDIO_POLICY_TOOLS_PATH + 'audio_policy_common_build_type/audio_policy_common_' + type + '.xml'
        if os.path.exists(filepath) is False:
            logging.error('[buildAudioPolicyConfigurationXml:E] not exsit filepath:' + filepath)
            return

    # read base xml
    audioPolicyCommonBaseXmlTree = ET.parse(AUDIO_POLICY_TOOLS_PATH + 'audio_policy_common_base.xml')
    audioPolicyCommonBaseXmlRoot = audioPolicyCommonBaseXmlTree.getroot()
    module = audioPolicyCommonBaseXmlRoot.find('.//module')
    mixPorts = audioPolicyCommonBaseXmlRoot.find('.//mixPorts')
    devicePorts = audioPolicyCommonBaseXmlRoot.find('.//devicePorts')
    attachedDevices = audioPolicyCommonBaseXmlRoot.find('.//attachedDevices')

    audioPolicyDevicesXmlTree = ET.parse(AUDIO_POLICY_DEVICES_XML_PATH)
    audioPolicyDevicesXmlRoot = audioPolicyDevicesXmlTree.getroot()

    audioPolicyCommonDevicePortsXmlTree = ET.parse(AUDIO_POLICY_TOOLS_PATH + 'audio_policy_common_devicePorts.xml')
    audioPolicyCommonDevicePortsXmlRoot = audioPolicyCommonDevicePortsXmlTree.getroot()

    audioPolicyCommonRoutesXmlTree = ET.parse(AUDIO_POLICY_TOOLS_PATH + 'audio_policy_common_routes.xml')
    audioPolicyCommonRoutesXmlRoot = audioPolicyCommonRoutesXmlTree.getroot()

    # insert the license text
    audioPolicyCommonBaseXmlRoot.insert(0, license)
    # insert the build type info
    buildInfo = ET.Comment(' device:' + chipDeviceType + ', buildType:' + audioBuildType + ', soundbar:' + soundbarProduct + ' ')
    audioPolicyCommonBaseXmlRoot.insert(0, buildInfo)

    # attachedDevices
    if attachedDevices is None:
        logging.info('[buildAudioPolicyConfigurationXml:I] not find attachedDevices!!! insert attachedDevices')
        attachedDevices = ET.SubElement(module, "attachedDevices")
    audioPolicyDevicesXml_attachedDevicesRoot = audioPolicyDevicesXmlRoot.find('.//attachedDevices')
    audioPolicyDevicesXml_devicePortsRoot = audioPolicyDevicesXmlRoot.find('.//devicePorts')
    if audioPolicyDevicesXml_attachedDevicesRoot is not None:
        attachedDevices.clear()
    for audioPolicyDevicesXml_attachedDevices_itemRoot in audioPolicyDevicesXml_attachedDevicesRoot.findall('item'):
        found = False
        for audioPolicyDevicesXml_devicePorts_itemRoot in audioPolicyDevicesXml_devicePortsRoot.findall('item'):
            if audioPolicyDevicesXml_devicePorts_itemRoot.text == audioPolicyDevicesXml_attachedDevices_itemRoot.text:
                found = True
                break
        if not found:
            logging.error('[buildAudioPolicyConfigurationXml:E] invalid attachedDevices:' +
                         audioPolicyDevicesXml_attachedDevices_itemRoot.text + ' in devicePorts define')
            return
        attachedDevices.append(audioPolicyDevicesXml_attachedDevices_itemRoot)

    # devicePorts
    if devicePorts is None:
        logging.info('[buildAudioPolicyConfigurationXml:I] not find devicePorts in audio_policy_common_base.xml, insert devicePorts')
        devicePorts = ET.SubElement(module, "devicePorts")
    audioPolicyCommonDevicePortsXml_devicePortsRoot = audioPolicyCommonDevicePortsXmlRoot.find('.//devicePorts')
    if audioPolicyDevicesXml_devicePortsRoot is None:
        logging.error('[buildAudioPolicyConfigurationXml:E] not find devicePorts in audio_policy_devices.xml. return.')
        return
    if audioPolicyCommonDevicePortsXml_devicePortsRoot is None:
        logging.error('[buildAudioPolicyConfigurationXml:E] not find devicePorts in audio_policy_common_devicePorts.xml. return.')
        return
    devicePorts.clear()
    for audioPolicyDevicesXml_devicePorts_itemRoot in audioPolicyDevicesXml_devicePortsRoot.findall('item'):
        logging.debug('[buildAudioPolicyConfigurationXml:D] audioPolicyDevicesXml_devicePorts_itemRoot:' + audioPolicyDevicesXml_devicePorts_itemRoot.text)
        for devicePortInTableXml in audioPolicyCommonDevicePortsXml_devicePortsRoot:
            # logging.debug('[buildAudioPolicyConfigurationXml:D] audioPolicyDevicesXml_devicePorts_itemRoot:' + audioPolicyDevicesXml_devicePorts_itemRoot.text + ', common:' + devicePortInTableXml.get('tagName'))
            if audioPolicyDevicesXml_devicePorts_itemRoot.text == devicePortInTableXml.get('tagName'):
                logging.debug('[buildAudioPolicyConfigurationXml:D] find devicePort:' + audioPolicyDevicesXml_devicePorts_itemRoot.text)
                devicePorts.append(devicePortInTableXml)
                break

    # read build type xml(_dtshd, _ddp, _ms12...)
    replaceBuildTypeXml(supportBuildTypes, mixPorts, devicePorts)

    # TODO: workaround, Google multichannel-PCM playback has a bug. For atv version, delete multi-channel PCM.
    for mixport in mixPorts.findall('.//mixPort'):
        mixportName = mixport.get('name')
        if version == 'atv' and (mixportName == 'direct pcm' or mixportName == 'tunnel pcm' or mixportName == 'compress offload'):
            for profile in mixport.findall('.//profile'):
                if profile.get('format') == 'AUDIO_FORMAT_PCM_16_BIT':
                    profile.set('channelMasks', 'AUDIO_CHANNEL_OUT_STEREO')
    for devicePort in devicePorts.findall('.//devicePort'):
        devicePortName = devicePort.get('tagName')
        if version == 'atv' and (devicePortName == 'Speaker' or devicePortName == 'HDMI ARC' or devicePortName == 'HDMI EARC'):
            for profile in devicePort.findall('.//profile'):
                if profile.get('format') == 'AUDIO_FORMAT_PCM_16_BIT':
                    profile.set('channelMasks', 'AUDIO_CHANNEL_OUT_STEREO')
    # routes
    routes = module.find('routes')
    if routes != None:
        module.remove(routes)
    routes = ET.SubElement(module, "routes")
    genRoutes(routes, mixPorts, devicePorts, audioPolicyCommonRoutesXmlRoot)

    # TODO: add 32bit PCM profile for tv product. In the future, all products will support 32bit.
    if AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE == 'tv':
        modify32BitProfile(mixPorts, devicePorts)

    # write to XML file
    indent(audioPolicyCommonBaseXmlRoot)
    audioPolicyCommonBaseXmlTree.write(outputFilePath, encoding='unicode', xml_declaration=True)
    # audioPolicyCommonBaseXmlTree.write(outputFilePath, encoding='utf-8', xml_declaration=True)

def parseArgs():

    argparser = argparse.ArgumentParser(description="build audio_policy_configuration.xml need some parameters.")
    argparser.add_argument('--odmDirName',
                           help="odm directory name (amlogic, zte, smdc...). Mandatory.",
                           required=True)
    argparser.add_argument('--chipDeviceType',
                           help="chip device directory name (ohm, calla, oppen...). Mandatory.",
                           required=True)
    argparser.add_argument('--audioBuildType',
                           help="audio build type (ms12, ddp, dtshd...). Mandatory.",
                           metavar="audioBuildType",
                           required=True)
    argparser.add_argument('--soundbarProduct',
                           help="Soundbar Product type. Mandatory.",
                           metavar="soundbarProduct",
                           required=True)
    argparser.add_argument('--atvVersion',
                           help="atvVersion(atv, aosp).",
                           required=True)
    argparser.add_argument('--productType',
                           help="productType(tv, mbox).",
                           required=True)
    return argparser.parse_args()

def main():
    # logging.basicConfig(level=logging.DEBUG, format='%(message)s')
    # logging.basicConfig(level=logging.INFO, format='%(message)s')
    logging.basicConfig(level=logging.WARN, format='%(message)s')
    global AUDIO_POLICY_TOOLS_PATH, ANDROID_CODE_ROOT_PATH, AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE
    AUDIO_POLICY_TOOLS_PATH = os.path.dirname(os.path.abspath(__file__)) + '/'
    ANDROID_CODE_ROOT_PATH = AUDIO_POLICY_TOOLS_PATH
    for _ in range(6):
        ANDROID_CODE_ROOT_PATH = os.path.dirname(ANDROID_CODE_ROOT_PATH)
    if len(sys.argv) != 1:
        args = parseArgs()
        logging.warning('[buildAudioPolicyConfigurationXml:W] odm:' + args.odmDirName + ' device:' + args.chipDeviceType
                    + ', audioBuildType:' + args.audioBuildType + ', soundbar:' + args.soundbarProduct + ', version:' + args.atvVersion + ', product:' + args.productType)
        AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE = args.productType
        outputFilePath = AUDIO_POLICY_TOOLS_PATH + 'output_xml/audio_policy_configuration.xml'
        genXmlFile(outputFilePath, args.odmDirName, args.chipDeviceType, args.audioBuildType, args.soundbarProduct, args.atvVersion)
        for dolby in ['_ms12', '_ms12v1', '_ddp', '']:
            for dts in ['_dtshd', '_dtsx', '']:
                buildTypeName = dolby + dts
                fileName = buildTypeName;
                if fileName == '':
                    fileName = '_default'
                outputFilePath = AUDIO_POLICY_TOOLS_PATH + 'output_xml/' + 'audio_policy_configuration' + fileName + '.xml'
                genXmlFile(outputFilePath, args.odmDirName, args.chipDeviceType, buildTypeName, args.soundbarProduct, args.atvVersion)
    else:
        # cmd: python3 buildAudioPolicyConfigurationXml.py
        logging.warning('[buildAudioPolicyConfigurationXml:W] debug mode')
        ottName = 'ohm_wv4'
        tvName = 'calla'
        for dolby in ['_ms12', '_ms12v1', '_ddp', '']:
            for dts in ['_dtshd', '_dtsx', '']:
                outputFilePath = AUDIO_POLICY_TOOLS_PATH + 'output_files_test/' + ottName + dolby + dts + '.xml'
                AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE = 'mbox'
                logging.info('[buildAudioPolicyConfigurationXml:I] ----------------------generate file:' + outputFilePath)
                genXmlFile(outputFilePath, 'amlogic', ottName, dolby + dts, 'false', 'aosp')
                outputFilePath = AUDIO_POLICY_TOOLS_PATH + 'output_files_test/' + tvName + dolby + dts + '.xml'
                AUDIO_POLICY_BUILD_PARAM_PRODUCT_TYPE = 'tv'
                logging.info('[buildAudioPolicyConfigurationXml:I] ----------------------generate file:' + outputFilePath)
                genXmlFile(outputFilePath, 'amlogic', tvName, dolby + dts, 'false', 'aosp')

if __name__ == "__main__":
    sys.exit(main())
