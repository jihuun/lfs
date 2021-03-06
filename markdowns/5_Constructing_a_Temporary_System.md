# 5. Constructing a Temporary System

<!-- toc -->


## 5.1. Introduction
HOST 시스템에서 lfs시스템 제작에 사용할 패키지 빌드하기.  

## 5.2. Toolchain Technical Notes

패키지의 설치 기본 구조는
먼저 configure 를 실행하여( --옵션들을 필요에 맞게 설정하여) Makefile을 만들고,  
make 실행하여 소스코드를 빌드하고 make install 을 하여 빌드생성물을 $PATH/로 복사한다.  
Binutils의 ./configure를 실행하면 다음의 순서대로 설치.  

### 5.2.1. Bintutils 

현재 시스템이 어떤건지 확인하는 방법.
```sh
 $ ./config.quess
```
압축이 풀린 Binutils 패키지 디렉토리에 있는 config.guess를 실행하면 현재 시스템의 정보다 나온다.($LFS_TGT 와는 조금 다르게 출력됨)  
바이너리는 그 시스템에서 동작하도록 빌드되어야 하기 때어야 하기 때문에 중요.  
./configure 를 통해서 시스템의 적합한  Makefile을 만드는동안 어셈블러와 링커가 설치된다.   
Binutils install은 어셈블러와 링커를 /tools/bin 와 /tools/$LFS_TGT/bin 두 경로에 설치한다.  
각각의 디렉토리는 서로 hard link 되어있다.  

### 5.2.2. GCC
Binutils 다음에 설치할 패키지는 GCC이다.  
configure를 실행할때 다음의 문구가 나오는것을 확인.  
더이상 $PATH 를 참조하지 않고 /tools/ 에서 찾아서 실행함을 확인.  
```sh
 $ checking what assembler to use... /tools/i686-pc-linux-gnu/bin/as
 $ checking what linker to use... /tools/i686-pc-linux-gnu/bin/ld
```

### 5.2.3. Linux header

### 5.2.4. Glibc
그 다음에 설치할 패키지는 Glibc이다.

### 5.2.5. Binutils - Pass 2
바뀐 ld라이브러리 지정?

### 5.2.6. GCC - Pass 2
gcc에게 새로운 dynamic linker를 사용한다고 알려줌.


## 5.3. General Compilation Instructions

- __각각의 패키지 빌드는 다음의 규칙을 따른다.__  

>1. /mnt/lfs/sources/ 에있는 패키지 소스를 /mnt/lfs/tools로 옮기지 말기.
2. /mnt/lfs/sources/ 디렉토리로 이동.
3. 각 패키지는 각각 다음의 순서대로 작업.
  a. tar를 이용 각 패키지를 압축 해제 
  	(현재 User가 lfs이어야 함)
  b. 패키지의 압축해제된 디렉토리로 이동.
  c. 다음에 진행할 각 패키지별 빌드방법대로 수행.
  d. /mnt/lfs/sources/ 다시 디렉토리로 이동.
  e. $LFS/sources/내의 <패키지이름>-build/ 디렉토리 제거


## 5.4. Binutils-2.25 - Pass 1

Binutils 패키지는 build에 필요한
linker, assembler, object파일을 다루기 위한 툴들이 포함된 패키지이다.


- __build 위한 Makefile 생성용 디렉토리 생성.__  

```sh
 $ mkdir -v ../binutils-build
 $ cd ../binutils-build
```

- __빌드 사전준비__  
  configure 시스템에 맞는 옵션과 함께  스크립트 실행

```sh
 $ ../binutils-2.25/configure		\
	--prefix=/tools			\
	--with-sysroot=$LFS		\
	--with-lib-path=/tools/lib	\
	--target=$LFS_TGT		\
	--disable-nls			\
	--disable-werror
```
\전에는 공백이 있어야함.  
/binutils-build/ 내에 Makefile 생성된것 확인.  

옵션
--prefix=/tools  
/tools 에 설치하는것으로 설정  

--with-sysroot=$LFS  
빌드 시스템이 $LFS(/mnt/lfs)안에서 필요한 타겟 시스템 라이브러리를 찾으라고 설정하는 옵션  

--with-lib-path=/tools/lib  
linker가 설정될 때 사용할 라이브러리 경로 지정  

--target=$LFS_TGT  
$LFS_TGT 와 config.guess가 return하는 결과가 조금 다르기 때문에 configure 스크립트로 크로스 링커를 만들기 위해 $LFS_TGT 값을 Binutils 빌드시스템(Makefile)에 적용하라는 의미  

--disable-nls  
다국어지원옵션 끄기.  

