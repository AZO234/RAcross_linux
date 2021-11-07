#!/bin/bash

RACROSS_GIT_INIT=0

if [ ${RACROSS_GIT_INIT} -ne 0 ]; then
 git config --global user.email "you@example.com"
 git config --global user.name "Your Name"
fi
ssh -oStrictHostKeyChecking=no github.com

RACROSS_BUILDROOT=0

export RACROSS_BASE=`pwd`

export RACROSS_CACHE=${RACROSS_BASE}/cache
rm -rf ${RACROSS_CACHE}
mkdir -p ${RACROSS_CACHE}

export RACROSS_TOOLS=${HOME}/RAcross-tools
rm -rf ${RACROSS_TOOLS}
mkdir -p ${RACROSS_TOOLS}

RACROSS_INITSCRIPT=~/.profile

RACROSS_LOG=${RACROSS_BASE}/log
rm -rf ${RACROSS_LOG}
mkdir ${RACROSS_LOG}

if [ ${RACROSS_BUILDROOT} -ne 0 ]; then
 RACROSS_TOOLCHAIN=~/.local/opt
 mkdir -p ${RACROSS_TOOLCHAIN}
fi

# repo
mkdir -p ~/.local/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.local/bin/repo
chmod a+x ~/.local/bin/repo
export PATH=$PATH:~/.local/bin
echo 'PATH=$PATH:~/.local/bin' >> ${RACROSS_INITSCRIPT}

# psptoolchain
echo "*** setup psptoolchain ***"
cd ${RACROSS_BASE}
git clone --depth=1 https://github.com/pspdev/psptoolchain.git
tar -Jcv ${RACROSS_CACHE}/psptoolchain.tar.xz psptoolchain
export PSPDEV=${RACROSS_TOOLS}/pspdev
export PATH=$PATH:$PSPDEV/bin
echo "export PSPDEV=${RACROSS_TOOLS}/pspdev" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$PSPDEV/bin" >> ${RACROSS_INITSCRIPT}
cd psptoolchain
./toolchain.sh
cd ${RACROSS_BASE}
rm -rf psptoolchain

## libtransistor
## /home/domi/RAcross_linux/libtransistor/dist/include/expected.hpp:20:10: fatal error: 'exception' file not found
##include <exception>
#echo "*** setup libtransistor ***"
#cd ${RACROSS_BASE}
#export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist
#echo "export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist" >> ${RACROSS_INITSCRIPT}
#git clone --recursive https://github.com/reswitched/libtransistor
#tar -Jcf ${RACROSS_CACHE}/libtransistor.tar.xz libtransistor
#git clone --recursive https://github.com/reswitched/libtransistor-base
#tar -Jcf ${RACROSS_CACHE}/libtransistor-base.tar.xz libtransistor-base
#cd libtransistor-base
#pip3 install -r requirements.txt
#make
#cp -r dist ../libtransistor/
#cd ../libtransistor
#make
#mkdir -p ${RACROSS_TOOLS}/libtransistor
#cp -r dist ${RACROSS_TOOLS}/libtransistor/
#cd ${RACROSS_BASE}
#rm -rf libtransistor-base
#rm -rf libtransistor

# crosstool-NG
echo "*** setup crosstool-NG ***"
cd ${RACROSS_BASE}
git clone --depth=1 https://github.com/crosstool-ng/crosstool-ng
tar -Jcf ${RACROSS_CACHE}/crosstool-ng.tar.xz crosstool-ng
cd crosstool-ng
./bootstrap
automake --add-missing
./configure --prefix=${RACROSS_TOOLS}/crosstool-ng
make 2>&1 ${RACROSS_LOG}/crosstool-ng.log
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
ct-ng build 2>&1 ${RACROSS_LOG}/rpi2.log
export PATH=$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/buildtools/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf armv7-rpi2-linux

