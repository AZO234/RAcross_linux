#!/bin/bash

case "`uname -v`" in
*Ubuntu*)
sudo ./RAcross_linux_su.sh
;;
esac
./RAcross_linux_user.sh

echo "*****************************************"
echo "RAcross setup is finished. please reboot."
echo "*****************************************"

