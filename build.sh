#!/bin/bash

if [ "$#" -ne 1 ]; then
	MAKE_DEF_CONFIG=bcm2709_defconfig
else
	MAKE_DEF_CONFIG=$1
fi

echo "Build Raspberry Pi kernel starts now"
echo "default configuration = $MAKE_DEF_CONFIG"
#export PATH="/opt/rpi-tools/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf\
#-raspbian-x64/bin:$PATH"
echo "PATH = $PATH"
#KERNEL=kernel7
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- $MAKE_DEF_CONFIG
[ "$?" -eq 0 ] || exit $?;
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j 6
[ "$?" -eq 0 ] || exit $?;
