#!/vendor/bin/sh


for module in `cat  /vendor/lib/modules/modules.load`
do
    insmod /vendor/lib/modules/$module
done

