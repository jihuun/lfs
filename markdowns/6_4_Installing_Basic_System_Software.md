## 6. Installing Basic System Software (4)

<!-- toc -->
  
  
  
  
## 6.46. Diffutils-3.3  
  
The Diffutils package contains programs that show the differences between files or directories.  
  
  
- __First fix a file so locale files are installed:__    
  
```sh  
 $ sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in  
```  
  
  
- __Prepare Diffutils for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
## 6.47. Gawk-4.1.1  
  
The Gawk package contains programs for manipulating text files.  
  
  
- __Prepare Gawk for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
- __install the documentation:__    
  
```sh  
 $ mkdir -v /usr/share/doc/gawk-4.1.1  
 $ cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.1  
```  
  
  
  
  
  
  
  
## 6.48. Findutils-4.4.2  
  
  
The Findutils package contains programs to find files.   
  
  
  
- __Prepare Findutils for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr --localstatedir=/var/lib/locate  
```  
> (옵션) --localstatedir    
FHS 규정에따라 database 의 위치를 /var/lib/locate으로  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
- __find위치 변경__    
  
```sh  
 $ mv -v /usr/bin/find /bin  
 $ sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb  
```  
  
  
  
  
  
## 6.49. Gettext-0.19.4  
  
  
The Gettext package contains utilities for internationalization and localization.   
  
  
- __Prepare Gettext for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr --docdir=/usr/share/doc/gettext-0.19.4  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results (this takes a long time, around 3 SBUs), issue:__    
  
```sh  
 $ make check  
```  
> test suite fail발생  
```  
============================================================================  
Testsuite summary for gettext-tools 0.19.4  
============================================================================  
## TOTAL: 397  
## PASS:  377  
## SKIP:  19  
## XFAIL: 0  
## FAIL:  1  
## XPASS: 0  
## ERROR: 0  
============================================================================  
See tests/test-suite.log  
Please report to bug-gnu-gettext@gnu.org  
============================================================================  
Makefile:2221: recipe for target 'test-suite.log' failed  
make[5]: *** [test-suite.log] Error 1  
make[5]: Leaving directory '/sources/gettext-0.19.4/gettext-tools/tests'  
Makefile:2327: recipe for target 'check-TESTS' failed  
make[4]: *** [check-TESTS] Error 2  
make[4]: Leaving directory '/sources/gettext-0.19.4/gettext-tools/tests'  
Makefile:5172: recipe for target 'check-am' failed  
make[3]: *** [check-am] Error 2  
make[3]: Leaving directory '/sources/gettext-0.19.4/gettext-tools/tests'  
Makefile:1721: recipe for target 'check-recursive' failed  
make[2]: *** [check-recursive] Error 1  
make[2]: Leaving directory '/sources/gettext-0.19.4/gettext-tools'  
Makefile:369: recipe for target 'check-recursive' failed  
make[1]: *** [check-recursive] Error 1  
make[1]: Leaving directory '/sources/gettext-0.19.4'  
Makefile:661: recipe for target 'check' failed  
make: *** [check] Error 2  
```  
>> 일단 그냥 진행.  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
## 6.50. Intltool-0.50.2  
## 6.50. Intltool-0.50.2  
  
The Intltool is an internationalization tool used for extracting translatable strings from source files.  
  
### 6.50.1. Installation of Intltool  
  
  
  
- __Prepare Intltool for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
 $ install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.50.2/I18N-HOWTO  
```  
  
  
  
  
  
  
## 6.51. Gperf-3.0.4  
  
  
Gperf generates a perfect hash function from a key set.  
  
### 6.51.1. Installation of Gperf  
  
- __Prepare Gperf for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
## 6.52. Groff-1.22.3  
  
The Groff package contains programs for processing and formatting text.  
  
### 6.52.1. Installation of Groff  
  
  
- __Prepare Groff for compilation:__    
  
```sh  
 $ PAGE=<paper_size> ./configure --prefix=/usr  
```  
> 미국은 PAGE=letter 아니면 PAGE=A4로 하면됨.  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __이 package는 test suite가 없음__    
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
  
  
## 6.53. Xz-5.2.0  
The Xz package contains programs for compressing and decompressing files.   
  
### 6.53.1. Installation of Xz  
  
  
  
- __Prepare Xz for compilation with:__    
  
```sh  
 $ ./configure --prefix=/usr --docdir=/usr/share/doc/xz-5.2.0  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package and make sure that all essential files are in the correct directory:__    
  
```sh  
 $ make install  
 $ mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin  
 $ mv -v /usr/lib/liblzma.so.* /lib  
 $ ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so  
