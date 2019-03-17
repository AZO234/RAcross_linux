#!/bin/bash

export RACROSS_BASE=`pwd`

export RACROSS_CACHE=${RACROSS_BASE}/cache
rm -rf ${RACROSS_CACHE}
mkdir -p ${RACROSS_CACHE}

export RACROSS_TOOLS=${HOME}/RAcross-tools
rm -rf ${RACROSS_TOOLS}
mkdir -p ${RACROSS_TOOLS}

RACROSS_INITSCRIPT=~/.profile

# psptoolchain
echo "*** setup psptoolchain ***"
cd ${RACROSS_BASE}
git clone --depth=1 https://github.com/pspdev/psptoolchain.git
patch -p1 -d psptoolchain < ${RACROSS_BASE}/psptoolchain.patch
tar Jcvf ${RACROSS_CACHE}/psptoolchain.tar.xz psptoolchain
export PSPDEV=${RACROSS_TOOLS}/pspdev
export PATH=$PATH:$PSPDEV/bin
echo "export PSPDEV=${RACROSS_TOOLS}/pspdev" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$PSPDEV/bin" >> ${RACROSS_INITSCRIPT}
cd psptoolchain
./toolchain.sh
cd ${RACROSS_BASE}
rm -rf psptoolchain

# libtransistor
echo "*** setup libtransistor ***"
cd ${RACROSS_BASE}
export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist
echo "export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist" >> ${RACROSS_INITSCRIPT}
git clone --recursive https://github.com/reswitched/libtransistor
tar Jcvf ${RACROSS_CACHE}/libtransistor.tar.xz libtransistor
git clone --recursive https://github.com/reswitched/libtransistor-base
tar Jcvf ${RACROSS_CACHE}/libtransistor-base.tar.xz libtransistor-base
cd libtransistor-base
pip3 install -r requirements.txt
make
cp -r dist ../libtransistor/
cd ../libtransistor
make
mkdir -p ${RACROSS_TOOLS}/libtransistor
cp -r dist ${RACROSS_TOOLS}/libtransistor/
cd ${RACROSS_BASE}
rm -rf libtransistor-base
rm -rf libtransistor

# crosstool-NG
echo "*** setup crosstool-NG ***"
cd ${RACROSS_BASE}
git clone --depth=1 https://github.com/crosstool-ng/crosstool-ng
tar Jcvf ${RACROSS_CACHE}/crosstool-ng.tar.xz crosstool-ng
cd crosstool-ng
./bootstrap
automake --add-missing
./configure --prefix=${RACROSS_TOOLS}/crosstool-ng
make
make install
export PATH=$PATH:${RACROSS_TOOLS}/crosstool-ng/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/crosstool-ng/bin" >> ${RACROSS_INITSCRIPT}
ct-ng update-samples
cd ${RACROSS_BASE}
rm -rf crosstool-ng

echo "*** setup RPi2 cross env ***"
cd ${RACROSS_BASE}
mkdir armv7-rpi2-linux
cd armv7-rpi2-linux
ct-ng armv7-rpi2-linux-gnueabihf
sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
mv .config_mod .config
ct-ng build
export PATH=$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/buildtools/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf armv7-rpi2-linux

echo "*** setup RPi3 cross env ***"
cd ${RACROSS_BASE}
mkdir armv8-rpi3-linux
cd armv8-rpi3-linux
ct-ng armv8-rpi3-linux-gnueabihf
sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
mv .config_mod .config
ct-ng build
export PATH=$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/buildtools/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf armv8-rpi3-linux

# Xenon_Toolchain
echo "*** setup Xenon_Toolchain ***"
cd ${RACROSS_BASE}
export DEVKITXENON="${RACROSS_TOOLS}/xenon"
export PATH="$PATH:$DEVKITXENON/bin:$DEVKITXENON/usr/bin"
echo "export DEVKITXENON=${RACROSS_TOOLS}/xenon" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$DEVKITXENON/bin:\$DEVKITXENON/usr/bin" >> ${RACROSS_INITSCRIPT}
git clone --depth=1 https://github.com/Free60Project/libxenon.git
patch libxenon/toolchain/build-xenon-toolchain < ${RACROSS_BASE}/build-xenon-toolchain.patch
patch libxenon/toolchain/build-xenon-toolchain < ${RACROSS_BASE}/build-xenon-toolchain_4.7.4.patch
cp ${RACROSS_BASE}/gcc.diff_4.7.4 libxenon/toolchain/
tar Jcvf ${RACROSS_CACHE}/libxenon.tar.xz libxenon
cd libxenon/toolchain
./build-xenon-toolchain toolchain
cd ${RACROSS_BASE}
rm -rf libxenon

