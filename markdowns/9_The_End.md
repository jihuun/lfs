## 9. The End  

      
<!-- toc -->
      
  

## 9.1. The End  
  
이제 새로운 custom LFS시스템이 완전히 설치되었다.   
  
  
  
- __release 노트 파일생성__    
  
```sh  
echo 7.7 > /etc/lfs-release  
```  
  
- __시스템 상태 보여주는 파일 생성__    
  
```sh  
cat > /etc/lsb-release << "EOF"  
DISTRIB_ID="Linux From Scratch"  
DISTRIB_RELEASE="7.7"  
DISTRIB_CODENAME="<your name here>"  
DISTRIB_DESCRIPTION="Linux From Scratch"  
EOF  
```  
  
  
  
  
  
      
      
## 9.2. Get Counted  
  
Register하기.  
http://www.linuxfromscratch.org/cgi-bin/lfscounter.php   
  
```  
Records 101 – 200 of 177  
  
LFS ID	Name			First LFS Version  
25608	Roberto Rodriguez Jr	7.7  
25609	Moli			7.7  
25610	Gerhard			7.7  
25611	Ji-Hun Kim		7.7  
```  
  
Let`s reboot into LFS now.  
  
  
  
  
      
      
## 9.3. Rebooting the System  
  
shutdown -r now  
  
  
      
      
## 9.4. What Now?  
BLFS or piLFS?  





      
      
## 9.5. 추가 설정.


      
### bash 쉘 프롬프트 모양 바꾸기  

현재 ``-bash-4.3.3 $`` 이렇게 되어있음.  
echo $PS1 해보면 ``PS1="-\s-\v$ "`` 이렇게 나와서 그렇다  
PS1 환경변수를 수정해야한다.  
참고  http://webdir.tistory.com/105   

현재 LFS시스템에는 root계정밖에 없으니 root의 홈 디렉토리인 /root/밑에  
.bashrc 파일을 만들어 아래와같이 환경변수 셋팅을 해주면됨.  
참고 http://superuser.com/questions/268460/wheres-bashrc-for-root  


- __/root/.bashrc파일에 아래와같이 입력__  

```sh
export PS1="\u@\h:\w\$ "
```
> \u : user계정명  
> \h : host name  
> \w : full path  
> \$ : $모양 표시 (\\$ : root일때 #으로 바꿔줌)  

- __그 뒤 bashrc 적용__  
 
```sh
 $ source /root/.bashrc
```
> 여기에하면 재부팅할때마다 적용해줘야함.  
> /etc/profile 에 써주면  재부팅시 바로 적용됨.  




      
      
## 9.6 내가만든 LFS를 USB로 부팅가능하게 만들기.  


### 9.6.1. 배경 및 사전조사    

lfs현재 상태를 mkisofs  를 이용해 .iso 파일로 만들고  
USB에 grub을 설치하고 MBR? 로 설정하여 부팅가능하게 하면 되려나?  
일단 아무 폴더를 iso로 만들고 mount하니까 파일 그대로 볼수 있었음.  

- __iso생성 및 mount테스트__  

```sh
 $ mkisofs -r -V "test ISO" -o iso_test_vimdic.iso ~/Downloads/vimdic-master
 $ sudo mount -o loop ~/Downloads/iso_test_vimdic.iso /mnt/test_iso/
```


http://www.linuxquestions.org/questions/linux-from-scratch-13/booting-lfs-from-usb-stick-897465/  
일반적인방법  
http://www.pendrivelinux.com/boot-multiple-iso-from-usb-via-grub2-using-linux/  
http://www.pendrivelinux.com/install-grub2-on-usb-from-ubuntu-linux/  


ISO 이미지 만들기.  
http://idchowto.com/index.php/linux%EC%97%90%EC%84%9C-iso-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EB%A7%8C%EB%93%A4%EA%B8%B0-mkisofs/


참고 블로그  
http://blog.daum.net/bagjunggyu/118
http://bagjunggyu.blogspot.kr/2014/04/ubuntu-1404-lts-usb.html


### 9.6.2. USB에 GRUB 설치 테스트  

http://www.pendrivelinux.com/boot-multiple-iso-from-usb-via-grub2-using-linux/
따라서 USB에 Grub설치하기.


``(참고)`` dd 와 mkisofs로 ISO 파일 만들기.  
> 
> - __mkisofs 이용__   
> 
> ```sh
>  $ mount -v -t ext4 /dev/sdb5 /mnt/lfs
>  $ mkisofs -r -V "test ISO" -o lfs-7-7.iso /mnt/lfs
> ```
> 나중에 iso를 mount 할때는 mount -t ext4 옵션으로 mount가 안되고 -o loop로
> mount 해야함.  
> lfs iso이미지는 이렇게 만듦.  
>
> - __dd 이용__   
> 
> ```sh
>  $ dd if=/dev/sdb5 of=lfs-7-7.iso
> ```
>
> - __일반적인 iso 관련 사용법?__   
>
> ```
> files -> iso		$ mkisofs -o image.iso <pathlist>
> view iso		$ mount image.iso -o loop <dirname>
> iso -> CD		$ cdrecord -v -eject dev=<i,j,k> image.iso
> CD -> iso		$ dd if=/dev/cdrom of=image.iso
> ```


### 9.6.3. 파일시스템 통째로 복사하여 USB 부팅 하기 

아래대로 따라해서 usb에 grub으로 부팅 성공함. 
//iso를 로딩하는 grub설정 방법은 추후 확인.  

#### (1). Format your USB Flash Drive to use a Single Partition:

```sh

