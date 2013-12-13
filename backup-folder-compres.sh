#!/bin/bash
#simplescript by denzfarid

#spinner
function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)

    local on_success="DONE"
    local on_fail="FAIL"
    local white="\e[1;37m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local nc="\e[0m"

    case $1 in
        start)
            # calculate the column where spinner and status msg will be displayed
            let column=$(tput cols)-${#2}-8
            # display message and position the cursor in $column column
            echo -ne ${2}
            printf "%${column}s"

            # start spinner
            i=1
            sp='\|/-'
            delay=0.15

            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}

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

backup_date=`date +%Y_%m_%d_%H_%M`
read -p "1. Please enter the name of backup file: " Fname
read -p "2. Please enter the folder location: " SFOLD1
read -p "3. Target location to save this backup file: " DFOLD1
read -p "4. Select compress type(zip, tar.gz, tar.bz2, 7z): " COMP1
case $COMP1 in
#zip)zip ${DFOLD1}/${Fname}-${backup_date}.zip $SFOLD1 > /dev/null 2>&1;;
tar.gz) 
start_spinner 'compresing folder please wait...'
sleep 1
tar cvfz ${DFOLD1}/${Fname}-${backup_date}.tar.gz $SFOLD1 > /dev/null 2>&1;;

tar.bz2) 
start_spinner 'compresing folder please wait...'
sleep 1
tar cvfj ${DFOLD1}/${Fname}-${backup_date}.tar.bz2 $SFOLD1 > /dev/null 2>&1;;

7z) 
start_spinner 'compresing folder please wait...'
sleep 1
7za -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on a ${DFOLD1}/${Fname}-${backup_date}.7z $SFOLD1 > /dev/null 2>&1;;

*) echo "Please enter a valid compression(zip, tar.gz, tar.bz2)";exit;;
esac
stop_spinner $?
echo -e "\e[37;41m Backup file created at ${DFOLD1}/${Fname}-${backup_date}.${COMP1}\e8\e[0m"


