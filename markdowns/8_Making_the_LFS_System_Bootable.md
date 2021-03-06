# 8. Making the LFS System Bootable

<!-- toc -->

    
    
    
## 8.1. Introduction  
  
이번장에서 LFS시스템을 부팅가능하게 만든다.  
fstab파일을 만들고, kernel을 빌드 할 것이다.  
그리고 GRUB부트로더를 설치할것이다. 그러면 부팅시에 LFS system을 선택하여 부팅할 수 있을것.  
  
  
  
  
  
    
    
## 8.2. Creating the /etc/fstab File  
  
파일시스템을 기본으로 마운트 시키기 위해서 /etc/fstab파일을 이용한다.  
(지난 장에서는 mount 명령어로 일일이 했었음.)  
  
  
- __/etc/fstab파일 생성__    
  
```sh  
## Begin /etc/fstab  
  
## file system  mount-point  type     options             dump  fsck  
##                                                              order  
  
/dev/sdb5      /            ext4     defaults            1     1  
proc           /proc        proc     nosuid,noexec,nodev 0     0  
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0  
devpts         /dev/pts     devpts   gid=5,mode=620      0     0  
tmpfs          /run         tmpfs    defaults            0     0  
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0  
  
## End /etc/fstab  
```  
> 원래는 아래 줄도 있는데 swap 파티션 안만들어서 제거함.  
> /dev/<yyy>     swap         swap     pri=1               0     0  
  
  
  
  
  
  
  
    
    
## 8.3. Linux-3.19  
  
드디어 리눅스 커널 빌드.  
  
  
    
### 8.3.1. Installation of the kernel  
  
커널 컴파일하기.  
  
  
- __커널 소스 clean__    
  
```sh  
 $ make mrproper  
```  
  
  
- __menuconfig할 엄두가 안나서 defconfig함__    
  
```sh  
 $ make defconfig  
```  
> 나중에 커널 컴파일 제대로 다시해보기.  
> .config생성됨  
  
  
- ____    
  
```sh  
 $ make  
```  
>   
아래와같은 식으로 output  
```  
....  
Setup is 15692 bytes (padded to 15872 bytes).  
System is 5797 kB  
CRC 6bd48724  
Kernel: arch/x86/boot/bzImage is ready  (#1)  
Building modules, stage 2.  
MODPOST 16 modules  
....  
```  
bzImage생성됨.   
  
  
- __Install the modules, if the kernel configuration uses them__    
  
```sh  
make modules_install  
```  
  
  
- __bzImage를 /boot/로 복사__    
  
```sh  
cp -v arch/x86/boot/bzImage /boot/vmlinuz-3.19-lfs-7.7  
```  
  
  
  
- __System.map /boot/로 복사__    
  
```sh  
cp -v System.map /boot/System.map-3.19  
```  
The kernel configuration file .config produced by the make menuconfig step above contains all the configuration selections for the kernel that was just compiled. It is a good idea to keep this file for future reference:  
  
- __.config 백업__    
  
```sh  
cp -v .config /boot/config-3.19  
```  
  
  
- __Install the documentation for the Linux kernel:__    
  
```sh  
install -d /usr/share/doc/linux-3.19  
cp -r Documentation/* /usr/share/doc/linux-3.19  
```  
  
  
  
  
  
    
### 8.3.2. Configuring Linux Module Load Order  
  
/etc/modprobe.d/안에 있는 설정파일을 수정하여 모듈을 순서대로 로드할수 있음.  
이 순서를 잘 조정하면 원하는 순서대로 모듈을 로드할 수 있음.  
  
- __/etc/modprobe.d/usb.conf 생성__    
  
```sh  
install -v -m755 -d /etc/modprobe.d  
cat > /etc/modprobe.d/usb.conf << "EOF"  
## Begin /etc/modprobe.d/usb.conf  
  
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true  
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true  
  
## End /etc/modprobe.d/usb.conf  
EOF   
```  
  
  
  
  
  
    
    
## 8.4. Using GRUB to Set Up the Boot Process  
  
LFS대로 grub을 따라했다간 grub 을 새로 설치하기 때문에  컴퓨터가 날라갈지도 모른다.  
기존 HOST시스템 grub 에 LFS 메뉴를 추가하기로 한다.  
  
  
  
> ```  
> grub 버전 체크   
> grub-install --version  
> ```  
>   
> /etc/default/grub 에서  
> ```  
> GRUB_DEFAULT=0  // 숫자갯수가 메뉴갯수  
> ```  
>   
>   
> ```  
> 7 GRUB_HIDDEN_TIMEOUT=0  
> 8 GRUB_HIDDEN_TIMEOUT_QUIET=true  
> ```  
> 이걸  
>   
> ```  
> 7 #GRUB_HIDDEN_TIMEOUT=0  
> 8 GRUB_HIDDEN_TIMEOUT_QUIET=false  
> ```  
> 이렇게 바꿔줘야 메뉴가 보이는듯.?  
  
  
그냥  위에꺼 안하고  
- ____    
  
```sh  
 $ sudo update-grub  
```  
했더니. 자동으로 unkown으로 /dev/sdb5에 LFS가 잡힘?  읭?  
/etc/grub.d/30_os-prober 에서 알아서 한듯.  
   
  
이제 재부팅하면 Grub에서 메뉴에 나옴.  
  
  
``(참고)`` host 우분투에서 grub 수정하기  
http://egloos.zum.com/nemonein/v/4722068  
http://skylit.tistory.com/87  
  
  
  
  
  
  
  
  
  
  
  
