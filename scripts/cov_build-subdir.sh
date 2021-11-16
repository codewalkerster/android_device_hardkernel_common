#!/bin/bash

echo "Cov-debug: mode:$1"

echo "Cov-debug: dir:$2"

source build/envsetup.sh && lunch $1
[ $? -ne 0 ] && echo -e "Cov-debug: set env or lunch($1) failure, please check" && exit 1

if [ ! -d $2 ]; then
    echo -e "Folder does not exist, please check the input parameters " && exit 1
fi

cd $2 && mm
[ $? -ne 0 ] && echo -e "build dir({$2}) failure failure " && exit 1

echo "Cov-debug: detect android success " && exit 0