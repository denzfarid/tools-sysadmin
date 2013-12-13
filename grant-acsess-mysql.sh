#!/bin/bash
#denfarid
  
EXPECTED_ARGS=4
E_BADARGS=65
MYSQL=`which mysql`
  
Q1="grant all on $1.* to $2@'$3' IDENTIFIED BY '$4';"
Q2="show grants for $2@'$3';"
SQL="${Q1}${Q2}"
  

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 dbname dbuser ipaddress dbpass"
  echo "egg: $0 blog root 127.0.0.7 1234"
  exit $E_BADARGS
fi
$MYSQL -uroot  -e "$SQL"
echo "Successfull!"
