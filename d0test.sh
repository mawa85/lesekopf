#!/bin/bash
stty 300 -F /dev/ttyUSB0 1:0:9a7:0:3:1c:7f:15:4:5:1:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0 

COUNTER=1
while [ $COUNTER -le 5 ]
do
    ( sleep 1; echo -e "\x2f\x3f\x21\x0d\x0a" > /dev/ttyUSB0 ) &
    #sende "/?!" mit Return an Raspi (Udo's Erweiterung + IR-Kopf seriell)
    while read -t8 line
    do
      echo $line # > /home/pi/lgread.log
    done < /dev/ttyUSB0

    while read -t8 line
    do
      echo $line # >> /home/pi/lgread.log
    done < /dev/ttyUSB0

    echo "COUNTER: " $COUNTER
    let COUNTER=COUNTER+1
done

exit