# Vita SDK
echo "*** setup Vita SDK ***"
cd ${RACROSS_BASE}
export VITASDK=${RACROSS_TOOLS}/vitasdk
export PATH=$VITASDK/bin:$PATH
echo "export VITASDK=${RACROSS_TOOLS}/vitasdk" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$VITASDK/bin:\$PATH" >> ${RACROSS_INITSCRIPT}
git clone --depth=1 https://github.com/vitasdk/vdpm
patch vdpm/include/install-vitasdk.sh < ${RACROSS_BASE}/install-vita_sdk.patch
tar Jcvf ${RACROSS_CACHE}/vdpm.tar.xz vdpm
cd vdpm
./bootstrap-vitasdk.sh
./install-all.sh
cd ${RACROSS_BASE}
rm -rf vdpm

# devkitPro
echo "*** setup devkitPro ***"
cd ${RACROSS_BASE}
git clone --depth=1 https://github.com/devkitPro/buildscripts.git
patch -p1 -d buildscripts < ${RACROSS_BASE}/buildscripts.patch
cp ${RACROSS_BASE}/config1.sh buildscripts/
cp ${RACROSS_BASE}/config2.sh buildscripts/
cp ${RACROSS_BASE}/config3.sh buildscripts/
tar Jcvf ${RACROSS_CACHE}/buildscripts.tar.xz buildscripts
export DEVKITPRO=${RACROSS_TOOLS}/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export DEVKITA64=$DEVKITPRO/devkitA64
export DEVKITPPC=$DEVKITPRO/devkitPPC
export LIBCTRU=${RACROSS_TOOLS}/devkitpro/libctru
export LIBOGC=${RACROSS_TOOLS}/devkitpro/libogc
export LIBNX=${RACROSS_TOOLS}/devkitpro/libnx
echo "export DEVKITPRO=${RACROSS_TOOLS}/devkitpro" >> ${RACROSS_INITSCRIPT}
echo "export DEVKITARM=\$DEVKITPRO/devkitARM" >> ${RACROSS_INITSCRIPT}
echo "export DEVKITA64=\$DEVKITPRO/devkitA64" >> ${RACROSS_INITSCRIPT}
echo "export DEVKITPPC=\$DEVKITPRO/devkitPPC" >> ${RACROSS_INITSCRIPT}
echo "export LIBCTRU=\$DEVKITPRO/libctru" >> ${RACROSS_INITSCRIPT}
echo "export LIBOGC=\$DEVKITPRO/libogc" >> ${RACROSS_INITSCRIPT}
echo "export LIBNX=\$DEVKITPRO/libnx" >> ${RACROSS_INITSCRIPT}
cd buildscripts
cp config1.sh config.sh
./build-devkit.sh
cp config2.sh config.sh
./build-devkit.sh
cp config3.sh config.sh
./build-devkit.sh
cd ${RACROSS_BASE}
rm -rf buildscripts

# ps2toolchain
echo "*** setup ps2toolchain ***"
cd ${RACROSS_BASE}
git clone https://github.com/ps2dev/ps2toolchain.git
tar Jcvf ${RACROSS_CACHE}/ps2toolchain.tar.xz ps2toolchain
git clone https://github.com/ps2dev/ps2sdk-ports.git
tar Jcvf ${RACROSS_CACHE}/ps2sdk-ports.tar.xz ps2sdk-ports
git clone https://github.com/ps2dev/gsKit.git
tar Jcvf ${RACROSS_CACHE}/gsKit.tar.xz gsKit
git clone https://github.com/ps2dev/ps2-packer.git
tar Jcvf ${RACROSS_CACHE}/ps2-packer.tar.xz ps2-packer
export PS2DEV=${RACROSS_TOOLS}/ps2dev
export PS2SDK=$PS2DEV/ps2sdk
export PATH=$PATH:$PS2DEV/bin:$PS2DEV/ee/bin:$PS2DEV/iop/bin:$PS2DEV/dvp/bin:$PS2SDK/bin
echo "export PS2DEV=${RACROSS_TOOLS}/ps2dev" >> ${RACROSS_INITSCRIPT}
echo "export PS2SDK=\$PS2DEV/ps2sdk" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$PS2DEV/bin:\$PS2DEV/ee/bin:\$PS2DEV/iop/bin:\$PS2DEV/dvp/bin:\$PS2SDK/bin" >> ${RACROSS_INITSCRIPT}
cd ps2toolchain
./toolchain.sh
cd ${RACROSS_BASE}/ps2sdk-ports
make
make install
cd ${RACROSS_BASE}/gsKit
make
make install
cd ${RACROSS_BASE}/ps2-packer
make
make install
cd ${RACROSS_BASE}
rm -rf ps2toolchain
rm -rf ps2sdk-ports
rm -rf gsKit
rm -rf ps2-packer

