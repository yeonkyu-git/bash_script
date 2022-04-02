#!/bin/bash 

# 오늘 기준 1일이 지난 로그파일 삭제 
# 1. 오늘 기준 3일 지난 로그를 찾기 
# 2. 로그 삭제 
# 3. 로그 삭제가 있는 경우 텔레그램으로 전송 
# 4. 로그 삭제가 없는 경우 텔레그램으로 미전송 

LOGPATH="/var/log/nginx"
HOSTNAME="$(hostname)"
FILES="$(find "${LOGPATH}" -name "*.log" -type f -mtime +1)"



for FILE in ${FILES}
do
  rm -rf ${FILE}
  /root/monitor/tel_send.sh "${HOSTNAME}" "${FILE}을 지웠습니다."
done