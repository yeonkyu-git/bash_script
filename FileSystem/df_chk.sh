# 파일시스템 용량 초과시 메일보내기 

#!/bin/bash 
str=`df -k | awk {'print $5$6'} | sed '/Use%Mounted/d'`
result="Check "
max=20

for temp in `echo "${str}"`
do

  num=`expr index "${temp}" %` # % 문자의 위치
  value=`expr substr "${temp}" 1 "${num}" | sed 's/%//g'`  # substring 하는데, %를 빼고 숫자만 나오게 하기 

  if [ "${value}" -gt "${max}" ]  # 파일시스템 용량이 max보다 크다면
  then
    length=`expr "${#temp}"`  # 길이 구하기 
    let "start=${num}+1"
    let "count=${length}-${num}+1"
    dir=`expr substr "${temp}" "${start}" "${count}"`  # max보다 큰 파일시스템 명 
    result="${result} [\"${dir}\" used=${value}%]"
    result_bool="true"
  fi
done

if [ "${result_bool}" ] # 파일시스템 용량 초과 일 경우
then
  echo "sending the mail"
  echo "${result}"

  EMAIL="dusrbpoiiij@naver.com"
  EMAILMESSAGE="${result} <`date`>"
  SUBJECT="WARNING!!"
  echo "${EMAILMESSAGE}" /bin/main -s "${SUBJECT}" "${EMAIL}"
else
  echo "good"
fi