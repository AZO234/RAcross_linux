#!/bin/bash

source RAcross_config.sh

export RACROSS_BASE=`pwd`

export RACROSS_CACHE=${RACROSS_BASE}/cache
export RACROSS_TOOLS=${HOME}/RAcross-tools

RACROSS_INITSCRIPT=${HOME}/.profile

RACROSS_SETUP_GIT=0

if [[ ${RACROSS_SETUP_GIT} = 1 ]] ; then
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
fi

mkdir ${HOME}/.ssh
touch ${HOME}/.ssh/known_hosts
ssh-keyscan github.com >> ${HOME}/.ssh/known_hosts

# ps2toolchain
echo "*** setup ps2toolchain ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/ps2dev/ps2toolchain.git
	tar -Jcf ${RACROSS_CACHE}/ps2toolchain.tar.xz ps2toolchain
	git clone https://github.com/ps2dev/ps2sdk-ports.git
	tar -Jcf ${RACROSS_CACHE}/ps2sdk-ports.tar.xz ps2sdk-ports
	git clone https://github.com/ps2dev/gsKit.git
	tar -Jcf ${RACROSS_CACHE}/gsKit.tar.xz gsKit
	git clone https://github.com/ps2dev/ps2-packer.git
	tar -Jcf ${RACROSS_CACHE}/ps2-packer.tar.xz ps2-packer
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf ps2toolchain
		rm -rf ps2sdk-ports
		rm -rf gsKit
		rm -rf ps2-packer
	fi
else
	tar -Jxf ${RACROSS_CACHE}/ps2toolchain.tar.xz
	tar -Jxf ${RACROSS_CACHE}/ps2sdk-ports.tar.xz
	tar -Jxf ${RACROSS_CACHE}/gsKit.tar.xz
	tar -Jxf ${RACROSS_CACHE}/ps2-packer.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
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
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf ps2toolchain
		rm -rf ps2sdk-ports
		rm -rf gsKit
		rm -rf ps2-packer
	fi
fi

# psptoolchain
echo "*** setup psptoolchain ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/pspdev/psptoolchain.git
	tar -Jcf ${RACROSS_CACHE}/psptoolchain.tar.xz psptoolchain
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf psptoolchain
	fi
else
	tar -Jxf ${RACROSS_CACHE}/psptoolchain.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	export PSPDEV=${RACROSS_TOOLS}/pspdev
	export PATH=$PATH:$PSPDEV/bin
	echo "export PSPDEV=${RACROSS_TOOLS}/pspdev" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$PSPDEV/bin" >> ${RACROSS_INITSCRIPT}
	cd psptoolchain
	./toolchain.sh
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf psptoolchain
	fi
fi

# libtransistor
echo "*** setup libtransistor ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist
	echo "export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist" >> ${RACROSS_INITSCRIPT}
fi
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone --recursive https://github.com/reswitched/libtransistor
	tar -Jcf ${RACROSS_CACHE}/libtransistor.tar.xz libtransistor
	git clone --recursive https://github.com/reswitched/libtransistor-base
	tar -Jcf ${RACROSS_CACHE}/libtransistor-base.tar.xz libtransistor-base
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf libtransistor-base
		rm -rf libtransistor
	fi
else
	tar -Jxf ${RACROSS_CACHE}/libtransistor.tar.xz
	tar -Jxf ${RACROSS_CACHE}/libtransistor-base.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cd libtransistor-base
	pip install -r requirements.txt
	make
	cp -r dist ../libtransistor/
	cd ../libtransistor
	make
	mkdir -p ${RACROSS_TOOLS}/libtransistor
	cp -r dist ${RACROSS_TOOLS}/libtransistor/
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf libtransistor-base
		rm -rf libtransistor
	fi
fi

# crosstool-NG
echo "*** setup crosstool-NG ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/crosstool-ng/crosstool-ng.git
	cd crosstool-ng
	git remote add AZO234 https://github.com/AZO234/crosstool-ng.git
	git pull --no-edit AZO234 fix
	cd ..
	tar -Jcf ${RACROSS_CACHE}/crosstool-ng.tar.xz crosstool-ng
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf crosstool-ng
	fi