echo "*** setup RPi3 32bit cross env ***"
cd ${RACROSS_BASE}
mkdir armv8-rpi3-linux
cd armv8-rpi3-linux
ct-ng armv8-rpi3-linux-gnueabihf
sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
mv .config_mod .config
ct-ng build 2>&1 ${RACROSS_LOG}/rpi3_32.log
export PATH=$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/buildtools/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf armv8-rpi3-linux

echo "*** setup RPi3 64bit cross env ***"
cd ${RACROSS_BASE}
mkdir aarch64-rpi3-linux
cd aarch64-rpi3-linux
ct-ng aarch64-rpi3-linux-gnu
sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
mv .config_mod .config
ct-ng build 2>&1 ${RACROSS_LOG}/rpi3_64.log
export PATH=$PATH:${RACROSS_TOOLS}/aarch64-rpi3-linux-gnu/buildtools/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/aarch64-rpi3-linux-gnu/bin" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf aarch64-rpi3-linux

echo "*** setup RPi4 32bit cross env ***"
cd ${RACROSS_BASE}
mkdir armv8-rpi4-linux
cd armv8-rpi4-linux
ct-ng armv8-rpi4-linux-gnueabihf
sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
mv .config_mod .config
ct-ng build 2>&1 ${RACROSS_LOG}/rpi4_32.log
export PATH=$PATH:${RACROSS_TOOLS}/armv8-rpi4-linux-gnueabihf/buildtools/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv8-rpi4-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf armv8-rpi4-linux

echo "*** setup RPi4 64bit cross env ***"
cd ${RACROSS_BASE}
mkdir aarch64-rpi4-linux
cd aarch64-rpi4-linux
ct-ng aarch64-rpi4-linux-gnu
sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
mv .config_mod .config
ct-ng build 2>&1 ${RACROSS_LOG}/rpi4_64.log
export PATH=$PATH:${RACROSS_TOOLS}/aarch64-rpi4-linux-gnu/buildtools/bin
echo "export PATH=\$PATH:${RACROSS_TOOLS}/aarch64-rpi4-linux-gnu/bin" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf aarch64-rpi4-linux

if [ ${RACROSS_BUILDROOT} -ne 0 ]; then
 # GCW0
#c-stack.c:55:26: error: missing binary operator before token "("
#   55 | #elif HAVE_LIBSIGSEGV && SIGSTKSZ < 16384
#      |                          ^~~~~~~~
 cd ${RACROSS_BASE}
 git clone --depth 1 https://github.com/gcwnow/buildroot.git GCW0_buildroot
# cp 04-fix-sigstksz.patch GCW0_buildroot/package/m4/
# cp no_STAT_VER.patch GCW0_buildroot/package/fakeroot/
 cd GCW0_buildroot
 make gcw0_defconfig
 make -j4
 mv output/host gcw0-toolchain
 cd ${RACROSS_BASE}
 rm -rf GCW0_buildroot
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/gcw0-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/gcw0-toolchain/bin" >> ${RACROSS_INITSCRIPT}

 # RS90
#mkdir: ディレクトリ `/opt/rs90-toolchain' を作成できません: 許可がありません
 cd ${RACROSS_BASE}
 git clone --depth 1 https://github.com/rs90-randomsjunk/buildroot.git RS90_buildroot
 cd RS90_buildroot
 make od_rs90_defconfig
 make -j4
 mv output/host rs90-toolchain
 cd ${RACROSS_BASE}
 rm -rf RS90_buildroot
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/rs90-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/rs90-toolchain/bin" >> ${RACROSS_INITSCRIPT}

 # RS97
