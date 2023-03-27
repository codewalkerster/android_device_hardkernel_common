#!/vendor/bin/sh

system_modules_dir=$(echo /system/lib/modules/5.15*)
for module in `cat /vendor/lib/modules/system_dlkm.modules.load`
do
    insmod ${system_modules_dir}/${module}
done

for module in `cat /vendor/lib/modules/modules.load`
do
    insmod /vendor/lib/modules/$module
done

