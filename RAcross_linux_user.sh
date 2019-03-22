#!/bin/bash

source RAcross_config.sh

export RACROSS_TOOLS=${HOME}/RAcross-tools
rm -rf ${RACROSS_TOOLS}
mkdir -p ${RACROSS_TOOLS}

RACROSS_INITSCRIPT=~/.profile

# psptoolchain
echo "*** setup psptoolchain ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/pspdev/psptoolchain.git
	patch -p1 -d psptoolchain < ${RACROSS_BASE}/psptoolchain.patch
	tar Jcvf ${RACROSS_CACHE}/psptoolchain.tar.xz psptoolchain
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf psptoolchain
	fi
else
	tar Jxfv ${RACROSS_CACHE}/psptoolchain.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	export PSPDEV=${RACROSS_TOOLS}/pspdev
	export PATH=$PATH:$PSPDEV/bin
	echo "export PSPDEV=${RACROSS_TOOLS}/pspdev" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$PSPDEV/bin" >> ${RACROSS_INITSCRIPT}
	cd psptoolchain
	./toolchain.sh
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf psptoolchain
	fi
fi

# libtransistor
echo "*** setup libtransistor ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist
	echo "export LIBTRANSISTOR_HOME=${RACROSS_TOOLS}/libtransistor/dist" >> ${RACROSS_INITSCRIPT}
fi
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --recursive https://github.com/reswitched/libtransistor
	tar Jcvf ${RACROSS_CACHE}/libtransistor.tar.xz libtransistor
	git clone --recursive https://github.com/reswitched/libtransistor-base
	tar Jcvf ${RACROSS_CACHE}/libtransistor-base.tar.xz libtransistor-base
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf libtransistor-base
		rm -rf libtransistor
	fi
else
	tar Jxfv ${RACROSS_CACHE}/libtransistor.tar.xz
	tar Jxfv ${RACROSS_CACHE}/libtransistor-base.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	cd libtransistor-base
	pip3 install -r requirements.txt
	make
	cp -r dist ../libtransistor/
	cd ../libtransistor
	make
	mkdir -p ${RACROSS_TOOLS}/libtransistor
	cp -r dist ${RACROSS_TOOLS}/libtransistor/
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf libtransistor-base
		rm -rf libtransistor
	fi
fi

# crosstool-NG
echo "*** setup crosstool-NG ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/crosstool-ng/crosstool-ng
	tar Jcvf ${RACROSS_CACHE}/crosstool-ng.tar.xz crosstool-ng
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf crosstool-ng
	fi
else
	tar Jxfv ${RACROSS_CACHE}/crosstool-ng.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	cd crosstool-ng
	./bootstrap
	automake --add-missing
	./configure --prefix=${RACROSS_TOOLS}/crosstool-ng
	make
	make install
	export PATH=$PATH:${RACROSS_TOOLS}/crosstool-ng/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/crosstool-ng/bin" >> ${RACROSS_INITSCRIPT}
	ct-ng update-samples
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf crosstool-ng
	fi
fi

echo "*** setup RPi2 cross env ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	mkdir armv7-rpi2-linux
	cd armv7-rpi2-linux
	ct-ng armv7-rpi2-linux-gnueabihf
	sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
	mv .config_mod .config
	ct-ng build
	export PATH=$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/buildtools/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv7-rpi2-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf armv7-rpi2-linux
	fi
fi

echo "*** setup RPi3 cross env ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	mkdir armv8-rpi3-linux
	cd armv8-rpi3-linux
	ct-ng armv8-rpi3-linux-gnueabihf
	sed -e "s/\${HOME}\/x-tools/\${RACROSS_TOOLS}/g" .config > .config_mod
	mv .config_mod .config
	ct-ng build
	export PATH=$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/buildtools/bin
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/armv8-rpi3-linux-gnueabihf/bin" >> ${RACROSS_INITSCRIPT}
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf armv8-rpi3-linux
	fi
fi

# Xenon_Toolchain
echo "*** setup Xenon_Toolchain ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	export DEVKITXENON="${RACROSS_TOOLS}/xenon"
	export PATH="$PATH:$DEVKITXENON/bin:$DEVKITXENON/usr/bin"
	echo "export DEVKITXENON=${RACROSS_TOOLS}/xenon" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:\$DEVKITXENON/bin:\$DEVKITXENON/usr/bin" >> ${RACROSS_INITSCRIPT}
fi
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/Free60Project/libxenon.git
	patch libxenon/toolchain/build-xenon-toolchain < ${RACROSS_BASE}/build-xenon-toolchain.patch
	patch libxenon/toolchain/build-xenon-toolchain < ${RACROSS_BASE}/build-xenon-toolchain_4.7.4.patch
	cp ${RACROSS_BASE}/gcc.diff_4.7.4 libxenon/toolchain/
	tar Jcvf ${RACROSS_CACHE}/libxenon.tar.xz libxenon
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf libxenon
	fi
else
	tar Jxfv ${RACROSS_CACHE}/libxenon.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	cd libxenon/toolchain
	./build-xenon-toolchain toolchain
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf libxenon
	fi
fi

# Vita SDK
echo "*** setup Vita SDK ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	export VITASDK=${RACROSS_TOOLS}/vitasdk
	export PATH=$VITASDK/bin:$PATH
	echo "export VITASDK=${RACROSS_TOOLS}/vitasdk" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$VITASDK/bin:\$PATH" >> ${RACROSS_INITSCRIPT}
fi
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/vitasdk/vdpm
	patch vdpm/include/install-vitasdk.sh < ${RACROSS_BASE}/install-vita_sdk.patch
	tar Jcvf ${RACROSS_CACHE}/vdpm.tar.xz vdpm
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf vdpm
	fi
