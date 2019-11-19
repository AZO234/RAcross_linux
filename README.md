RAcross_linux
=============

RAcross is libretro(RA?)'s core cross build emvironment.

	- Use Ubuntu 19.10 (Vanilla)

RAcross_linux can test follow cross builds

	- PSP
	- psl1ght
	- Xenon
	- Vita
	- Vita
	- Switch(libtransistor)
	- Android
	- CTR(3DS)
	- NGC
	- Wii
	- WiiU
	- libnx
	- Emscripten
	- RPi2
	- RPi3
	- RPi4

install
-------

	1. Locate RAcross_linux directory on home dir
	2. setup with terminal

		1. cd RAcross_linux
		2. ./setup.sh

		- packages
		- psptoolchain (first yes confirm, setup go to end)
		- libtransistor
		- crosstool-NG
			- RPi2
			- RPi3
			- RPi4
		- Xenon_Toolchain
		- Vita SDK
		- devkitPro
		- ps2toolchain
		- ps3toolchain
		- Emscripten
		- Android NDK
		- libretro-super

	3. "RAcross setup is finished." displaied then close terminal and reboot

usage
-----

	1. open terminal
	2. locate your core source at /home/USER/
	3. edit libretro-super/build-core.sh, LR_CORE and LR_CORE_SRC value
	4. cd libretro-super
	5. ./build-core.sh
	6. build logs are output in 'log' dir  
	binalys are output in 'dist' dir

