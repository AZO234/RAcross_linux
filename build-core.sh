#!/bin/bash

LR_CORE=np2kai
LR_CORE_SRC=~/NP2kai

LR_DISTLOG_CLEAN=1
LR_SRC_FETCH=0

export RACROSS_TOOLS=${HOME}/RAcross-tools

cd ~/libretro-super

if [[ ${LR_DISTLOG_CLEAN} = 1 ]] ; then
rm -rf dist/*
rm -rf log/*
fi

unset CC
unset CXX
unset AR
unset LD

# host(linux x86_64)
rm -rf libretro-${LR_CORE}
echo "=== host - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build.sh ${LR_CORE}
echo "=== host - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_host.log

# PSP
rm -rf libretro-${LR_CORE}
echo "=== PSP - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-psp1.sh ${LR_CORE}
echo "=== PSP - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_psp.log

# Xenon
rm -rf libretro-${LR_CORE}
echo "=== Xenon - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-xenon.sh ${LR_CORE}
echo "=== Xenon - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_xenon.log

# Vita
rm -rf libretro-${LR_CORE}
echo "=== Vita - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-vita.sh ${LR_CORE}
echo "=== Vita - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_vita.log

# Switch
rm -rf libretro-${LR_CORE}
echo "=== Switch - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-switch.sh ${LR_CORE}
echo "=== Switch - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_switch.log

# android-mk
rm -rf libretro-${LR_CORE}
echo "=== android-mk - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-android-mk.sh ${LR_CORE} 2>&1 | tee log/${LR_CORE}_android.log
echo "=== android-mk - build end ==="

# CTR
rm -rf libretro-${LR_CORE}
echo "=== CTR - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-ctr.sh ${LR_CORE}
echo "=== CTR - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_ctr.log

# NGC
rm -rf libretro-${LR_CORE}
echo "=== NGC - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-ngc.sh ${LR_CORE}
echo "=== NGC - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_ngc.log

# Wii
rm -rf libretro-${LR_CORE}
echo "=== Wii - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-wii.sh ${LR_CORE}
echo "=== Wii - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_wii.log

# WiiU
rm -rf libretro-${LR_CORE}
echo "=== WiiU - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-wiiu.sh ${LR_CORE}
echo "=== WiiU - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_wiiu.log

# libnx
rm -rf libretro-${LR_CORE}
echo "=== libnx - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-libnx.sh ${LR_CORE}
echo "=== libnx - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_libnx.log

# PS2
rm -rf libretro-${LR_CORE}
echo "=== PS2 - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-ps2.sh ${LR_CORE}
echo "=== PS2 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_ps2.log

# PS3
rm -rf libretro-${LR_CORE}
echo "=== PS3 - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-ps3.sh ${LR_CORE}
echo "=== PS3 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_ps3.log

# PSL1GHT
rm -rf libretro-${LR_CORE}
echo "=== PSL1GHT - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-psl1ght.sh ${LR_CORE}
echo "=== PSL1GHT - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_psl1ght.log

# iOS Theos
rm -rf libretro-${LR_CORE}
echo "=== iOS Theos - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-ios-theos.sh ${LR_CORE}
echo "=== iOS Theos - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_ios-theos.log

# Classic
rm -rf libretro-${LR_CORE}
echo "=== Classic - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-classic_armv7_a7.sh ${LR_CORE}
echo "=== Classic - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_classic_armv7_a7.log

# Emscripten
source ${RACROSS_TOOLS}/emsdk/emsdk_env.sh
rm -rf libretro-${LR_CORE}
echo "=== Emscripten - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-emscripten.sh ${LR_CORE}
echo "=== Emscripten - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_emscripten.log

# RPi2
export CC=armv7-rpi2-linux-gnueabihf-gcc
export CXX=armv7-rpi2-linux-gnueabihf-g++
export AR=armv7-rpi2-linux-gnueabihf-ar
export LD=armv7-rpi2-linux-gnueabihf-g++

rm -rf libretro-${LR_CORE}
echo "=== RPi2 - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-rpi2.sh ${LR_CORE}
echo "=== RPi2 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_rpi2.log

# ARMv8 RPi3
export CC=armv8-rpi3-linux-gnueabihf-gcc
export CXX=armv8-rpi3-linux-gnueabihf-g++
export AR=armv8-rpi3-linux-gnueabihf-ar
export LD=armv8-rpi3-linux-gnueabihf-g++

rm -rf libretro-${LR_CORE}
echo "=== ARMv8 RPi3 - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-armv8-rpi3.sh ${LR_CORE}
echo "=== ARMv8 RPi3 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_armv8_rpi3.log

# AArch64 RPi3
export CC=aarch64-rpi3-linux-gnu-gcc
export CXX=aarch64-rpi3-linux-gnu-g++
export AR=aarch64-rpi3-linux-gnu-ar
export LD=aarch64-rpi3-linux-gnu-g++

rm -rf libretro-${LR_CORE}
echo "=== AArch64 RPi3 - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-aarch64-rpi3.sh ${LR_CORE}
echo "=== AArch64 RPi3 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_aarch64_rpi3.log

# RPi4
export CC=aarch64-rpi4-linux-gnu-gcc
export CXX=aarch64-rpi4-linux-gnu-g++
export AR=aarch64-rpi4-linux-gnu-ar
export LD=aarch64-rpi4-linux-gnu-g++

rm -rf libretro-${LR_CORE}
echo "=== RPi4 - build start ==="
if [[ ${LR_SRC_FETCH} = 1 ]] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-rpi4.sh ${LR_CORE}
echo "=== RPi4 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_rpi4.log

unset CC
unset CXX
unset AR
unset LD

