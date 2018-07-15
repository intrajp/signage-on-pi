Download from package from https://git.busybox.net/buildroot. 

For now, this package is amenable to us. 

buildroot-2018.05.tar.gz 

unzip the package. 

copy .config_signage_on_pi2 as .config. 
```
$ make menuconfig 
```

  Change setting as your needs, but include fbv for sure. 

open config.txt 
  Change setting as your needs. These should be set. 
(defaults) 
MY_SIGNAGE_DIR=pinkrabbit 
PICTURE_ONE_SHOT=pink_rabbit.png 

prepare .png file. It should be set one directory above of topdir. 

copy scripts to board/raspberrypi2. 

```
$ make all 
```

copy sdcard image. 

(example) 
```
# cfdisk /dev/mmcblk0 
```
1 for 50M and bootable would be fine 
2 for 1G would be fairy enough 

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

Start oneshot. 

```
# show-png-onshot-daemon 
```

Copyright Shintaro Fujiwara 

