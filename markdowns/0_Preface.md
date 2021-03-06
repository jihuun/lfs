﻿# 0. Preface

<!-- toc -->



##  0.1. 우분투 설치

- 개발 환경 구축
Ubuntu 14.04 samsung sens P580 노트북에  
LFS를 위하여 우분투 새로 설치. 설치시 lfs에서 사용할 파티션 ext4로 20GB 할당.


- Host System Requirements
시스템에 필요한 패키지 확인
아래의 command 터미널에 복붙하여 확인.

## 0.2. 개발환경에 설치된 패키지 버전 확인

```sh 
Cat > version-check.sh << "EOF"
#!/bin/bash
# Simple script to list version numbers of critical development tools

export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
echo "/bin/sh -> `readlink -f /bin/sh`"
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo yacc is `/usr/bin/awk --version | head -n1`
else 
  echo "awk not found" 
fi

gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2-  # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1
xz --version | head -n1

echo 'main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF

bash version-check.sh  
```
> 여기서 패키지가 없으면 일일이 설치하면됨.  
 여기서 cat > version-check.sh << "EOF"  
 EOF  
 형식의 커맨드는 version-check.sh파일에 EOF를 만나기전까지 내용~~~을 삽입하라는 뜻.  


## 0.3. 라이브러리 체크

```sh  
brary-check.sh << "EOF"
#!/bin/bash
for lib in lib{gmp,mpfr,mpc}.la; do
  echo $lib: $(if find /usr/lib* -name $lib|
	       grep -q $lib;then :;else echo not;fi) found
done
unset lib
EOF

bash library-check.sh

jihuun@jihuun:~/project/lfs$ bash library-check.sh
libgmp.la: not found
libmpfr.la: not found
libmpc.la: not found  
```  
> 이렇게 나오지만 상관없음. 모두 없거나 모두 있으면 됨.  
 (The files identified by this script should be all present or all absent, but not only one or two present.)