else
	tar -Jxf ${RACROSS_CACHE}/crosstool-ng.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cd crosstool-ng
	./bootstrap
	automake --add-missing
	./configure --prefix=${RACROSS_TOOLS}/crosstool-ng
	make
	make install
	export PATH=$PATH:${RACROSS_TOOLS}/crosstool-ng/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/crosstool-ng/bin" >> ${RACROSS_INITSCRIPT}
	ct-ng update-samples
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf crosstool-ng
	fi
fi

echo "*** setup RPi2 cross env ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	mkdir armv7-rpi2-linux
	cd armv7-rpi2-linux
	ct-ng armv7-rpi2-linux-gnueabihf
	sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
	mv .config_mod .config
	ct-ng build
	export PATH=$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/buildtools/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf armv7-rpi2-linux
	fi
fi

echo "*** setup armv8 RPi3 cross env ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	mkdir armv8-rpi3-linux
	cd armv8-rpi3-linux
	ct-ng armv8-rpi3-linux-gnueabihf
	sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
	mv .config_mod .config
	ct-ng build
	export PATH=$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/buildtools/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf armv8-rpi3-linux
	fi
fi

echo "*** setup aarch64 RPi3 cross env ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	mkdir aarch64-rpi3-linux-gnu
	cd aarch64-rpi3-linux-gnu
	ct-ng aarch64-rpi3-linux-gnu
	sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
	mv .config_mod .config
	ct-ng build
	export PATH=$PATH:${RACROSS_TOOLS}/aarch64-rpi3-linux-gnu/buildtools/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/aarch64-rpi3-linux-gnu/bin" >> ${RACROSS_INITSCRIPT}
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf aarch64-rpi3-linux-gnu
	fi
fi

echo "*** setup aarch64 RPi4 cross env ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	mkdir aarch64-rpi4-linux-gnu
	cd aarch64-rpi4-linux-gnu
	ct-ng aarch64-rpi4-linux-gnu
	sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
	mv .config_mod .config
	ct-ng build
	export PATH=$PATH:${RACROSS_TOOLS}/aarch64-rpi4-linux-gnu/buildtools/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/aarch64-rpi4-linux-gnu/bin" >> ${RACROSS_INITSCRIPT}
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf aarch64-rpi4-linux-gnu
	fi
fi

# Xenon_Toolchain
echo "*** setup Xenon_Toolchain ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	export DEVKITXENON="${RACROSS_TOOLS}/xenon"
	export PATH="$PATH:$DEVKITXENON/bin:$DEVKITXENON/usr/bin"
	echo "export DEVKITXENON=${RACROSS_TOOLS}/xenon" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$DEVKITXENON/bin:\$DEVKITXENON/usr/bin" >> ${RACROSS_INITSCRIPT}
fi
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/Free60Project/libxenon.git
	cd libxenon
	git remote add AZO234 https://github.com/AZO234/libxenon.git
	git pull --no-edit AZO234 fix
	cd ..
	cp ${RACROSS_BASE}/gcc.diff_4.7.4 libxenon/toolchain/
	tar -Jcf ${RACROSS_CACHE}/libxenon.tar.xz libxenon
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf libxenon
	fi
else
	tar -Jxf ${RACROSS_CACHE}/libxenon.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cd libxenon/toolchain
	./build-xenon-toolchain toolchain
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf libxenon
	fi
fi

# Vita SDK
echo "*** setup Vita SDK ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	export VITASDK=${RACROSS_TOOLS}/vitasdk
	export PATH=$VITASDK/bin:$PATH
	echo "export VITASDK=${RACROSS_TOOLS}/vitasdk" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$VITASDK/bin:\$PATH" >> ${RACROSS_INITSCRIPT}
fi
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/vitasdk/vdpm.git
	cd vdpm
	git remote add AZO234 https://github.com/AZO234/vdpm.git
	git pull --no-edit AZO234 fix
	cd ..
	tar -Jcf ${RACROSS_CACHE}/vdpm.tar.xz vdpm
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf vdpm
	fi
