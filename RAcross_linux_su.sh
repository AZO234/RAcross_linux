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
	# wxWidgets
	apt-key adv --fetch-keys http://repos.codelite.org/CodeLite.asc
	apt-add-repository -y 'deb https://repos.codelite.org/wx3.1.3/ubuntu/ focal universe'

	apt -y update
	apt -y upgrade
	apt -y install git
	apt-get -dy install libgmp3-dev libmpfr-dev libmpc-dev texinfo gettext build-essential lld squashfs-tools llvm clang python-dev cmake mercurial gcc-multilib libelf-dev zlib1g-dev libzip-dev libyaml-dev nodejs default-jre g++ autoconf automake doxygen bison flex libncurses5-dev libsdl1.2-dev libreadline-dev libusb-1.0-0-dev libfreetype6-dev libtool libtool-bin subversion tcl unzip wget patch libucl-dev libbz2-dev libpng-dev libopenal-dev libpixman-1-dev libsdl-image1.2-dev python3-setuptools python3 python3-dev python3-pip curl libssl-dev libfreeimage-dev libudev-dev libexpat1-dev mesa-common-dev liblz4-dev libmagick++-dev libfftw3-dev help2man gawk gperf libusb-dev fakeroot perl libtinfo5 ninja-build gcc-arm-none-eabi libzstd-dev liblzo2-dev liblz4-dev libsdl2-dev libsdl2-mixer-dev libsdl2-net-dev libsdl2-ttf-dev libglib2.0-dev libgtk2.0-dev libssl-dev \
libwxbase3.1-0-unofficial3 libwxbase3.1unofficial3-dev libwxgtk3.1-0-unofficial3 libwxgtk3.1unofficial3-dev wx3.1-headers wx-common libwxgtk-media3.1-0-unofficial3 libwxgtk-media3.1-unofficial3-dev libwxgtk-webview3.1-0-unofficial3 libwxgtk-webview3.1unofficial3-dev libwxbase3.1-0-unofficial3-dbg libwxgtk3.1-0-unofficial3-dbg libwxgtk-webview3.1-0-unofficial3-dbg libwxgtk-media3.1-0-unofficial3-dbg wx3.1-i18n wx3.1-examples
fi
if [[ ${RACROSS_SETUP_INSTALL} = 1 ]] ; then
	apt -y install libgmp3-dev libmpfr-dev libmpc-dev texinfo gettext build-essential lld squashfs-tools llvm clang python-dev cmake mercurial gcc-multilib libelf-dev zlib1g-dev libzip-dev libyaml-dev nodejs default-jre g++ autoconf automake doxygen bison flex libncurses5-dev libsdl1.2-dev libreadline-dev libusb-1.0-0-dev libfreetype6-dev libtool libtool-bin subversion tcl unzip wget patch libucl-dev libbz2-dev libpng-dev libopenal-dev libpixman-1-dev libsdl-image1.2-dev python3-setuptools python3 python3-dev python3-pip curl libssl-dev libfreeimage-dev libudev-dev libexpat1-dev mesa-common-dev liblz4-dev libmagick++-dev libfftw3-dev help2man gawk gperf libusb-dev fakeroot perl libtinfo5 ninja-build gcc-arm-none-eabi libzstd-dev liblzo2-dev liblz4-dev libsdl2-dev libsdl2-mixer-dev libsdl2-net-dev libsdl2-ttf-dev libglib2.0-dev libgtk2.0-dev libssl-dev \
libwxbase3.1-0-unofficial3 libwxbase3.1unofficial3-dev libwxgtk3.1-0-unofficial3 libwxgtk3.1unofficial3-dev wx3.1-headers wx-common libwxgtk-media3.1-0-unofficial3 libwxgtk-media3.1-unofficial3-dev libwxgtk-webview3.1-0-unofficial3 libwxgtk-webview3.1unofficial3-dev libwxbase3.1-0-unofficial3-dbg libwxgtk3.1-0-unofficial3-dbg libwxgtk-webview3.1-0-unofficial3-dbg libwxgtk-media3.1-0-unofficial3-dbg wx3.1-i18n wx3.1-examples
fi
;;
esac

# OpenDigux RG350 toolchain
rm -rf /opt/rg350-toolchain
mkdir /opt/rg350-toolchain
chown ${SUDO_USER}: /opt/rg350-toolchain

