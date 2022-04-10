#!/bin/bash 

## 1. 변수 설정
HOST=$(/bin/hostname)
LOG="/tmp/backup.log"
PUSH="/root/monitor/tel_send.sh"
DATE=$(/bin/date +%Y.%m.%d)
BAK_LIST="/etc/exports /etc/nfs.conf /etc/nfsmount.conf" ### 백업할 디렉토리/파일을 지정 
BAK_PATH="/mnt/BACKUP/${HOST}"  ### 백업 디렉토리
BAK_FILE="${BAK_PATH}/${DATE}_${HOST}.tgz"  ### 파일명 

## 2. 스토리지에 마운트
/bin/mount /mnt

## 3. 로그 파일 생성 
/bin/touch "${LOG}"

## 4. 백업 디렉토리 확인
if [ -e ${BAK_PATH} ]
then
  # 백업 디렉토리가 존재한다면 
  /bin/echo "백업 디렉토리가 존재합니다."
else
  # 백업 디렉토리가 없으면 생성함 
  /bin/mkdir -p ${BAK_PATH}
fi

## --- 로그 기록 시작 
{
  # 백업 시작 시간 
  /bin/echo
  /bin/echo "=== 백업 시작 시간 : "
  /bin/date
  /bin/echo 

  ## 이전 백업 파일 삭제
  /bin/echo "=== 이전 백업 파일 삭제 :"
  /bin/echo
  /bin/find ${BAK_PATH} -mtime +7 -exec sh -c "ls -1 {}; rm {}" \;
  /bin/echo

  ## 5. 백업 
  # p : 퍼미션 유지 P: 절대경로 유지 
  /bin/tar czpPf "${BAK_FILE}" ${BAK_LIST}

  ## 백업 파일 정보 
  NAME="$(/bin/ls -al "${BAK_FILE}" | awk '{print $9}')"
  SIZE="$(/bin/ls -al "${BAK_FILE}" | awk '{print $5}')"
  /bin/echo "=== 백업 파일 정보 : "
  /bin/echo " | 파일명 : ${NAME} "
  /bin/echo " | 파일크기 : ${SIZE}Byte "
  /bin/echo

  # 백업 종료 시간 
  /bin/echo
  /bin/echo "=== 백업 종료 시간 : "
  /bin/date
  /bin/echo 

}>|"${LOG}"   ## 중괄호 안에 있는 모든 출력이 LOG파일로 들어간다. 
## --- 로그 기록 끝 

## 스토리지에 언마운트 
/bin/umount /mnt

## 텔레그램으로 백업 로그를 전송 
"${PUSH}" "${HOST}" "$(/bin/cat "${LOG}")"

## 로그파일 삭제 
/bin/rm -f "${LOG}"