# ps3toolchain
echo "*** setup ps3toolchain ***"
mkdir -p ${RACROSS_TOOLS}/ps3dev
cd ${RACROSS_TOOLS}/ps3dev
git clone --depth=1 https://github.com/ps3dev/ps3toolchain.git
tar Jcvf ${RACROSS_CACHE}/ps3toolchain.tar.xz ps3toolchain
export PS3DEV=${RACROSS_TOOLS}/ps3dev
export PATH=$PATH:$PS3DEV/bin
export PATH=$PATH:$PS3DEV/ppu/bin
export PATH=$PATH:$PS3DEV/spu/bin
export PSL1GHT=$PS3DEV/psl1ght
export PATH=$PATH:$PSL1GHT/host/bin
echo "export PS3DEV=${RACROSS_TOOLS}/ps3dev" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$PS3DEV/bin" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$PS3DEV/ppu/bin" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$PS3DEV/spu/bin" >> ${RACROSS_INITSCRIPT}
echo "export PSL1GHT=\$PS3DEV/psl1ght" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$PSL1GHT/host/bin" >> ${RACROSS_INITSCRIPT}
cd ps3toolchain
./toolchain.sh
cd ${RACROSS_BASE}
rm -rf ps3toolchain

# Emscripten
echo "*** setup Emscripten ***"
cd ${RACROSS_TOOLS}
git clone --depth=1 https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk update
git pull
cd ${RACROSS_TOOLS}
tar Jcvf ${RACROSS_CACHE}/emsdk.tar.xz emsdk
export EMSDK=${RACROSS_TOOLS}/emsdk
export PATH=$PATH:${EMSDK}/emscripten/1.38.28
export EM_CONFIG=/home/${USER}/.emscripten
export EMSCRIPTEN_NATIVE_OPTIMIZER=${EMSDK}/clang/e1.38.28_64bit/optimizer
export EMSCRIPTEN=${EMSDK}/emscripten/1.38.28
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ${RACROSS_BASE}
rm -rf emsdk

# Android NDK
echo "*** setup android ***"
cd ${RACROSS_BASE}
wget https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip -O ${RACROSS_CACHE}/android-ndk-r18b-linux-x86_64.zip
unzip ${RACROSS_CACHE}/android-ndk-r18b-linux-x86_64.zip -d ${RACROSS_TOOLS}/
export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r18b
export PATH=$PATH:${RACROSS_TOOLS}/android-ndk-r18b
echo "export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r18b" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:${RACROSS_TOOLS}/android-ndk-r18b" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf android-ndk-r18b-*

# libretro-super
echo "*** setup libretro-super ***"
cd ~
git clone --depth=1 https://github.com/libretro/libretro-super.git
patch -p1 -d libretro-super < ${RACROSS_BASE}/libretro-super.patch
tar Jcvf ${RACROSS_CACHE}/libretro-super.tar.xz libretro-super
chmod +x libretro-super/libretro-build-android-mk.sh
chmod +x libretro-super/libretro-build-emscripten.sh
chmod +x libretro-super/libretro-build-libnx.sh
chmod +x libretro-super/libretro-build-psl1ght.sh
chmod +x libretro-super/libretro-build-xenon.sh
chmod +x libretro-super/libretro-build-rpi2.sh
chmod +x libretro-super/libretro-build-rpi3.sh

# build scripts
cp ${RACROSS_BASE}/build-core.sh ~/libretro-super

