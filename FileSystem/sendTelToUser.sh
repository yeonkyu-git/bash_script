#!/bin/bash 


### | jq '.result[0].message.from.id
## 메시지를 보내온 유저에게 메시지를 다시 전송한다. 
UPDATE=$(curl https://api.telegram.org/bot5129140102:AAFl3YaKDHPe7mSU3lXIQRwDLTudFW33Ruk/getUpdates | jq '.result')
HOSTNAME=$(hostname)
TEXT="답장이야!!"

for row in $(echo "${UPDATE}" | jq -r '.[] | @base64'); do        
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }
    ID=$(_jq '.message.from.id')

    /root/monitor/tel_send.sh "${HOSTNAME}" "${TEXT}" "${ID}"
done