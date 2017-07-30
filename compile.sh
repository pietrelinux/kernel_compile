#!/bin/sh
echo " Instalando dependencias"
sleep 3
apt-get update
apt-get install -y build-essential bin86 kernel-package libqt4-dev wget libncurses5 libncurses5-dev qt4-dev-tools libqt4-dev zlib1g-dev gcc-arm-linux-gnueabihf git debootstrap u-boot-tools device-tree-compiler libusb-1.0-0-dev android-tools-adb android-tools-fastboot qemu-user-static

echo " Creando ramdisk"
sleep 3
mkdir /tmp/ramdisk
mkdir /home/sunxi
mkdir /home/sunxi/kernel
mkdir /home/sunxi/modules
mount -t tmpfs none /tmp/ramdisk -o size=1200M
echo " Instalando kernel generico " 
cd /tmp/ramdisk 
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.12.4.tar.xz
sudo tar -Jxf linux-4.12.4.tar.xz
cd linux-4.12.4
sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf sunxi_defconfig
sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- xconfig
sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage dtbs
sudo ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=output make modules modules_install
cp arch/arm/boot/zImage /home/sunxi/kernel
cp -r arch/arm/boot/dts /home/sunxi/dts
cp -r output/lib /home/sunxi/modules
rm -r /tmp/ramdisk/linux-4.12.4
rm /tmp/ramdisk/linux-4.12.4.tar.xz
umount /tmp/ramdisk/
exit
