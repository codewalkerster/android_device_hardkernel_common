#!/bin/bash
export ARCH=arm64
export ARCHV=aarch64
export CROSS_COMPILE=aarch64-linux-gnu-
export BOARD_COMPILE_ATV=false
export BOARD_COMPILE_CTS=false
export PATH=/opt/toolchains/gcc-linaro-12.2.1-2022.12-x86_64_aarch64-linux-gnu/bin/:/opt/toolchains/xpack-riscv-none-embed-gcc-10.2.0-1.2/bin/:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
