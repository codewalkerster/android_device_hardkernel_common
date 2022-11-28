import os
import sys

def format_xml(filename):
    # 1. 读取xml内容
    fd = open(filename, 'r', encoding = 'utf-8')
    lines = fd.readlines()
    fd.close()
    fd = open(filename, 'r', encoding = 'utf-8')
    context = fd.read()
    fd.close()

    # 临时标志位
    flag = 0

    comments=list()
    mediacodecs=list()
    decoders=list()
    settings=list()
    encoders=list()

    revise_mediacodecs = list()
    revise_decoders=list()
    revise_settings=list()
    revise_encoders=list()
    media_codes_start='<Included>'
    media_codes_end='</Included>'
    if '<Included>' not in context:
        media_codes_start='<MediaCodecs>'
        media_codes_end='</MediaCodecs>'
    print(filename + " " + media_codes_start)


    # 2. 读取存储正文之前的注释信息，注在'<Included>'之前的均默认为注释信息，返回列表comments
    for line in lines:
        if media_codes_start in line:
            break
        comments.append(line)

    # 3. 读取'<Included>'信息，返回列表mediacodecs
    for line in lines:
        if media_codes_start in line:
            flag = 1
        if flag == 1:
            mediacodecs.append(line)
        if media_codes_end in line:
            flag = 0
    if len(mediacodecs) == 0:
        return

    # 4. '<Included>'信息进行格式化，返回列表revise_mediacodecs
    i = 0
    for line in mediacodecs:
        i = i + 1
        if media_codes_start in line or media_codes_end in line:
            revise_mediacodecs.append(line.lstrip())
        elif '<Decoders>' in line or '</Decoders>' in line or '<Settings>' in line or '</Settings>' in line or '<Encoders>' in line or '</Encoders>' in line:
            revise_mediacodecs.append("    " + line.lstrip())
        elif '<MediaCodec' in line or '</MediaCodec>' in line or '<Setting' in line or '<Variant' in line:
            revise_mediacodecs.append("        " + line.lstrip())
        elif line.strip() == '':
            continue
        else:
            revise_mediacodecs.append("            " + line.lstrip())

    # 5. 读取'</Decoders>'信息，并进行排序归类，返回列表revise_decoders
    for line in revise_mediacodecs:
        if '<Decoders>' in line:
            flag = 1
        if flag == 1:
            decoders.append(line)
        if '</Decoders>' in line:
            flag = 0
            break

    temp=list()
    for line in decoders:
        if '<Decoders>' in line or '</Decoders>' in line:
            continue
        if '<MediaCodec' in line and '/>' in line:
            revise_decoders.append(line)
            continue
        if '<MediaCodec' in line:
            flag = 1
        if flag == 1:
            temp.append(line)
        if '</MediaCodec>' in line:
            revise_decoders.append(''.join(temp))
            temp.clear()

    # 6. 读取'</Encoders>'信息，并进行排序归类，返回列表revise_encoders
    flag = 0
    for line in revise_mediacodecs:
        if '<Encoders>' in line:
            flag = 1
        if flag == 1:
            encoders.append(line)
        if '</Encoders>' in line:
            flag = 0
            break

    temp.clear()
    for line in encoders:
        if '<Encoders>' in line or '</Encoders>' in line:
            continue
        if '<MediaCodec' in line and '/>' in line:
            revise_encoders.append(line)
            continue
        if '<MediaCodec' in line:
            flag = 1
        if flag == 1:
            temp.append(line)
        if '</MediaCodec>' in line:
            revise_encoders.append(''.join(temp))
            temp.clear()

    # 6. 读取'</Settings>'信息，比较少，且不变，因此不动这部分
    flag = 0
    for line in revise_mediacodecs:
        if '<Settings>' in line:
            flag = 1
        if flag == 1:
            settings.append(line)
        if '</Settings>' in line:
            flag = 0
            break

    if 'backup' in sys.argv:
        fd = open("result_" + filename, 'w')
    else:
        fd = open(filename, 'w')

    revise_decoders.sort()
    revise_encoders.sort()
    fd.write(''.join(comments))
    fd.write(media_codes_start + "\n")
    if len(revise_decoders) != 0:
        fd.write("    <Decoders>\n")
        fd.write(''.join(revise_decoders))
        fd.write("    </Decoders>\n")
    if len(settings) != 0:
        fd.write(''.join(settings))
    if len(revise_encoders) != 0:
        fd.write("    <Encoders>\n")
        fd.write(''.join(revise_encoders))
        fd.write("    </Encoders>\n")
    fd.write(media_codes_end)
    fd.close()



for files in sys.argv:
    if 'media_codec' in files and os.path.exists(files):
        format_xml(files)

