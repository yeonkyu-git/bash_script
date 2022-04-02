#!/bin/bash 

# 파티션별 사용량을 확인해서 80% 이ㅇ인 파티션이 있으면 관리자에게 메시지 보냄
# 1. 파션별 사용량 확인
# 2. 크기를 비교해서 처리
# 3. use가 80% 이상이면 관리자에게 메시지
# 4. 80% 미만이면 아무것도 안함 

# TEXT 변수에 보낼 메시지를 작성 
TEXT="$(df -h | \
      awk '{
              gsub("%", ""); 
              USE=$5; MNT=$6; 
              if ( USE > 20 ) 
                print MNT, "파티션이", USE, "%를 사용중입니다."
            }' | \
      grep -v "^[A-Z]")"

HOST="$(hostname)"

# 20% 이상 디스크를 사용하는 파티션이 있을 경우 
# TEXT 수의 내용 (메시지) 를 관리자에게 보냄
if [ ${#TEXT} -gt 1 ]  # 텍스트의 크기가 1바이트 이상인 경우 
then
  /root/monitor/tel_send.sh "${HOST}" "${TEXT}"
fi