How to use boot video function:

1.add the config in device/hardkernel/common/BoardConfig.mk :
  BOOT_VIDEO_ENABLE ?= true

2.copy the boot video file to device/hardkernel/common/bootvideo ,rename to bootanimation.ts please!

3.rebuild system.