```  
  
  
  
  
  
  
  
  
## 6.54. GRUB-2.02~beta2  
  
The GRUB package contains the GRand Unified Bootloader.  
  
  
  
- __Prepare GRUB for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr          \  
		     --sbindir=/sbin        \  
		     --sysconfdir=/etc      \  
		     --disable-grub-emu-usb \  
		     --disable-efiemu       \  
		     --disable-werror  
```  
  
  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __This package does not come with a test suite.__    
  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```    
  
- GRUB은 이 LFS시스템을 부팅가능하게 한다. 뒤에 8.4절에서 다룸.  
[Section 8.4, “Using GRUB to Set Up the Boot Process](http://linuxfromscratch.org/lfs/view/stable/chapter08/grub.html)  
  
  
  
  
  
  
  
  
  
  
## 6.55. Less-458  
  
The Less package contains a text file viewer.  
  
### 6.55.1. Installation of Less  
  
  
  
- __Prepare Less for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr --sysconfdir=/etc  
```  
> (옵션) --sysconfdir=/etc    
This option tells the programs created by the package to look in /etc for the configuration files.  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
- __This package does not come with a test suite.__    
  
  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
  
## 6.56. Gzip-1.6  
  
The Gzip package contains programs for compressing and decompressing files.  
  
### 6.56.1. Installation of Gzip  
  
  
- __Prepare Gzip for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr --bindir=/bin  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
- __몇몇 프로그램 이동:__    
  
```sh  
 $ mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin  
 $ mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin  
```  
  
  
  
  
  
  
  
  
## 6.57. IPRoute2-3.19.0  
  
The IPRoute2 package contains programs for basic and advanced IPV4-based networking.  
  
### 6.57.1. Installation of IPRoute2  
  
  
- __Berkeley DB의 의존성 제거__    
  
```sh  
 $ sed -i '/^TARGETS/s@arpd@@g' misc/Makefile  
 $ sed -i /ARPD/d Makefile  
 $ sed -i 's/arpd.8//' man/man8/Makefile  
```  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
- 이 패키지는 test suite를 가지고 있지만 chroot한 상태에서 진행하는것이 문제없는지 확신할 수 없다.    
따라서 나중에 LFS로 부팅하고 시도해보라.  
  
- __Install the package:__    
  
```sh  
 $ make DOCDIR=/usr/share/doc/iproute2-3.19.0 install  
```  
  
  
  
  
  
  
## 6.58. Kbd-2.0.2  
  
키보드  
The Kbd package contains key-table files, console fonts, and keyboard utilities.  
  
  
- __i386 keymap관련 패치__    
  
```sh  
 $ patch -Np1 -i ../kbd-2.0.2-backspace-1.patch  
```  
  
- __패치적용이후에 다시 생성__    
  
```sh  
 $ sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure  
 $ sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in  
```  
  
  
- __Prepare Kbd for compilation:__    
  
```sh  
 $ PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
 ```  
  
- __ If desired, install the documentation:__    
   
 ```sh  
 $ mkdir -v       /usr/share/doc/kbd-2.0.2  
 $ cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.2  
```  
  
  
  
  
  
## 6.59. Kmod-19  
  
The Kmod package contains libraries and utilities for loading kernel modules  
  
  
  
- __Prepare Kmod for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr          \  
	--bindir=/bin          \  
	--sysconfdir=/etc      \  
	--with-rootlibdir=/lib \  
	--with-xz              \  
	--with-zlib  
```  
> (옵션)  
--with-xz, --with-zlib  
These options enable Kmod to handle compressed kernel modules.  
--with-rootlibdir=/lib  
This option ensures different library related files are placed in the correct directories.  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
- __Install the package, and create symlinks__    
  
```sh  
 $ make install  
 $   
 $ for target in depmod insmod lsmod modinfo modprobe rmmod; do  
 $ 	ln -sv ../bin/kmod /sbin/$target  
 $ done  
 $   
 $ ln -sv kmod /bin/lsmod  
```  
  
  
  
  
  
  
  
  
  
  
## 6.60. Libpipeline-1.4.0  
  
The Libpipeline package contains a library for manipulating pipelines of subprocesses in a flexible and convenient way.  
  
### 6.60.1. Installation of Libpipeline  
  
  
  
- __Prepare Libpipeline for compilation:__    
  
```sh  
 $ PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
  
  
  
## 6.61. Make-4.1  
  