else
	tar Jxfv ${RACROSS_CACHE}/vdpm.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	cd vdpm
	./bootstrap-vitasdk.sh
	./install-all.sh
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf vdpm
	fi
fi

# devkitPro
echo "*** setup devkitPro ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/devkitPro/buildscripts.git
	patch -p1 -d buildscripts < ${RACROSS_BASE}/buildscripts.patch
	cp ${RACROSS_BASE}/config1.sh buildscripts/
	cp ${RACROSS_BASE}/config2.sh buildscripts/
	cp ${RACROSS_BASE}/config3.sh buildscripts/
	tar Jcvf ${RACROSS_CACHE}/buildscripts.tar.xz buildscripts
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf buildscripts
	fi
else
	tar Jxfv ${RACROSS_CACHE}/buildscripts.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
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
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf buildscripts
	fi
fi

# ps2toolchain
echo "*** setup ps2toolchain ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone https://github.com/ps2dev/ps2toolchain.git
	tar Jcvf ${RACROSS_CACHE}/ps2toolchain.tar.xz ps2toolchain
	git clone https://github.com/ps2dev/ps2sdk-ports.git
	tar Jcvf ${RACROSS_CACHE}/ps2sdk-ports.tar.xz ps2sdk-ports
	git clone https://github.com/ps2dev/gsKit.git
	tar Jcvf ${RACROSS_CACHE}/gsKit.tar.xz gsKit
	git clone https://github.com/ps2dev/ps2-packer.git
	tar Jcvf ${RACROSS_CACHE}/ps2-packer.tar.xz ps2-packer
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf ps2toolchain
		rm -rf ps2sdk-ports
		rm -rf gsKit
		rm -rf ps2-packer
	fi
else
	tar Jxfv ${RACROSS_CACHE}/ps2toolchain.tar.xz
	tar Jxfv ${RACROSS_CACHE}/ps2sdk-ports.tar.xz
	tar Jxfv ${RACROSS_CACHE}/gsKit.tar.xz
	tar Jxfv ${RACROSS_CACHE}/ps2-packer.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
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
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf ps2toolchain
		rm -rf ps2sdk-ports
		rm -rf gsKit
		rm -rf ps2-packer
	fi
fi

# ps3toolchain
echo "*** setup ps3toolchain ***"
mkdir -p ${RACROSS_TOOLS}/ps3dev
cd ${RACROSS_TOOLS}/ps3dev
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/ps3dev/ps3toolchain.git
	tar Jcvf ${RACROSS_CACHE}/ps3toolchain.tar.xz ps3toolchain
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf ps3toolchain
	fi
else
	tar Jxfv ${RACROSS_CACHE}/ps3toolchain.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
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
	if [ ${RACROSS_SETUP_DELETE} = 1 ] ; then
		cd ${RACROSS_BASE}
		rm -rf ps3toolchain
	fi
fi

# Emscripten
echo "*** setup Emscripten ***"
cd ${RACROSS_TOOLS}
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/emscripten-core/emsdk.git
	cd emsdk
	./emsdk update
	git pull
	cd ${RACROSS_TOOLS}
	tar Jcvf ${RACROSS_CACHE}/emsdk.tar.xz emsdk
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf emsdk
	fi
else
	tar Jxfv ${RACROSS_CACHE}/emsdk.tar.xz
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	cd emsdk
	./emsdk install latest
	./emsdk activate latest
#	source ./emsdk_env.sh
#	echo "source ${RACROSS_TOOLS}/emsdk/emsdk_env.sh" >> ${RACROSS_INITSCRIPT}
fi

# Android NDK
echo "*** setup Android NDK ***"
cd ${RACROSS_BASE}
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	wget https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip -P ${RACROSS_CACHE}
fi
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	unzip ${RACROSS_CACHE}/android-ndk-r18b-linux-x86_64.zip -d ${RACROSS_TOOLS}/
	export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r18b
	export PATH=$PATH:${RACROSS_TOOLS}/android-ndk-r18b
	echo "export NDK_ROOT_DIR=${RACROSS_TOOLS}/android-ndk-r18b" >> ${RACROSS_INITSCRIPT}
	echo "export PATH=\$PATH:${RACROSS_TOOLS}/android-ndk-r18b" >> ${RACROSS_INITSCRIPT}
fi

# libretro-super
echo "*** setup libretro-super ***"
cd ~
if [ ${RACROSS_SETUP_CACHE} = 1 ] ; then
	git clone --depth=1 https://github.com/libretro/libretro-super.git
	patch -p1 -d libretro-super < ${RACROSS_BASE}/libretro-super.patch
	chmod +x libretro-super/libretro-build-android-mk.sh
	chmod +x libretro-super/libretro-build-emscripten.sh
	chmod +x libretro-super/libretro-build-libnx.sh
	chmod +x libretro-super/libretro-build-psl1ght.sh
	chmod +x libretro-super/libretro-build-xenon.sh
	chmod +x libretro-super/libretro-build-rpi2.sh
	chmod +x libretro-super/libretro-build-rpi3.sh
	tar Jcvf ${RACROSS_CACHE}/libretro-super.tar.xz libretro-super
	if [ ${RACROSS_SETUP_INSTALL} = 0 ] ; then
		rm -rf libretro-super
	fi
else
	tar Jxfv ${RACROSS_CACHE}/libretro-super.tar.xz
fi

# build scripts
if [ ${RACROSS_SETUP_INSTALL} = 1 ] ; then
	cp ${RACROSS_BASE}/build-core.sh ~/libretro-super
fi

