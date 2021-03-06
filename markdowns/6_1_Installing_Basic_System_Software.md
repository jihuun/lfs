# 6. Installing Basic System Software (1)
  
<!-- toc -->
  

  
## 6.1. Introduction  
  
리눅스 시스템이 어떻게 동작하는가를 이해하는데 핵심요소는 바로  
각 패키지의 사용목적과 왜 필요한지를 이해하는 것이다.    
  
각 순서를 철처히 지켜야한다. 문제발생 소지가 줄어듬.    
  
그리고 앞으로는 lfs가 아닌 root 유저로 로그인해서 진행해야함.    
``(찾아보기)`` lfs 에서 sudo -s 하면 에러나고   
	jihuun계정에서sudo -s 하면 정상적으로 su로 계정 전환됨. 왜?    
  

> ``(주의)`` : 5장에서 /sources 에서 압축을 풀어 빌드했던 폴더는 모두 지우고 시작해야함.   
5장에서 만들었던 configure옵션과 6장에서 진행하는 configure옵션이 다르기때문에 빌드 혹은 test suite에서 실패하는 경우가 생기는듯.  

> 문제 발생시 아래에서 검색하면 자료많이 나옴.  
http://search.gmane.org/?query=msgunfmt-3&author=&group=gmane.linux.lfs.support&sort=relevance&DEFAULTOP=and&xP=fail%09msgunfmt%093&xFILTERS=Glinux.lfs.support---A   

  
  
## 6.2. Preparing Virtual Kernel File Systems  
  
파일시스템은 disk공간을 차지하지 않고 메모리에 상주한다.    
  
- __파일시스템이 마운트 될 디렉토리들을 생성.__  
  
```sh
 $ mkdir -pv $LFS/{dev,proc,sys,run}  
```
  
  
  
  
### 6.2.1. Creating Initial Device Nodes  
  
커널이 시스템을 부팅할때 몇몇 디바이스 노드가 필요하다.  
특히 console, null노드가 필요.   
이 디바이스노드는 반드시 하드디스크에 생성되어야한다. (udevd가 시작되기전에 필요)  
그리고 리눅스가 init=/bin/bash를 시작할때 필요  
``(찾아보기)`` udevd : /dev 의 디바이스파일 관리 데몬?    
  
- __mknod명령으로 디바이스 노드 생성__  

```sh
 $ mknod -m 600 $LFS/dev/console c 5 1  
 $ mknod -m 666 $LFS/dev/null c 1 3  
```
``(찾아보기)`` 디바이스 노드란? , 디바이스 파일과의 차이는?    
``(찾아보기)`` mknod 옵션 의미    
  
- ls 해보면 아래와 같이 나옴.    

```sh
root@jihuun:/mnt/lfs/dev# ls -al  
crw------- 1 root root 5, 1  7월 31 13:51 console  
crw-rw-rw- 1 root root 1, 3  7월 31 13:51 null  
```
  
  
  
  
### 6.2.2. Mounting and Populating /dev  
  
  
일반적으로 부팅중 Udev에 의해 디바이스가 생성되지만,    
 아직 Udev를 설치하지도 않았고 부팅도 안했으니, 수동으로 /dev에 마운트 시켜야 한다.  
 `  
HOST시스템의 /dev 디렉토리에 bind 마운팅을 함으로써 수행 가능하다.  
bind마운팅은 다른 마운트 포인트의 미러를 생성한다.   
  
``(찾아보기)`` bind mounting 이란?  
> mount --bind olddir newdir    
특정 디렉토리 내용을 미러링할 수 있음.  
olddir를 newdir에서도 볼수 있게 해줌.  
한쪽에서 변경한것은 다른한쪽도 같이 변경됨.  
[mount --bind 옵션](http://egloos.zum.com/studyfoss/v/5262292)  
  
- __$LFS/dev에 /dev를 미러링__    

```sh
 $ mount -v --bind /dev $LFS/dev  
