# Shell Cheatsheet

## Search and replace

```
grep -rl 'apples' /dir_to_search_under | xargs sed -i 's/apples/oranges/g'
```

## Install DVD Iso into a USB

```
fdisk -l
Disk /dev/sdb: 28.9 GiB, 31004295168 bytes, 60555264 sectors
Disk model: DataTraveler 3.0
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x0985b0db


sudo ddrescue ~/Descargas/rhel-8.0-x86_64-dvd.iso /dev/sdb --force -D
```
