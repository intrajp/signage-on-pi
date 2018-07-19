Download the package from https://git.busybox.net/buildroot. 

For now, this package is amenable to us. 

buildroot-2018.05.tar.gz 

untar the package. 

goto rasberrypi2 on this project. 

copy config_signage_on_pi2 as .config to the directory buildroot. 
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
SLEEP_SEC=60
LOOP=1
```

Prepare .png file. It should be set one directory above of buildroot topdir. 

Directory name should be 'PICTURES_ORIGINAL'

Picture file name should be like '${PICTURE_ONE_SHOT}-01.png'

Make pictures with command 'pdftoppm <inputpdf> ${PICTURE_ONE_SHOT} -png'

Copy pictures to directory 'PICTURES_ORIGINAL'.  

Copy scripts to board/raspberrypi2. 

```
$ make all 
```
During make, PINKRABBIT_PICTURES directory is made and converted pictures are saved. 

If you want to start automatically, login as root and edit 'cmdline.txt'.

To hide boot message, change "console=tty1" to "console=tty3".

Add "loglevel=3" not to show non-critical messages.

Add "vt.global_cursor_default=0” to stop cursor-blinking.

Add "logo.nologo” not showing kernel logo.

Now you copy sdcard.img to device. 

(example) 
```
# cfdisk /dev/mmcblk0 
```
1 for 50M and bootable would be fine 

2 for 1G would be fairly enough 

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

Copyright Shintaro Fujiwara 