#No file to patch.  Skipping patch.
#1 out of 1 hunk ignored
#make[1]: *** [package/pkg-generic.mk:209: /home/domi/RAcross_linux/RS97_buildroot/output/build/sdl_mixer-1.2.13/.stamp_patched] エラー 1
#make: *** [Makefile:84: _all] エラー 2
 cd ${RACROSS_BASE}
 git clone --depth 1 https://github.com/rs-97-cfw/buildroot.git RS97_buildroot
 cp 04-fix-sigstksz.patch RS97_buildroot/package/m4/
 cp no_STAT_VER.patch RS97_buildroot/package/fakeroot/
 cd RS97_buildroot
 make rs97_config
 make -j4
 mv output/host rs97-toolchain
 cd ${RACROSS_BASE}
 rm -rf RS97_buildroot
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/rs97-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/rs97-toolchain/bin" >> ${RACROSS_INITSCRIPT}

 # RG350
 cd ${RACROSS_BASE}
 git clone --depth 1 https://github.com/tonyjih/RG350_buildroot.git
 cd RG350_buildroot
 make rg350_defconfi
 make -j4
 mv output/host rg350-toolchain
 cd ${RACROSS_BASE}
 rm -rf RG350_buildroot
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/rg350-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/rg350-toolchain/bin" >> ${RACROSS_INITSCRIPT}

 # RG351
#configure: error: in `/home/domi/RAcross_linux/rg351p-buildroot/output/build/sdl_mixer-1.2.13':
#configure: error: C compiler cannot create executables
#See `config.log' for more details
#make[1]: *** [package/pkg-generic.mk:240: /home/domi/RAcross_linux/rg351p-buildroot/output/build/sdl_mixer-1.2.13/.stamp_configured] エラー 77
 cd ${RACROSS_BASE}
 git clone --depth 1 https://github.com/gameblabla/rg351p-buildroot.git
 cp 04-fix-sigstksz.patch rg351p-buildroot/package/m4/
 cp no_STAT_VER.patch rg351p-buildroot/package/fakeroot/
 rm rg351p-buildroot/package/sdl_mixer/0001-Add-Libs.private-field-to-pkg-config-file.patch
 rm rg351p-buildroot/package/sdl_mixer/0004-modpluginclude.patch
 rm rg351p-buildroot/package/sdl_mixer/0005-Fixwontbuildontremor.patch
 rm rg351p-buildroot/package/sdl_mixer/0007-forceTremor.patch
 rm rg351p-buildroot/package/sdl_mixer/0008-forceTremor.patch
 cd rg351p-buildroot
 make rg351p_defconfig
 make -j4
 mv output/host rg351-toolchain
 cd ${RACROSS_BASE}
# rm -rf rg351p-buildroot
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/rg351-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/rg351-toolchain/bin" >> ${RACROSS_INITSCRIPT}

 # Odroid C1
#./libexec/gcc/arm-linux-gnueabihf/4.9.1/cc1: error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or directory
#Incorrect ABI setting: EABIhf selected, but toolchain is incompatible
#make[1]: *** [package/pkg-generic.mk:188: /home/domi/RAcross_linux/buildroot-Odroid-C1/output/build/toolchain-external-undefined/.stamp_configured] エラー 1
 cd ${RACROSS_BASE}
 git clone --depth 1 https://github.com/wzab/buildroot-Odroid-C1.git
 cd buildroot-Odroid-C1
 make odroidc1_defconfig
 make -j4
 mv output/host odroidc1-toolchain
 cd ${RACROSS_BASE}
 rm -rf buildroot-Odroid-C1
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/odroidc1-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/odroidc1-toolchain/bin" >> ${RACROSS_INITSCRIPT}

 # Odroid C2
 #SSP support not available in this toolchain, please disable BR2_TOOLCHAIN_EXTERNAL_HAS_SSP
 #make[1]: *** [package/pkg-generic.mk:188: /home/domi/RAcross_linux/OdroidC2_buildroot/output/build/toolchain-external-undefined/.stamp_configured] エラー 1
 cd ${RACROSS_BASE}
 git clone --depth 1 https://github.com/hardkernel/buildroot.git OdroidC2_buildroot
 cd OdroidC2_buildroot
 make odroidc2_defconfig
 make -j4
 mv output/host odroidc2-toolchain
 cd ${RACROSS_BASE}
 rm -rf OdroidC2_buildroot
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/odroidc2-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/odroidc2-toolchain/bin" >> ${RACROSS_INITSCRIPT}

 # Odroid C4
 #make[1]: *** [package/pkg-generic.mk:231: /home/domi/RAcross_linux/OdroidC4_buildroot/output/odroidc4/build/toolchain-external-linaro-aarch64-6dot2-201702-preinstalled/.stamp_configured] エラー 1

 cd ${RACROSS_BASE}
 mkdir OdroidC4_buildroot
 cd OdroidC4_buildroot
 repo init -u https://github.com/hardkernel/platform-manifest.git -b aml64_buildroot_master_c4 --depth=1
 repo sync
 repo start aml64_buildroot_master_c4 --all
 source buildroot/build/setenv.sh odroidc4_release
 make -j4
 mv output/host odroidc4-toolchain
 cd ${RACROSS_BASE}
 rm -rf OdroidC4_buildroot
 export PATH=$PATH:${RACROSS_TOOLCHAIN}/odroidc4-toolchain/bin
 echo "export PATH=\$PATH:${RACROSS_TOOLCHAIN}/odroidc4-toolchain/bin" >> ${RACROSS_INITSCRIPT}
