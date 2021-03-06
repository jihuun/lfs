# 6. Installing Basic System Software (3)
  
<!-- toc -->

## 6.18. Bzip2-1.0.6    
압축/해제 패키지    
  
  
- __패치 적용__    
  
```sh  
 $ patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch    
```  
  
- __심볼릭 링크 관련 makefile수정__    
  
```sh  
 $ sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile  
```  
  
- __man page관련 makefile수정__    
  
```sh  
 $ sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile  
```  
  
- __make 준비__    
  
```sh  
 $ make -f Makefile-libbz2_so  
 $ make clean  
```  
  
- __빌드__    
  
```sh  
 $ make  
```  
  
- __설치__    
  
```sh  
 $ make PREFIX=/usr install  
```  
  
- __ㅇㅇ__    
  
```sh  
 $ cp -v bzip2-shared /bin/bzip2  
 $ cp -av libbz2.so* /lib  
 $ ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so  
 $ rm -v /usr/bin/{bunzip2,bzcat,bzip2}  
 $ ln -sv bzip2 /bin/bunzip2  
 $ ln -sv bzip2 /bin/bzcat  
```  
> ``(문제발생)``     
bzip2-shared 와 libbz2.so* 가 안만들어져서 cp가 안됨.    
bzip2-1.0.6.tar.gz 압축 다시 해제하고 다시 빌드 하니 해결.    
``(주의)`` 여러줄 명령어 복붙할때 fail 로그 지나치기 쉬운데 꼼꼼히 확인할것.    
  
  
  
  
  
  
  
  
## 6.19. Pkg-config-0.28  
  
The pkg-config package contains a tool for passing the include path and/or  
library paths to build tools during the configure and make file execution.  
  
  
  
### 6.19.1. Installation of Pkg-config  
  
  
- __빌드준비__    
  
```sh  
 $ ./configure --prefix=/usr         \  
		     --with-internal-glib  \  
		     --disable-host-tool   \  
		     --docdir=/usr/share/doc/pkg-config-0.28  
```  
  
- __컴파일__    
  
```sh  
 $ make  
```  
  
- __test suite__    
  
```sh  
 $ make check  
```  
  
- __설치__    
  
```sh  
 $ make install  
```  
  







  
## 6.20. Ncurses-5.9

The Ncurses package contains libraries for terminal-independent handling of character screens.

- __Prepare Pkg-config for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr           \  
	     --mandir=/usr/share/man \  
	     --with-shared           \  
	     --without-debug         \  
	     --enable-pc-files       \  
	     --enable-widec  
```  
  
- __빌드__    
  
```sh  
 $ make  
```  
  
- __설치__    
  
```sh  
 $ make install  
```  
  
  
- __공유라이브러리 이동__    
  
```sh  
 $ mv -v /usr/lib/libncursesw.so.5* /lib  
```  
  
- __삭제된 심폴릭링크 재생성__    
  
```sh  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so  
```  
  
- __심볼릭링크__    
  
```sh  
 $ for lib in ncurses form panel menu ; do  
	rm -vf                    /usr/lib/lib${lib}.so  
	echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so  
	ln -sfv lib${lib}w.a      /usr/lib/lib${lib}.a  
	ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc  
done  
  
 $ ln -sfv libncurses++w.a /usr/lib/libncurses++.a  
```  
  
- __make sure that old applications that look for -lcurses at build time are still buildable__    
  
```sh  
 $ rm -vf                     /usr/lib/libcursesw.so  
 $ echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so  
 $ ln -sfv libncurses.so      /usr/lib/libcurses.so  
 $ ln -sfv libncursesw.a      /usr/lib/libcursesw.a  
 $ ln -sfv libncurses.a       /usr/lib/libcurses.a  
