#!/vendor/bin/sh

system_modules_dir=$(echo /system/lib/modules/5.15*)
for module in `cat /vendor/lib/modules/modules.load`; do
	system_module=`grep "/${module}" vendor/lib/modules/system_dlkm.modules.load`
	if [ -f ${system_modules_dir}/${system_module} ]; then
		 insmod ${system_modules_dir}/${system_module}
	else
		insmod /vendor/lib/modules/${module}
	fi
done