```
> 근데 ls $LFS/dev 했을때 바로 /dev 의 내용이 안보이고  
터미널을 새로 열어야 보임.  
  
> ``(주의)`` : 터미널을 새로 열었다면 export LFS=/mnt/lfs 다시해줘야함.  
> echo $LFS 가 있는지 항상 확인 필요.  
  
  
> ``(주의)`` : 나중에 6장 빌드하다가 꼬일때 /dev/sdb5 를 다지우고 다시 시작하고자 할때,    
/dev/sdb5가 mount된 /mnt/lfs/의 내용을 rm -rf * 해버리면 큰 문제가 발생한다.    
/mnt/lfs/dev/가 호스트 시스템의/dev로 바운드 마운팅 되어있기때문에 호스트 시스템 자체가 망가짐.  
/dev/ 밑에 아무것도 없는 시스템이 되어버림.    
그러나 다행이도 재부팅시 udev가 /dev 를 다시 채우는지 문제가 없어짐.  
  
  
  
  
  
### 6.2.3. Mounting Virtual Kernel File Systems  
  
- __나머지 가상 파일시스템 마운트__  

```sh
 $ mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620  
 $ mount -vt proc proc $LFS/proc  
 $ mount -vt sysfs sysfs $LFS/sys  
 $ mount -vt tmpfs tmpfs $LFS/run  
```
> mode=620 and gid=5 makes "mesg y" the default on newly created PTYs  
> HOST시스템의 /sys /proc /dev/pts가  $LFS/ 아래에 똑같이 마운트됨.  
/run은 다르게 마운트되어있음.  
  
> ``(찾아보기)`` devpts, proc, sysfs, tmpfs 각 가상 파일시스템의 역할?  
  
- 현재 lfs관련 mount 된 내용들.  

```sh
 $ mount  
/dev/sdb5 on /mnt/lfs type ext4 (rw)  
/dev on /mnt/lfs/dev type none (rw,bind)  
/dev on /mnt/lfs/dev type none (rw,bind)  <- 실수로 두번함  
devpts on /mnt/lfs/dev/pts type devpts (rw,gid=5,mode=620)  
proc on /mnt/lfs/proc type proc (rw)  
sysfs on /mnt/lfs/sys type sysfs (rw)  
tmpfs on /mnt/lfs/run type tmpfs (rw)  
```
  
  
In some host systems, /dev/shm is a symbolic link to /run/shm. The /run tmpfs  
was mounted above so in this case only a directory needs to be created.  
  
- __$LFS/dev/shm 생성__  

```sh
 $ if [ -h $LFS/dev/shm ]; then  
 $ 	mkdir -pv $LFS/$(readlink $LFS/dev/shm)  
 $ fi  
```
HOST 시스템에는 /dev/shm -> /run/shm/ 심볼릭 링크되어있음.    
  
  
  
  
  
  
  
## 6.3. Package Management  
  
LFS에서는 패키지 관리자를 설치하지 않는다.  
아래 참고.  
http://linuxfromscratch.org/lfs/view/stable/chapter06/pkgmgt.html  
  
This approach is used by most of the package managers found in the commercial  
distributions. Examples of package managers that follow this approach are RPM  
(which, incidentally, is required by the Linux Standard Base Specification),  
pkg-utils, Debian's apt, and Gentoo's Portage system. A hint describing how to  
adopt this style of package management for LFS systems is located at  
http://www.linuxfromscratch.org/hints/downloads/files/fakeroot.txt.  
  
  
  
## 6.4. Entering the Chroot Environment  
  
  
## 6.4. Entering the Chroot Environment  
  
이제 본격적으로 최종 LFS빌드, 설치 시작하기 위해 change root를 함.  
  
It is time to enter the chroot environment to begin building and installing the  
final LFS system. As user root, run the following command to enter the realm  
that is, at the moment, populated with only the temporary tools:  
  
- __루트계정으로 chroot 명령 실행__    

```sh
 $ chroot "$LFS" /tools/bin/env -i		\  
	HOME=/root                  \  
	TERM="$TERM"                \  
	PS1='\u:\w\$ '              \  
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \  
	/tools/bin/bash --login +h  
