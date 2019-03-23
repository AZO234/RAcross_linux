#!/bin/bash

LR_CORE=np2kai
LR_CORE_SRC=~/NP2kai

LR_DISTLOG_CLEAN=1
LR_SRC_FETCH=0

export RACROSS_TOOLS=${HOME}/RAcross-tools

cd ~/libretro-super

if [ ${LR_DISTLOG_CLEAN} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-psp1.sh ${LR_CORE}
echo "=== PSP - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_psp.log

# psl1ght
rm -rf libretro-${LR_CORE}
echo "=== psl1ght - build start ==="
if [ ${LR_SRC_FETCH} = 1 ] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-psl1ght.sh ${LR_CORE}
echo "=== psl1ght - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_psl1ght.log

# Xenon
rm -rf libretro-${LR_CORE}
echo "=== Xenon - build start ==="
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-android-mk.sh ${LR_CORE}
echo "=== android-mk - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_android.log

# CTR
rm -rf libretro-${LR_CORE}
echo "=== CTR - build start ==="
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
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
if [ ${LR_SRC_FETCH} = 1 ] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-libnx.sh ${LR_CORE}
echo "=== libnx - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_libnx.log

# Emscripten
source ${RACROSS_TOOLS}/emsdk/emsdk_env.sh
rm -rf libretro-${LR_CORE}
echo "=== Emscripten - build start ==="
if [ ${LR_SRC_FETCH} = 1 ] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-emscripten.sh ${LR_CORE}
echo "=== Emscripten - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_emscripten.log

export CC=armv7-rpi2-linux-gnueabihf-gcc
export CXX=armv7-rpi2-linux-gnueabihf-g++
export AR=armv7-rpi2-linux-gnueabihf-ar
export LD=armv7-rpi2-linux-gnueabihf-g++

# RPi2
rm -rf libretro-${LR_CORE}
echo "=== RPi2 - build start ==="
if [ ${LR_SRC_FETCH} = 1 ] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-rpi2.sh ${LR_CORE}
echo "=== RPi2 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_rpi2.log

export CC=armv8-rpi3-linux-gnueabihf-gcc
export CXX=armv8-rpi3-linux-gnueabihf-g++
export AR=armv8-rpi3-linux-gnueabihf-ar
export LD=armv8-rpi3-linux-gnueabihf-g++

# RPi3
rm -rf libretro-${LR_CORE}
echo "=== RPi3 - build start ==="
if [ ${LR_SRC_FETCH} = 1 ] ; then
./libretro-fetch.sh ${LR_CORE}
else
cp -rf ${LR_CORE_SRC} libretro-${LR_CORE}
fi
./libretro-build-rpi3.sh ${LR_CORE}
echo "=== RPi3 - build end ==="
mv log/${LR_CORE}.log log/${LR_CORE}_rpi3.log

unset CC
unset CXX
unset AR
unset LD

