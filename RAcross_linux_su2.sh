#!/bin/bash

source RAcross_config.sh

mv ${RACROSS_TOOLS}/GCW0_buildroot/output/host /opt/gcw0-toolchain
mv ${RACROSS_TOOLS}/RS90_buildroot/output/host /opt/rs90-toolchain
tar -jxf ${RACROSS_TOOLS}/opendingux-rg350-toolchain.tar.bz2
mv rg350-toolchain /opt/
rm opendingux-rg350-toolchain.tar.bz2

