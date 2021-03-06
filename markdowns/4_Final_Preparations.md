
# 4. Final Preparations

<!-- toc -->





## 4.1. Introduction
이번 챕터에서는 권한이 없는 user를 새로 등록할 것이다. HOST시스템의 안전을 위해서, 그리고 그 user를 위한 적절한 빌드환경을 구축한다.


## 4.2. Creating the $LFS/tools Directory

chap5 에서는 LFS시스템을 구축하기 위한 HOST시스템의 tool을 구축한다.  
그 tool들은 $LFS/tools 디렉토리에 설치할 것임.  
chap6에서 컴파일하는 본격적으로 LFS시스템에 필요한 tool들과 분리하기 위해서임.  
나중에 더이상 필요가 없을때 쉽게 삭제하기 위함.  


- __루트권한으로 tools디렉토리 생성__  

```sh
 $ mkdir -v $LFS/tools
```


- __/디렉토리에 tools디렉터리로 symblic link로 연결.__  

```sh
 $ ln -sv $LFS/tools /
```
> ln 사용법 : ln [OPTION]... TARGET... DIRECTORY  
/디렉터리에 TARGET으로 synbolic link 생성되어 /tools로 연결됨.  
``(찾아보기)`` 왜 tools만 생성되나?



## 4.3. Adding the LFS User

root권한으로 로그인하게되면 간단한 실수도로 HOST시스템을 망가트릴 수 있기때문에
패키지등을 빌드할 때 권한이 없는 user로 로그인하는것이 좋다.  
따라서 lfs 이름의 그룹과 user를 추가하고 인스톨과정은 이 계정으로 로그인해 작업한다.  


```sh
 $ groupadd lfs
 $ useradd -s /bin/bash -g lfs -m -k /dev/null lfs
```
> (옵션)  
 -s /bin/bash : lfs유져의 기본 쉘 지정  
 -g lfs : lfs유져를 lfs그룹에 포함.  
 -m :  /home 디렉토리 추가  
 -k /dev/null :   
 lfs : user 이름  

> ``(찾아보기)`` 왜 groupadd도 해야하나? useradd만 해도되지 않나?


- __lfs 유져의 password설정__  

```sh
 $ passwd lfs
```

- __lfs 유저가 $LFS/tools에 access할 수 있도록 권한 설정__  

```sh
 $ chown -v lfs $LFS/tools
```

- __lfs 유저가 $LFS/sources에 access할 수 있도록 권한 설정__  

```sh
 $ chown -v lfs $LFS/sources
```

- __lfs계정으로 로그인__  

```sh
 $ su - lfs
```
>``(찾아보기)`` su 의 의미, - 의 의미  
(substitute user su) su 와 su -차이: `su -` 는 .bash_profile과 .bashrc 를 새로 불러들임  
`su`는 현재 로그인된 유저의 환경설정 변수를 그대로 사용  

>``(찾아보기)`` login shell, non-login shell 이란? 
		로그인 쉘은 .bash_profile호출, 터미널을 열었을때 login물어봄.  
		논-로그인 쉘은 .bashrc호출. 터미널을 열었을때 login없음.  

	아래는 login shell에 해당하는 경우.  
	1. accessing your computer remotely via ssh (or connecting locally with ssh localhost)  
	2. simulating an initial login shell with bash -l (or sh -l)  
	3. simulating an initial root login shell with sudo -i  
	or sudo -u username -i for another non-root user  
	4. authenticating as another non-root user with su - username (and their password)  
	5. using the sudo login command to switch user  
	위의 경우는 4.번에 해당하므로 처음 su - lfs는 할때는 login shell 에 해당함.  




## 4.4. Setting Up the Environment  

- __lfs계정의 bash shell 환경 구축__  

```sh
 $ cat > ~/.bash_profile << "EOF"
 $ exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
 $ EOF
```
lfs계정으로 로그인하면 lfs의 $HOME디렉토리에 있는 .bash_profile실행되어 초기 설정 됨.  
위의 명령을 수행하면 .bash_profile파일이 생성되고 그 파일에 아래 한줄이 추가됨.  

exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash  
이 명령을 수행하면 새로운 환경의 /bin/bash 로 shell을 재구성함.  
(환경변수가 초기화 되며 HOME TERM PS1만 기존의 환경변수 사용)  

``(찾아보기)``.bash_profile 과 .bashrc의 차이  

``(찾아보기)`` PS1, TERM환경변수의 역할?   
> PS1은 쉘 프롬프트 모양을 결정하는 환경변수 참고:http://webdir.tistory.com/105  
TERM(xterm) x윈도우 시스템을 위한 터미널에뮬레이터 

``(찾아보기)`` exec env의 역할?  
> `exec` - execute a file  
`env` - run a program in a modified environment  
`-i` 옵션 : ignore environment 빈 환경으로 다시 시작.  
`env -i /bin/bash` 의 의미 빈환경으로 bash를 다시시작  


- __.bashrc 설정__  

```sh
 $ cat > ~/.bashrc << "EOF"
 $ set +h
 $ umask 022
 $ LFS=/mnt/lfs
 $ LC_ALL=POSIX
 $ LFS_TGT=$(uname -m)-lfs-linux-gnu
 $ PATH=/tools/bin:/bin:/usr/bin
 $ export LFS LC_ALL LFS_TGT PATH
 $ EOF
```
> 새 인스턴스의 쉘은 non-login shell이기 때문에 .bashrc 만 읽는다.  
.bashrc 에 나머지 환경설정.  


> 1. set +h : bash의 hash function 끄기.  
	hash는 실행속도를 줄이기 위해서 util의 이전 PATH 를 기억하고 있음.  
2. umask 022 : 만들어질 새 파일은 소유자만 write할 수 있음.  
	실행,read는 다른 계정도 가능.  
3. LFS=/mnt/lfs  
	lfs마운트 포인트를 환경변수로 등록  
4. LC_ALL=POSIX  
5. LFS_TGT=$(uname -m)-lfs-linux-gnu  
6. PATH=/tools/bin:/bin:/usr/bin  
	사용할 util PATH 지정해 바로 사용할 수 있도록.  
7. export LFS LC_ALL LFS_TGT PATH  
	전역 환경변수로 등록  

> ``(찾아보기)``set 명령어, umask, LC_ALL=POSIX의미,  
``(찾아보기)``위 옵션 의미 더 찾아보기.  
	http://linuxfromscratch.org/lfs/view/stable/chapter04/settingenvironment.html  
	
이것으로 LFS시스템을 구축하기 위한,  
HOST시스템의 임시 tool들을 빌드할 환경이 구축되었다.  



## 4.5. About SBUs
이 문서에서는 각각의 패키지를 컴파일하고 설치하는데 걸리는 시간을 SBU로 나타낸다.  
예를들어 4.5 SBUs 는 어떤 시스템이 Binutil을 컴파일하고 설치하는데 10분이 걸렸다면
예제 패키지를 빌드하는데는 45분정도가 걸릴거라는뜻.


## 4.6. About the Test Suites
컴파일이 정상적으로 되었는지 확인하는 Test Suites가 존재함.
