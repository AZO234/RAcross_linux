#!/bin/bash

source RAcross_config.sh

export RACROSS_BASE=`pwd`

export RACROSS_CACHE=${RACROSS_BASE}/cache
if [[ ${RACROSS_SETUP_CACHE} = 1 ]] ; then
rm -rf ${RACROSS_CACHE}
mkdir -p ${RACROSS_CACHE}
fi

export RACROSS_TOOLS=${HOME}/RAcross-tools
rm -rf ${RACROSS_TOOLS}
mkdir -p ${RACROSS_TOOLS}

case "`uname -v`" in
*Ubuntu*)
sudo ./RAcross_linux_su.sh
;;
esac
./RAcross_linux_user.sh

if [[ ${RACROSS_SETUP_DELETE} = 1 ]] ; then
	rm -rf $RACROSS_BASE
fi

echo "*****************************************"
echo "RAcross setup is finished. please reboot."
echo "*****************************************"