Open a terminal and type sudo su
 $ fdisk -l (and note which device is your USB Drive)
 $ fdisk /dev/sdx (replacing x with your actual usb device)
	Type d (to delete the existing partition)
	Type n (to create a new partition)
	Type p (for primary partition)
	Type 1 (to create the first partition)
	Press Enter (to use the first cylinder)
	Press Enter again (to use the default value as the last cylinder)
	Type a (for active)
	Type 1 (to mark the first partition active "bootable")
	Type t (for partition type)
	Type 83 (to use linux partition)
	Type w (to write the changes and close fdisk)
```
> ``(주의)``  fdisk /dev/sdx  sdx1 이 아니라 sdx 임.  



#### (2). Create a ext4 filesystem on the USB flash drive:

```sh
sudo umount /dev/sdc1 (or whatever your usb is)
sudo mkfs.ext4 /dev/sdc1
```


#### (3). Install Grub2 on the USB Flash Drive:

```sh
mkdir /mnt/USB && mount /dev/sdx1 /mnt/USB (replacing x with your actual usb device)

grub-install --force --no-floppy --boot-directory=/mnt/USB/boot /dev/sdx
(replacing x with your actual USB device)

cd /mnt/USB/boot/grub (to change directory)
wget pendrivelinux.com/downloads/grub.cfg

