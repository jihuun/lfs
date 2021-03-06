
# 3. Packages and Patches


<!-- toc -->


## 3.1. Introduction
$LFS/sources 디렉터리를 만들어 이부분에 LFS시스템에서 필요한 유틸리티소스를 저장해놓음.  
나중에 빌드해서 사용. LFS 시스템의 루트 파티션에 저장되는 소스임.  


- __source디렉토리 생성__  

```sh
 $ mkdir -v $LFS/sources
```
> -v 옵션은 대부분 -verbose 옵션이고 실행 상태의 메시지를 출력해준다는 의미이다.  


- __source 디렉토리 권한 설정__  

```sh
 $ chmod -v a+wt $LFS/sources
```
> $LFS/sources 를 Sticky비트로 설정함.  
Sticky비트는 멀티유져가 해당 디렉토리에 쓰기권한을 가져도, 오직 소유자만이 파일을 삭제할수 있는 퍼미션이다.  
chmod a+wt 의미  
>> a : all user  
\+ : 766 이런 숫자가 아닌 문자로 권한설정하는 심볼  
w : write  
t : sticky bit  


- __패키지와 패치 소스 받기.__  

```sh
 $ wget http://linuxfromscratch.org/lfs/view/stable/wget-list
 $ wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
```
> 패키지가 상당히 많아 일일이 받기 어렵다. LFS가이드에 다운받는 주소 리스트가 나와있으며  
(http://linuxfromscratch.org/lfs/view/stable/wget-list)  
이주소를 wget하면 wget-list 파일이 생성되고 페이지내용이 들어있다.  
이 wget-list로 손쉽게 파일들을 wget 이용해 다운로드 할수 있다.   
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources  

- __정상 다운로드 확인__  

```sh
 $ pushd $LFS/sources
 $ md5sum -c md5sums
 $ popd
```
> md5sum 명령 : 올바른 패키지를 받았고 다음진행하기전에 사용가능한지 확인하는 용도로 사용.  
>> ``(찾아보기)`` md5란?  
(Message-Digest algorithm 5) 128bit 암호화 해시 함수 프로그램이 원본 그대로인지 확인하는 무결성 검사 1996년 MD5d의 설계상 결함이 발견되어 암호학자들은 ShA-1와 같이 안전한 알고리즘 사용 권장





## 3.2. All Packages

모든 패키지(version)의 목록  
http://linuxfromscratch.org/lfs/view/stable/chapter03/packages.html  
패치는  
http://linuxfromscratch.org/lfs/view/stable/chapter03/patches.html  

```
Attr (2.4.47) 
Autoconf (2.69) 
Automake (1.15) 
Bash (4.3.30) 
Bc (1.06.95) 
Binutils (2.25) 
Bison (3.0.4) 
Bzip2 (1.0.6) 
Check (0.9.14) 
Coreutils (8.23) 
DejaGNU (1.5.2) 
Diffutils (3.3) 
Eudev (2.1.1) 
Eudev-manpages (2.1.1) 
E2fsprogs (1.42.12) 
Expat (2.1.0) 
Expect (5.45) 
File (5.22) 
Findutils (4.4.2) 
Flex (2.5.39) 
Gawk (4.1.1) 
GCC (4.9.2) 
GDBM (1.11) 
Gettext (0.19.4) 
Glibc (2.21) 
GMP (6.0.0a) 
Gperf (3.0.4) 
Grep (2.21) 
Groff (1.22.3) 
GRUB (2.02~beta2) 
Gzip (1.6) 
Iana-Etc (2.30) 
Inetutils (1.9.2) 
Intltool (0.50.2) 
IPRoute2 (3.19.0) 
Kbd (2.0.2) 
Kmod (19) 
Less (458) 
LFS-Bootscripts (20150222) 
Libcap (2.24) 
Libpipeline (1.4.0) 
Libtool (2.4.6) 
Linux (3.19) 
M4 (1.4.17) 
Make (4.1) 
Man-DB (2.7.1) 
Man-pages (3.79) 
MPC (1.0.2) 
MPFR (3.1.2) 
Ncurses (5.9) 
Patch (2.7.4) 
Perl (5.20.2) 
Pkg-config (0.28) 
Procps (3.3.10) 
Psmisc (22.21) 
Readline (6.3) 
Sed (4.2.2) 
Shadow (4.2.1) 
Sysklogd (1.5.1) 
Sysvinit (2.88dsf) 
Tar (1.28) 
Tcl (8.6.3) 
Texinfo (5.2) 
Time Zone Data (2015a) 
Udev-lfs Tarball (udev-lfs-20140408)
Util-linux (2.26)
Vim (7.4) 
XML::Parser (2.44) 
Xz Utils (5.2.0) 
Zlib (1.2.8) 
```


```md
• ACL
디 렉토리 및 파일에 특정 사용자, 그룹에 특정 권한을 넣어 줄 수 있는 기능
• Attr
파일 시스템 개체에 대한 확장 된 속성을 관리하기 위한 프로그램
• Autoconf
자동으로 소스 프로그램을 설정하는 쉘 스크립트. 완료 후 재설치 요망
• Automake
 Gnu 코딩 표중에 준하는 Makefile을 자동으로 생성해주는 프로그래
• Bash
커맨드 셸의 일종으로 Gnu 프로젝트를 위해 태어남
• Bc
리눅스 계산기 정밀도계산기.
• Binutils
오브젝트 파일을 처리하기위한 링커, 어셈블러, 및 기타 도구가 포함. 바이너리 조작
또는 정보를 보기 위한 프로그램 모음
• Bison
yacc을 컴파일 하기위한 컴파일러. yacc 는 컴파일러 구성을 도와주는
소프트웨어도구
• Bzip2
압축 해제프로그램
• Check
다른 프로그램의 위험을 테스트 하기위한 프로그램 툴체인에만 필요
•Coreutils
기본적인 툴들을 포함하고 있는 프로그램 Ex)cat , ls ,rm etc..
• DejaGNU
다른 어플리케이션을 테스트 하기 위한 프레임워크. 임시 툴체인에만 사용
• Diffutils
diff 명령어를 위한 프로그램
• E2fsprogs
EXT2, EXT3 및 ext4 파일 시스템을 처리하기 위한 유틸리티 
• Eudev
장치 관리자 프로그램. Udev가 무겁기 때문에 생긴 프로그램 디바이스가 추가되거나
시스템으로부터 제거 될 때 동적으로 / dev에 디렉토리 엔트리를 제어
• Expat
XML parser  XML :: 파서 펄 모듈이 필요합니다.
• Expect
telnet이나 ftp와 같이 interactive한 환경이 필요한 곳에서 특정 문자열을
기다리고(expect), 정해진 문자열을 자동으로 보내는(send)등의 처리를 하는
스크립트 언어. 툴체인 시만 필요
• File
file 명령어 지정된 파일의 종류 확인하는 명령어.
• Findutils
find 명령어 빌드 스크립트에서 사용
• Flex
lex을 컴파일하기 컴파일러. lex 컴파일러의 구성을 도와주는 소프트웨어 도구
• Gawk
특정 문자열에서 필요한 정보를 찾기 위한 툴. 빌드스크립트에서 사용
• GCC
GNU 컴팡일러
• GDBM
내부적으로 DB를 전문적으로 처리하는 여러 함수로 구성된 라이브러리
• Gettext
국제화 및 다양한 패키지의 현지화를 위한 유틸리티와 라이브러리 포함
• Glibc
GNU C 라이브러리
• GMP
임의의 크기를 가진 수치를 계산하기 위한 자유 소프트웨어 라이브러리
• Gperf
완벽한  해쉬 함수를 생성 명령어 Eudev에 필요
• Grep
특정한 패턴을 찾는 명령어
• Groff
처리 및 서식 텍스트 프로그램. Man page 작성필시 필요
• GRUB
부트로더
• Gzip
압축프로그램
• Iana-etc
네트워크 서비스와 프로토콜에 대한 데이터를 제공프로그램
• Inetutils
기본 네트워크 관리를 위한 프로그램
• Intltool
소스 파일에서 번역 문자열을 추출하기 위한 프로그램. 다양한 종류의 데이터
파일들을 국제화시키는데 사용되는 유틸리티.
• IProute2
기존 리눅스 시스템에 사용하던 네트웍 관련 툴들을 하나로 묶어 놓은 유틸리티
• KBD
키 테이블 파일, 미국 이외의 키보드를 키보드 유틸리티 및 콘솔 글꼴의 수를
포함하는 프로그램
• KMOD (kernel drive module)
리눅스 커널 모듈을 관리 프로그램
• Less
리눅스용 텍스트 파일 뷰어. Vi와 유사하지만 읽기전용
• Libcap
리눅스 커널에서 사용할 수 있는 POSIX 1003.1e 기능에 대한 사용자 공간
인터페이스를 구현
• Libpipeline
Libpipeline 패키지는 유연하고 편리한 방법으로 서브 프로세스의 파이프 라인을
조작하기 위한 라이브러리
• Libtool
GNU프로그래밍 도구이며 컴파일된 포터블 라이브러리를 만드는데 이용
• LinuxKernel
커널
• M4
매크로 처리 언어.
• Make
파일 관리 유틸리티
• Man-DB
설명서 페이지를 찾아 볼 수있는 프로그램
• Man-page
man page
• MPC
복소수연산 프로그램
• MPFR
multiple-precision floating-pint 라이브러리
• Ncurses
일반 터미널의 콘솔 화면에서 사용자 친화적인 Consol 윈도우 환경을 만들 수 있도록
도와주는 라이브러리 
• Patch
파일을 수정하거나 일반적으로 diff 프로그램에 의해 생성 된 패치 파일을 적용하여
파일을 생성하는 프로그램.
• Perl
런타임 언어 펄 인터프리터
• Pkg-config
소스 코드로부터 소프트웨어를 컴파일할 목적으로 설치된 라이브러리를 조회하기
위해 통일된 인터페이스를 제공하는 컴퓨터 소프트웨어
• Procps-NG
모니터링 프로세스에 대한 프로그램.
• Psmisc
실행중인 프로세스에 대한 정보를 표시하는 프로그램. 
• Readline
명령 줄 인터페이스에서 줄 편집 및 입력 기록 저장 등의 역할을 하는 라이브러리
• Sed
비대화형모드의 줄 단위 편집기. Bash 스크립트에 필요
• Shadow
안전한 방법으로 암호를 처리하기 한 프로그램.
• Sysklogd
로그 파일 만들기 위한 프로그램 시스템 로그 데몬
• Sysvinit
리눅스 시스템의 다른 모든 프로세스의 부모 init 프로그램.
• Tar
압축/해제 프로그램
• Tcl
스크립트 언어
•Texinfo
읽기, 쓰기, 및 정보 페이지를 변환하는 프로그램
• Util - linux  
다양한 유틸리티 프로그램. 시스템, 콘솔, 파티션 및 메시지를 처리하기 위한
유틸리티.
• Vim
편집기
• XML :: Parser
Expat는와 인터페이스 Perl 모듈
• XZ Utils    
압축 파일을 압축 해제 프로그램이 포함되어 있습니다. 그것은 가장 높은 압축은
일반적으로 사용할 수 제공하고 XZ 또는 LZMA 형식으로 패키지를 압축 해제하는 데
유용
• Zlib  
일부 프로그램에서 사용하는 압축 및 압축 해제 루틴을 포함
```

