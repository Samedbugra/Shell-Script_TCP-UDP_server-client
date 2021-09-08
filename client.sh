#!/usr/bin/env bash

router="127.1"

send_TCP(){

for id in `seq 10`
do 
    local msg="Client tan bir paket var"
    local zaman=$(date) 
    local packet='{id:"181213024", no:"'$id'", msg:"'$msg'", timestamp:"'$zaman'"}'

    socat - tcp4-connect:$router:5001 2>/dev/null  < <(echo $packet)
    if test ! $? -eq 0
    then
        echo "{TCP}-->A2 ye baglanilamadi. Baglantı Reddedildi" >> client.txt
    else
        echo "CLIENT-->{TCP}: {$msg}{$id}{$zaman}"   >> client.txt
    fi
    sleep 0.5
done

}
send_UDP(){

for id in `seq 10`
do 
    local msg="Client tan bir paket var"
    local zaman=$(date)
    local packet='{id:"181213024", no:"'$id'", msg:"'$msg'", timestamp:"'$zaman'"}'

    socat - udp4:$router:5001 2>/dev/null  < <(echo $packet)
    if test ! $? -eq 0
    then
        echo "{UDP}-->A2 ye baglanilamadi . Baglanti Reddedildi" >> client.txt
    else
        echo "CLIENT-->{UDP}: {$msg}{$id}{$zaman}" >> client.txt
    fi
    sleep 0.5
done

}

send_TCP &
send_UDP &
echo -e "\e[32m Packet Gonderiliyor...\e[0m"
