# 6. Installing Basic System Software (2)
  
<!-- toc -->

## 6.7. Linux-3.19 API Headers  
  
시스템의C 라이브러리(LFS의Glibc)가 사용하는 API 를 위해서   
리눅스 커널소스의 헤더파일을 사용해야한다.  
  
- __커널 소스의 이전 작업 내용 삭제__    
  
```sh  
 $ make mrproper    
```  
  
  
- __헤더파일 추출__    
  
```sh  
 $ make INSTALL_HDR_PATH=dest headers_install  
 $ find dest/include \( -name .install -o -name ..install.cmd \) -delete  
 $ cp -rv dest/include/* /usr/include  
```  
  
  
  
  
  
  
## 6.8. Man-pages-3.79  
  
- __man page 설치__    
  
```sh  
 $ make install  
```  
  
  
  
  
  
  
## 6.9. Glibc-2.21  
  
Glibc 는 아래의 일을 할 수 있는 기본 C 루틴을 제공.  
allocating memory, searching directories, opening and closing files,   
reading and writing files, string handling, pattern matching, arithmetic 등.  
  
  
### 6.9.1. Installation of Glibc  
  
- __패치 적용__    
  
```sh  
 $ patch -Np1 -i ../glibc-2.21-fhs-1.patch  
```  
FHS-compliant관련 이슈 패치임.  
패치적용은 별거 아니고 해당 패키지에 필요한 패치들 source레벨로 그냥 적용하는것임.  
  
  
- __32-bit arch에 영향을 주는 Regression 수정__    
  
```sh  
 $ sed -e '/ia32/s/^/1:/' \  
    -e '/SSE2/s/^1://' \  
    -i  sysdeps/i386/i686/multiarch/mempcpy_chk.S  
```  
sed 유틸리티로 memcpy_chk.S 파일 내용 수정    
  
  
- __빌드 디렉토리 생성__     
  
```sh  
 $ mkdir -v ../glibc-build  
 $ cd ../glibc-build  
```  
  
  
  
- __Glibc confirue 설정 makefile 생성__    
  
```sh  
 $ ../glibc-2.21/configure    \  
	--prefix=/usr          \  
	--disable-profile      \  
	--enable-kernel=2.6.32 \  
	--enable-obsolete-rpc  
```  
> (에러 발생)  
```  
checking for nm... nm  
configure: error:   
*** These critical programs are missing or too old: gawk  
*** Check the INSTALL file for required versions.  
```  
> (원인)   
/tools 및에 gawk가 없었음.    
5장에서 설치를 안했었다.    
다시 lfs로 로그인 해서 /source/gawk 경로가서 5장대로 make ,make install하면됨.    
(반드시 lfs계정으로 configure, make, make check까지만 수행)     
그러나 5장 마지막에 /tools 의 권한을 root로 바꿨다.    
lfs 로 로그인하면 make install에서 권한이 없어서 /tools 및으로 gawk바이너리를 복사를 못함.    
그래서  make install만 jihuun계정으로 sudo로 해야함.     
그런데 lfs계정으로는 sudo가 안돼서 jihuun계정에서 sudo로 make install함.    
  
> (주의) tools밑의 temp유틸리티는 반드시 lfs계정으로 빌드해야함.     
이유는 gawk를 빌드할때 lfs계정으로하면  PATH가 tools/bin이 우선이기때문에    
tools/밑의 유틸리티를 이용해 빌드한다.     
그렇지않으면 호스트 시스템의 유틸리티와 라이브러리를 사용해 빌드하기때문에     
gawk를 분명/tools/bin/gawk으로 설치했는데도 자꾸 gawk가 없다고 나옴.    
- ldd했을때 라이브러리 자체가/tools/lib 으로 이용.    
```sh  
lfs@jihuun:/mnt/lfs/sources/gawk-4.1.1$ ldd /tools/bin/gawk  
linux-vdso.so.1 (0x00007fffe8bfe000)  
libdl.so.2 => /tools/lib/libdl.so.2 (0x00007f624089b000)  
libm.so.6 => /tools/lib/libm.so.6 (0x00007f6240596000)  
libc.so.6 => /tools/lib/libc.so.6 (0x00007f62401f3000)  
/tools/lib64/ld-linux-x86-64.so.2 (0x00007f6240a9f000)  
```  
>> 아닌듯 계정마다 공유라이브러리 위치는 달랐음.    
  
  
- __패키지 빌드__    
  
```sh  
 $ make  
```  
  
- __Test suite 실행__    
  