fi

# Xenon_Toolchain
echo "*** setup Xenon_Toolchain ***"
cd ${RACROSS_BASE}
export DEVKITXENON="${RACROSS_TOOLS}/xenon"
export PATH="$PATH:$DEVKITXENON/bin:$DEVKITXENON/usr/bin"
echo "export DEVKITXENON=${RACROSS_TOOLS}/xenon" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:\$DEVKITXENON/bin:\$DEVKITXENON/usr/bin" >> ${RACROSS_INITSCRIPT}
git clone --depth=1 https://github.com/Free60Project/libxenon.git
tar -Jcf ${RACROSS_CACHE}/libxenon.tar.xz libxenon
cd libxenon/toolchain
export PREFIX=~/RAcross-tools/xenon
./build-xenon-toolchain toolchain
cd ${RACROSS_BASE}
rm -rf libxenon
export PREFIX

# Vita SDK
echo "*** setup Vita SDK ***"
cd ${RACROSS_BASE}
export VITASDK=${RACROSS_TOOLS}/vitasdk
export PATH=$VITASDK/bin:$PATH
echo "export VITASDK=${RACROSS_TOOLS}/vitasdk" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$VITASDK/bin:\$PATH" >> ${RACROSS_INITSCRIPT}
git clone --depth=1 https://github.com/vitasdk/vdpm
tar -Jcf ${RACROSS_CACHE}/vdpm.tar.xz vdpm
cd vdpm
./bootstrap-vitasdk.sh
./install-all.sh
cd ${RACROSS_BASE}
rm -rf vdpm

# devkitPro
#devkita64-rules-1.0.1.tar.gz
#curl: (22) The requested URL returned error: 404 

