Download the package from https://git.busybox.net/buildroot. 

For now, this package is amenable to us. 

buildroot-2018.08.tar.gz 

untar the package. 

goto rasberrypi directory on this project. 

copy config file as .config to the directory buildroot. 

Note that rpi3 stuff is still in the testing state.

```
$ make menuconfig 
```

  Change setting as your needs, like login prompt or password stuff, but include fbv for sure. 

open pinkrabbit.cfg 

  Change setting as your needs. These should be set. 

(defaults) 
```
MY_SIGNAGE_DIR=pinkrabbit
PICTURE_ONE_SHOT=pinkrabbit
#SIZE=640x480
#SIZE=1024x786
SIZE=1280x800
SLEEP_SEC=5
LOOP=1
```

Prepare .png file. It should be set one directory above of buildroot topdir. 

Directory name should be 'PICTURES_ORIGINAL'

Picture file name should be like '${PICTURE_ONE_SHOT}-01.png'

Make pictures with command 'pdftoppm <inputpdf> ${PICTURE_ONE_SHOT} -png'

Copy pictures to directory 'PICTURES_ORIGINAL'.  

Copy scripts to board/raspberrypi2. 

The config file retrieves kernel from git repository.

If you want to build your own kernel, and if your own kernel resides in /home/intrajp/linux,

Edit local.mk in top of Buildroot like this.
```
LINUX_OVERRIDE_SRCDIR = /home/intrajp/linux/
```

```
$ make all 
```
During make, PINKRABBIT_PICTURES directory is made and converted pictures are saved. 

Now you copy sdcard.img to device. 

(example) 
```
# cfdisk /dev/mmcblk0 
```
1 for 50M and bootable would be fine 

2 for 500M would be fairly enough 

```
# shred -v /dev/mmcblk0p1 
# shred -v /dev/mmcblk0p2 
# mkfs.vfat /dev/mmcblk0p1 
# mkfs.ext4 /dev/mmcblk0p2 
```

```
# dd if=output/images/sdcard.img of=/dev/mmcblk0 status=progress 
```

As it starts, login. 

(Default) 

root:pinkrabbit 

Start oneshot (when you can login). 

```
# show-png-oneshot-daemon 
```

Pictures will be shown each for $SLEEP_SEC and loop forever.


If you want to start automatically, login as root and edit 'cmdline.txt'.

To hide boot message, change "console=tty1" to "console=tty3".

Add "loglevel=3" not to show non-critical messages.

Add "vt.global_cursor_default=0” to stop cursor-blinking.

Add "logo.nologo” not showing kernel logo.

Here is a hint for mounting sdcard.img.

First, get the startsector number of each partition and multiply it by 512.

(example)
```
$ file sdcard.img
sdcard.img: DOS/MBR boot sector; partition 1 : ID=0xc, active, start-CHS (0x0,0,2), end-CHS (0x4,20,17), startsector 1, 65536 sectors; partition 2 : ID=0x83, start-CHS (0x4,20,18), end-CHS (0x43,209,15), startsector 65537, 1024000 sectors
```

First, multiply startsector number by 512 and get offset number.

On above example, goes like this.

So, offset number should be 1 multiply 512=512 and 65536 multiply 512=33554944

(example)
```
# mkdir /mnt/sdcard1
# mount -t vfat -o loop,offset=512 sdcard.img /mnt/sdcard1
# umount /mnt/sdcard1
# mount -t ext4 -o loop,offset=33554944 sdcard.img /mnt/sdcard2
```

Another hint for mounting sdcard.img.

Install kpartx into your local machine.

Now, do this.

```
# kpartx -av sdcard.img 
# ll /dev/mapper
# dmsetup info
# mount /dev/mapper/loop0p1 /mnt/sdcard1
```

Here's a hint for adjusting picture to screen, add "--stretch” to the script line for automatic picture stretching.


Copyright Shintaro Fujiwara 