The Make package contains a program for compiling packages.  
### 6.61.1. Installation of Make  
  
  
  
- __Prepare Make for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
  
## 6.62. Patch-2.7.4  
  
The Patch package contains a program for modifying or creating files by applying a “patch” file typically created by the diff program.  
  
### 6.62.1. Installation of Patch  
  
  
  
- __Prepare Patch for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
## 6.63. Sysklogd-1.5.1  
  
The Sysklogd package contains programs for logging system messages   
  
### 6.63.1. Installation of Sysklogd  
  
  
- __몇 조건에 segmentation fault 문제 수정__    
  
```sh  
 $ sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __This package does not come with a test suite.__    
  
  
- __Install the package:__    
  
```sh  
 $ make BINDIR=/sbin install  
```  
  
### 6.63.2. Configuring Sysklogd  
  
  
  
- __/etc/syslog.conf파일 생성__    
  
```sh  
 $ cat > /etc/syslog.conf << "EOF"  
 $ # Begin /etc/syslog.conf  
 $   
 $ auth,authpriv.* -/var/log/auth.log  
 $ *.*;auth,authpriv.none -/var/log/sys.log  
 $ daemon.* -/var/log/daemon.log  
 $ kern.* -/var/log/kern.log  
 $ mail.* -/var/log/mail.log  
 $ user.* -/var/log/user.log  
 $ *.emerg *  
 $   
 $ # End /etc/syslog.conf  
 $ EOF  
```  
  
  
  
  
  
  
## 6.64. Sysvinit-2.88dsf  
  
The Sysvinit package contains programs for controlling the startup, running, and shutdown of the system.  
  
### 6.64.1. Installation of Sysvinit  
  
  
- __패치적용__    
  
```sh  
 $ patch -Np1 -i ../sysvinit-2.88dsf-consolidated-1.patch  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make -C src  
```  
This package does not come with a test suite.  
  
  
  
- __Install the package:__    
  
```sh  
 $ make -C src install  
```  
  
  
  
  
  
  
  
  
  
  
  
  
## 6.65. Tar-1.28  
  
The Tar package contains an archiving program.  
  
### 6.65.1. Installation of Tar  
  
  
  
- __Prepare Tar for compilation:__    
  
```sh  
 $ FORCE_UNSAFE_CONFIGURE=1  \  
 $ ./configure --prefix=/usr \  
            --bindir=/bin  
```  
> FORCE_UNSAFE_CONFIGURE=1 : This forces the test for mknod to be run as root.   
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results (about 1 SBU), issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
 $ make -C doc install-html docdir=/usr/share/doc/tar-1.28  
```  
  
  
  
  
  
  
  
  
  
## 6.66. Texinfo-5.2  
  
The Texinfo package contains programs for reading, writing, and converting info pages.  
  
### 6.66.1. Installation of Texinfo  
  
  
  
- __Prepare Texinfo for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
- __Optionally, install the components belonging in a TeX installation:__    
  
```sh  
 $ make TEXMF=/usr/share/texmf install-tex  
```  
  
  
- __documtent관련__    
  
```sh  
 $ pushd /usr/share/info  
 $ rm -v dir  
 $ for f in *  
 $ do install-info $f dir 2>/dev/null  
 $ done  
 $ popd  
```  
  
  
  
  
  
  
  
## 6.67. Eudev-2.1.1  
  
The Eudev package contains programs for dynamic creation of device nodes.  
  
``(찾아보기)``  /etc/udev/hwdb.d  룰? 이뭔지?  
``(찾아보기)``  udevadm hwdb --update 역할  
  
  
### 6.67.1. Installation of Eudev  
  
  
  
- __First, fix a test script:__    
  
```sh  
 $ sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl  
```  
  
  
- __Prepare Eudev for compilation:__    
  
```sh  
 $ BLKID_CFLAGS=-I/tools/include       \  
 $ BLKID_LIBS='-L/tools/lib -lblkid'   \  
	./configure --prefix=/usr           \  
	--bindir=/sbin          \  
	--sbindir=/sbin         \  
	--libdir=/usr/lib       \  
	--sysconfdir=/etc       \  
	--libexecdir=/lib       \  
	--with-rootprefix=      \  
	--with-rootlibdir=/lib  \  
	--enable-split-usr      \  
	--enable-libkmod        \  
	--enable-rule_generator \  
	--enable-keymap         \  
	--disable-introspection \  
	--disable-gudev         \  
	--disable-gtk-doc-html  
```  
  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
- __디렉토리 생성__    
  
