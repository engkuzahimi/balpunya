#!/bin/bash

initCount=0
logs=/var/log/suricata/fast.log
msg_caption=/tmp/telegram_msg_caption
chat_id="791863390"
token="2112153783:AAGBfDuVAp8ByvtzMZ2xlRZscszJ_GjpSr8"

function sendAlert
{
    curl -s -F chat_id=$chat_id -F text="$notifikasi" https://api.telegram.org/bot$token/sendMessage #> /dev/null 2&>1

}

while true
do
    lastCount=$(wc -c $logs | awk '{print $1}')
    if(($(($lastCount)) > $initCount));
        then
        msg= $(tail -n 1 $logs) #GetLastLineLog
        echo $msg > $msg_caption #set Caption / Pesan
        #echo -e "Ada Serangan\n\nServer Time : $(date +"%d %b %Y %T")\n\n"$msg > $msg caption #set Caption / Pesan

        caption=$(<$msg_caption) #set Caption
        waktu=$(echo $caption | cut -d "." -f1)
        pesan=$(echo $caption | cut -c 47-1000 |cut -d "!" -f1)
        ip_asal=$(echo $caption | cut -d "}" -f2 | cut -d ":" -f1)
        port_asal=$(echo $caption | cut -d "}" -f2 | cut -d ":" -f2 | cut -d "-" -f1)
        ip_tujuan=$(echo $caption | cut -d "}" -f2 | cut -d ":" -f2 | cut -d ">" -f2)
        port_tujuan=$(echo $caption | cut -d "}" -f2 | cut -d ":" -f3 | cut -d " " -f1)
        notifikasi=$(echo -e $pesan "\n\nWaktu :" $waktu "\nIP Asal :" $ip_asal "\nMelalui Port" $port_asal "\nIP Tujuan: " $ip_tujuan "\nMenuju Port" $port_tujuan)

        sendAlert #Panggil Fungsi di function
        echo "Alert Terkirim"
        initCount=$lastCount
        rm -f $msg_caption
        sleep 1

    fi

done