echo "*** setup devkitPro ***"
cd ${RACROSS_BASE}
git clone --depth=1 https://github.com/devkitPro/buildscripts.git
patch -p1 -d buildscripts < ${RACROSS_BASE}/buildscripts.patch
cp ${RACROSS_BASE}/config1.sh buildscripts/
cp ${RACROSS_BASE}/config2.sh buildscripts/
cp ${RACROSS_BASE}/config3.sh buildscripts/
tar -Jcf ${RACROSS_CACHE}/buildscripts.tar.xz buildscripts
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
#/bin/bash: 行 1: /home/domi/RAcross_linux/ps2toolchain/build/ps2toolchain-ee/build/gcc/build-mips64r5900el-ps2-elf-stage2/./gcc/xgcc: そのようなファイルやディレクトリはありません
echo "*** setup ps2toolchain ***"
cd ${RACROSS_BASE}
git clone https://github.com/ps2dev/ps2toolchain.git
tar -Jcf ${RACROSS_CACHE}/ps2toolchain.tar.xz ps2toolchain
git clone https://github.com/ps2dev/ps2sdk-ports.git
tar -Jcf ${RACROSS_CACHE}/ps2sdk-ports.tar.xz ps2sdk-ports
git clone https://github.com/ps2dev/gsKit.git
tar -Jcf ${RACROSS_CACHE}/gsKit.tar.xz gsKit
git clone https://github.com/ps2dev/ps2-packer.git
tar -Jcf ${RACROSS_CACHE}/ps2-packer.tar.xz ps2-packer
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
#--2021-11-07 13:13:12--  http://mirror.yongbok.net/nongnu/freetype/freetype-2.4.3.tar.gz
#mirror.yongbok.net (mirror.yongbok.net) をDNSに問いあわせています... 169.56.72.170, 2401:c900:1601:148::3
#mirror.yongbok.net (mirror.yongbok.net)|169.56.72.170|:80 に接続しています... 接続しました。
#HTTP による接続要求を送信しました、応答を待っています... 404 Not Found
#2021-11-07 13:13:12 エラー 404: Not Found。
echo "*** setup ps3toolchain ***"
mkdir -p ${RACROSS_TOOLS}/ps3dev
cd ${RACROSS_TOOLS}/ps3dev
git clone --depth=1 https://github.com/ps3dev/ps3toolchain.git
tar -Jcf ${RACROSS_CACHE}/ps3toolchain.tar.xz ps3toolchain
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
RACROSS_EMSDK_VER=2.0.31
cd ${RACROSS_TOOLS}
git clone --depth=1 https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk update
git pull
cd ${RACROSS_TOOLS}
tar -Jcf ${RACROSS_CACHE}/emsdk.tar.xz emsdk
export EMSDK=${RACROSS_TOOLS}/emsdk
export PATH=$PATH:${EMSDK}/emscripten/${RACROSS_EMSDK_VER}
export EM_CONFIG=/home/${USER}/.emscripten
export EMSCRIPTEN_NATIVE_OPTIMIZER=${EMSDK}/clang/e${RACROSS_EMSDK_VER}_64bit/optimizer
export EMSCRIPTEN=${EMSDK}/emscripten/${RACROSS_EMSDK_VER}
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ${RACROSS_BASE}
rm -rf emsdk

# Android NDK
echo "*** setup android ***"
RACROSS_ANDROIDNDK_VER=23
cd ${RACROSS_BASE}
wget https://dl.google.com/android/repository/android-ndk-r${RACROSS_ANDROIDNDK_VER}-linux-x86_64.zip -O ${RACROSS_CACHE}/android-ndk-r${RACROSS_ANDROIDNDK_VER}-linux-x86_64.zip
unzip ${RACROSS_CACHE}/android-ndk-r${RACROSS_ANDROIDNDK_VER}-linux-x86_64.zip -d ${RACROSS_TOOLS}/
export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r${RACROSS_ANDROIDNDK_VER}
export PATH=$PATH:${RACROSS_TOOLS}/android-ndk-r${RACROSS_ANDROIDNDK_VER}
echo "export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r${RACROSS_ANDROIDNDK_VER}" >> ${RACROSS_INITSCRIPT}
echo "export PATH=\$PATH:${RACROSS_TOOLS}/android-ndk-r${RACROSS_ANDROIDNDK_VER}" >> ${RACROSS_INITSCRIPT}
cd ${RACROSS_BASE}
rm -rf android-ndk-r${RACROSS_ANDROIDNDK_VER}-*

# libretro-super
echo "*** setup libretro-super ***"
cd ~
git clone --depth=1 https://github.com/libretro/libretro-super.git
patch -p1 -d libretro-super < ${RACROSS_BASE}/libretro-super.patch
tar -Jcf ${RACROSS_CACHE}/libretro-super.tar.xz libretro-super
chmod +x libretro-super/libretro-build-android-mk.sh
chmod +x libretro-super/libretro-build-emscripten.sh
chmod +x libretro-super/libretro-build-libnx.sh
chmod +x libretro-super/libretro-build-psl1ght.sh
chmod +x libretro-super/libretro-build-xenon.sh
chmod +x libretro-super/libretro-build-rpi2.sh
chmod +x libretro-super/libretro-build-rpi3.sh

# build scripts
cp ${RACROSS_BASE}/build-core.sh ~/libretro-super