```sh  
 $ mkdir -pv /lib/udev/rules.d  
 $ mkdir -pv /etc/udev/rules.d  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
- __Now, install the man pages:__    
  
```sh  
 $ tar -xvf ../eudev-2.1.1-manpages.tar.bz2 -C /usr/share  
```  
  
  
- __Finally, install some custom rules and support files useful in an LFS environment:__    
  
```sh  
 $ tar -xvf ../udev-lfs-20140408.tar.bz2  
 $ make -f udev-lfs-20140408/Makefile.lfs install  
```  
  
  
### 6.67.2. Configuring Eudev  
  
  
- __initial database 생성__    
  
```sh  
 $ udevadm hwdb --update  
```  
> This command needs to be run each time the hardware information is updated.  
  
  
  
  
  
  
  
  
## 6.68. Util-linux-2.26  
  
여기서 설치하는 갖가지 유틸리티들은 의존성관계가 없는듯.  
  
  
  
The Util-linux package contains miscellaneous utility programs. Among them are utilities for handling file systems, consoles, partitions, and messages.  
  
### 6.68.1. FHS compliance notes  
  
  
- __FHS에따라 디렉토리 생성__    
  
```sh  
 $ mkdir -pv /var/lib/hwclock  
```  
  
### 6.68.2. Installation of Util-linux  
  
  
  
- __Prepare Util-linux for compilation:__    
  
```sh  
 $ ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime     \  
	--docdir=/usr/share/doc/util-linux-2.26 \  
	--disable-chfn-chsh  \  
	--disable-login      \  
	--disable-nologin    \  
	--disable-su         \  
	--disable-setpriv    \  
	--disable-runuser    \  
	--disable-pylibmount \  
	--without-python     \  
	--without-systemd    \  
	--without-systemdsystemunitdir  
```  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __run the test suite as a non-root user:__    
  
```sh  
 $ chown -Rv nobody .  
 $ su nobody -s /bin/bash -c "PATH=$PATH make -k check"  
```  
> test suite 를 root계정으로하면 위함함.     
임의의 nobody계정으로 테스트돌림.  
  
  
  
- __Install the package:__    
    
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
  
## 6.69. Man-DB-2.7.1  
  
  
The Man-DB package contains programs for finding and viewing man pages.  
``(찾아보기)`` man-page 와 man-db 의 차이?  
  
  
### 6.69.1. Installation of Man-DB  
  
  
  
- __Prepare Man-DB for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr                          \  
		     --docdir=/usr/share/doc/man-db-2.7.1 \  
		     --sysconfdir=/etc                      \  
		     --disable-setuid                       \  
		     --with-browser=/usr/bin/lynx           \  
		     --with-vgrind=/usr/bin/vgrind          \  
		     --with-grap=/usr/bin/grap  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
  
  
  
  
  
## 6.70. Vim-7.4  
  
The Vim package contains a powerful text editor.  
  
  
### 6.70.1. Installation of Vim  
  
  
- __vimrc 설정파일 위치 정의__    
  
```sh  
 $ echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h  
```  
  
  
- __Prepare Vim for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
 $ make -j1 test  
```  
> "ALL DONE" 문자열이 나오면 성공임.  
  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
- __vi로 심링크 지정__    
  
```sh  
 $ ln -sv vim /usr/bin/vi  
 $ for L in  /usr/share/man/{,*/}man1/vim.1; do  
 $ 	ln -sv vim.1 $(dirname $L)/vi.1  
 $ done  
```  
  
- __vim doc위치 심링크지정__    
  
```sh  
 $ ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4  
```  
  
  
### 6.70.2. Configuring Vim  
  
  
- __기본 vimrc생성__    
  
```sh  
 $ cat > /etc/vimrc << "EOF"  
" Begin /etc/vimrc  
  
set nocompatible  
set backspace=2  
syntax on  
if (&term == "iterm") || (&term == "putty")  
set background=dark  
endif  
  
" End /etc/vimrc  
EOF  
```  
  
- __vimrc옵션 설정에 대한 문서는 아래를 참고__    
  
```sh  
 $ vim -c ':options'  
```  
  
  
  
  
  
  
  
  
  
  
## 6.71. About Debugging Symbols    
  
A bash binary with debugging symbols: 1200 KB    
A bash binary without debugging symbols: 480 KB    
Glibc and GCC files (/lib and /usr/lib) with debugging symbols: 87 MB    
Glibc and GCC files without debugging symbols: 16 MB    
  
  
  
  
  
  
  
  
## 6.72. Stripping Again  
  
