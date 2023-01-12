#!/usr/bin/env bash

config_file=$1
read_db_config() {
    if [ ! -f "${config_file}" ]; then
        echo "Error: Config file ${config_file} does not exist."
        exit 1
    fi
    while IFS=': ' read key value; do
        case $key in
            "database_name") database_name="$value";;
            "database_user") database_user="$value";;
            "database_pass") database_pass="$value";;
        esac
    done < "${config_file}"
    if [ -z "${database_name}" ] || [ -z "${database_user}" ] || [ -z "${database_pass}" ]; then
        echo "Error: Config file ${config_file} is not formatted correctly, it should have keys database_name, database_user, database_pass."
        exit 1
    fi
}


dump_db() {
    dump_type=$1
    timestamp=$2
    now=$(date +"%Y-%m-%d %T")
    dump_file="${database_name}_${dump_type}_${timestamp}.sql"
    compressed_file="${dump_file}.gz"
    dump_cmd="mysqldump -u${database_user} -p${database_pass} ${database_name}"

    if [ "$dump_type" == "min" ]; then
        dump_cmd="${dump_cmd} --ignore-table=${database_name}.log_*"
    fi

    dump_cmd="${dump_cmd} | gzip -9 > ${compressed_file}"

    log_dump_start "${now}" "${dump_type}" "${compressed_file}"

    eval "${dump_cmd}"

    backup_size=$(du -h "${compressed_file}" | awk '{print $1}')

    log_dump_end "${now}" "${dump_type}" "${compressed_file}" "${backup_size}"
}


log_dump_start() {
    now=$1
    dump_type=$2
    file_name=$3
    echo "${now}: Starting ${dump_type} dump: ${file_name}" >> backup.log
}


log_dump_end() {
    now=$1
    dump_type=$2
    file_name=$3
    size=$4
    echo "${now}: Completed ${dump_type} dump: ${file_name}, Size: ${size}" >> backup.log
}

read_db_config
dump_db full $(date +"%Y%m%d%H%M")
dump_db min $(date +"%Y%m%d%H%M")


# Assumptions 
# 1. procedures or functions are not required to backup. In case they are required, then the command must use --routines
# 2. the script is stored in the same folder as the backups. There is no absolute path for the new created dumps
# 3. required tools are already installed: mysqldump, mysqlclient, gzip and any other tool
# 4. I couldn't find a good method to pipe the dump to two different files. There are chances to pipe to mysql, however, it might require
# resources that depending on the DB size might not be available. That is why at the end I used two different versions of the mysqldump command
# and I call it twice.
# 5. local disk has enough space to store the backups
# 6. the user has enough permissions to login, run the script and store the output files in the local filesystem
# 7. mysql is running in a "server" that can run the script and is not a service like RDS in AWS
# 8. server has enough RAM to keep in memory the dump whereas the file is compressed and stored
# 9. the script assumes that the db.config file is located in the same directory as the script, and that its format is as specified (i.e. "database_name: mydb", "database_user: root", "database_pass: Root")
# if not, the script shows an error
# 10. the script assumes that the log file is located in the same directory as the script
# 11. user take other security measures

# keeping the logs is a good practice when it comes to automated processes, that is why a log file was added.
