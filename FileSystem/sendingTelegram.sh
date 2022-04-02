#!/bin/bash 

# telegram bot으로 메시지를 보내는 쉘 스크립트
# 2개의 파라미터가 필요함
# 파라미터가 두개가 안될 경우 사용 방법을 출력하고 스크립트를 종료 
## 1. 서버 호스트 이름 
## 2. 메시지
## 실행결과는 현재 날짜/시각, 서버이름, 지정한 메시지를 텔레그램으로 보냄 

# 파라미터 확인 
if [ $# -ne 2 ]
then
  echo "Usage "
  echo "$0 {HOSTNAME} {MESSAGES}"
  echo
  echo "example) "
  echo "$0 \"cent1\" \"/var/log/nginx 파티션을 확인하시오 \""
  echo
  exit 0
fi

# 텔레그램 봇 관련 정보 
# ID="5158212482"
API_TOKEN="5129140102:AAFl3YaKDHPe7mSU3lXIQRwDLTudFW33Ruk"
URL="https://api.telegram.org/bot${API_TOKEN}/sendMessage"

# 날짜
DATE="$(date "+%Y-%m-%d %H:%M")"

# 보낼 메시지 작성
ID=$3
TEXT="${DATE} [$1] $2"

# 메시지 보내기
curl -s -d "chat_id=${ID}&text=${TEXT}" ${URL} > /dev/null