```
> ``(주의)`` grub-install 설치 옵션에  /dev/sdx 임을 주의
> 이렇게하면 USB로 재부팅시 grub화면이 보임.  


#### (4). LFS 루트파일시스템 USB로 통째로 복사

```sh  
 $ mount /dev/sdc1 /mnt/USB
 $ mount /dev/sdb5 /mnt/lfs
 $ cd /mnt/lfs
 $ cp -avp bin/ dev/ etc/ home/ lib/ lib64 media/ mnt/ opt/ proc/ root/ run/ sbin/ sources/ srv/ sys/ tmp/ usr/ var/ /mnt/USB/
 $ cp boot/* /mnt/USB/boot/
```
> iso로딩 대신 이방법 사용.  


#### (5). grub.cfg 수정.

```sh  
cat > boot/grub/grub.cfg << "EOF"
## Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,1)

menuentry "GNU/Linux, Linux 3.19-lfs-7.7" {
	        linux   /boot/vmlinuz-3.19-lfs-7.7 root=/dev/sdc1 ro
}
EOF
```
> (hd0,1) USB의 첫번째 파티션이므로 1임.  
> root=/dev/sdc1 으로 수정  
> 
> http://linuxfromscratch.org/lfs/view/stable/chapter08/grub.html  

> 여기까지하면 가까스로 부팅은 됨.
> 하지만 중간에 부팅이 멈춤.  


#### (6). initrd 추가.  

- initrd 이미지 HOST의 것으로 복사

```sh  
cp  /boot/initrd.img-3.8.0-42-generic  /mnt/USB/boot/
```  
> 실제로는 커널을 빌드할때 config 옵션으로 initrd를 줘서 생성한 initrd를 추가해줘야할듯  

- grub.cfg 에 initrd추가  

```patch  
menuentry "GNU/Linux, Linux 3.19-lfs-7.7" {
		linux   /boot/vmlinuz-3.19-lfs-7.7 root=/dev/sdc1 ro
+		initrd 	/boot/initrd.img-3.8.0-42-generic
}
```  

여기까지하면 HOST PC에서 USB로 부팅이 됨. 하지만 다른 PC에서 부팅안됨. 이유는
다른 PC에서는 USB가 grub에 지정한 /dev/sdc1으로 마운트 되지 않을 수도 있기때문이다.  
따라서 /dev/sdx의 절대경로를 지정하는게 아니라 UUID로 지정하면 이 문제를 해결할 수 있음.


``(찾아보기)`` initrd란?
> initrd란 램디스크를 의미한다.  
>  압축을 풀고 확인하면, 작은 파일시스템이 들어있다.  
initrd란 rd(ram disk)에 부팅에 필요한 커널이미지를 미리 설정해 놓고, 커널을
하드디스크가 아닌 initrd에서 읽어온 후, 그 이후에 하드디스크에서 필요한 모듈
등을 읽어오기 위해 사용, 주로 배포판의 기본 커널에서 쓰임, 각각의 컴퓨터마다
각기 다른 하드디스크 컨트롤러를 사용하고 있는데 이들 모두를 커널에 포함하기에는
용량이 너무 커너 initrd에 최소한의 것들만 갖춘 커널을 넣고, 커널이 부팅한
이후에 적절한 하드디스크 컨트롤러 드라이버를 읽도록 하기 위함임)
> 필요한 이유  
> 다음과 같은 상황에 필요  
> 1. SCSI 하드디스크 장치만 가지고 있다.  
> 2. 커널 이미지에는 SCSI 기능이 들어 있지 않다.  
> 3. SCSI 기능은 모듈로 처리되어 있다.  
> 커널이 부팅하면서 SCSI 하드 디스크를 읽어야 하는데, 커널에는 SCSI 기능이
> 들어있지 않다.  
> SCSI 기능이 없으므로(아직 올라오지 않음) SCSI 하드디스크를 읽을 수가 없다.  
>  그래서 패닉이 생긴다.  
> http://egloos.zum.com/gimgimal/v/1246071   
> http://icecreamie.tistory.com/m/post/13  


##### (7) USB의 UUID 설정하기.

모든 PC에서 부팅 가능해짐.

root=UUID= (16진수 주소)  
blkid 로 UUID확인  

- grub.cfg 수정.

```patch  
menuentry "GNU/Linux, Linux 3.19-lfs-7.7" {
-	        linux   /boot/vmlinuz-3.19-lfs-7.7 root=/dev/sdc1 ro
+	        linux   /boot/vmlinuz-3.19-lfs-7.7 root=UUID=c8124732-5693-4f0e-8dec-cff6508173df ro
		initrd 	/boot/initrd.img-3.8.0-42-generic
}
```  

- /etc/fstab 의 root파일 시스템의 mount point를 USB의 UUID로 수정   

```patch  
- /dev/sdb5      /            ext4     defaults            1     1
+ UUID=c8124732-5693-4f0e-8dec-cff6508173df      /	ext4     defaults 1     1
```  
> fstab은 부팅시 디폴트로 마운트할 파일시스템을 기술하는 파일이다.  
> 루트(/)파일 시스템은 USB자체를 마운트 하여 사용하므로 USB의 경로로 지정해줘야함.  
> /dev/sdx 로해도되지만 UUID로 변경  




      

### 9.6.4. 추가 확인해볼 사항들.  


``(찾아보기)`` grub.cfg 설정방법 찾아보기
http://www.normalesup.org/~george/comp/live_iso_usb/

``(참고)`` .img 파일 마운트하기.  
> 라즈비안 img를 받아서 마운트 해보기.  
> https://www.raspberrypi.org/downloads/  
> 참고 : http://www.meadhbh.org/mountraspianimages  
>   
> - __fdisk로 block 확인?__    
>   
>  # fdisk -l 2015-05-05-raspbian-wheezy.img   
>   
> ```  
> Disk 2015-05-05-raspbian-wheezy.img: 3276 MB, 3276800000 bytes  
> 255 heads, 63 sectors/track, 398 cylinders, total 6400000 sectors  
> Units = sectors of 1 * 512 = 512 bytes  
> Sector size (logical/physical): 512 bytes / 512 bytes  
> I/O size (minimum/optimal): 512 bytes / 512 bytes  
> Disk identifier: 0xa6202af7  
>   
> Device Boot      Start         End      Blocks   Id  System  
> 2015-05-05-raspbian-wheezy.img1            8192      122879       57344    c
> W95 FAT32 (LBA)  
> 2015-05-05-raspbian-wheezy.img2          122880     6399999     3138560   83
> Linux  
> ```  
>
> - __loop로 마운트__  
> 
> ```  
>  # mount 2015-05-05-raspbian-wheezy.img -o loop,offset=$((512 * 122880))
>  /mnt/rasp/
>  # mount 2015-05-05-raspbian-wheezy.img -o loop,offset=$((512 * 8192))
>  /mnt/rasp0/
> ```  
> 아래것이 /boot/에 있어야할 바이너리인듯.?  


``(참고)`` raspbian sd card에 설치하기.  

```sh
 $ fdisk 및 mkfs.ext4 이용 sd card포맷.
 $ dd bs=4M if=2015-05-05-raspbian-wheezy.img of=/dev/sdx
```
https://www.raspberrypi.org/documentation/installation/installing-images/linux.md  


``(찾아보기)``  /dev/sdc /dev/sdc1 의 차이는?  
https://www.google.co.kr/search?client=ubuntu&channel=fs&q=difrence+%2Fdev%2Fsdb+%2Fdev%2Fsdb1&ie=utf-8&oe=utf-8&gfe_rd=cr&ei=crDnVeGNJ-bC8AenvaCwBA  
  
  
``(찾아보기)``  spindle 라즈베리파이에서사용한 부팅시스템?    
http://asbradbury.org/projects/spindle/  


``(참고)`` pc 부팅 과정  
1. BIOS를 통해 부트로더 로딩  
2. GRUBbootloader를 통해 커널과 initrd를 램에 적재  
3. 커널 로딩후 initrd를 통해 root fileSystem을  읽기로  마운트  
4. init.rc/mountfs 스크립트를 통해 root fileSystem 읽기쓰기로 다시 마운트 (fstab 파일로딩 따라서 여기에 마운트 포지션도 변경이 필요)  
5. 초기화 과정 진행  

``(찾아보기)`` pc와 임베디드보드 bootloader차이  

``(참고)`` 부팅관련 참고 사이트  
libe CD 만들기. https://www.linux.co.kr/home/lecture/?leccode=113  
램디스크의 구현과 응용프로그램 실행  
http://webcache.googleusercontent.com/search?q=cache:7T2WBL5-1QgJ:cfile3.uf.tistory.com/attach/11250D3B4EC36C442FDFED+&cd=8&hl=ko&ct=clnk&gl=kr  

``(참고)`` initrd for LFS  
http://www.linuxfromscratch.org/hints/downloads/files/OLD/initrd.txt  



##  9.7 LFS 파일시스템 Ramdisk로 압축하여 부팅USB만들기.  

### 9.7.1 파일 시스템 램디스크로 압축하기  

```sh
$dd if=/dev/zero of=ramdisk bs=1k count=1048576
$mkfs.ext4 ramdisk 
$mkdir /mnt/mnt_ramdisk
$mount ramdisk /mnt/mnt_ramdisk
$cp -avp /bin /etc /lib /mnt /proc /run /srv /tmp /var /dev /home /lib64 /media /opt /root /sbin /sys /usr /mnt/mnt_ramdisk  
$umount ramdisk
$gzip ramdisk
```````````````````
``(참고)``  
복사하는 내용은 lfs 파일시스템 폴더.  
fstab 수정 필요 /dev/ram0 이 루트파일시스템 위치  
/dev 에 시스템 ram0을 복사해와야함  
``(찾아보기)`` dd명령어  
https://wiki.kldp.org/HOWTO/html/Adv-Bash-Scr-HOWTO/zeros.html

### 9.7.2 kernel 수정



- 커널 .config 수정 (1GB 램디스크를 지원하기 위해서)

```sh
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=1048576
```

``(참고)``menuconfig 이용 방법  
```sh
$# make menuconfig
Device Drivers --->
 'Block devices->' 선택
<*> RAM block device support 에서 space bar x 2
(16) Default number of RAM disks (NEW)
(1048576) Default RAM disk size (kbytes) (NEW)
```  

- 커널 빌드

```sh  
 $ make mrproper
 $ make menuconfig // 위 참고
 $ make
 $ cp -v arch/x86/boot/bzImage /mnt/USB/boot/vmlinuz-3.19-lfs-7.7
 $ cp -v System.map /boot/System.map-3.19
```  


### 9.7.3 grub.cfg 수정 및 부팅  

커널 이미지와 압축된 램디스크를 grub에 맞게 설정해줌  
```sh
/boot/vmlinuz-3.19-lfs-7.7 root=/dev/ram0 ro quiet splash  
initrd /boot/ramdisk.gz  
```  

### 9.7.4 fstab수정 

```patch  
- /dev/sdb5      /            ext4     defaults            1     1
+ /dev/ram0      /            ext4     defaults            1     1
```  

이후 부팅완료  
``$ free -h`` 로 memory확인  


``(참조사이트)``  
https://wiki.kldp.org/HOWTO/html/Bootdisk-HOWTO/buildroot.html (루트파일시스템제작)  
http://hulryung.tistory.com/204 (루트파일시스템)  
https://cms.kut.ac.kr/user/joo/IFC412/IFC412_09.pdf (ramdisk F/S 및 컴파일)   
http://egloos.zum.com/furmuwon/v/11145268 (initrd initramfs 차이점)  
http://www.iamroot.org/xe/QnA/60940 (initramfs)  
https://wiki.gentoo.org/wiki/GRUB2_Quick_Start/ko (grub2관련)
