#!/bin/bash

source RAcross_config.sh

if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
rm -rf ${RACROSS_CACHE}
mkdir -p ${RACROSS_CACHE}
chown ${SUDO_USER}: ${RACROSS_CACHE}
fi
rm -rf ${RACROSS_TOOLS}
mkdir -p ${RACROSS_TOOLS}
chown ${SUDO_USER}: ${RACROSS_TOOLS}

case "`uname -v`" in
*Ubuntu*)
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	apt -y update
	apt -y upgrade
	apt -y install git
	apt-get -dy install libgmp3-dev libmpfr-dev libmpc-dev texinfo gettext build-essential lld squashfs-tools llvm clang python-dev python-pip cmake libelf-dev zlib1g-dev libzip-dev libyaml-dev nodejs default-jre g++ autoconf automake doxygen bison flex libncurses5-dev libsdl1.2-dev libreadline-dev libusb-1.0-0-dev libfreetype6-dev libtool libtool-bin subversion tcl unzip wget patch libucl-dev libbz2-dev libpng-dev libopenal-dev libpixman-1-dev libsdl-image1.2-dev python3-setuptools python3 python3-dev python3-pip curl libssl-dev libfreeimage-dev libudev-dev libexpat1-dev mesa-common-dev liblz4-dev libmagick++-dev libfftw3-dev help2man gawk gperf libusb-dev fakeroot perl libtinfo5
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	apt -y install libgmp3-dev libmpfr-dev libmpc-dev texinfo gettext build-essential lld squashfs-tools llvm clang python-dev python-pip cmake libelf-dev zlib1g-dev libzip-dev libyaml-dev nodejs default-jre g++ autoconf automake doxygen bison flex libncurses5-dev libsdl1.2-dev libreadline-dev libusb-1.0-0-dev libfreetype6-dev libtool libtool-bin subversion tcl unzip wget patch libucl-dev libbz2-dev libpng-dev libopenal-dev libpixman-1-dev libsdl-image1.2-dev python3-setuptools python3 python3-dev python3-pip curl libssl-dev libfreeimage-dev libudev-dev libexpat1-dev mesa-common-dev liblz4-dev libmagick++-dev libfftw3-dev help2man gawk gperf libusb-dev fakeroot perl libtinfo5
fi
;;
esac

export RACROSS_BASE=`pwd`

export RACROSS_CACHE=${RACROSS_BASE}/cache
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
rm -rf ${RACROSS_CACHE}
mkdir -p ${RACROSS_CACHE}
chown ${SUDO_USER}: ${RACROSS_CACHE}
fi

export RACROSS_TOOLS=/home/${SUDO_USER}/RAcross-tools
rm -rf ${RACROSS_TOOLS}
mkdir -p ${RACROSS_TOOLS}
chown ${SUDO_USER}: ${RACROSS_TOOLS}

RACROSS_INITSCRIPT=/home/${SUDO_USER}/.profile

# ps2toolchain
echo "*** setup ps2toolchain ***"
cd ${RACROSS_BASE}
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
	git clone --depth=1 https://github.com/ps2dev/ps2toolchain.git
	tar -Jcf ${RACROSS_CACHE}/ps2toolchain.tar.xz ps2toolchain
	git clone --depth=1 https://github.com/ps2dev/ps2sdk-ports.git
	tar -Jcf ${RACROSS_CACHE}/ps2sdk-ports.tar.xz ps2sdk-ports
	git clone --depth=1 https://github.com/ps2dev/gsKit.git
	tar -Jcf ${RACROSS_CACHE}/gsKit.tar.xz gsKit
	git clone --depth=1 https://github.com/ps2dev/ps2-packer.git
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
	chown ${SUDO_USER}: ${RACROSS_INITSCRIPT}
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

