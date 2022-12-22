#!/bin/bash
# Script to log connection lost to local gateway in a csv file
# Verison 1; next version will include multiple interfaces at once
# By Vince Winter(vincex.winter@intel.com)
# Last updated on 12/21/2022

### Varibles ###
GATEWAY=$(ip route show 0.0.0.0/0 | awk '{print $3}')
INTERATE=${INTERATE:-10}
LOG_FILE=${LOG_FILE:-~/ping-log.csv}
###

### Functions ###
ping_log(){
while true; do
  ping_cmd
  hostname_ip
  echo -n "$(date), ${HOST_NAME} (${IP_ADDR}), ${PING_RESULTS}" >> "${LOG_FILE}"
  if [ "${PING_EXIT}" -eq 0 ]; then
    echo ", [UP]" >> "${LOG_FILE}"
  else
    echo ", [DOWN]" >> "${LOG_FILE}"
  fi
  sleep "${INTERATE}"
done
}

ping_cmd(){
# fping is used instead of standard ping for better exit codes
if PING_RESULTS=$(fping --retry=1 --addr --name "${GATEWAY}"); then
  PING_EXIT=0
else
  PING_EXIT=1
fi
# This is seperated from the if state so not to effect exit status of fping
PING_RESULTS=$(echo "${PING_RESULTS}" | awk -F ")" '{print $1")"}')
}

hostname_ip(){
HOST_NAME=$(hostname)
IP_ADDR=$(ip route get "${GATEWAY}" | sed -n 's/.*src \([0-9.]\+\).*/\1/p')
}
table_header(){
echo "date/time, local hostname/ip, gateway hostname/ip, Status" >>"${LOG_FILE}"
}
###

table_header
ping_log