디버깅 심볼 제거    
  
### ''(참고)'' Stripping하기전에 현재까지 구성한 루트파일시스템 백업해두기.  
  
```sh  
drwxr-xr-x   2 root root  4096  8월 11 14:55 bin  
drwxr-xr-x   2 root root  4096  8월  7 17:35 boot  
drwxr-xr-x  16 root root  4260  8월 11 14:17 dev	\\ 
drwxr-xr-x  10 root root  4096  8월 11 15:13 etc  
drwxr-xr-x   2 root root  4096  8월  7 17:35 home  
drwxr-xr-x   4 root root  4096  8월 11 14:55 lib  
lrwxrwxrwx   1 root root     3  8월  7 17:35 lib64 -> lib  
drwxr-xr-x   4 root root  4096  8월  7 17:35 media  
drwxr-xr-x   2 root root  4096  8월  7 17:35 mnt  
drwxr-xr-x   2 root root  4096  8월  7 17:35 opt  
dr-xr-xr-x 245 root root     0  8월  7 19:18 proc	\\  
drwxr-x---   2 root root  4096  8월 11 15:15 root  
drwxrwxrwt   4 root root    80  8월 10 20:29 run	\\  
drwxr-xr-x   2 root root  4096  8월 11 14:55 sbin  
drwxr-xr-x  69 lfs  root  4096  8월 11 15:03 sources	\\  
drwxr-xr-x   2 root root  4096  8월  7 17:35 srv  
dr-xr-xr-x  13 root root     0  8월  7 19:18 sys	\\  
drwxrwxrwt   2 root root 20480  8월 11 15:13 tmp	\\  
drwxr-xr-x  12 root root  4096  8월  7 17:08 tools	\\  
drwxr-xr-x  10 root root  4096  8월  7 17:35 usr  
drwxr-xr-x  10 root root  4096  8월  7 17:35 var  
```  
> 위에 주석친(\\) 경로는 복사안함. 이유는 mount로 올린곳이라 복사 잘 안됨.    
나중에 다시 mount하면 될듯.    
http://linuxfromscratch.org/lfs/view/stable/chapter06/kernfs.html    
그리고 tools와 sources는 이전에 백업해두었기 때문에 복사x    
  
- __백업 수행__    
  
```sh  
 $ cd 백업 디렉토리  
 $ sudo cp /mnt/lfs/{bin,boot,etc,home,lib,lib64,media,mnt,opt,root,sbin,srv,usr,var} .  
```  
  
  
### Stripping  
  
- __로그 아웃__    
  
```sh  
 $ logout  
```  
  
- __chroot__    
  
```sh  
 $ chroot $LFS /tools/bin/env -i            \  
	HOME=/root TERM=$TERM PS1='\u:\w\$ ' \  
	PATH=/bin:/usr/bin:/sbin:/usr/sbin   \  
	/tools/bin/bash --login  
	Now the binaries and libraries can be safely stripped:  
```  
  
- __stripping__    
  
```sh  
 $ /tools/bin/find /{,usr/}{bin,lib,sbin} -type f \  
	-exec /tools/bin/strip --strip-debug '{}' ';'  
```  
  
  
  
  
  
  
  
  
  
## 6.73. Cleaning Up  
  
  
Finally, clean up some extra files left around from running tests:  
  
- __test 수행동안 생성된 파일 제거__    

```  
 $ rm -rf /tmp/*  
```  
  
- __다음부터 재로그인 할때는 아래와 같이 로그인 하면됨.__    

```sh  
 $ chroot "$LFS" /usr/bin/env -i              \  
	HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \  
	PATH=/bin:/usr/bin:/sbin:/usr/sbin     \  
	/bin/bash --login  
```  
> PATH에 /tools/가 없어짐.    
  
  
  
- __tools제거__    

```sh  
 $ rm -rf /tools  
```  
> 6장을 빌드하기 위한 임시 유틸리티로 더이상 필요없음.    
  
  
만약 재부팅을 한다면 아래 대로 재 mount 시키면됨. 그리고 chroot  
[Section 6.2.2, “Mounting and Populating /dev”](http://linuxfromscratch.org/lfs/view/stable/chapter06/kernfs.html#ch-system-bindmount)    
[Section 6.2.3, “Mounting Virtual Kernel File Systems”.](http://linuxfromscratch.org/lfs/view/stable/chapter06/kernfs.html#ch-system-kernfsmount)    
  
  
  
  
  
  
