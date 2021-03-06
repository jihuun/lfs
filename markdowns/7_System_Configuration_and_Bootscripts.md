# 7. System Configuration and Bootscripts

  
<!-- toc -->
  
  
  
  
  
  
## 7.1. Introduction    
  
리눅스 시스템을 부팅하는 것은 몇몇 과정이 더 필요하다.    
프로세스가 파일시스템과 가상파일시스템에 마운트 되야함.    
  
> 디바이스 초기화    
> swap 활성화    
> swap 파티션과 파일 마운트    
> 시스템 클럭 설정    
> 네트워크 설정    
> 시스템에서 요구하는 데몬 실행    
> 유져가 필요한 custom 작업들 수행.    
  
이 과정은 정확한 순서로 수행되어야한다. 그리고 동시에 빠르게 실행되어야한다.    
  
  
  
  
  
### 7.1.1. System V    
   
System V는 Unix시스템에서 전통적으로 사용하는 부트 프로세스이다.     
init프로그램을 사용하고 login(getty)같은 기본 프로그램을 설치한다.      
그리고 필요한 스크립트를 실행한다. 이 스크립트는 rc라는 이름이 붙어있으며    
시스템이 초기화되는데 필요한 일련의 작업들이 실행된다.    
이 init프로그램은 /etc/inittab 파일에 기술되어진 내용으로 컨트롤되며      
이 파일에는 runlevel이 기술되어있다.    
  
> 0 — halt    
> 1 — Single user mode    
> 2 — Multiuser, without networking    
> 3 — Full multiuser mode    
> 4 — User definable    
> 5 — Full multiuser mode with display manager    
> 6 — reboot    
디폴트 run level은 3 또는 5.    
  
- System V의 장점    
이해하기 쉽다. 커스터마이징 하기 쉽다.    
    
- System V의 단점    
부팅이 느리다. 순차적 프로세싱(딜레이가많음).     
스크립트를 추가하는데 매뉴얼이 필요.      
(Adding scripts requires manual, static sequencing decisions.)    
  
  
  
  
  
