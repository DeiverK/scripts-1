#!/usr/bin/env bash

# set database name and credentials
DB_NAME="mydb"
DB_USER=""
DB_PASS=""

# create the database
mysql --user=$DB_USER --password=$DB_PASS -e "CREATE DATABASE $DB_NAME;"

# create tables
for i in {1..10}; do
  mysql --user=$DB_USER --password=$DB_PASS $DB_NAME -e "CREATE TABLE table$i (id INT AUTO_INCREMENT PRIMARY KEY, data VARCHAR(255));"
done

# generate random data
for i in {1..10}; do
  for j in {1..100}; do
    data=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    mysql --user=$DB_USER --password=$DB_PASS $DB_NAME -e "INSERT INTO table$i (data) VALUES ('$data');"
  done
done
