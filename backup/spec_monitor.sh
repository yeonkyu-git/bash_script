#!/bin/bash 

## CPU, MEM, Disk 체크 후 임계값 넘어가면 텔레그램 메시지 보내기 

# 0. 기본 정보 
HOSTNAME=$(/bin/hostname) # 호스트네임 
PUSH="/root/monitor/tel_send.sh"  # 텔레그램 메시지 푸쉬 스크립트 

# 1. CPU 값 확인 
IDLE_CPU_PERCENT=$(/bin/top -b -n 1 | grep -i cpu\(s\)| awk -F, '{print $4}' | tr -d "%id," | awk -F. '{print $1}')
USED_CPU_PERCENT=$((100-${IDLE_CPU_PERCENT}))
if [ ${USED_CPU_PERCENT} -ge 20 ]
then
  TEXT="${HOSTNAME} 서버의 CPU 사용률이 ${USED_CPU_PERCENT}%로 20%를 초과했습니다."
  "${PUSH}" "${HOSTNAME}" "${TEXT}"
fi

# 2. 메모리 확인 
TOTALMEM=$(free | sed -n '2,2p' | awk '{print$2}')
AVAILABLE=$(free | sed -n '2,2p' | awk '{print$7}')
USED_MEM_PERCENT=$((100*(${TOTALMEM} - ${AVAILABLE})/${TOTALMEM}))

if [ ${USED_MEM_PERCENT} -ge 20 ]
then
  TEXT="${HOSTNAME} 서버의 메모리 사용률이 ${USED_MEM_PERCENT}%로 20%를 초과했습니다."
  "${PUSH}" "${HOSTNAME}" "${TEXT}"
fi


# 3. Disk 용량 확인
TEXT=$(df -h | awk '{
  gsub("%", "");
  USE=$5; MNT=$6;
  if ( USE > 20 )
    print MNT, "파티션이", USE, "%로 20%를 초과하였습니다."
}' | grep -v "^[A-Z]")

if [ ${#TEXT} -gt 1 ]  # 텍스트의 크기가 1바이트 이상인 경우 
then
  "${PUSH}" "${HOSTNAME}" "${TEXT}"
fi







# grep -i 옵션 대문자소문자 구별 안함 
# grep -v 일치하지 않는 것을 선택 
# awk -F 필드 구분 문자 지정 
# tr -d "%id," 문자 삭제 