``(참고)`` debian 부트프로세스 참고.    
> https://www.debian.org/doc/manuals/debian-reference/ch03.en.html    
    
  
  
  
``(참고)`` /etc/init.d/ 에 부팅시 실행될 스크립트가 존재하고 그게 /etc/rc0.d/ ~ etc/rcS.d/ 밑에 심볼릭 링크 되어있음.    
> 심볼릭링크되는 이름은 K숫자 혹은 S숫자 이런식으로 변경됨.    
> lfs에서는 /etc/rc.d/rc0.d/ 이런식으로 경로가 되어있음.    
  
  
``(참고)`` rcS.d/ 와  rc0.d/의 차이?    
> rcS.d/는  Boot-time system configuration/initialization script  인듯?    
  
  
``(참고)`` 리눅스 부팅관련 참고글      
> [리눅스 부팅과정 이해](https://www.linux.co.kr/home/lecture/?leccode=10256)      
> [리눅스 -run-level이해](http://haerakai.tistory.com/3)      
init이 /etc/inittab 을 읽음.     
  
  
  
  
``(참고)`` 우분투는 sysvinit 을 사용하지 않음. upstart사용(?) /etc/inittab없음.      
> systemd사용    
> /etc/inittab 파일 자체는 아예 없어져 버렸고,      
> 설정 파일들은 /etc/init 디렉토리 아래에 아래와 같은 여러개의 파일로 나뉘어 존재 한다.    
> (upstart-udev-bridge.conf , rc-sysinit.conf, rc.conf, rcS.conf, control-alt-delete.conf, tty1.conf)    
> http://forum.falinux.com/zbxe/index.php?document_srl=533108&mid=lecture_tip     
> http://egloos.zum.com/mcchae/v/11179204    
  
  
``(참고)`` systemd 란?    
init 대체, inetd대체(crond,ard,syslog,watchd대체), udev대체    
http://clien.net/cs2/bbs/board.php?bo_table=cm_linux&wr_id=7662&sca=%5BOpen+source%5D    
  
  
  
  
``(참고)`` inittab 규칙    
> id:runlevels:action:process     
> 7.6.2.장에서 만들것임.    
  
  
  
  
  
  
## 7.2. LFS-Bootscripts-20150222  
  
/sources/lfs-bootscripts-20150222/ 에는 LFS시스템이 부팅/종료될때 필요한 스크립트들이 구성되어있으며    
Makefile 은 그 스크립트를 적절히 배치하는 역할을 한다.     
  
  
  
  
### 7.2.1. Installation of LFS-Bootscripts  
  
- __LFS-부트스크립트 설치__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
### 7.2.2. Contents of LFS-Bootscripts  
  
- 설치 경로  
> /etc/rc.d   
> /etc/init.d (symbolic link)   
> /etc/sysconfig   
> /lib/services   
> /lib/lsb (symbolic link)  
  
  
  
- 설치되는 스크립트    
> 아래스크립트는 LFS를 위해서 만들어진 부트스크립트임.    
> ``checkfs``        
> 파일시스템이 마운트되기 전에 파일시스템이 무결한지 확인.    
> ``cleanfs``      
> reboots, fastboot, forcefsck 파일사이에서 유지 되어서는 안되는 파일을 제거.     
> ``console``      
원하는 키보드 레이아웃을 위한 적절한 keymap 테이블을 load, 스크린 font도 설정.     
> ``functions``      
> Contains common functions, such as error and status checking, that are used by several bootscripts      
> ``halt``      
> 시스템 중단.      
> ``ifdown``      
> 네트워크 디바이스 중단.     
> ``ifup``      
> 네트워크 디바이스 초기화.     
> ``localnet``      
> 시스템의 hostname과 로컬 loopback 디바이스를 설정.    
> ``modules``      
> /etc/sysconfig/modules에 존재하는 커널 모듈 load. (거기에 같이있는 매개변수 이용)    
> ``mountfs``      
> 모든 파일시스템 마운트 (noauto또는 network기반은 제외)    
> ``mountvirtfs``      
> proc같은 커널의 가상파일시스템 마운트    
> ``network``      
> 네트워크 인터페이스 설정(예를들어 네트워크 카드, 디폴트 gateway)    
> ``rc``      
> 마스터 run-level 컨트롤 스크립트.      
> 모든 다른 부트스크립트를 하나하나 실행함. 이 순서는 심볼릭 링크의 이름으로 정해짐.(S~ 혹은 K~)    
> ``reboot``      
> 시스템 재부팅    
> ``sendsignals``      
> 시스템이 재부팅되거나 halt되기전에 모든 프로세스가 종료되었는지 확인.    
> ``setclock``      
> HW clock이 UTC time으로 설정되지 않았을때 커널 clock을 로컬 time으로 설정.    
> ``ipv4-static``      
> IP 주소 할당.    
> ``swap``      
> swap 파일과 파티션을 enable/disable    
> ``sysctl``      
> /etc/sysctl.conf에서 시스템 설정값을 로딩함. (커널에 그 파일이 있다는 가정하에)    
> ``sysklogd``      
> 시스템 커널로그 데몬 실행/종료    
> ``template``      
> 다른 데몬을 위해 커스텀 부트스크립트 생성을위한 탬플릿.    
> ``udev``      
> /dev 디렉토리를 준비하고 Udev를 실행.    
> ``udev_retry``      
> udev uevents가 실패했을때 재 시도,       
> 필요하다면 rule사본을 생성( /run/udev 으로부터 /etc/udev/rules 로)    
    
    
    
    
  
  
- ``(참고)`` __lfs 부트스트립트 Makefile일부__    
> 파일위치 /sources/lfs-bootscripts-20150222/Makefile    
> /etc/init.d/의 어떤 스크립트가 어떤 run-level로 지정되었는지 알수 있음.    
>  
> ```makefile  
>  rcS: files  
>  	ln -sf ../init.d/mountvirtfs ${ETCDIR}/rc.d/rcS.d/S00mountvirtfs  
>  	ln -sf ../init.d/modules     ${ETCDIR}/rc.d/rcS.d/S05modules  
>  	ln -sf ../init.d/localnet    ${ETCDIR}/rc.d/rcS.d/S08localnet  
>  	ln -sf ../init.d/udev        ${ETCDIR}/rc.d/rcS.d/S10udev  
>  	ln -sf ../init.d/swap        ${ETCDIR}/rc.d/rcS.d/S20swap  
>  	ln -sf ../init.d/checkfs     ${ETCDIR}/rc.d/rcS.d/S30checkfs  
>  	ln -sf ../init.d/mountfs     ${ETCDIR}/rc.d/rcS.d/S40mountfs  
>  	ln -sf ../init.d/cleanfs     ${ETCDIR}/rc.d/rcS.d/S45cleanfs  
>  	ln -sf ../init.d/udev_retry  ${ETCDIR}/rc.d/rcS.d/S50udev_retry  
>  	ln -sf ../init.d/console     ${ETCDIR}/rc.d/rcS.d/S70console  
>  	ln -sf ../init.d/sysctl      ${ETCDIR}/rc.d/rcS.d/S90sysctl  
>    
>  rc0: files  
>  	ln -sf ../init.d/network     ${ETCDIR}/rc.d/rc0.d/K80network  
>  	ln -sf ../init.d/sysklogd    ${ETCDIR}/rc.d/rc0.d/K90sysklogd  
>  	ln -sf ../init.d/sendsignals ${ETCDIR}/rc.d/rc0.d/S60sendsignals  
>  	ln -sf ../init.d/swap        ${ETCDIR}/rc.d/rc0.d/S65swap  
>  	ln -sf ../init.d/mountfs     ${ETCDIR}/rc.d/rc0.d/S70mountfs  
>  	ln -sf ../init.d/localnet    ${ETCDIR}/rc.d/rc0.d/S90localnet  
>  	ln -sf ../init.d/halt        ${ETCDIR}/rc.d/rc0.d/S99halt  
>    
>  rc1: files  
>  	ln -sf ../init.d/network     ${ETCDIR}/rc.d/rc1.d/K80network  
>  	ln -sf ../init.d/sysklogd    ${ETCDIR}/rc.d/rc1.d/K90sysklogd  
>    
>  rc2: files  
>  	ln -sf ../init.d/network     ${ETCDIR}/rc.d/rc2.d/K80network  
>  	ln -sf ../init.d/sysklogd    ${ETCDIR}/rc.d/rc2.d/K90sysklogd  
>    
>  rc3: files  
>  	ln -sf ../init.d/sysklogd    ${ETCDIR}/rc.d/rc3.d/S10sysklogd  
>  	ln -sf ../init.d/network     ${ETCDIR}/rc.d/rc3.d/S20network  
>    
>  rc4: files  
>  	ln -sf ../init.d/sysklogd    ${ETCDIR}/rc.d/rc4.d/S10sysklogd  
>  	ln -sf ../init.d/network     ${ETCDIR}/rc.d/rc4.d/S20network  
>    
>  rc5: files  
>  	ln -sf ../init.d/sysklogd    ${ETCDIR}/rc.d/rc5.d/S10sysklogd  
>  	ln -sf ../init.d/network     ${ETCDIR}/rc.d/rc5.d/S20network  
>    
>  rc6: files  
>  	ln -sf ../init.d/network     ${ETCDIR}/rc.d/rc6.d/K80network  
>  	ln -sf ../init.d/sysklogd    ${ETCDIR}/rc.d/rc6.d/K90sysklogd  
>  	ln -sf ../init.d/sendsignals ${ETCDIR}/rc.d/rc6.d/S60sendsignals  
>  	ln -sf ../init.d/swap        ${ETCDIR}/rc.d/rc6.d/S65swap  
>  	ln -sf ../init.d/mountfs     ${ETCDIR}/rc.d/rc6.d/S70mountfs  
>  	ln -sf ../init.d/localnet    ${ETCDIR}/rc.d/rc6.d/S90localnet  
>  	ln -sf ../init.d/reboot      ${ETCDIR}/rc.d/rc6.d/S99reboot  
>    
> ```  
  
  
- ``(참고)`` __make install의 출력 로그는 아래와 같음.__    
>   
> ```sh  
> root:/sources/lfs-bootscripts-20150222# make install  
> install -d -m 755  /etc/rc.d/rc0.d  
> install -d -m 755  /etc/rc.d/rc1.d  
> install -d -m 755  /etc/rc.d/rc2.d  
> install -d -m 755  /etc/rc.d/rc3.d  
> install -d -m 755  /etc/rc.d/rc4.d  
> install -d -m 755  /etc/rc.d/rc5.d  
> install -d -m 755  /etc/rc.d/rc6.d  
> install -d -m 755  /etc/rc.d/rcS.d  
> install -d -m 755  /etc/rc.d/init.d  
> install -d -m 755  /etc/sysconfig  
> install -d -m 755  /lib  
> install -d -m 755  /lib/services  
> install -d -m 755  /usr/share/man/man8  
> install -d -m 755  /sbin  
> ln -sfn       services    /lib/lsb  
> ln -sfn       rc.d/init.d /etc/init.d  
> install -m 754 lfs/init.d/checkfs       /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/cleanfs       /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/halt          /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/console       /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/localnet      /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/modules       /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/mountfs       /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/mountvirtfs   /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/network       /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/rc            /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/reboot        /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/sendsignals   /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/setclock      /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/swap          /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/sysctl        /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/sysklogd      /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/template      /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/udev          /etc/rc.d/init.d/  
> install -m 754 lfs/init.d/udev_retry    /etc/rc.d/init.d/  
> install -m 754 lfs/sbin/ifup            /sbin  
> install -m 754 lfs/sbin/ifdown          /sbin  
> install -m 644 lfs/sbin/ifup.8      /usr/share/man/man8  
> ln -sf  ifup.8                              /usr/share/man/man8/ifdown.8  
> install -m 754     lfs/lib/services/ipv4-static-route  /lib/services  
> install -m 754     lfs/lib/services/ipv4-static        /lib/services  
> install -m 644 lfs/lib/services/init-functions     /lib/services  
> if [ ! -f /etc/sysconfig/createfiles ]; then \  
> 	install -m 644 lfs/sysconfig/createfiles /etc/sysconfig/ ;\  
> fi  
> if [ ! -f /etc/sysconfig/modules     ]; then \  
> 	install -m 644 lfs/sysconfig/modules     /etc/sysconfig/ ;\  
> fi  
> if [ ! -f /etc/sysconfig/udev_retry  ]; then \  
> 	install -m 644 lfs/sysconfig/udev_retry  /etc/sysconfig/ ;\  
> fi  
> if [ ! -f /etc/sysconfig/rc.site     ]; then \  
> 	install -m 644 lfs/sysconfig/rc.site     /etc/sysconfig/ ;\  
> fi  
> ln -sf ../init.d/mountvirtfs /etc/rc.d/rcS.d/S00mountvirtfs  
> ln -sf ../init.d/modules     /etc/rc.d/rcS.d/S05modules  
> ln -sf ../init.d/localnet    /etc/rc.d/rcS.d/S08localnet  
> ln -sf ../init.d/udev        /etc/rc.d/rcS.d/S10udev  
> ln -sf ../init.d/swap        /etc/rc.d/rcS.d/S20swap  
> ln -sf ../init.d/checkfs     /etc/rc.d/rcS.d/S30checkfs  
> ln -sf ../init.d/mountfs     /etc/rc.d/rcS.d/S40mountfs  
> ln -sf ../init.d/cleanfs     /etc/rc.d/rcS.d/S45cleanfs  
> ln -sf ../init.d/udev_retry  /etc/rc.d/rcS.d/S50udev_retry  
> ln -sf ../init.d/console     /etc/rc.d/rcS.d/S70console  
> ln -sf ../init.d/sysctl      /etc/rc.d/rcS.d/S90sysctl  
> ln -sf ../init.d/network     /etc/rc.d/rc0.d/K80network  
> ln -sf ../init.d/sysklogd    /etc/rc.d/rc0.d/K90sysklogd  
> ln -sf ../init.d/sendsignals /etc/rc.d/rc0.d/S60sendsignals  
> ln -sf ../init.d/swap        /etc/rc.d/rc0.d/S65swap  
> ln -sf ../init.d/mountfs     /etc/rc.d/rc0.d/S70mountfs  
> ln -sf ../init.d/localnet    /etc/rc.d/rc0.d/S90localnet  
> ln -sf ../init.d/halt        /etc/rc.d/rc0.d/S99halt  
> ln -sf ../init.d/network     /etc/rc.d/rc1.d/K80network  
> ln -sf ../init.d/sysklogd    /etc/rc.d/rc1.d/K90sysklogd  
> ln -sf ../init.d/network     /etc/rc.d/rc2.d/K80network  
> ln -sf ../init.d/sysklogd    /etc/rc.d/rc2.d/K90sysklogd  
> ln -sf ../init.d/sysklogd    /etc/rc.d/rc3.d/S10sysklogd  
> ln -sf ../init.d/network     /etc/rc.d/rc3.d/S20network  
> ln -sf ../init.d/sysklogd    /etc/rc.d/rc4.d/S10sysklogd  
> ln -sf ../init.d/network     /etc/rc.d/rc4.d/S20network  
> ln -sf ../init.d/sysklogd    /etc/rc.d/rc5.d/S10sysklogd  
> ln -sf ../init.d/network     /etc/rc.d/rc5.d/S20network  
> ln -sf ../init.d/network     /etc/rc.d/rc6.d/K80network  
> ln -sf ../init.d/sysklogd    /etc/rc.d/rc6.d/K90sysklogd  
> ln -sf ../init.d/sendsignals /etc/rc.d/rc6.d/S60sendsignals  
> ln -sf ../init.d/swap        /etc/rc.d/rc6.d/S65swap  
> ln -sf ../init.d/mountfs     /etc/rc.d/rc6.d/S70mountfs  
> ln -sf ../init.d/localnet    /etc/rc.d/rc6.d/S90localnet  
> ln -sf ../init.d/reboot      /etc/rc.d/rc6.d/S99reboot  
> ```  
  
  
  
``(참고)`` install 과  cp의 차이점?    
> 둘다 복사하는 유틸리티.    
> install 은 dest파일을 먼저 지우고 복사.    
> cp는 overwrite하는 듯.    
> 보통 install은 Makefile에서 많이 사용함.    
  
  
  
  
  
  
## 7.3. Overview of Device and Module Handling  
  
chap.6에서 udev를 설치했다. udev가 어떻게 동작하는지 확인하기 전에  
과거에 device를 어떻게 handling했는지 역사를 살펴본다.    
  
리눅스 시스템에서는 전통적으로 정적 디바이스 생성 방법을 사용했었다.     
예전에는 MAKEDEV라는 스크립트를 사용했는데 mknod프로그램을 이용해서, 실제 HW 디바이스가 존재하는지 여부는 관계없이 수많은 node를 /dev 밑에 만들었다.    
  
그러나 Udev를 이용하면서, 커널이 찾은 존재하는 device만을위한 node를 생성할 수 있게 되었다.    
그 node들은 devtmpfs파일시스템에 저장된다.    
그래서 메모리공간을 더 절약할 수가 있게되었다.    
  
  
  
### 7.3.1. History  
  
2000년 2월에 devfs 파일시스템이 2.3.46 kernel에 반영되었고 2.4 stable kernel에서 이용가능하게 되었다.  
그러나 커널 소스에 존재함에도 불구하고 커널의 코어개발자들에 의해 서포트되지 않았다.  
Race condition등 여러 문제로 2006년 6월에 커널에서 완전히 제거되었다.    
이것은 2.6 stable kernel부터 sysfs 파일시스템으로 대체되었다.    
  
  
### 7.3.2. Udev Implementation  
  
  
#### 7.3.2.1. Sysfs  
드라이버가 커널에 컴파일되어 빌트인될때는 커널에 의해 감지되면 sysfs(내부적으로는 devtmpfs 사용)에 등록한다.   
드라이버가 모듈로 컴파일되면 모듈이 로딩될때 sysfs에 등록.  
sysfs가 마운트되면 (/sys) sysfs로 레지스터한 드라이버는 userspace에서 접근가능하다.  
  
  
#### 7.3.2.2. Device Node Creation  
  
디바이스파일은 devtmpfs 파일시스템에 의해서 생성된다. 어떠한 드라이버라도 디바이스 노드로 등록하기위해서는 devtmpfs를 통해야한다. devtmpfs 인스턴스가 /dev에 마운트 될때, 디바이스 노드가 이름,퍼미션,소유권을 변경하면서 생성된다.  
  
그 뒤, 커널은 uevent를 udev데몬(udevd)에 날린다.   
/etc/udev/rules.d, /lib/udev/rules.d, 그리고 /run/udev/rules.d 경로에 기술된 rule을 기반으로  
udevd는 디바이스 노드에대한 새로운 심볼릭링크를 생성한다. 퍼미션, 소유권, 그룹, 내부, udevd DB 등을 변경.  
  
이 세가지 경로는 함께 병합된다.   
  
  
#### 7.3.2.3. Module Loading  
  
  
  
#### 7.3.2.4. Handling Hotpluggable/Dynamic Devices  
  
  
  
### 7.3.3. Problems with Loading Modules and Creating Devices  
  
디바이스 노드를 자동으로생성하는것은 몇가지 문제가 발생할 수 있다.   
  
  
  
#### 7.3.3.1. A kernel module is not loaded automatically  
  
sys/bus/ 에 modalias 파일이 있어야만 드라이버가  udev의 도움을 받을수있음.  
  
  
#### 7.3.3.2. A kernel module is not loaded automatically, and Udev is not intended to load it  
  
modprobe 를 설정한다 udev가 wrapped module을 로딩한 뒤에 wrapper를 로딩하기 위해서  
  
  
#### 7.3.3.3. Udev loads some unwanted module  
  
  
#### 7.3.3.4. Udev creates a device incorrectly, or makes a wrong symlink  
  
  
#### 7.3.3.5. Udev rule works unreliably  
  
  
#### 7.3.3.6. Device naming order changes randomly after rebooting    
  
  
  
  
  
  
  
  
``(찾아보기)`` __udev 에 대해서, rule작성법, 동작원리 등__    
> udev는 (Userspace Implementation of devfs의 약자) 디바이스 파일 자동 관리.    
> http://lshsblog.blogspot.kr/2011/01/udev.html      
> http://kjjeon.blogspot.kr/2015/05/udev-usb-mount.html    
>   
> http://hoonycream.tistory.com/entry/udev    
> > - 리눅스 부팅 시 init 의 실행 시 /sbin/init 프로세스가 /etc/inittab 로딩 후 각 스크립트 등을 실행    
> > - 이 때 sysfs 를 /sys 로 마운트하여 udev 데몬이 동작    
> > - udev 데몬이 실행 된 후 시스템에서 디바이스 노드 생성    
> > - 실제 디바이스가 detect 되면 sysfs 에 등록되고 해당 디바이스는 사용자 공간에서 /sys에 등록    
> > - udev 데몬으로 netlink socket 을 이용하여 새로운 디바이스가 생성되었다는 메시지를 전송    
> > - udev 데몬은 /sys의 디바이스 내용 (Major, Minor 번호 및 생성할 디바이스 파일의 이름 등) 을 이용해서 /dev 에 디바이스 노드를 생성    
>   
> [udev rule기초 간략 설명 이동](http://chonnom.com/bbs/board.php?bo_table=B19&wr_id=440)    
> > udev rule 간단 규칙.    
> > ```  
> > KERNEL=="hdb", NAME="my_spare_disk"  
> > ```  
> > hdb장치가 추가되면 /dev/my_spare_disk 노드를 생성한다.    
  
  
  
  
  
  
  
  
  
  
## 7.4. Managing Devices  
  
  
### 7.4.1. Network Devices  
eth0 eth1이 순서가 바뀔수도 있기때문에  
udev 룰을 이용해 MAC 어드레스 기반에 따라 디바이스 생성.  
  
  
#### 7.4.1.1. Disabling Persistent Naming on the Kernel Command Line  
  
  
  
#### 7.4.1.2. Creating Custom Udev Rules  
  
The naming scheme can be customized by creating custom Udev rules. A script has been included that generates the initial rules. Generate these rules by running:  
  
- __스크립트를 이용해 네트워크 udev rule생성__    
  
```sh  
 $ bash /lib/udev/init-net-rules.sh  
```  
> /etc/udev/rules.d/70-persistent-net.rules 생성됨.     
  
- __생성된 rule확인__    
  
```sh  
 $ cat /etc/udev/rules.d/70-persistent-net.rules  
```  
  
  
- __rule파일 내용__    
  
```sh  
## This file was automatically generated by the /lib/udev/write_net_rules  
## program, run by the persistent-net-generator.rules rules file.  
##  
## You can modify it, as long as you keep each rule on a single  
## line, and change only the value of the NAME= key.  
  
## net device sky2  
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:24:54:8a:85:a5", ATTR{dev_id}=="0x0", ATTR{type}=="1", NAME="eth0"  
  
## net device ath9k  
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="e8:39:df:84:11:ab", ATTR{dev_id}=="0x0", ATTR{type}=="1", NAME="wlan0"  
```  
>   
> SUBSYSTEM=="net" - udev 가 network 카드 디바이스가 아니면 무시하도록 함.    
ACTION=="add" - add의 상황이 아니면 무시됨.    
DRIVERS=="?*" - 이미 존재하는 VLAN이나 bridge sub-interface들을 무시하도록 만듬  
ATTR{address} - NIC 의 MAC 어드레스    
ATTR{type}=="1" - 1우선순위의 인터페이스만 룰 적용. 나머지는 skip    
NAME - /dev/에 해당 이름으로 생성.    
  
  
  
  
  
  
  
  
  
  
  
  
  
## 7.5. General Network Configuration  
  
### 7.5.1. Creating Network Interface Configuration Files  
  
네트워크 인터페이스는 /etc/sysconfig/에 있는 스크립트에 의해 켜지거나 꺼짐.  
  
- __eth0에 대한 설정파일 생성__    
  
```sh  
 $ cd /etc/sysconfig/  
 $ cat > ifconfig.eth0 << "EOF"  
	ONBOOT=yes  
	IFACE=eth0  
	SERVICE=ipv4-static  
	IP=192.168.1.2  
	GATEWAY=192.168.1.1  
	PREFIX=24  
	BROADCAST=192.168.1.255  
 $ EOF  
```  
> 내 시스템에 맞게 값 수정함.  
  
  
### 7.5.2. Creating the /etc/resolv.conf File  
  
  
- ____    
  
```sh  
cat > /etc/resolv.conf << "EOF"  
## Begin /etc/resolv.conf  
  
domain <Your Domain Name>  
nameserver <IP address of your primary nameserver>  
nameserver <IP address of your secondary nameserver>  
  
## End /etc/resolv.conf  
EOF  
```  
> host system의 resolv.conf랑 똑같이 맞춤.  
  
### 7.5.3. Configuring the system hostname  
  
  
- __Create the /etc/hostname file and enter a hostname__    
  
```sh  
echo "<lfs>" > /etc/hostname  
```  
  
### 7.5.4. Customizing the /etc/hosts File  
- ____    
  
```sh  
Private Network Address Range      Normal Prefix  
10.0.0.1 - 10.255.255.254           8  
172.x.0.1 - 172.x.255.254           16  
192.168.y.1 - 192.168.y.254         24  
```  
  
  
  
  
  
  
  
  
  
  
  
  
## 7.6. System V Bootscript Usage and Configuration  
  
  
### 7.6.1. How Do the System V Bootscripts Work?  
  
### 7.6.2. Configuring Sysvinit  
  
init프로그램이 초기화하기위해서 /etc/inittab파일을 읽는다.  
  
- __/etc/inittab 생성__    
  
```sh  
cat > /etc/inittab << "EOF"  
## Begin /etc/inittab  
  
id:3:initdefault:  
  
si::sysinit:/etc/rc.d/init.d/rc S  
  
l0:0:wait:/etc/rc.d/init.d/rc 0  
l1:S1:wait:/etc/rc.d/init.d/rc 1  
l2:2:wait:/etc/rc.d/init.d/rc 2  
l3:3:wait:/etc/rc.d/init.d/rc 3  
l4:4:wait:/etc/rc.d/init.d/rc 4  
l5:5:wait:/etc/rc.d/init.d/rc 5  
l6:6:wait:/etc/rc.d/init.d/rc 6  
  
ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now  
  
su:S016:once:/sbin/sulogin  
  
1:2345:respawn:/sbin/agetty --noclear tty1 9600  
2:2345:respawn:/sbin/agetty tty2 9600  
3:2345:respawn:/sbin/agetty tty3 9600  
4:2345:respawn:/sbin/agetty tty4 9600  
5:2345:respawn:/sbin/agetty tty5 9600  
6:2345:respawn:/sbin/agetty tty6 9600  
  
## End /etc/inittab  
EOF  
```  
> inittab man 페이지 참고.    
> rc 스크립트를 이용하여  
> /etc/rc.d/rcS.d/먼저 실행, 그뒤 /etc/rc.d/rc?.d/ 실행 (?는 initdefault value)  
>   
> rc는 /lib/lsb/init-functions 라이브러리를 읽는다.    
> 이 라이브러리는 또한 추가 configuration 파일인 /etc/sysconfig/rc.site 를 읽는다.  
> 다음 섹션에서 설명할 모든 시스템 설정 파일 파라미터들은 모두 이 하나의 파일로 통합될 수 있다.  
>   
> 디버깅의 용이성을 위해 함수 스크립트의 로그는 /run/var/bootlog에 저장  
> /run이 tmpfs파일시스템이기 때문에 booting때마다 바뀜.  
> /var/log/boot.log가 지워지지않는 로그임.  
  
> ``(찾아보기)`` 위의 inittab파일 내용 이해하기  
  
  
  
#### 7.6.2.1. Changing Run Levels  
  
run-level은 init <runlevel> 으로 바꿀 수 있음.  
/etc/rc.d/rc?.d/에 존재하는 스크립트는 /etc/rc.d/init.d/ 에 존재하는 스크립트의 심볼릭 링크임.  
심볼릭링크의 바뀐이름이 (S,K) 실제 스크립트에 전달되는  서로다른 매개변수임.  
  
  
### 7.6.3. Udev Bootscripts  
  
The /etc/rc.d/init.d/udev initscript starts udevd,   
triggers any "coldplug" devices that have already been created by the kernel  
and waits for any rules to complete. The script also unsets the uevent handler  
from the default of /sbin/hotplug . This is done because the kernel no longer  
needs to call out to an external binary. Instead udevd will listen on a netlink  
socket for uevents that the kernel raises.  
  
udev_retry는 mountfs 스크립트가 진행된 이후에 udev 관련작업을 마무리한다.   
파일시스템이 마운트 된상태에서 진행되어야할 작업들때문에  
The /etc/rc.d/init.d/udev_retry initscript   
takes care of re-triggering events for subsystems whose rules may rely on  
filesystems that are not mounted until the mountfs script is run (in  
particular, /usr and /var may cause this). This script runs after the mountfs  
script, so those rules (if re-triggered) should succeed the second time around.  
It is configured from the /etc/sysconfig/udev_retry file; any words in this  
file other than comments are considered subsystem names to trigger at retry  
time.  To find the subsystem of a device, use udevadm info --attribute-walk  
<device> where <device> is an absolute path in /dev or /sys such as /dev/sr0 or  
/sys/class/rtc.  
  
#### 7.6.3.1. Module Loading  
  
모듈로 빌드된 디바이스 드라이버는 aliases를 가지고 있을 것이다.  
modinfo프로그램에 의해서 aliases를 볼 수 있음.  
  
#### 7.6.3.2. Handling Hotpluggable/Dynamic Devices  
  
  
  
### 7.6.4. Configuring the System Clock  
  
  
  
- __Create a new file /etc/sysconfig/clock__    
  
```sh  
cat > /etc/sysconfig/clock << "EOF"  
## Begin /etc/sysconfig/clock  
  
UTC=1  
  
## Set this to any options you might need to give to hwclock,  
## such as machine hardware clock type for Alphas.  
CLOCKPARAMS=  
  
## End /etc/sysconfig/clock  
EOF  
```  
  
  
  
``(찾아보기)`` __/etc/sysconfig/ 의 역할?__  
> The /etc/sysconfig/ directory is where a variety of system configuration files  
> /etc/sysconfig/rc.site는 lfs에만 있는 파일인듯.  
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/3/html/Reference_Guide/ch-sysconfig.html  
  
  
  
  
### 7.6.5. Configuring the Linux Console  
  
/etc/sysconfig/console 안만듦. 어차피 한글은 안됨.  
이파일을 만들면 rc.site에 있는 내용을 덮어씀.  
  
  
### 7.6.6. Creating Files at Boot  
  
부팅타임에 파일을 생성하고 싶을땐 /etc/sysconfig/createfiles 파일에 기술하면됨.  
  
### 7.6.7. Configuring the sysklogd Script  
  
  
- __timestamp간격 바꾸고 싶으면 /etc/sysconfig/rc.site에서__    
  
```sh  
SYSKLOGD_PARMS=  
```  
  
  
### 7.6.8. The rc.site File  
  
/etc/sysconfig/rc.site 파일 참고 주석에 설명있음.  
  
  
- ustomizing the Boot and Shutdown Scripts  
  
/etc/sysconfig/rc.site 수정.  
  
[각각의 옵션설명 참고](http://www.linuxfromscratch.org/lfs/view/stable/chapter07/usage.html)  
> OMIT_UDEV_SETTLE=y.  
> OMIT_UDEV_RETRY_SETTLE=y.  
> VERBOSE_FSCK=y.  
> FASTBOOT=y  
> SKIPTMPCLEAN=y.  
> KILLDELAY=0.  
  
  
  
  
  
  
  
  
  
  
  
  
  
## 7.7. The Bash Shell Startup Files  
  
쉘 프로그램(/bin/bash)은 스타트업 파일들의 모음을 사용해서 환경을 구축한다.  
/etc에 디렉토리는 글로벌 셋팅이다. 만약 home디렉토리가 있다면 덮어씌워질 것이다.  
  
login shell은 성공적으로 로그인된 이후에 시작된다. (/bin/login 이용)   
(/etc/passwd파일을 읽음 으로써. )  
  
  
/etc/profile과 ~/.bash_profile은 interactive login shell이 실행되었을때 읽는 파일  
  
  
- __locale변경__    
  
```sh  
cat > /etc/profile << "EOF"  
## Begin /etc/profile  
  
export LANG=<ll>_<CC>.<charmap><@modifiers>  
  
## End /etc/profile  
EOF  
```  
> ko_KR.utf8 로변경  
  
  
  
  
  
  
  
  
  
## 7.8. Creating the /etc/inputrc File  
  
inputrc 파일은 특정상황에서 키보드 매핑을 다룬다.  
readline프로그램이 사용하는 startup file이다.  
  
home디렉토리에 .inputrc 파일을 만들면 덮어씌워진다.  
자세한 내용은 info readline  
  
  
- __/etc/inputrc파일 생성__    
  
```sh  
cat > /etc/inputrc << "EOF"  
## Begin /etc/inputrc  
## Modified by Chris Lynn <roryo@roryo.dynup.net>  
  
## Allow the command prompt to wrap to the next line  
set horizontal-scroll-mode Off  
  
## Enable 8bit input  
set meta-flag On  
set input-meta On  
  
## Turns off 8th bit stripping  
set convert-meta Off  
  
## Keep the 8th bit for display  
set output-meta On  
  
## none, visible or audible  
set bell-style none  
  
## All of the following map the escape sequence of the value  
## contained in the 1st argument to the readline specific functions  
"\eOd": backward-word  
"\eOc": forward-word  
  
## for linux console  
"\e[1~": beginning-of-line  
"\e[4~": end-of-line  
"\e[5~": beginning-of-history  
"\e[6~": end-of-history  
"\e[3~": delete-char  
"\e[2~": quoted-insert  
  
## for xterm  
"\eOH": beginning-of-line  
"\eOF": end-of-line  
  
## for Konsole  
"\e[H": beginning-of-line  
"\e[F": end-of-line  
  
## End /etc/inputrc  
EOF  
```  
  
  
  
  
  
  
  
  
  
  
## 7.9. Creating the /etc/shells File  
  
  
- __/etc/shells 파일 생성__    
  
```sh  
cat > /etc/shells << "EOF"  
## Begin /etc/shells  
  
/bin/sh  
/bin/bash  
  
## End /etc/shells  
EOF  
```  
  
