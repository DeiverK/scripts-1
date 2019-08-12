#!/bin/bash

# This script monitors if a job is running and if not, it starts the requiered process.

working_folder="$(pwd)"
log="${working_folder}/running_process.log"

process_name="requiered.job"
let min_pids=1
current_date=$(date +%d-%m-%Y" "%T)

function start_process()
{
    echo "Starting process." >> ${log}
}

countrun=$(ps -ef | grep -i "${process_name}" | grep -v "grep" | wc -l)
if [[ ${countrun} -gt ${min_pids} ]]
then
    echo "There was ${countrun} process running at: ${current_date}" >> ${log}
    exit 0
else
    start_process
    echo "New process just started at: ${current_date}" >> ${log}
fi

exit 0
