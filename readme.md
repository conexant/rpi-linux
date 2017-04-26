
# Overview
This repo was forked from https://github.com/raspberrypi/linux have been modified to build for *Conexant AudioSmart 4-Mic Development Kit*. This creates a 4.4.50 based kernel running on Raspberry Pi 2/3 system. 

The code is based raspberrypi/linux, commit’s SHA-1 hash
[04c8e47067d4873c584395e5cb260b4f170a99ea](https://github.com/raspberrypi/linux/commit/04c8e47067d4873c584395e5cb260b4f170a99ea)

**All drivers patches can be downloaded from the following links**

1. https://github.com/conexant/rpi-linux/commit/2300b06977312ed8c72d511d2ccef9e523a18eb2.patch
2. https://github.com/conexant/rpi-linux/commit/42b8c90ef803f6ff8048d98994e0e553f2029022.patch
3. https://github.com/conexant/rpi-linux/commit/c742ab72c38f4f974d41ceaa7f4557ae6b10c253.patch
4. https://github.com/conexant/rpi-linux/commit/700c42e9e82e585058b83dfef2d29e119cdcdd4a.patch
5. https://github.com/conexant/rpi-linux/commit/e867d62404a73797c2eceb241d85ee0dc68a66f1.patch
6. https://github.com/conexant/rpi-linux/commit/f4570f0547091a76d482c7dbde275e6af4d249c8.patch
7. https://github.com/conexant/rpi-linux/commit/88c026ed26d06751716a95493378e82228737d2b.patch
8. https://github.com/conexant/rpi-linux/commit/e40501eff125512e58da9ea4ac6a4ecef47e956d.patch


# BUILD KERNEL

Below describe all of the required steps to build Linux kernel. We're going to adapt instructions from below page at Raspberry official site to build kernel.  https://www.raspberrypi.org/documentation/linux/kernel/building.md

There are two main methods for building the kernel. Since *Local Building* method will take a long time, we are going to focus on *Cross Compiling* method. 

### INSTALL TOOLCHAIN

If you don't have toolchain installed, please use the following command to install the toolchain:
```
git clone https://github.com/raspberrypi/tools
```
For convenient, yon can add the sub-direction *bin* to $PATH 
```
/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin
```
### GET SOURCES

Clone the following kernel tree
```
$ git clone --depth 10 -n --branch cnxt-rpi-4.4.y --single-branch https://github.com/conexant/rpi-linux.git
$ cd rpi-linux
$ git checkout
```
### BUILD SOURCES

Use the following commands to build the code, assumes your build platform is Ubuntu.
```
$ KERNEL=kernel7
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
```
Enable the driver options
```
$ make ARCH=arm menuconfig 
```
In the Kernel Configuration, go to:
```
[Device Drivers] => [Sound card support] => [Advanced Linux Sound Architecture] => [ALSA for SoC audio support]
```
Check the two boxes:
```
[m] - Support for Smart Speaker Pi add on soundcard (USB)
[m] - Support for Smart Speaker Pi add on soundcard (I2S)
```
Save the configuration and exit out back to the terminal. 

Then, build the code. 
```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
```

### INSTALL DIRECTLY ONTO THE SD CARD
Using the SD card with the AVS already setup, use a SD card adapter to connect the card to the host. Identify the FAT partition (boot) and the ext4 partition (root), this will be necessary to install the kernel to the SD card. See the section *Install Directly onto the SD card* at the following link for details. https://www.raspberrypi.org/documentation/linux/kernel/building.md

### CONFIGURE CONFIG.TXT 
After building, installing the kernel, boot with newly created SD card. and edit the /boot/config.txt file with the following options:
```
dtoverlay=rpi-cxsmartspk-usb
dtoverlay=i2s-mmap
dtparam=i2c_arm=on
program_usb_boot_mode=1
```

