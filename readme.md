
# Overview
This repo, forked from https://github.com/raspberrypi/linux, has been modified for the **Conexant AudioSmart® 4-Mic Development Kit for Amazon AVS**. This creates a 4.4.50 based kernel running on Raspberry Pi 2 system. 

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

---

# BUILDING THE KERNEL

Build the Linux kernel for the RPi 2. The following instructions refer to cross compiling the driver on an Ubuntu environment.

**Note:** The following steps must be completed on the host machine (which is running the Ubuntu environment and which the kernel will be built on). The /boot/config.txt should be changed on the RPi 2, after the kernel is installed.

Prior to building the Linux driver, the following packages must be installed: Git, bc, libncurses5-dev, libncursesw5-dev, and gcc-arm-linux-gnueabihf. All these packages can be installed with the following command:
```  
  $ sudo apt-get install git bc libncurses5-dev libncursesw5-dev gcc-arm-linux-gnueabihf
```
There are two main methods for building the kernel. Since *Local Building* method will take a long time, we are going to focus on *Cross Compiling* method. 

## INSTALL TOOLCHAIN

The following instructions create a 4.4.50 kernel running on the RPi 2. If you don't have the toolchain installed, use the following commands to install the toolchain:
```
  $ cd ~
  $ git clone https://github.com/raspberrypi/tools
```
For your convenience,the sub-directory, bin, can be added to $PATH 
```
  $ PATH=$PATH:~/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin
```
## GET SOURCES

Clone the following kernel tree
```
$ git clone --depth 10 -n --branch cnxt-rpi-4.4.y --single-branch https://github.com/conexant/rpi-linux.git
$ KERNEL=kernel7
$ cd rpi-linux
$ git checkout
```
## BUILD SOURCES

Use the following commands to build the code, assuming your build platform is Ubuntu.
```
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
```
Enable the driver options
```
$ make ARCH=arm menuconfig 
```
In the Linux/arm 4.4.50 Kernel Configuration menu, go to:
```
[Device Drivers] => [Sound card support] => [Advanced Linux Sound Architecture] => [ALSA for SoC audio support]
```
Check the two boxes:
```
[M] - Support for Smart Speaker Pi add on soundcard (USB)
[M] - Support for Smart Speaker Pi add on soundcard (I2S)
```
Save the configuration and exit out back to the terminal. 

Then, build the code. 
**Note: The compilation can be sped up by using the '-j n' option, with n equal to the number of processors * 1.5. This will reduce the compilation time significantly.**

```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
```

## INSTALL DIRECTLY ONTO THE SD CARD
**Note:** Before installing the kernel, the microSD card should have completed the Amazon AVS setup.

Using the SD card with the AVS already setup, use a SD card adapter to connect the card to the host. Identify the FAT partition (boot) and the ext4 partition (root), this will be necessary to install the kernel to the SD card. See the section *Install Directly onto the SD card* [here](https://www.raspberrypi.org/documentation/linux/kernel/building.md) for details.

## CONFIGURE CONFIG.TXT 
After the installation of the kernel is complete, insert the microSD card in the RPi 2 and edit the /boot/config.txt file with the following options:
```
dtoverlay=rpi-cxsmartspk-usb
dtoverlay=i2s-mmap
dtparam=i2c_arm=on
program_usb_boot_mode=1
```
**To ensure audio playback is through the driver just built/installed, the default audio device should be disabled. Make the following change to the /boot/config.txt file.**
```
dtparam=audio=off
```
## Verify the driver installation 
To verify that the driver is correctly installed, open a terminal on the RPi 2 and send the following command:
```
aplay -l
```
Under the list of playback hardware devices, Card 0 should be named cxsmtspkpiusb [cxsmtspk-pi-usb] and it should be the only device displayed.