```  
  
- __Ncurses doc설치__    
  
```sh  
 $ mkdir -v       /usr/share/doc/ncurses-5.9  
 $ cp -v -R doc/* /usr/share/doc/ncurses-5.9  
```  
  
  
아래거 안함. 확인필요.    
> Note  
> The instructions above don`t create non-wide-character Ncurses libraries since no package installed by compiling from sources would link against them at runtime. If you must have such libraries because of some binary-only application or to be compliant with LSB, build the package again with the following commands:  
>   
>```sh  
> $ make distclean  
> ./configure --prefix=/usr    \  
> 	--with-shared    \  
> 	--without-normal \  
> 	--without-debug  \  
> 	--without-cxx-binding  
> $ make sources libs  
> $ cp -av lib/lib*.so.5* /usr/lib  
>```  
  
  
  
  
  
  
## 6.21. Attr-2.4.47  
The attr package contains utilities to administer the extended attributes on  
filesystem objects.  
  
  
  
  
- __Modify the documentation directory__    
  
```sh  
 $ sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in  
```  
  
- __Prepare Attr for compilation__    
  
```sh  
 $ ./configure --prefix=/usr --bindir=/bin  
```  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
- __파일시스템 관련 test__    
  
```sh  
 $ make -j1 tests root-tests  
```  
  
- __Install the package__    
  
```sh  
 $ make install install-dev install-lib  
 $ chmod -v 755 /usr/lib/libattr.so  
```  
  
- __공유라이브러리 이동__    
  
```sh  
 $ mv -v /usr/lib/libattr.so.* /lib  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so  
```  
  
  
attr	 	Extends attributes on filesystem objects  
getfattr	Gets the extended attributes of filesystem objects  
setattr 	Sets the extended attributes of filesystem objects  
libattr 	Contains the libbrary functions for manipulating extended attributes  
  
  
  
  
  
  
  
  
  
  
## 6.22. Acl-2.2.52  
  
엑세스 컨트롤  
The Acl package contains utilities to administer Access Control Lists, which  
are used to define more fine-grained discretionary access rights for files and  
directories.  
  
  
  
- __Modify the documentation directory__    
  
```sh  
 $ sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in  
```  
  
- __Fix some broken tests__    
  
```sh  
 $ sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test  
```  
  
- __fix a bug__    
  
```sh  
 $ sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \  
    libacl/__acl_to_any_text.c  
```  
  
- __Prepare Acl for compilation__    
  
```sh  
 $ ./configure --prefix=/usr \  
	     --bindir=/bin \  
	     --libexecdir=/usr/lib  
```  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
- __Install the package__    
  
```sh  
 $ make install install-dev install-lib  
 $ chmod -v 755 /usr/lib/libacl.so  
```  
  
  
- __공유라이브러리 이동__    
  
```sh  
 $ mv -v /usr/lib/libacl.so.* /lib  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so  
```  
  
  
  
  
  
  
  
  
## 6.23. Libcap-2.24  
  
The Libcap package implements the user-space interfaces to the POSIX 1003.1e  
capabilities available in Linux kernels. These capabilities are a partitioning  
of the all powerful root privilege into a set of distinct privileges.  
  
### 6.23.1. Installation of Libcap  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
- __Install the package__    
  
```sh  
 $ make RAISE_SETFCAP=no prefix=/usr install  
 $ chmod -v 755 /usr/lib/libcap.so  
```  
  
- __공유라이브러리 /lib으로 이동__    
  
```sh  
 $ mv -v /usr/lib/libcap.so.* /lib  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so  
```  
  
### 6.23.2. Contents of Libcap    
  
Installed programs: capsh, getcap, getpcaps, and setcap    
Installed library: libcap.{a,so}    
  
- Short Descriptions    
capsh 		A shell wrapper to explore and constrain capability support  
getcap 		Examines file capabilities  
getpcaps 	Displays the capabilities on the queried process(es)  
libcap 		Contains the library functions for manipulating POSIX 1003.1e capabilities  
  
  
  
  
  
  
  
  
## 6.24. Sed-4.2.2  
  
sed 유틸리티 설치  
The Sed package contains a stream editor.  
  
### 6.24.1. Installation of Sed    
  
  
- __Prepare Sed for compilation__    
  
```sh  
 $ ./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-4.2.2    
```  
> (옵션)    
--htmldir : This sets the installation directory for the HTML documentation.    
  
  
- __Compile the package__    
  
```sh  
 $ make  
 $ make html  
```  
  
- __To test the results__    
  
```sh  
 $ make check  
```  
  
- __Install the package__    
  
```sh  
 $ make install  
 $ make -C doc install-html  
```  
  
  
### 6.24.2. Contents of Sed  
  
Installed program: 	sed  
Installed directory: 	/usr/share/doc/sed-4.2.2  
  
- Short Descriptions    
sed 		Filters and transforms text files in a single pass  
  
  
  
  
  
  
  
  
  
  
  
  
## 6.25. Shadow-4.2.1  
  
shadow패키지는 password를 다루는 프로그램을 포함한 패키지.  
  
  
### 6.25.1. Installation of Shadow  
  
  
- __group 프로그램 , man page설치 비활성__    
  
```sh  
 $ sed -i 's/groups$(EXEEXT) //' src/Makefile.in  
 $ find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;  
```  
coreutil에서 더 좋은 버전을 설치할 것임.  
  
  
- __default crypt 대신 SHA512 으로 설정__    
  
```sh  
 $ sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \  
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs  
```  
  
  
- __etc/useradd 파일 수정__    
  
```sh  
 $ sed -i 's/1000/999/' etc/useradd  
```  
  
- __Prepare Shadow for compilation__    
  
```sh  
 $ ./configure --sysconfdir=/etc --with-group-name-max-length=32  
```  
  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
- __passwd파일  /bin으로 이동__    
  
```sh  
 $ mv -v /usr/bin/passwd /bin  
```  
더 적절한 경로  
  
  
  
  
### 6.25.2. Configuring Shadow    
  
이 패키지는 유져와 그룹을 add, modify 삭제 할수 있는 유틸리티를 포함한다.  
  
  
- __shadowed password를 설정하기 위해__    
  
```sh  
 $ pwconv  
```  
  
  
- __shadowed group password 설정__    
  
```sh  
 $ grpconv  
```  
  
  
  
### 6.25.3. Setting the root password  
  
Choose a password for user root and set it by running:  
  
- __root계정을위한 password설정__    
  
```sh  
 $ passwd root  
```  
  
  
  
  
  
  
  
  
## 6.26. Psmisc-22.21  
  
실행중인 프로세스에대한 정보를 보여주는 프로그램 포함.  
  
### 6.26.1. Installation of Psmisc  
  
  
- __Prepare Psmisc for compilation__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
- __FHS를 만족하는 경로로 이동__    
  
```sh  
 $ mv -v /usr/bin/fuser   /bin  
 $ mv -v /usr/bin/killall /bin  
```  
  
  
  
  
  
  
  
  
  
## 6.27. Procps-ng-3.3.10  
  
프로세스 모니터링 프로그램  
ps도 여기서 깔림  
  
### 6.27.1. Installation of Procps-ng  
  
  
- __Prepare procps-ng for compilation__    
  
```sh  
 $ ./configure --prefix=/usr                           \  
	     --exec-prefix=                          \  
	     --libdir=/usr/lib                       \  
	     --docdir=/usr/share/doc/procps-ng-3.3.10 \  
	     --disable-static                        \  
	     --disable-kill  
```  
  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
- __test suite__    
  
```sh  
 $ sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp  
 $ make check  
```  
  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
  
- __/usr가 마운트되지 않았을때 찾을 수 있는 경로로 변경__    
  
```sh  
 $ mv -v /usr/bin/pidof /bin  
 $ mv -v /usr/lib/libprocps.so.* /lib  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so  
```  
  
  
  
  
  
  
  
## 6.28. E2fsprogs-1.42.12  
  
ext2, ext3, ext4 파일시스템을 다루는 유틸리티  
  
6.28.1. Installation of E2fsprogs  
  
First, fix a potential security issue identified upstream:  
  
- __잠재적 보안이슈 수정.__    
  
```sh  
 $ sed -e '/int.*old_desc_blocks/s/int/blk64_t/' \  
    -e '/if (old_desc_blocks/s/super->s_first_meta_bg/desc_blocks/' \  
    -i lib/ext2fs/closefs.c  
```  
패치대신 소스파일 직접 수정..?  
  
  
- __build디렉토리 생성__    
  
```sh  
 $ mkdir -v build  
 $ cd build  
```  
  
- __Prepare E2fsprogs for compilation__    
  
```sh  
 $ LIBS=-L/tools/lib                    \  
 $ CFLAGS=-I/tools/include              \  
 $ PKG_CONFIG_PATH=/tools/lib/pkgconfig \  
 $ ../configure --prefix=/usr           \  
	--bindir=/bin           \  
	--with-root-prefix=""   \  
	--enable-elf-shlibs     \  
	--disable-libblkid      \  
	--disable-libuuid       \  
	--disable-uuidd         \  
	--disable-fsck  
```  
  
  
  
  
  
  
  
  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
  
- __test suite__    
  
```sh  
 $ ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib  
 $ make LD_LIBRARY_PATH=/tools/lib check  
```  
> (에러발생) 아래와같이 나왔지만 그냥 진행.    
```  
150 tests succeeded	2 tests failed  
Tests failed: f_boundscheck i_e2image   
Makefile:338: recipe for target 'test_post' failed  
make[1]: *** [test_post] Error 1  
make[1]: Leaving directory '/sources/e2fsprogs-1.42.12/build/tests'  
Makefile:372: recipe for target 'check-recursive' failed  
make: *** [check-recursive] Error 1  
```  
> /밑에 다지우고 다시 6장부터 시작하니 에러발생안함.    
5장 /tools제작할때 쓰인 source밑에 압축풀린 디렉토리를 제거하지 않고 사용한게 문제였는듯.  
  
  
- __설치__    
  
```sh  
 $ make install  
```  
  
- __Install the static libraries and headers__    
  
```sh  
 $ make install-libs  
```  
  
  
- __디버깅 심볼을 나중에 지울수 있게 w권한줌__    
  
```sh  
 $ chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a  
```  
  
  
- __압축해제__    
  
```sh  
 $ gunzip -v /usr/share/info/libext2fs.info.gz  
 $ install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info  
```  
  
- __documentation 생성__    
  
```sh  
 $ makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo  
 $ install -v -m644 doc/com_err.info /usr/share/info  
 $ install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info  
```  
  
  
  
  
  
  
  
  
  
## 6.29. Coreutils-8.23  
  
기본 시스템의 유틸리티 설치  
  
  
  
- __패치 적용__    
  
```sh  
 $ patch -Np1 -i ../coreutils-8.23-i18n-1.patch   
 $ touch Makefile.in  
```  
  
  
- __prepare Coreutils for compilation__    
  
```sh  
 $ FORCE_UNSAFE_CONFIGURE=1 ./configure \  
            --prefix=/usr            \  
	    --enable-no-install-program=kill,uptime  
```  
  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
> (에러발생) make -j2로 했었음.  
```  
  GEN      man/cp.1  
  help2man: cant get --help info from man/cp.td/cp  
  Try `--no-discard-stderr if option outputs to stderr  
  Makefile:14065: recipe for target 'man/cp.1' failed  
  make[2]: *** [man/cp.1] Error 127  
```  
> 경로 지우고 다시 make시도 -> 그래도 안됨 (man/cp.1에서 에러남)  
Makefile에서 아래와같이 수정하고  make -j1으로 다시 빌드.  
run_help2man = $(PERL) -- $(srcdir)/man/help2man --no-discard-stderr    
http://golfreeze.packetlove.com/smileboard/index.php?action=printpage;topic=701.0  
> -> 여기서부터 / 밑에 다 지우고 다시시작  
  
>> /밑에 다지우고 다시 6장부터 시작하니 에러발생안함.    
5장 /tools제작할때 쓰인 source밑에 압축풀린 디렉토리를 제거하지 않고 사용한게 문제였는듯.  
  
  
- __test suite__    
  
```sh  
 $ make NON_ROOT_USERNAME=nobody check-root  
```  
> 이제부터 테스트를 하기위해 nobody 유져를 생성하여 진행.  
``(찾아보기)`` 왜 nobody유져로 테스트를 해야하는지?    
  
- __/etc/group 수정__    
  
```sh  
 $ echo "dummy:x:1000:nobody" >> /etc/group  
```  
  
``(찾아보기)`` nobody user란?    
  
  
- __현재 디렉토리부터 nobody로 권한줌 (테스트용)__    
  
```sh  
 $ chown -Rv nobody .   
```  
> ls -al 해보면 모든 디렉토리가 nobody root로 바뀜.  
  
- __run the tests__    
  
```sh  
 $ su nobody -s /bin/bash \  
          -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"  
```  
> nobody로 bash쉘에 로그인해서 make check실행  
``(찾아보기)`` 끝나면 자동으로 nobody에서 root로 변경?    
  
- __Remove the temporary group__    
  
```sh  
 $ sed -i '/dummy/d' /etc/group  
```  
> make check가 정상적으로 완료되면 임시로 생성하였던 그룹 제거(nobody)  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
- __FHS에 맞게 유틸리티 위치시킴__    
  
```sh  
 $ mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin  
 $ mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin  
 $ mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin  
 $ mv -v /usr/bin/chroot /usr/sbin  
 $ mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8  
 $ sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8  
```  
  
  
- __아래는 루트 파티션의 부트스트립트와 관련된 패키지__    
  
```sh  
 $ mv -v /usr/bin/{head,sleep,nice,test,[} /bin  
```  
> Some of the scripts in the LFS-Bootscripts package depend on head, sleep, and  
nice. As /usr may not be available during the early stages of booting, those  
binaries need to be on the root partition:    
  
  
  
  
  
  
  
  
  
  
  
  
## 6.30. Iana-Etc-2.30  
  
### 6.30.1. Installation of Iana-Etc  
  
  
- __빌드__    
  
```sh  
 $ make  
```  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
> 이후에 /etc/protocols 와 /etc/services 가 생김.  
> ``(찾아보기)`` /etc/protocols 와 /etc/services 의 역할??  
> /etc/protocols    
Describes the various DARPA Internet protocols that are available from the TCP/IP subsystem    
/etc/services    
Provides a mapping between friendly textual names for internet services, and their underlying assigned port numbers and protocol types    
  
  
  
  
  
  
  
  
  
  
## 6.31. M4-1.4.17  
The M4 package contains a macro processor.  
  
  
- __Prepare M4 for compilation__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
- __빌드__    
  
```sh  
 $ make  
```  
  
- __test suite__    
  
```sh  
 $ make check  
```  
:  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
## 6.32. Flex-2.5.39  
  
text에서 패턴을 인식하는 프로그램 생성을 위한 패키지  
  
  
- __bison을 필요로 하는 regression test 스킵__    
  
```sh  
 $ sed -i -e '/test-bison/d' tests/Makefile.in  
```  
  
  
- __Prepare Flex for compilation__    
  
```sh  
 $ ./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.5.39  
```  
  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
  
- __To test the results (about 0.5 SBU)__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
- __lex 심링크 생성__    
  
```sh  
 $ ln -sv flex /usr/bin/lex  
```  
> lex 로 많이 씀.  
  
  
  
  
  
  
  
  
  
  
  
## 6.33. Bison-3.0.4  
  
### 6.33.1. Installation of Bison  
  
  
- __Prepare Bison for compilation__    
  
```sh  
 $ ./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4  
```  
  
  
- __Compile the package__    
  
```sh  
 $ make  
```  
  
- ____    
  
```sh  
 $ make check  
```  
> (주의) 6.32 flex에서 모르고 make install을 안했더니 아래와 같은 에러뜸.  
> 정말로 flex 쳐봤더니 명령어가 없음. 다시 돌아가서 make install실행하니 정상.  
```  
g++: error: ./examples/calc++/calc++-scanner.cc: No such file or directory  
g++: fatal error: no input files  
compilation terminated.  
```  
``(참고)`` http://thread.gmane.org/gmane.linux.lfs.support/37684  
  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
  
  
  
## 6.34. Grep-2.21  
  
The Grep package contains programs for searching through files.  
  
  
- __잠재적 보안이슈 수정__    
  
```sh  
 $ sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c  
```  
  
  
- __Prepare Grep for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr --bindir=/bin  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
- __To test the results__    
  
```sh  
 $ make check  
```  
  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
  
  
  
## 6.35. Readline-6.3  
  
  
The Readline package is a set of libraries that offers command-line editing and history capabilities.  
  
### 6.35.1. Installation of Readline  
  
First install some patches to fix various bugs that have been addressed upstream:  
  
- __버그 수정__    
  
```sh  
 $ patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch  
```  
> upstream에서 진행되었었던.  
  
  
  
- __몇몇 버그 발생 가능성 수정__    
  
```sh  
 $ sed -i '/MV.*old/d' Makefile.in  
 $ sed -i '/{OLDSUFF}/c:' support/shlib-install  
```  
> Reinstalling Readline will cause the old libraries to be moved to <libraryname>.old. While this is normally not a problem, in some cases it can trigger a linking bug in ldconfig. This can be avoided by issuing the following two seds:  
  
  
  
- __Prepare Readline for compilation__    
  
```sh  
 $ ./configure --prefix=/usr --docdir=/usr/share/doc/readline-6.3  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make SHLIB_LIBS=-lncurses  
```  
  
  
- __test suite는 패키지에 포함 안되어있음__  
  
  
  
- __Install the package:__    
  
```sh  
 $ make SHLIB_LIBS=-lncurses install  
```  
  
  
- __dynamic library 보다 적절한 위치로 이동, 몇몇 심링크 수정__    
  
```sh  
 $ mv -v /usr/lib/lib{readline,history}.so.* /lib  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so  
```  
  
  
- __install the documentation:__    
  
```sh  
 $ install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3  
```  
  
  
  
  
  
  
  
## 6.36. Bash-4.3.30  
  
  
  
- __버그 패치 적용__    
  
```sh  
 $ patch -Np1 -i ../bash-4.3.30-upstream_fixes-1.patch  
```  
  
  
- __Prepare Bash for compilation__    
  
```sh  
 $ ./configure --prefix=/usr                    \  
	--bindir=/bin                    \  
	--docdir=/usr/share/doc/bash-4.3.30 \  
	--without-bash-malloc            \  
	--with-installed-readline  
```  
> configure를 바로 전에 설치한 readline 라이브러리를 사용하는것으로 지정.  
  
  
- __빌드__    
  
```sh  
 $ make  
```  
  
  
  
- __nobody user로 현재 경로 소유권 지정__    
  
```sh  
 $ chown -Rv nobody .  
```  
> nobody 유져가 현재 소스트리를 write할 수 있어야함  
  
  
- __nobody user로 test진행__    
  
```sh  
 $ su nobody -s /bin/bash -c "PATH=$PATH make tests"  
```  
> ``(찾아보기)`` make check를 nobody로 진행하는 이유는?  
  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
  
- __설치한 새 bash로 로그인__    
  
```sh  
 $ exec /bin/bash --login +h  
```  
  
  
  
  
  
  
  
  
  
  
## 6.37. Bc-1.06.95  
  
The Bc package contains an arbitrary precision numeric processing language.  
  
  
- __코드의 일부 memory leaks수정 패치적용__    
  
```sh  
 $ patch -Np1 -i ../bc-1.06.95-memory_leak-1.patch  
```  
  
  
  
- __Prepare Bc for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr           \  
	--with-readline         \  
	--mandir=/usr/share/man \  
	--infodir=/usr/share/info  
```  
> Bc도 configure를 바로 전에 설치한 readline 라이브러리를 사용하는것으로 지정.  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __bc test__    
  
```sh  
 $ echo "quit" | ./bc/bc -l Test/checklib.b  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
  
## 6.38. Libtool-2.4.6  
The Libtool package contains the GNU generic library support script. It wraps the complexity of using shared libraries in a consistent, portable interface.  
  
  
  
  
- __Prepare Libtool for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results (about 11.0 SBU), issue:__    
  
```sh  
 $ make check  
```  
> make check 시  
이런 에러가 남 automake이후에 다시 하면 없어질 거라고함.  
>>   
```  
Makefile:2459: recipe for target 'check-local' failed  
make[3]: *** [check-local] Error 1  
make[3]: Leaving directory '/sources/libtool-2.4.6'  
Makefile:1897: recipe for target 'check-am' failed  
make[2]: *** [check-am] Error 2  
make[2]: Leaving directory '/sources/libtool-2.4.6'  
Makefile:1606: recipe for target 'check-recursive' failed  
make[1]: *** [check-recursive] Error 1  
make[1]: Leaving directory '/sources/libtool-2.4.6'  
Makefile:1899: recipe for target 'check' failed  
make: *** [check] Error 2  
```  
  
  
- __Install the package:__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
## 6.39. GDBM-1.11  
  
The GDBM package contains the GNU Database Manager.  
  
### 6.39.1. Installation of GDBM  
  
  
- __Prepare GDBM for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr --enable-libgdbm-compat  
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
  
  
  
  
  
  
  
  
## 6.40. Expat-2.1.0  
  
The Expat package contains a stream oriented C library for parsing XML.  
  
### 6.40.1. Installation of Expat  
  
  
- __Prepare Expat for compilation:__    
  
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
 $ install -v -dm755 /usr/share/doc/expat-2.1.0  
 $ install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.1.0  
```  
  
  
  
  
  
  
  
## 6.41. Inetutils-1.9.2  
  
The Inetutils package contains programs for basic networking.  
  
### 6.41.1. Installation of Inetutils  
  
  
- __적절한 빌드를 위해 ifconfig를 허용하도록 정의 추가__    
  
```sh  
 $ echo '#define PATH_PROCNET_DEV "/proc/net/dev"' >> ifconfig/system/linux.h   
```  
  
  
- __Prepare Inetutils for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr  \  
	--localstatedir=/var   \  
	--disable-logger       \  
	--disable-whois        \  
	--disable-servers  
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
  
  
  
- __Move some programs so they are available if /usr is not accessible:__    
  
```sh  
 $ mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin  
 $ mv -v /usr/bin/ifconfig /sbin  
```  
  
  
  
  
  
  
  
  
  
  
  
  
## 6.42. Perl-5.20.2  
  
  
The Perl package contains the Practical Extraction and Report Language.  
  
### 6.42.1. Installation of Perl  
  
  
- __Perl confituration파일이 참고하는 /etc/hosts 파일 생성__    
  
```sh  
 $ echo "127.0.0.1 localhost $(hostname)" > /etc/hosts  
```  
  
  
- __perl이 시스템에 설치된 라이브러리 사용 하도록__    
  
```sh  
 $ export BUILD_ZLIB=False  
 $ export BUILD_BZIP2=0  
```  
  
- __configure__    
  
```sh  
 $ sh Configure -des -Dprefix=/usr                 \  
			   -Dvendorprefix=/usr           \  
			   -Dman1dir=/usr/share/man/man1 \  
			   -Dman3dir=/usr/share/man/man3 \  
			   -Dpager="/usr/bin/less -isR"  \  
			   -Duseshrplib  
```  
  
  
- __Compile the package:__    
  
```sh  
 $ make  
```  
  
  
- __To test the results (approximately 2.5 SBU)__    
  
```sh  
 $ make -k test  
```  
  
  
- __Install the package and clean up:__    
  
```sh  
 $ make install  
 $ unset BUILD_ZLIB BUILD_BZIP2  
```  
  
  
  
  
  
  
  
## 6.43. XML::Parser-2.44  
The XML::Parser module is a Perl interface to James Clark`s XML parser, Expat.  
  
### 6.43.1. Installation of XML::Parser  
  
  
  
- __Prepare XML::Parser for compilation:__    
  
```sh  
perl Makefile.PL  
```  
  
  
- __Compile the package:__    
  
```sh  
make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
make test  
```  
  
  
- __Install the package:__    
  
```sh  
make install  
```  
  
  
  
  
  
  
## 6.44. Autoconf-2.69  
  
The Autoconf package contains programs for producing shell scripts that can automatically configure source code.  
  
  
  
- __Prepare Autoconf for compilation:__    
  
```sh  
./configure --prefix=/usr  
```  
  
  
- __Compile the package:__    
  
```sh  
make  
```  
  
  
- __To test the results, issue:__    
  
```sh  
make check  
```  
> check 5개 에러발생 그러나 정상임  
(In addition, one test fails due to changes in libtool-2.4.3 and later.)  
  
  
  
- __Install the package:__    
  
```sh  
make install  
```  
  
  
  
  
  
  
  
  
  
## 6.45. Automake-1.15  
  
The Automake package contains programs for generating Makefiles for use with Autoconf.  
  
### 6.45.1. Installation of Automake  
  
  
  
- __Prepare Automake for compilation:__    
  
```sh  
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15  
```  
  
  
- __Compile the package:__    
  
```sh  
make  
```  
  
- __test suite__    
  
```sh  
sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh  
make -j4 check  
```  
  
  
- __Install the package:__    
  
```sh  
make install  
```  
  
  
  
  
