#!/bin/bash

# This script pings a remote host to check the availability and keeps a log of it

remote_host=""
working_folder="$(pwd)"
log="${working_folder}/availability.log"
let lap=0

while [ ${lap} -lt 360 ]
do
    ping -c1 ${remote_host} > /dev/null
    if [[ $? -eq 0 ]]
    then
        sleep 10s
    else
        current_date=$(date +%d-%m-%Y" "%T)
        echo "The ${remote_host} is not available... Ping failed at: ${current_date}" >> ${log}
    fi
done

exit 0
