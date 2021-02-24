##### Leaf: Beyond Linux From Scratch Systemd 10.0 Script Collection.

---

##### 步骤

1. 创建必要的目录和文件
	```
	bash leaf_init.sh
	```
	/var/leaf/log/available 非常重要的日志文件，记录已安装的软件包。
	/var/leaf/cache         软件源码包解压到此处，然后进行编译。
	/var/leaf/script        每个软件对应的安装脚本放在此处。


2. 挂载额外分区(可选)
	创建一个分区用于存放源码包(/dev/sda4)。
	```
	cfdisk /dev/sda
	mkfs.ext4 /dev/sda4
	mount /dev/sda4 /mnt/pkg -v
	```
	如果希望开机挂载，可以修改/etc/fstab文件，root用户使用blkid查看磁盘的UUID。


3. 下载脚本
	将此仓库的script下的所有脚本下载到/var/leaf/script，template.sh是脚本模板。

---

欢迎提issues。