else
	tar -Jxf ${RACROSS_CACHE}/vdpm.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cd vdpm
	./bootstrap-vitasdk.sh
	./install-all.sh
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf vdpm
	fi
fi

# devkitPro
echo "*** setup devkitPro ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/devkitPro/buildscripts.git
	cd buildscripts
	git remote add AZO234 https://github.com/AZO234/buildscripts.git
	git pull --no-edit AZO234 fix
	cd ..
	cp ${RACROSS_BASE}/config1.sh buildscripts/
	cp ${RACROSS_BASE}/config2.sh buildscripts/
	cp ${RACROSS_BASE}/config3.sh buildscripts/
	tar -Jcf ${RACROSS_CACHE}/buildscripts.tar.xz buildscripts
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf buildscripts
	fi
else
	tar -Jxf ${RACROSS_CACHE}/buildscripts.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	export DEVKITPRO=${RACROSS_TOOLS}/devkitpro
	export DEVKITARM=$DEVKITPRO/devkitARM
	export DEVKITA64=$DEVKITPRO/devkitA64
	export DEVKITPPC=$DEVKITPRO/devkitPPC
	echo "export DEVKITPRO=${RACROSS_TOOLS}/devkitpro" >> ${RACROSS_INITSCRIPT}
	echo "export DEVKITARM=\$DEVKITPRO/devkitARM" >> ${RACROSS_INITSCRIPT}
	echo "export DEVKITA64=\$DEVKITPRO/devkitA64" >> ${RACROSS_INITSCRIPT}
	echo "export DEVKITPPC=\$DEVKITPRO/devkitPPC" >> ${RACROSS_INITSCRIPT}
	cd buildscripts
	cp config1.sh config.sh
	./build-devkit.sh
	cp config2.sh config.sh
	./build-devkit.sh
	cp config3.sh config.sh
	./build-devkit.sh
	patch ${DEVKITA64}/base_tools < ${RACROSS_BASE}/devkitA64_base_tools.patch
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf buildscripts
	fi
fi

# ps3toolchain
echo "*** setup ps3toolchain ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/ps3dev/ps3toolchain.git
	tar -Jcf ${RACROSS_CACHE}/ps3toolchain.tar.xz ps3toolchain
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf ps3toolchain
	fi
else
	tar -Jxf ${RACROSS_CACHE}/ps3toolchain.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	export PS3DEV=${RACROSS_TOOLS}/ps3dev
	export PSL1GHT=${PS3DEV}/psl1ght
	export PATH=$PATH:$PS3DEV/bin
	export PATH=$PATH:$PS3DEV/ppu/bin
	export PATH=$PATH:$PS3DEV/spu/bin
	echo "export PS3DEV=${RACROSS_TOOLS}/ps3dev" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$PS3DEV/bin" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$PS3DEV/ppu/bin" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$PS3DEV/spu/bin" >> ${RACROSS_INITSCRIPT}
	cd ps3toolchain
	./toolchain.sh
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf ps3toolchain
	fi
fi

# PSL1GHT
echo "*** setup PSL1GHT ***"
rm -rf ${PSL1GHT}
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/bucanero/PSL1GHT.git
	tar -Jcf ${RACROSS_CACHE}/PSL1GHT.tar.xz PSL1GHT
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf PSL1GHT
	fi
else
	tar -Jxf ${RACROSS_CACHE}/PSL1GHT.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	export PATH=$PATH:$PSL1GHT/host/bin
	echo "export PSL1GHT=${PSL1GHT}" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$PSL1GHT/host/bin" >> ${RACROSS_INITSCRIPT}
	cd PSL1GHT
	make install-ctrl
	make
	make install
	if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
		cd ${RACROSS_BASE}
		rm -rf PSL1GHT
	fi
fi

