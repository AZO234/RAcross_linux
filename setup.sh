#!/bin/bash

source RAcross_config.sh

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

