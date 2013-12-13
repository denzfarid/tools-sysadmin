#!/bin/bash
#denfarid
#enter your passwd mysql
  
EXPECTED_ARGS=4
E_BADARGS=65
MYSQL=`which mysql`

Q1="create database $1;"
Q2="grant all on $1.* to $2@'$3' IDENTIFIED BY '$4';"
Q3="show grants for $2@'$3';"
PASS="YOUR_PASSWD"

SQL="${Q1}${Q2}${Q3}"
  

if [ $# -ne $EXPECTED_ARGS ]
then
clear
  echo "Usage: $0 dbname dbuser ipaddress dbpass"
  echo "egg: $0 blog root 127.0.0.7 1234"
  exit $E_BADARGS
fi

$MYSQL -uroot -p -e "$SQL"
echo "Successfull!"