--disable-werror  
warnning에 의해 빌드가 멈추는것을 막음.  


- __빌드__  

```sh
 $ make
```
해도 아직 /tools 에는 아무것도 없음  
``(찾아보기)`` make 와 make install의 차이?  
make : 소스코드로부터 빌드  
make install : 빌드된 바이너리를 실행가능한 경로로 복사.(PATH)  
[참고사이트](https://robots.thoughtbot.com/the-magic-behind-configure-make-make-install)

- __디렉터리 생성__  

```sh
 $ case $(uname -m) in
 $   x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
 $ esac
```
/tools/lib 생성 , /tools/lib64는 lib을 가리키게 함.
mkdir: created directory '/tools/lib' 
'/tools/lib64' -> 'lib'  
근데 lib이 뭥미? 경로?  


- __빌드__  

```sh
 $ make install
```
/tools/ 밑에 뭐가 많이 생김. -> make 에서 빌드된 바이너리들이 /tools 로 복사된것. 

- __binutils-build/ 삭제__  



## 5.5. GCC-4.9.2 - Pass 1

GNU 컴파일러 모음.

gcc 압축해제 후 이동.
```sh
 $ tar -jxvf gcc-4.9.2.tar.bz2
 $ cd gcc-4.9.2/
```


- __gcc에 필요한 패키지 압축해제__  

```sh
 $ tar -xf ../mpfr-3.1.2.tar.xz
 $ mv -v mpfr-3.1.2 mpfr
 $ tar -xf ../gmp-6.0.0a.tar.xz
 $ mv -v gmp-6.0.0 gmp
 $ tar -xf ../mpc-1.0.2.tar.gz
 $ mv -v mpc-1.0.2 mpc
```

- __gcc의 dynamic linker를 /tools에 있는것으로 변경__  
  gcc의 탐색 경로인 /usr/include도 제거

```sh
 $ for file in \
 $    $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
 $ do
 $    cp -uv $file{,.orig}
 $    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
 $        -e 's@/usr@/tools@g' $file.orig > $file
 $    echo '
 $ #undef STANDARD_STARTFILE_PREFIX_1
 $ #undef STANDARD_STARTFILE_PREFIX_2
 $ #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
 $ #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
 $     touch $file.orig
 $ done
```
``(찾아보기)`` 어떤의미인지  
[찾아보기사이트](https://wiki.kldp.org/wiki.php/LFS/Preparation#s-4.1)  
[찾아보기사이트](http://linuxfromscratch.org/lfs/view/stable/chapter05/gcc-pass1.html)  

- __스택보호 하도록 gcc/configure 수정__  

```sh
 $ sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
```
gcc는 스택보호를 정확히 하지 못함.  
옵션  
-i : 파일 변경 (gcc/configure)  
sed '/AAA/aBBB' 의미  
AAA문자열 을 찾아서 그 밑에 BBB 삽입  
-> "k prot" 는 "stack protect" 를 찾기위한 문자열   
그 아래 gcc_cv_libc_provides_ssp=yes 문장 삽입.  


- __gcc-build 생성__  

```sh
 $ mkdir -v ../gcc-build
 $ cd ../gcc-build
```


- __congigure 실행__  

```sh
 $ ../gcc-4.9.2/configure                               \
	--target=$LFS_TGT                                \
	--prefix=/tools                                  \
	--with-sysroot=$LFS                              \
	--with-newlib                                    \
	--without-headers                                \
	--with-local-prefix=/tools                       \
	--with-native-system-header-dir=/tools/include   \
	--disable-nls                                    \
	--disable-shared                                 \
	--disable-multilib                               \
	--disable-decimal-float                          \
	--disable-threads                                \
	--disable-libatomic                              \
	--disable-libgomp                                \
	--disable-libitm                                 \
	--disable-libquadmath                            \
	--disable-libsanitizer                           \
	--disable-libssp                                 \
	--disable-libvtv                                 \
	--disable-libcilkrts                             \
	--disable-libstdc++-v3                           \
	--enable-languages=c,c++
```
/gcc-build 에 Makefile생성됨.  
옵션  
[참고사이트](http://linuxfromscratch.org/lfs/view/stable/chapter05/gcc-pass1.html)  


- __빌드__  

```sh
 $ make
```

- __Install the package:__  

```sh
 $ make install
```


- __빌드 디렉토리 삭제__  

```sh
 $ rm -rf gcc-build/
```
	lfs@jihuun:/mnt/lfs/sources$ du -sh gcc-build/
	946M	gcc-build/
이기 때문에 gcc-build/ 를 지워야함.


## 5.6. Linux-3.19 API Headers

리눅스 커널 전체?  or API만? 
커널 API만 추출하기.

### 5.6.1. Installation of Linux API Headers

Linux kernel tarball 내의 c 헤더파일을 사용가능하도록 만들어
리눅스 커널의 API 추출

- __패키지  압축해제__  

```sh
 $ xz -d linux-3.19.tar.xz
 $ tar -xvf linux-3.19.tar
 $ cd linux-3.19/
```
``(참고)`` .tar.xz 압축풀기.
```sh
.tar.xz - 이중으로 압축을 풀어야 함.
압축 해제 (.xz 압축 해제 -> tar 압축 해제)
$ xz -d [압축파일명.tar.xz]
$ tar -xf [압축파일명.tar]
```

- __커널트리의 불필요한 것들 제거__  

```sh
 $ make mrproper
```
``(찾아보기)`` make mrproper의 정확한 의미

- __kernel header 추출__  

```sh
 $ make INSTALL_HDR_PATH=dest headers_install
 $ cp -rv dest/include/* /tools/include
```
-> /tools/include 디렉터리에 
리눅스커널의 /include/의 일부 디렉토리의  헤더파일이 복사됨.  

``(찾아보기)`` 이게 뭐하는 명령인지 알아보기  
``(찾아보기)`` linux API header란?  
``(찾아보기)`` 왜 리눅스 커널의 헤더파일을 사용하는지?  
``(찾아보기)`` /tools/include 의 역할은?  


## 5.7. Glibc-2.21 


메인 C 라이브러리를 포함하는 패키지.  
기본적인 메모리할당, 디렉토리 탐색, 파일 open/close, 파일 read/write, 문자열 처리, 패턴 매칭, 산술연산 등등을 수행. 

### 5.7.1. Installation of Glibc

In some cases, particularly LFS 7.1, the rpc headers were not installed properly.  
 Test to see if they are installed in the host system and install if they are not.  

- __rpc header가 설치되어있는지 확인__  

```sh
 $ if [ ! -r /usr/include/rpc/types.h ]; then
	su -c 'mkdir -pv /usr/include/rpc'
	su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc'
 $ fi
```
설치 안되어있으면 설치  
``(찾아보기)`` rpc header란?  


- __패키지의 32-bit 구조에 영향을 주는 Regression수정__    

```sh
 $ sed -e '/ia32/s/^/1:/' \
    -e '/SSE2/s/^1://' \
    -i  sysdeps/i386/i686/multiarch/mempcpy_chk.S
```


- __-build 디렉토리 생성__  

```sh
 $ mkdir -v ../glibc-build
 $ cd ../glibc-build
```


- __congigure 실행.  컴파일 사전준비__  

```sh
 $ ../glibc-2.21/configure                             \
	--prefix=/tools                               \
	--host=$LFS_TGT                               \
	--build=$(../glibc-2.21/scripts/config.guess) \
	--disable-profile                             \
	--enable-kernel=2.6.32                        \
	--with-headers=/tools/include                 \
	libc_cv_forced_unwind=yes                     \
	libc_cv_ctors_header=yes                      \
	libc_cv_c_cleanup=yes
```
``(찾아보기)`` 옵션 의미 정리하기.
[찾아보기사이트](http://linuxfromscratch.org/lfs/view/stable/chapter05/glibc.html)  


- __빌드__  

```sh
 $ make
```


- __Install the package:__  

```sh
 $ make install
```



- __이시점에서 정상으로 수행되었다면 아래의 대로 나와야함.__  

```sh
 $ echo 'main(){}' > dummy.c
 $ $LFS_TGT-gcc dummy.c
 $ readelf -l a.out | grep ': /tools'
```
위에처럼 하면 error없고 출력은 아래처럼 나와야함.

```sh
[Requesting program interpreter: /tools/lib/ld-linux.so.2]
```

만약 위에처럼 정상이 아니면 뒤돌아가서 왜 이러는지 체크해야함.  
이것이 수정되지 않으면 다음으로의 진행은 무의미함.  

- __정상이면 테스트했던 파일 삭제__  

```sh
 $ rm -v dummy.c a.out
```

- __빌드 디렉토리 삭제__  

```sh
 $ rm -rf glibc-build/
```


## 5.8. Libstdc++-4.9.2

표준 C++ 라이브러리, g++ 컴파일러의 확실한 동작을  위해 필요


- __Libstd++ 은 gcc 소스의 일부이기 때문에 이미 압축해제했던 gcc-4.9.2/ 로이동__  

```sh
 $ cd gcc-4.9.2
```

- __빌드 디렉토리 생성__  

```sh
 $ mkdir -pv ../gcc-build
 $ cd ../gcc-build
```


- __configure 실행__  

```sh
 $ ../gcc-4.9.2/libstdc++-v3/configure \
	--host=$LFS_TGT                 \
	--prefix=/tools                 \
	--disable-multilib              \
	--disable-shared                \
	--disable-nls                   \
	--disable-libstdcxx-threads     \
	--disable-libstdcxx-pch         \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/4.9.2
```
``(찾아보기)`` 옵션 의미 정리하기.  
[찾아보기사이트](http://linuxfromscratch.org/lfs/view/stable/chapter05/gcc-libstdc++.html)  

- __컴파일 libstdc++__  

```sh
 $ make
```

- __Install the 라이브러리__  

```sh
 $ make install
```

- __빌드 디렉토리 삭제__  

```sh
 $ rm -rf gcc-build/
```


## 5.9. Binutils-2.25 - Pass 2  

``(찾아보기)`` binurils의 pass1 과 pass2의 차이??  

Create a separate build directory again:


- __디렉토리 이동__  

```sh
 $ cd binutils-2.25
```
압축해제는 이미 했기때문에 바로 이동.


- __빌드 디렉토리 생성__  

```sh
 $ mkdir -v ../binutils-build
 $ cd ../binutils-build
```


- __Prepare Binutils for compilation:__  

```sh
 $ CC=$LFS_TGT-gcc                \
 $ AR=$LFS_TGT-ar                 \
 $ RANLIB=$LFS_TGT-ranlib         \
   ../binutils-2.25/configure     \
   --prefix=/tools            \
   --disable-nls              \
   --disable-werror           \
   --with-lib-path=/tools/lib \
   --with-sysroot
```
``(찾아보기)`` 옵션 의미 정리하기.  
[찾아보기사이트](http://linuxfromscratch.org/lfs/view/stable/chapter05/binutils-pass2.html)  
옵션
CC=$LFS_TGT-gcc AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib  
이제부터 진짜 binutils의 native 빌드임. 
이전에는 HOST시스템의 tool을 이용해 빌드했는데 이제는 직접빌드한 tool을 이용.  


- __빌드__  

```sh
 $ make
```

- __Install the package:__  

```sh
 $ make install
```



- __Now prepare the linker for the “Re-adjusting” phase in the next chapter:__  

```sh
 $ make -C ld clean
 $ make -C ld LIB_PATH=/usr/lib:/lib
 $ cp -v ld/ld-new /tools/bin
```
(옵션)
-C ld clean  
This tells the make program to remove all compiled files in the ld subdirectory.  

-C ld LIB_PATH=/usr/lib:/lib  
This option rebuilds everything in the ld subdirectory.  
Specifying the LIB_PATH Makefile variable on the command line allows us to override the default value of the temporary tools and point it to the proper final path.  
The value of this variable specifies the linker`s default library search path.  
This preparation is used in the next chapter.  


- __빌드 디렉토리 삭제__  
```sh
 $ rm -rf binutils-build/
```

## 5.10. GCC-4.9.2 - Pass 2  

``(찾아보기)`` gcc의 pass1 과 pass2의 차이?? 왜함?  

pass 1 에서 GCC를 빌드할때는 내부 시스템 헤더가 몇개밖에 설치가 안됐었다.  
그중 하나는 limits.h인데  /tools/include/limits.h에 존재하지만 pass 1 당시에는 이 파일이 없었다.  
그래서 부분적으로 gcc가 설치됐었음.  

- __아래 명령으로 풀버전의 GCC빌드를 위한 모든 헤더 include__  

```sh
 $ cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
```


- __GCC의 기본 dynamic linker를 /tools 에있는것으로 경로변경__  

```sh
 $ for file in \
 $ 	$(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
 $ do
 $ 	cp -uv $file{,.orig}
 $ 	sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
 $ 		-e 's@/usr@/tools@g' $file.orig > $file
 $ 	echo '
 $ #undef STANDARD_STARTFILE_PREFIX_1
 $ #undef STANDARD_STARTFILE_PREFIX_2
 $ #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
 $ #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
 $ 	touch $file.orig
 $ done
```

- __GMP, MPFR, MPC 패키지 unpack__  

```sh
 $ tar -xf ../mpfr-3.1.2.tar.xz
 $ mv -v mpfr-3.1.2 mpfr
 $ tar -xf ../gmp-6.0.0a.tar.xz
 $ mv -v gmp-6.0.0 gmp
 $ tar -xf ../mpc-1.0.2.tar.gz
 $ mv -v mpc-1.0.2 mpc
```


- __gcc-build 디렉토리 생성__  

```sh
 $ mkdir -v ../gcc-build
 $ cd ../gcc-build
```


- __Now prepare GCC for compilation:__  

```sh
 $ CC=$LFS_TGT-gcc                                      \
 $ CXX=$LFS_TGT-g++                                     \
 $ AR=$LFS_TGT-ar                                       \
 $ RANLIB=$LFS_TGT-ranlib                               \
   ../gcc-4.9.2/configure                               \
   --prefix=/tools                                  \
   --with-local-prefix=/tools                       \
   --with-native-system-header-dir=/tools/include   \
   --enable-languages=c,c++                         \
   --disable-libstdcxx-pch                          \
   --disable-multilib                               \
   --disable-bootstrap                              \
   --disable-libgomp
```
``(찾아보기)``  옵션



- __빌드__  

```sh
 $ make -j2
```

- __Install the package:__  

```sh
 $ make install
```

- __gcc의 심볼릭 링크 생성__  

```sh
 $ ln -sv gcc /tools/bin/cc
```

- __이시점에서 정상으로 수행되었다면 아래의 대로 나와야함.__  

```sh
 $ echo 'main(){}' > dummy.c
 $ $LFS_TGT-gcc dummy.c
 $ readelf -l a.out | grep ': /tools'
```
위에처럼 하면 error없고 출력은 아래처럼 나와야함.

```sh
[Requesting program interpreter: /tools/lib/ld-linux.so.2]
```

만약 위에처럼 정상이 아니면 뒤돌아가서 왜 이러는지 체크해야함.  
이것이 수정되지 않으면 다음으로의 진행은 무의미함.  

- __정상이면 테스트했던 파일 삭제__  

```sh
 $ rm -v dummy.c a.out
```

- __빌드 디렉토리 삭제__  

```sh
 $ lfs@jihuun:/mnt/lfs/sources$ du -sh gcc-build/
1.1G	gcc-build/
```
```sh
 $ rm -rf gcc-build/
```

## 5.11. Tcl-8.6.3
### 5.11.1. Installation of Tcl

Tcl : Tool Command Language 가 포함된 패키지  
Tcl, Expect, DejaGNU, Check 는 test suites 를 위한 패키지 이다.  
필수는 아니지만 사용하면 마음이 든든할것.  
test suites는 chap 6에서 본격적으로 사용.  
``(찾아보기)`` test suites가 뭥미?  

- __패키지 압축해제후 이동__  

```sh
 $ tar -zxvf tcl8.6.3-src.tar.gz
 $ cd tcl8.6.3/
```

- __prepare__  

```sh
 $ cd unix
 $ ./configure --prefix=/tools
```

- __Build the package:__  

```sh
 $ make
```

- __Tcl 테스트 방법__  

```sh
 $ TZ=UTC make test
```
필수사항은 아니지만 테스트는 위와같이 함.  
당연히 실패할것임.  
TZ=UTC : time zone to Coordinated Universal Time(UTC)  
TZ환경변수는 chap7 에서 다시 다룰것임.  

- __패키지 인스톨__  

```sh
 $ make install
```

Make the installed library writable so debugging symbols can be removed later:
- __설치된 라이브러리를 쓰기 가능하게 변경.__  

```sh
 $ chmod -v u+w /tools/lib/libtcl8.6.so
```
그러면 나중에 디버깅 심볼 제거 가능.

Install Tcl`s headers. The next package, Expect, requires them to build.
- __Tcl headers 설치.__  

```sh
 $ make install-private-headers
```
``(찾아보기)`` 계속해서 패키지명+header라는놈이 나오는데 뭔지 찾기.
-> 해당 패키지 빌드할때 include 하는 헤더파일을 의미?


- __심볼릭링크 연결__  

```sh
 $ ln -sv tclsh8.6 /tools/bin/tclsh
```


### 5.11.2. Contents of Tcl

본패키지 설치관련 결과물.  
Installed programs:  
tclsh (link to tclsh8.6) and tclsh8.6  
Installed library:  
libtcl8.6.so, libtclstub8.6.a  

간략 설명
tclsh8.6		 The Tcl command shell
tclsh			 A link to tclsh8.6
libtcl8.6.so		 The Tcl library
libtclstub8.6.a		 The Tcl Stub library

## 5.12. Expect-5.45

대화식 프로그램에서 스크립트화된 대화를 수행하기위한 프로그램이 포함


### 5.12.1. Installation of Expect

First, force Expects configure script to use /bin/stty instead of a/usr/local/bin/stty it may find on the host system.  
This will ensure that our test suite tools remain sane for the final builds of our toolchain:  

- __HOST시스템의  /usr/local/bin/stty 대신에 /bin/stty를 사용하도록 수정.__  

```sh
 $ cp -v configure{,.orig}
 $ sed 's:/usr/local/bin:/bin:' configure.orig > configure
```
``(찾아보기)`` cp -v configure{,.orig} <- 의미?

- __configure설정.__  

```sh
 $ ./configure --prefix=/tools       \
	     --with-tcl=/tools/lib \
	     --with-tclinclude=/tools/include
```
(옵션)  
--with-tcl=/tools/lib  
This ensures that the configure script finds the Tcl installation in the temporary tools location instead of possibly locating an existing one on the host system.  

--with-tclinclude=/tools/include  
This explicitly tells Expect where to find Tcl's internal headers.  
Using this option avoids conditions where configure fails because it cannot automatically discover the location of Tcl's headers.  


- __빌드__  

```sh
 $ make
```

- __test suites 실행.__  

```sh
 $ make test
```
결과 아래와같이 나옴. 통과?
all.tcl:	Total	29	Passed	29	Skipped	0	Failed	0
Sourced 0 Test Files.


- __패키지 설치__  

```sh
 $ make SCRIPTS="" install
```
(옵션)
SCRIPTS="" : Expect스크립트 중에서 불필요한 스크립트 설치를 방지함.



### 5.12.2. Contents of Expect

본패키지 설치관련 결과물.
Installed program :		expect
Installed library : 		libexpect-5.45.so

간략 설명
expect :  
Communicates with other interactive programs according to a script  
libexpect-5.45.so :  
Contains functions that allow Expect to be used as a Tcl extension or to be used directly from C or C++ (without Tcl)  

## 5.13. DejaGNU-1.5.2

DejaGNU 는 다른 프로그램을 테스트 할 수 있는 프레임워크를 포함하는 패키지 이다.

### 5.13.1. Installation of DejaGNU

- __configure 실행.__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make install
```
To test the results, issue:

- __결과를 테스트 하기__  

```sh
 $ make check
```
``(찾아보기)`` make check는 또 뭐임?

### 5.13.2. Contents of DejaGNU

본패키지 설치관련 결과물.
Installed program :	runtest

간략 설명
runtest :  
A wrapper script that locates the proper expect shell and then runs DejaGNU Prev  

## 5.14. Check-0.9.14

Check는 C의 단위(unit) 테스트 프레임워크  

### 5.14.1. Installation of Check

- __check컴파일 준비__  

```sh
 $ PKG_CONFIG= ./configure --prefix=/tools
```
PKG_CONFIG 환경변수에 저장하면서 ./configure를 실행하는 명령인듯.  
(옵션)
PKG_CONFIG=  
This tells the configure script to ignore any pkg-config options that may cause the system to try to link with libraries not in the /tools directory.  
- __빌드__  

```sh
 $ make
```

- __test suite 수행__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```


### 5.14.2. Contents of Check

본패키지 설치관련 결과물.
Installed program:	checkmk
Installed library:	libcheck.{a,so}

간략 설명
checkmk :  
Awk script for generating C unit tests for use with the Check unit testing framework  
libcheck.{a,so} :  
Contains functions that allow Check to be called from a test program  

## 5.15. Ncurses-5.9

The Ncurses package contains libraries for terminal-independent handling of character screens.  

### 5.15.1. Installation of Ncurses


- __configure 실행__  

```sh
 $ ./configure --prefix=/tools \
	     --with-shared   \
	     --without-debug \
	     --without-ada   \
	     --enable-widec  \
	     --enable-overwrite
```
(옵션)  

--without-ada  
This ensures that Ncurses does not build support for the Ada compiler which may be present on the host but will not be available once we enter the chroot environment.  

--enable-overwrite  
This tells Ncurses to install its header files into /tools/include, instead of /tools/include/ncurses, to ensure that other packages can find the Ncurses headers successfully.

--enable-widec  
This switch causes wide-character libraries (e.g., libncursesw.so.5.9) to be built instead of normal ones (e.g., libncurses.so.5.9).  
These wide-character libraries are usable in both multibyte and traditional 8-bit locales, while normal libraries work properly only in 8-bit locales.  
Wide-character and normal libraries are source-compatible, but not binary-compatible.  
Compile the package:  

``(찾아보기)`` chroot란? (change root)  
[찾아보기사이트](https://kldp.org/node/30596)  
나중에 lfs의 루트파일시스템을 모두 구축한뒤 chroot 유틸로 /를 변경하여 재부팅 할듯.  


- __빌드.__  

```sh
 $ make
```

- __패키지 설치__  

```sh
 $ make install
```

## 5.16. Bash-4.3.30

The Bash package contains the Bourne-Again SHell.

### 5.16.1. Installation of Bash

- __Prepare Bash for compilation:__  

```sh
 $ ./configure --prefix=/tools --without-bash-malloc
```
--without-bash-malloc  
bash의 malloc함수가 세그멘테이션 fault를 발생시킨다고 알려져 있기때문에, bash의 malloc을 사용하지 않는 옵션. 
이옵션으로 보다 안정적인 Glibc의 malloc을 사용한다.  

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make tests
```
이번 5장의 임시 tool구축에서는 test suite 수행은 필수사항은 아니다.  
그냥 실행해보는거임.  

- __패키지 인스톨__  

```sh
 $ make install
```

- __빌드된 bash를 /tools/bin/sh로 심볼릭 링크 시킴.__  

```sh
 $ ln -sv bash /tools/bin/sh
```

## 5.17. Bzip2-1.0.6
Bzip2 패키지는 압축/해제를 할 수 있는 프로그램을 포함한다.  

### 5.17.1. Installation of Bzip2

- __Bzip2 패키지는 configure스크립트를 갖고있지 않음으로 바로 빌드.__  

```sh
 $ make
```

- __패키지 인스톨__  

```sh
 $ make PREFIX=/tools install
```
``(찾아보기)`` PREFIX=/tools 이 옵션은 왜 make할때 필요하지 않고 make install할때 필요한가?  


## 5.18. Coreutils-8.23

The Coreutils package contains utilities for showing and setting the basic system characteristics.  

### 5.18.1. Installation of Coreutils

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools --enable-install-program=hostname
```
(옵션)
--enable-install-program=hostname  
빌드 및 설치된 바이너리를 위한 hostnae을 설정  
기본은 disable이지만 Perl test suite 에 필요하기 때문에 hostname 설정.  
``(찾아보기)`` hostname 이란?  

- __빌드__  

```sh
 $ make
```


- __test suite__  

```sh
 $ make RUN_EXPENSIVE_TESTS=yes check
```
RUN_EXPENSIVE_TESTS=yes  
parameter tells the test suite to run several additional tests that are considered relatively expensive (in terms of CPU power and memory usage) on some platforms,  
but generally are not a problem on Linux.  

- __Install the package:__  

```sh
 $ make install
```

## 5.19. Diffutils-3.3
파일을 비교하는 프로그램

### 5.19.1. Installation of Diffutils

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.20. File-5.22
file 유틸리티

### 5.20.1. Installation of File

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

``(참고)``
- 설치전  
  lfs@jihuun:/mnt/lfs/sources$ which file /usr/bin/file
- 설치후 (make install 이후)  
  lfs@jihuun:/mnt/lfs/sources/file-5.22$ which file /tools/bin/file  
  file 유틸을 실행할때 실행경로가 make install 이후 달라짐.  
  나머지 패키지들도 다 마찬가지!  


## 5.21. Findutils-4.4.2
find 유틸리티 설치.

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.22. Gawk-4.1.1
text file을 조작할 수 있는 Gawk 유틸리티 설치

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.23. Gettext-0.19.4

gettext 유틸리티 설치.  
The Gettext package contains utilities for internationalization and localization.  
These allow programs to be compiled with NLS (Native Language Support), enabling them to output messages in the user`s native language.  
이번 임시 tool셋팅에서는 gettext에서 3개의 프로그램만 설치한다.  

- __configure 수행__  

```sh
 $ cd gettext-tools
 $ EMACS="no" ./configure --prefix=/tools --disable-shared
```
(옵션)
EMACS="no"  
This prevents the configure script from determining where to install Emacs Lisp files as the test is known to hang on some hosts.  

--disable-shared  
We do not need to install any of the shared Gettext libraries at this time, therefore there is no need to build them.  


- __빌드__  

```sh
 $ make -C gnulib-lib
 $ make -C intl pluralx.c
 $ make -C src msgfmt
 $ make -C src msgmerge
 $ make -C src xgettext
```
msgfmt, msgmerge, xgettext 이 세개의 파일만 빌드한다.


- __msgfmt, msgmerge, xgettext 프로그램 설치.__  

```sh
 $ cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
```

## 5.24. Grep-2.21

grep 유틸리티 설치
The Grep package contains programs for searching through files.

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.25. Gzip-1.6

gzip 유틸리티 설치

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```



``(참고)`` 계속 똑같은 설치법이 반복되서 쉘스크립트로 만듬.
```sh
! /tools/bin/bash
./configure --prefix=/tools
make -j2
make check
make install
​```````````````````
특징은 HOST시스템의 /bin/bash 말고 내가 빌드한 /tools/의 bash를 사용한것.

## 5.26. M4-1.4.17
The M4 package contains a macro processor.


- __configure 실행__  

​```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.27. Make-4.1

Make유틸리티 설치  
The Make package contains a program for compiling packages.  


- __configure 실행__  

```sh
 $ ./configure --prefix=/tools --without-guile
```
--without-guile  
This ensures that Make-4.1 won(')t link against Guile libraries, which may be present on the host system, but won(')t be available within the chroot environment in the next chapter.  

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.28. Patch-2.7.4

patch 유틸리티 설치 
The Patch package contains a program for modifying or creating files by applying a “patch” file typically created by the diff program.  

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```


## 5.29. Perl-5.20.2
The Perl package contains the Practical Extraction and Report Language.  

### 5.29.1. Installation of Perl 

- __configure 실행__  

```sh
 $ sh Configure -des -Dprefix=/tools -Dlibs=-lm
```
``(찾아보기)`` 위의 명령어 의미? configure를 sh로 실행? 왜?  


- __빌드__  

```sh
 $ make
```

- __빌드 생성물 복사__  

```sh
 $ cp -v perl cpan/podlators/pod2man /tools/bin
 $ mkdir -pv /tools/lib/perl5/5.20.2
 $ cp -Rv lib/* /tools/lib/perl5/5.20.2
```

## 5.30. Sed-4.2.2

sed 유틸리티 설치
The Sed package contains a stream editor.


- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.31. Tar-1.28
tar 유틸리티 설치
The Tar package contains an archiving program.


- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.32. Texinfo-5.2

The Texinfo package contains programs for reading, writing, and converting info
pages.

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.33. Util-linux-2.26
The Util-linux package contains miscellaneous utility programs.  
``(찾아보기)`` 이게 뭔 패키지인지?  

### 5.33.1. Installation of Util-linux

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools                \
	     --without-python               \
	     --disable-makeinstall-chown    \
	     --without-systemdsystemunitdir \
	     PKG_CONFIG=""
```
(옵션)  
--without-python  
This switch disables using Python if it is installed on the host system.  
It avoids trying to build unneeded bindings.  

--disable-makeinstall-chown  
This switch disables using the chown command during installation.  
This is not needed when installing into the /tools directory and avoids the necessity of installing as root.  

--without-systemdsystemunitdir  
On systems that use systemd, the package tries to install a systemd specific file to a non-existent directory in /tools.  
This switch disables the unnecessary action.  
PKG_CONFIG=""  
Setting this envronment variable prevents adding unneeded features that may be available on the host.  
Note that the location shown for setting this environment variable is different from other LFS sections where variables are set preceding the command.  
This location is shown to demonstrate an alternative way of setting an environment variable when using configure.  

- __빌드__  

```sh
 $ make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```


## 5.34. Xz-5.2.0

xz 유틸리티 설치  
The Xz package contains programs for compressing and decompressing files.  
It provides capabilities for the lzma and the newer xz compression formats.  
Compressing text files with xz yields a better compression percentage than with the traditional gzip or bzip2 commands.  

- __configure 실행__  

```sh
 $ ./configure --prefix=/tools
```

- __빌드__  

```sh
make
```

- __test suite__  

```sh
 $ make check
```

- __Install the package:__  

```sh
 $ make install
```

## 5.35. Stripping

lfs파티션의 공간은 많지 않기때문에 좀더 확보할 필요가 있다.  
불필요한 부분을 제거하기.  
디버깅 symbol제거  
strip : 오브젝트 파일에서 불필요한 symbol제거하는 유틸리티 그리고 이것은 필수사항은 아님.  

- __strip 으로 디버깅 symbol제거__  

```sh
 $ strip --strip-debug /tools/lib/*
 $ /usr/bin/strip --strip-unneeded /tools/{,s}bin/*
```

- __documentation 제거로 더 공간확보__   

```sh 
 $ rm -rf /tools/{,share}/{info,man,doc} 
```

이시점에서 LFS를 구축하려면 3GB 정도 공간이 필요 


## 5.36. Changing Ownership 

- __앞으로 루트계정으로 변경해서 작업__   

```sh 
 $ sudo -s 
```

아래의 명령으로 권한 변경. 
```sh 
 $ chown -R root:root $LFS/tools 
```
[찾아보기](http://linuxfromscratch.org/lfs/view/stable/chapter05/changingowner.html)


chap5까지의 내용을 ($LFS/tools)  
그리고 차기 LFS를 위해서 $LFS/tools는 백업을 해두는게 좋다.   
chap6에서 $LFS/tools 에 다시 설치할것이므로 변경됨.   