```sh  
 $ make check  
```  
> 이제부터 test suite실행을 반드시 해봐야한다.    
> 아래와 같이 몇몇 failure가 발생하는데 관계없음.    
[공식 테스트 로그 확인](http://www.linuxfromscratch.org/lfs/build-logs/7.7/i7-5820K/test-logs/)  
```  
FAIL: posix/tst-getaddrinfo4  
FAIL: posix/tst-getaddrinfo5  
Summary of test results:  
2 FAIL  
2183 PASS  
199 XFAIL  
3 XPASS  
Makefile:321: recipe for target 'tests' failed  
make[1]: *** [tests] Error 1  
make[1]: Leaving directory '/sources/glibc-2.21'  
Makefile:9: recipe for target 'check' failed  
make: *** [check] Error 2  
```  
  
- __필요한 파일 생성__    
  
```sh  
 $ touch /etc/ld.so.conf  
```  
> Glibc가 설치될때 위의 파일이 없으면 경고줌.    
  
  
- __패키지 인스톨__    
  
```sh  
 $ make install  
```  
  
  
- __nscd.conf 파일 생성__    
  
```sh  
 $ cp -v ../glibc-2.21/nscd/nscd.conf /etc/nscd.conf  
 $ mkdir -pv /var/cache/nscd  
```  
``(찾아보기)`` /etc/nscd.conf 의 역할?  
  
  
  
- __Locale 설정__    
  
```sh  
mkdir -pv /usr/lib/locale  
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8  
localedef -i de_DE -f ISO-8859-1 de_DE  
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro  
localedef -i de_DE -f UTF-8 de_DE.UTF-8  
localedef -i en_GB -f UTF-8 en_GB.UTF-8  
localedef -i en_HK -f ISO-8859-1 en_HK  
localedef -i en_PH -f ISO-8859-1 en_PH  
localedef -i en_US -f ISO-8859-1 en_US  
localedef -i en_US -f UTF-8 en_US.UTF-8  
localedef -i es_MX -f ISO-8859-1 es_MX  
localedef -i fa_IR -f UTF-8 fa_IR  
localedef -i fr_FR -f ISO-8859-1 fr_FR  
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro  
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8  
localedef -i it_IT -f ISO-8859-1 it_IT  
localedef -i it_IT -f UTF-8 it_IT.UTF-8  
localedef -i ja_JP -f EUC-JP ja_JP  
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R  
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8  
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8  
localedef -i zh_CN -f GB18030 zh_CN.GB18030  
```  
localedef 유틸리티로 각 locale이 설치됨.  
``(찾아보기)`` localedef 명령어  
  
- __모든 locale설치__    
  
```sh  
 $ make localedata/install-locales  
```  
  
  
  
  
  
  
  
### 6.9.2. Configuring Glibc  
  
  
- __/etc/nsswitch.conf파일 생성__    
  
```sh  
 $ cat > /etc/nsswitch.conf << "EOF"  
## Begin /etc/nsswitch.conf  
  
passwd: files  
group: files  
shadow: files  
  
hosts: files dns  
networks: files  
  
protocols: files  
services: files  
ethers: files  
rpc: files  
  
## End /etc/nsswitch.conf  
EOF  
```  
``(찾아보기)`` /etc/nsswitch.conf 의 역할은?  
  
  
  
- __timezone데이터 설치__    
  
```sh  
 $ tar -xf ../tzdata2015a.tar.gz  
  
 $ ZONEINFO=/usr/share/zoneinfo  
 $ mkdir -pv $ZONEINFO/{posix,right}  
  
 $ for tz in etcetera southamerica northamerica europe africa antarctica  \  
	    asia australasia backward pacificnew systemv; do  
	    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}  
	    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}  
	    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}  
 $ done  
  
 $ cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO  
 $ zic -d $ZONEINFO -p America/New_York  
 $ unset ZONEINFO  
```  
  
  
  
- __local time zone설정__    
  
```sh  
 $ tzselect  
```  
대화식으로 시간 zone설정  
  
Then create the /etc/localtime file by running:  
  
- __/etc/localtime파일 생성__    
  
```sh  
 $ cp -v /usr/share/zoneinfo/<xxx> /etc/localtime  
```  
> <xxx> 는 설치된 이름으로 변경    
  
``(찾아보기)`` /etc/localtime의 역할은?  
  
  
  
  
  
  
### 6.9.3. Configuring the Dynamic Loader  
  
  
``(찾아보기)`` dynamic loader 와 dymaic linker의 차이?  
 dynamic loader : 프로그램이 실행된 이후에 필요한  라이브러리나 바이너리를 메모리에 올려주는 역할?  
 dymaic linker: runtime에 필요한 공유라이브러리를 메모리에 올려주고 link해주는 운영체제의 한 기능?  
 static linker: 컴파일 타임에 라이브러리 포함?  
 다시조사..  
  
- __/etc/ld.so.conf 생성__    
  
```sh  
 $ cat > /etc/ld.so.conf << "EOF"  
## Begin /etc/ld.so.conf  
/usr/local/lib  
/opt/lib  
  
 $ EOF  
```  
> 디폴트 dynamic loader는(/lib/ld-linux.so.2) /lib 그리고 /usr/lib 에서 찾는다.    
그러나 만약 위의 두 경로가 아닌 다른곳에 라이브러리가 있다면,   
/etc/ld.so.conf 에 적어줘야한다.    
  
  
- __라이브러리 path추가__      
  
```sh  
 $ cat >> /etc/ld.so.conf << "EOF"  
## Add an include directory  
include /etc/ld.so.conf.d/*.conf  
  
 $ EOF  
 $ mkdir -pv /etc/ld.so.conf.d  
```  
  
  
  
### 6.9.4. Contents of Glibc  
빌드 생성물 참고. 많음.  
http://linuxfromscratch.org/lfs/view/stable/chapter06/glibc.html  
  
  
  
  
  
  
  
  
  
## 6.10. Adjusting the Toolchain  
  
C 라이브러리가 설치 되었으므로 이전에 임시로 사용했던(/tools) 라이브러리에서   
새 경로로 path지정.  
  
  
- __linker 교체__    
  
```sh  
 $ mv -v /tools/bin/{ld,ld-old}  
 $ mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}  
 $ mv -v /tools/bin/{ld-new,ld}  
 $ ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld  
```  
  
  
- __새 linker를 가리키도록 Gcc spec파일 수정__    
  
```sh  
 $ gcc -dumpspecs | sed -e 's@/tools@@g'                   \  
	-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \  
	-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \  
	`dirname $(gcc --print-libgcc-file-name)`/specs  
```  
  
  
- __빌드 테스트로 dynamic linker 위치 확인__    
  
```sh  
 $ echo 'main(){}' > dummy.c  
 $ cc dummy.c -v -Wl,--verbose &> dummy.log  
 $ readelf -l a.out | grep ': /lib'  
```  
> 결과를 아래와 같아야함.    
```  
[Requesting program interpreter: /lib/ld-linux.so.2]  
```  
  
  
- __Now make sure that we are setup to use the correct startfiles__    
  
```sh  
 $ grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log  
```  
> 결과는 아래와 같아야함.    
```  
/usr/lib/crt1.o succeeded  
/usr/lib/crti.o succeeded  
/usr/lib/crtn.o succeeded  
```  
  
  
- __컴파일러가 올바른 헤더파일을 찾는지 확인__    
  
```sh  
 $ grep -B1 '^ /usr/include' dummy.log  
```  
> 결과는 아래와 같아야함.    
```  
##include <...> search starts here:  
 /usr/include  
```  
  
  
- __새로운 linker가 올바른 탐색 path에 존재하는지 확인__    
  
```sh  
 $ grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'  
```  
> 결과는 아래와 같아야함.    
```  
SEARCH_DIR("/usr/lib")  
SEARCH_DIR("/lib");  
```  
  
  
- __올바른 libc를 사용하는지 확인__    
  
```sh  
 $ grep "/lib.*/libc.so.6 " dummy.log  
```  
> 결과는 아래와 같아야함.    
```  
attempt to open /lib/libc.so.6 succeeded    
```  
64비트 시스템에서는 /lib64/임.    
  
  
- __마지막으로 gcc가 정확한 dynamic linker를 사용하는지 확인__    
  
```sh  
 $ grep found dummy.log  
```  
> 결과는 아래와 같아야함.    
```  
found ld-linux.so.2 at /lib/ld-linux.so.2  
```  
  
  
- __모두 정상이라면 아래파일 제거__    
  
```sh  
 $ rm -v dummy.c a.out dummy.log  
```  
  
  
  
  
  
  
  
  
  
  
## 6.11. Zlib-1.2.8  
  
  
  
  
### 6.11.1. Installation of Zlib  
  
몇 프로그램에서 사용하는 압축/해제 루틴을 포함함.  
  
- __Prepare Zlib for compilation__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
> --profix=/usr 로 변경되었다는 점 주의  
  
  
- __Compile the package__    
  
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
  
  
  
- __공유 라이브러리는 /lib으로 옮겨져야함. __    
  
```sh  
 $ mv -v /usr/lib/libz.so.* /lib  
 $ ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so  
```  
> 그리고 결과 파일인 .so파일도 /usr/lib/으로 링크시킴.    
``(찾아보기)``  /usr/lib  /lib 차이?  
  
  
  
### 6.11.2. Contents of Zlib  
  
설치되는 라이브러리  
libz.{a,so}  
  
``(찾아보기)``  libz란?  
Contains compression and decompression functions used by some programs  
  
  
  
  
  
  
  
  
  
## 6.12. File-5.22  
  
  
### 6.12.1. Installation of File  
  
- __Prepare File for compilation__    
  
```sh  
 $ ./configure --prefix=/usr  
```  
  
  
- __Compile the package__    
  
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
  
  
### 6.12.2. Contents of File  
  
Installed programs: file  
Installed library: libmagic.so  
  
  
  
  
  
  
  
  
  
## 6.13. Binutils-2.25  
  
오브젝트 파일을 다루기위한 linker, assembler, other tool들을 포함.  
  
Verify that the PTYs are working properly inside the chroot environment  
by performing a simple test:  
  
- __chroot환경에서 PTY가 적절하게 동작하는지 확인__    
  
```sh  
 $ expect -c "spawn ls"  
```  
> 결과는 아래와 같아야 함.    
```  
spawn ls  
```  
> 만약 결과가 아래와 같이 나오면 안됨.    
```  
The system has no more ptys.  
Ask your system administrator to create more.  
```  
``(찾아보기)``  PTY란?  
  
  
- __빌드 디렉토리 생성__    
  
```sh  
 $ mkdir -v ../binutils-build  
 $ cd ../binutils-build  
```  
  
- __Prepare 빌드__    
  
```sh  
 $ ../binutils-2.25/configure --prefix=/usr   \  
                           --enable-shared \  
                           --disable-werror  
```  
  
  
- __컴파일__    
  
```sh  
 $ make tooldir=/usr  
```  
  
- __test suite__    
  
```sh  
 $ make -k check  
```  
  
- __패키지 설치__    
  
```sh  
 $ make tooldir=/usr install  
```  
  
  
``(찾아보기)`` 여기서 설치한 링커랑 위에서 설치한 dynamic 링커랑 뭐가 다름?  
dynamic loader?  
  
  
  
  
  
  
## 6.14. GMP-6.0.0a  
  
GMP패키지는 math라이브러리를 포함함.  
  
  
  
- __Prepare GMP for compilation:__    
  
```sh  
 $ ./configure --prefix=/usr \  
            --enable-cxx  \  
    	    --docdir=/usr/share/doc/gmp-6.0.0a  
```  
The meaning of the new configure options:  
  
  
- __컴파일, HTML documentation도 생성__    
  
```sh  
 $ make  
 $ make html  
```  
  
- __Test suite__    
  
```sh  
 $ make check 2>&1 | tee gmp-check-log  
```  
  
  
- __아래 테스트가 통화하는지 확인__    
  
```sh  
 $ awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log  
```  
  
  
- __설치__    
  
```sh  
 $ make install  
 $ make install-html  
```  
  
  
  
  
  
  
  
## 6.15. MPFR-3.1.2  
MPFR패키지는 functions for multiple precision math 를 포함.  
  
  
### 6.15.1. Installation of MPFR  
  
  
- __버그 패치 적용__    
  
```sh  
 $ patch -Np1 -i ../mpfr-3.1.2-upstream_fixes-3.patch  
```  
  
  
- __Prepare MPFR for compilation__    
  
```sh  
 $ ./configure --prefix=/usr        \  
            --enable-thread-safe \  
	    --docdir=/usr/share/doc/mpfr-3.1.2  
```  
  
  
- __빌드__    
  
```sh  
 $ make  
 $ make html  
```  
  
  
- __Test suite__    
  
```sh  
 $ make check  
```  
  
  
- __패키지 설치__    
  
```sh  
 $ make install  
 $ make install-html  
```  
 $   
  
  
  
  
  
  
  
## 6.16. MPC-1.0.2  
  
복잡한 math function을 포함하는 패키지  
  
  
### 6.16.1. Installation of MPC  
  
  
- __Prepare MPC for compilation__    
  
```sh  
 $ ./configure --prefix=/usr --docdir=/usr/share/doc/mpc-1.0.2  
```  
  
  
- __빌드__    
  
```sh  
 $ make  
 $ make html  
```  
  
  
- __Test suite__    
  
```sh  
 $ make check  
```  
  
  
- __패키지 설치__    
  
```sh  
 $ make install  
 $ make install-html  
```  
  
  
  
  
  
  
  
  
## 6.17. GCC-4.9.2  
gcc 패키지는 C, C++ 컴파일러를 포함하는 GNU 컴파일러 모음이다.  
  
  
- __빌드 디렉토리 생성__    
  
```sh  
 $ mkdir -v ../gcc-build  
 $ cd ../gcc-build  
```  
> (주의) chap4에서 만들었던 gcc-build/가 지워져있는지 확인  
  
  
- __gcc빌드 준비__    
  
```sh  
 $ SED=sed                       \  
 $ ../gcc-4.9.2/configure        \  
    --prefix=/usr            \  
    --enable-languages=c,c++ \  
    --disable-multilib       \  
    --disable-bootstrap      \  
    --with-system-zlib  
```  
  
- __빌드__    
  
```sh  
 $ make  
```  
  
- __stack 사이즈 수정__    
  
```sh  
 $ ulimit -s 32768  
```  
> gcc test suite는 스택을 많이 씀.  
  
  
- __Test suite 돌리기__    
  
```sh  
 $ make -k check  
```  
> 에러 발생  
```  
Makefile:2171: recipe for target 'do-check' failed  
make: *** [do-check] Error 2  
make: Target 'check' not remade because of errors.  
```  
> 문제인가 해서 lfs공식 build-log확인해보니 결과가 비슷하게 나온듯.  
http://www.linuxfromscratch.org/lfs/build-logs/7.7/i7-5820K/test-logs/082-gcc-4.9.2  
일단 계속 진행.  
시작할때부터 나오는 아래 에러로그도 정상임.    
```  
make[3]: autogen: Command not found  
Makefile:176: recipe for target 'check' failed  
make[3]: *** [check] Error 127  
make[3]: Leaving directory '/sources/gcc-build/fixincludes'  
Makefile:3416: recipe for target 'check-fixincludes' failed  
make[2]: *** [check-fixincludes] Error 2  
```  
  
> 아래와 같이 에러가 났지만 무시하고 계속진행    
> http://thread.gmane.org/gmane.linux.lfs.support/38010    
> ```sh  
> === g++ tests ===  
>   
> Running target unix  
> FAIL: g++.dg/asan/asan_test.C  -O2  AddressSanitizer_HugeMallocTest Ident((char*)malloc(size))[-1] = 0 output pattern test  
> XPASS: g++.dg/tls/thread_local-order2.C -std=c++11 execution test  
> XPASS: g++.dg/tls/thread_local-order2.C -std=c++1y execution test  
>   
> === g++ Summary ===  
>   
> # of expected passes		88500  
> # of unexpected failures	1  
> # of unexpected successes	2  
> # of expected failures		443  
> # of unsupported tests		3058  
>   
> ```  
  
  
- __위의 테스트 로그는 다음으로 확인__  
  
```sh  
 $ ../gcc-4.9.2/contrib/test_summary  
```  
요약만 보려고하면 | grep -A7 Summ. 하면됨.  
  
  
- __Install the package__    
  
```sh  
 $ make install  
```  
  
  
- __cpp의 심볼릭 링크를 /lib에 생성__    
  
```sh  
 $ ln -sv ../usr/bin/cpp /lib  
```  
  
  
  
- __cc를 gcc로 심볼릭 링크__    
  
```sh  
 $ ln -sv gcc /usr/bin/cc  
```  
> 많은 패키지가 cc를 사용함.  
  
  
- __LTO로 빌드하기 위한 심볼록 링크__    
  
```sh  
 $ install -v -dm755 /usr/lib/bfd-plugins  
 $ ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/4.9.2/liblto_plugin.so /usr/lib/bfd-plugins/  
```  
> Add a compatibility symlink to enable building programs with Link Time  
Optimization (LTO)  
  
  
  
- __정상 빌드 체크__    
  
```sh  
 $ echo 'main(){}' > dummy.c  
 $ cc dummy.c -v -Wl,--verbose &> dummy.log  
 $ readelf -l a.out | grep ': /lib'  
```  
> 결과가 아래와 같이 나와야함. 그런데 안나오는 경우    
> [Requesting program interpreter: /lib/ld-linux.so.2]    
> ```  
>  $ readelf -l a.out     
> ```  
> 해보면 아래와 같이 나오는데 /lib64에 같은내용이 있으므로 정상인것이다.    
> ``(찾아보기)`` readelf 명령어와 elf 파일구조 간단하게 파악해보기.    
>   
> - __readelf -l a.out__  
> 
> ```sh 
> root:/sources/gcc-build# readelf -l a.out   
>   
> Elf file type is EXEC (Executable file)  
> Entry point 0x4003a0  
> There are 8 program headers, starting at offset 64  
>   
> Program Headers:  
>   Type           Offset             VirtAddr           PhysAddr  
>   FileSiz        MemSiz             Flags	       Align  
>   PHDR           0x0000000000000040 0x0000000000400040 0x0000000000400040  
> 		 0x00000000000001c0 0x00000000000001c0  R E    8  
>   INTERP         0x0000000000000200 0x0000000000400200 0x0000000000400200  
> 		 0x0000000000000022 0x0000000000000022  R      1  
>   _[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]_  
>   LOAD           0x0000000000000000 0x0000000000400000 0x0000000000400000  
> 		 0x000000000000064c 0x000000000000064c  R E    200000  
>   LOAD           0x0000000000000650 0x0000000000600650 0x0000000000600650  
> 		 0x0000000000000228 0x0000000000000230  RW     200000  
>   DYNAMIC        0x0000000000000668 0x0000000000600668 0x0000000000600668  
> 		 0x00000000000001d0 0x00000000000001d0  RW     8  
>   NOTE           0x0000000000000224 0x0000000000400224 0x0000000000400224  
> 		 0x0000000000000020 0x0000000000000020  R      4  
>   GNU_EH_FRAME   0x0000000000000524 0x0000000000400524 0x0000000000400524  
> 		 0x0000000000000034 0x0000000000000034  R      4  
>   GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000  
> 		 0x0000000000000000 0x0000000000000000  RW     10  
>   
> Section to Segment mapping:  
>   Segment Sections...  
>   00       
>   01     .interp   
>   02     .interp .note.ABI-tag .hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt .text .fini .rodata .eh_frame_hdr .eh_frame   
>   03     .init_array .fini_array .jcr .dynamic .got .got.plt .data .bss   
>   04     .dynamic   
>   05     .note.ABI-tag   
>   06     .eh_frame_hdr   
>   07      
> ```  
  
  
  
- __올바른 startfile을 사용하는지 확인__    
  
```sh  
 $ grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log  
```  
> 결과는 아래와 같아야함.    
```  
/usr/lib/gcc/i686-pc-linux-gnu/4.9.2/../../../crt1.o succeeded  
/usr/lib/gcc/i686-pc-linux-gnu/4.9.2/../../../crti.o succeeded  
/usr/lib/gcc/i686-pc-linux-gnu/4.9.2/../../../crtn.o succeeded  
```  
  
- __컴파일러가 올바른 헤더파일을 찾는지 확인__    
  
```sh  
 $ grep -B4 '^ /usr/include' dummy.log  
```  
  
- __새 링커가 올바른 path를 찾는지 확인__    
  
```sh  
 $ grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'  
```  
> 결과는 아래와 같아야함.  (x86_64기준)  
```  
SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib64")  
SEARCH_DIR("/usr/local/lib64")  
SEARCH_DIR("/lib64")  
SEARCH_DIR("/usr/lib64")  
SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib")  
SEARCH_DIR("/usr/local/lib")  
SEARCH_DIR("/lib")  
SEARCH_DIR("/usr/lib");  
```  
  
- __올바른 libc를 사용하는지 확인__    
  
```sh  
 $ grep "/lib.*/libc.so.6 " dummy.log  
```  
> 결과는 아래와 같아야함.    
```  
attempt to open /lib/libc.so.6 succeeded  
```  
  
- __마지막으로 gcc가 올바른 dynamic linker를 사용하는지 확인__    
  
```sh  
 $ grep found dummy.log  
```  
> 결과는 아래와 같아야함.    
```  
found ld-linux.so.2 at /lib/ld-linux.so.2  
```  
결과가 이렇게 안나오면 다음으로 진행할 의미없음. 다시돌아가서 찾기.  
  
  
- __모두 정상이라면 아래파일 제거__    
  
```sh  
 $ rm -v dummy.c a.out dummy.log  
```  
  
- __misplaced file이동__    
  
```  
 $ mkdir -pv /usr/share/gdb/auto-load/usr/lib  
 $ mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib  
```  