# Theos
echo "*** setup Theos ***"
cd ${RACROSS_BASE}
export THEOS=${RACROSS_TOOLS}/theos
echo "export THEOS=${RACROSS_TOOLS}/theos" >> ${RACROSS_INITSCRIPT}
git clone https://github.com/theos/theos.git ${THEOS}
cd ${THEOS}
git remote add AZO234 https://github.com/AZO234/theos.git
git pull --no-edit AZO234 fix
git submodule update --init --recursive
cd ${RACROSS_BASE}
curl https://kabiroberai.com/toolchain/download.php?toolchain=ios-linux -Lo toolchain.tar.gz
tar -xzf toolchain.tar.gz -C ${THEOS}/toolchain
rm -rf ${THEOS}/sdks
git clone https://github.com/hirakujira/sdks.git ${THEOS}/sdks
curl https://swift.org/builds/swift-5.2.1-release/ubuntu1804/swift-5.2.1-RELEASE/swift-5.2.1-RELEASE-ubuntu18.04.tar.gz -Lo swift-toolchain.tar.gz
tar -xzf swift-5.2.1-RELEASE-ubuntu18.04.tar.gz
mkdir ${THEOS}/sdks/swift
mv swift-5.2.1-RELEASE-ubuntu18.04/usr/* ${THEOS}/sdks/swift
if [[ ! ${RACROSS_SETUP_DELETE} = 1 ]] ; then
	tar Jcvf ${RACROSS_CACHE}/theos.tar.xz ${THEOS}
fi

# Emscripten
echo "*** setup Emscripten ***"
cd ${RACROSS_TOOLS}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/emscripten-core/emsdk.git
	cd emsdk
	./emsdk update
	git pull
	cd ${RACROSS_TOOLS}
	tar -Jcf ${RACROSS_CACHE}/emsdk.tar.xz emsdk
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf emsdk
	fi
else
	tar -Jxf ${RACROSS_CACHE}/emsdk.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cd emsdk
	./emsdk install latest
	./emsdk activate latest
#	source ./emsdk_env.sh
#	echo "source ${RACROSS_TOOLS}/emsdk/emsdk_env.sh" >> ${RACROSS_INITSCRIPT}
fi

# OpenDingux GCW0
echo "*** OpenDingux GCW0 ***"
cd ${RACROSS_TOOLS}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/OpenDingux/buildroot.git
	tar -Jcf ${RACROSS_CACHE}/buildroot.tar.xz buildroot
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf buildroot
	fi
else
	tar -Jxf ${RACROSS_CACHE}/buildroot.tar.xz
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cd buildroot
	CONFIG=gcw0 FORCE_UNSAFE_CONFIGURE=1 ./rebuild.sh
fi

# OpenDingux RS90
echo "*** OpenDingux RS90 ***"
cd ${RACROSS_TOOLS}
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cd buildroot
	CONFIG=rs90 FORCE_UNSAFE_CONFIGURE=1 ./rebuild.sh
fi

# Android NDK
echo "*** setup Android NDK ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	wget https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip -P ${RACROSS_CACHE}
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	unzip ${RACROSS_CACHE}/android-ndk-r21-linux-x86_64.zip -d ${RACROSS_TOOLS}/
	export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r21
	export PATH=$PATH:${RACROSS_TOOLS}/android-ndk-r21
	echo "export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r21" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/android-ndk-r21" >> ${RACROSS_INITSCRIPT}
fi

# libretro-super
echo "*** setup libretro-super ***"
cd ~
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone https://github.com/libretro/libretro-super.git
	cd libretro-super
	git remote add AZO234 https://github.com/AZO234/libretro-super.git
	git pull --no-edit AZO234 AZO_fix
	cd ..
	tar -Jcf ${RACROSS_CACHE}/libretro-super.tar.xz libretro-super
	if [[ ${RACROSS_SETUP_INSTALL} = 0 ]] ; then
		rm -rf libretro-super
	fi
else
	tar -Jxf ${RACROSS_CACHE}/libretro-super.tar.xz
fi

# build scripts
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	cp ${RACROSS_BASE}/build-core.sh ~/libretro-super
fi