```
> ``(옵션)``    
chroot [OPTION] NEWROOT [COMMAND [ARG]...]    
"$LFS" : chroot이후에 $LFS/ 가 이제 / 디렉토리가 됨.(따라서 더이상 $LFS도 필요없음)    
/tools/bin/env -i : /tools에 새로 설치한 env명령로 -i 와함께 환경변수 초기화.    
env -i /tools/bin/bash : 지정한 환경변수로 bash다시 실행.    
--login +h :  로그인쉘   
  
(주의)  
만약 재부팅 했으면 6장 처음부터 여기까지 다시하면됨.    
mount 등 6.2.2.장  6.2.3.장 참고    
  
  
  
  
## 6.5. Creating Directories  
  
LFS의 파일시스템 생성하기.  
- __Unix 표준 디렉토리 구조로 생성__  

```sh
 $ mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}  
 $ mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}  
 $ install -dv -m 0750 /root  
 $ install -dv -m 1777 /tmp /var/tmp  
 $ mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}  
 $ mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}  
 $ mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}  
 $ mkdir -v  /usr/libexec  
 $ mkdir -pv /usr/{,local/}share/man/man{1..8}  

 $ case $(uname -m) in  
 $  x86_64) ln -sv lib /lib64  
 $          ln -sv lib /usr/lib64  
 $          ln -sv lib /usr/local/lib64 ;;  
 $ esac  

 $ mkdir -v /var/{log,mail,spool}  
 $ ln -sv /run /var/run  
 $ ln -sv /run/lock /var/lock  
 $ mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}  
```
[Filesystem Hierarchy Standard (FHS) 참고](https://wiki.linuxfoundation.org/en/FHS)    
  
  
  
  
  
  
## 6.6. Creating Essential Files and Symlinks  
  
  
- 몇몇 유틸리티 심볼릭 링크 생성  

```sh
 $ ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin  
 $ ln -sv /tools/bin/perl /usr/bin  
 $ ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib  
 $ ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib  
 $ sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la  
 $ ln -sv bash /bin/sh  
```
몇몇 유틸리티에서 /bin/bash 이런식으로 hard-coding 되어있어서 심볼릭 링크 걸어줘야함.  
  
  
- __/etc/mtab 으로 파일시스템 마운트 지정__  

```sh
 $ ln -sv /proc/self/mounts /etc/mtab  
```
fstab 같은 역할일듯.  
  
``(찾아보기)`` mtab fstab 차이와 그 내용의 의미.  
  
  
- /etc/etc/passwd 와 /etc/group 이 있어야 이름 생성됨.    
프롬프트에 I have no name! 뜨는거 해결하려면    
  
- __/etc/passwd 생성__  

```sh
 $ cat > /etc/passwd << "EOF"  
 $ root:x:0:0:root:/root:/bin/bash  
 $ bin:x:1:1:bin:/dev/null:/bin/false  
 $ daemon:x:6:6:Daemon User:/dev/null:/bin/false  
 $ messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false  
 $ nobody:x:99:99:Unprivileged User:/dev/null:/bin/false  
 $ EOF  
```
login시 이름을 이 파일에서 읽어옴.  
실제 passwd는 나중에 설정함.    
  
- __/etc/group 생성__  

```sh
 $ cat > /etc/group << "EOF"  
root:x:0:  
bin:x:1:daemon  
sys:x:2:  
kmem:x:3:  
tape:x:4:  
tty:x:5:  
daemon:x:6:  
floppy:x:7:  
disk:x:8:  
lp:x:9:  
dialout:x:10:  
audio:x:11:  
video:x:12:  
utmp:x:13:  
usb:x:14:  
cdrom:x:15:  
adm:x:16:  
messagebus:x:18:  
systemd-journal:x:23:  
input:x:24:  
mail:x:34:  
nogroup:x:99:  
users:x:999:  
EOF  
```
> 생성된 그룹들은 표준은 아님.    
이번챕터의 Udev configuration을 위한 생성임.    
  
``(찾아보기)`` /etc/etc/passwd 와 /etc/group 의 목적과 파일내용의 의미.    
  
  
To remove the “I have no name!” prompt, start a new shell. Since a full Glibc  
was installed in Chapter 5 and the /etc/passwd and /etc/group files have been  
created, user name and group name resolution will now work:  
  
- __프롬프트에 "I have no name!" 제거__    

```sh
 $ exec /tools/bin/bash --login +h    
```
> ``(찾아보기)`` bash가 새로 로그인할때  /etc/etc/passwd 와 /etc/group 참조 하는듯?    
  
  
  
  
- __log 파일 생성__    

```sh
 $ touch /var/log/{btmp,lastlog,wtmp}  
 $ chgrp -v utmp /var/log/lastlog  
 $ chmod -v 664  /var/log/lastlog  
 $ chmod -v 600  /var/log/btmp  
```
> login, agetty, init 프로그램등리  log파일을 사용함.  
  
  
  
  
  
  
  
  
  
## 6.7. Linux-3.19 API Headers  
다음 파일로  ..
  
  
  
