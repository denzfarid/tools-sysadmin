#!/bin/bash
 
#-----------------------------------------#
# Denzfarid #
# 09.12.13 #
# Dump a database with only the tables #
# containing the prefix given. #
#-----------------------------------------#

clear
echo -e "\e[01;32m                     ,"
echo "                    dM"
echo "                    MMr"
echo "                   4MMML                  ."
echo "                   MMMMM.                xf"
echo "   .              'M6MMM               .MM-"
echo "    Mh..          +MM5MMM            .MMMM"
echo "    .MMM.         .MMMMML.          MMMMMh"
echo "     )MMMh.        MM5MMM         MMMMMMM"
echo "      3MMMMx.     'MMM3MMf      xnMMMMMM'"
echo "      '*MMMMM      MMMMMM.     nMMMMMMP'"
echo "        *MMMMMx    'MMM5M'    .MMMMMMM="
echo "         *MMMMMh   'MMMMM'   JMMMMMMP"
echo "           MMMMMM   GMMMM.  dMMMMMM           ."
echo "            MMMMMM  'MMMM  .MMMMM(        .nnM'"
echo " ..          *MMMMx  MMMP  dMMMM'    .nnMMMMM*"
echo "  'MMn...     'MMMMr 'MM'  MMM'   .nMMMMMMM*'"
echo "   '4MMMMnn..   *MMM  MM' MMP'  .dMMMMMMM''"
echo "     ^MMMMMMMMx.  *ML 'M .M*  .MMMMMM**'"
echo "        *PMMMMMMhn. *x > M  .MMMM**''"
echo "           ''**MMMMhx).h)..=*'"
echo "                    .3P'%...."
echo -e "\e[01;32m                 .nP'     '*MMnx.\n\n"

 
set -e # End the script if any statement returns a non-true return value
set -u # End script if an unset variable is encountered.
 
WD=`pwd`
CURDATE=`date +%F`

sqluser="root"
sqlpass="YOUR_PASSWD"
 
echo "This will dump just the tables with the specified prefix from the specified database."

echo -n "Enter the database name: "
read dbase
 
# Get list of tables with the desired prefix
list=( $(mysql -u$sqluser -p$sqlpass $dbase --raw --silent --silent --execute="SHOW TABLES;") )

# Get List in terminal
for tablenames in ${list[@]}
do
if [[ "$tablenames" ]]; then
tablelists+="$tablenames, "
fi
done
echo
echo "Table prefix list : "
echo
echo "[ $tablelists]"

echo
echo -n "Enter the table prefix (*blank if you choice all): "
read prefix

for tablename in ${list[@]}
do
if [[ "$tablename" =~ $prefix ]]; then
tablelist+="$tablename "
fi
done
 
echo
echo "Here are the tables to be dumped: $tablelist"
 
echo
echo -n "Continue [y/n]:"
read cont
 
if [ "y" == $cont ]; then
`mysqldump -u$sqluser -p$sqlpass --opt $dbase $tablelist > ${dbase}_${prefix}${CURDATE}_BACKUP.sql`
clear
echo -e "\e[37;41m Done! Backup file created at ${WD}/${dbase}_${prefix}${CURDATE}_BACKUP.sql\e8\e[0m"
else
exit 1
fi
 
echo
 
exit 0
