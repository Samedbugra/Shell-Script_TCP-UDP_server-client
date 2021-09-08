#!/usr/bin/env bash

A4="127.1"
A3="127.1"

stop_route(){

pgrep -f "socat udp4-listen:5001,fork STDOUT" | xargs kill 2>/dev/null
pgrep -f "socat tcp4-listen:5001,fork STDOUT" | xargs kill 2>/dev/null
echo -ne "\r\e[31m\e[KBye!\e[0m"
exit 1

}
#TCP_send(){
#set -xv
 #   var=`echo ${1:-$(</dev/stdin)}`  
#    socat - tcp4:$A:20002 <<< "$var"
    
#}
TCP_do(){
#    set -xv
   (socat tcp4-listen:5001,fork STDOUT | \
#   tee -a >(TCP_send) | \
   tee -a >(socat /dev/stdin tcp4:$A4:20002,forever) | \
   xargs -d'\n' -IMSG sh -c  " echo 'ROUTE-->TCP: [MSG] {timestamp:\"'\`date\`'\"}' >> route.txt ")  2>/dev/null 
   
   if test ! $? -eq "0"
   then
        echo "{TCP}A4 e Baglanilamadi"  >> route.txt
    fi


}
UDP_do(){

   (socat udp4-listen:5001,fork STDOUT | \
   tee -a >(socat /dev/stdin udp4:$A3:10001) | \
   xargs -d'\n' -IMSG sh -c  " echo 'ROUTE-->UDP: [MSG] {timestamp:\"'\`date\`'\"}' >> route.txt " ) 2>/dev/null 

    if test ! $? -eq "0"
    then
        echo "{UDP}A3 e Baglanilamadi" >> route.txt
    fi
}

trap stop_route EXIT
trap stop_route SIGHUP
trap stop_route SIGINT
trap stop_route SIGKILL
trap stop_route SIGTERM

UDP_do &
TCP_do & 
while :; do echo -ne "\e[33m\e[K\rPacket Bekleniyor...Use ctrl+c to exit\e[0m";sleep 2;done


