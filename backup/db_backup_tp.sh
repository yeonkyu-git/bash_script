#!/bin/bash 

# 1. 변수 설정 
HOST=$(/bin/hostname)  # 서버 호스트 네임 
LOG="/tmp/backup.log"  # 백업 스크립트 로그 남길 파일 
PUSH="/root/monitor/tel_send.sh"  # 텔레그램 메시지 푸쉬 스크립트 
DATE=$(/bin/date +%Y.%m.%d)  # 날짜 
BAK_LIST="/etc/nginx /usr/share/nginx/html/www"  # 백업할 디렉터리 
BAK_PATH="/mnt/BACKUP/${HOST}" # 백업이 저장되는 디렉토리
BAK_FILE="${BAK_PATH}/${DATE}_${HOST}.tgz"  # 백업 파일 경로 및 이름 

# 2. 스토리지 마운트 
/bin/mount /mnt 

# 3. 로그 파일 생성 
/bin/touch "${LOG}"

# 4. 백업 디렉토리 확인 
if [ -e "${BAK_PATH}" ]
then 
  # 백업 디렉토리가 존재한다면 
  /bin/echo "백업 디렉토리 존재"
else 
  mkdir -p "${BAK_PATH}"
fi 

## --- 로그 기록 시작 
{

  /bin/echo 
  /bin/echo "=====백업 시작====="
  /bin/date 
  /bin/echo

  # 5. 백업 
  /bin/tar czpPf ${BAK_FILE} ${BAK_LIST}

  ## 백업 파일 정보 
  NAME="$(/bin/ls -al ${BAK_FILE} | awk '{print $9}')"
  SIZE="$(/bin/ls -alth ${BAK_FILE} | awk '{print $5}')"
  /bin/echo "=== 백업 파일 정보 : "
  /bin/echo " | 파일명 : ${NAME} "
  /bin/echo " | 파일크기 : ${SIZE} "

  /bin/echo 
  /bin/echo "=====백업 종료====="
  /bin/date 
  /bin/echo

}>|"${LOG}"
## -- 로그 기록 끝 

# 스토리지 Umount 
/bin/umount /mnt 

"${PUSH}" "${HOST}" "$(/bin/cat ${LOG})"




