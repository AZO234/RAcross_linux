#!/bin/bash

#RACROSS_CACHE=${RACROSS_BASE}/cache
#rm -rf ${RACROSS_CACHE}
#mkdir -p ${RACROSS_CACHE}
#chown ${SUDO_USER}: ${RACROSS_CACHE}

#RACROSS_TOOLS=/home/${SUDO_USER}/RAcross-tools
#rm -rf ${RACROSS_TOOLS}
#mkdir -p ${RACROSS_TOOLS}
#chown ${SUDO_USER}: ${RACROSS_TOOLS}

case "`uname -v`" in
*Ubuntu*)
apt -y install libgmp3-dev libmpfr-dev libmpc-dev texinfo git gettext build-essential lld squashfs-tools llvm clang python-dev python-pip cmake libelf-dev zlib1g-dev libzip-dev libyaml-dev nodejs default-jre g++ autoconf automake doxygen bison flex libncurses5-dev libsdl1.2-dev libreadline-dev libusb-1.0-0-dev libfreetype6-dev libtool libtool-bin subversion tcl unzip wget patch libucl-dev libbz2-dev libpng-dev libopenal-dev libpixman-1-dev libsdl-image1.2-dev python3-setuptools python3 python3-dev python3-pip curl libssl-dev libfreeimage-dev libudev-dev libexpat1-dev mesa-common-dev liblz4-dev libmagick++-dev libfftw3-dev help2man gawk gperf libusb-dev
;;
esac

