#!/bin/bash
stty 300 -F /dev/ttyUSB0 1:0:9a7:0:3:1c:7f:15:4:5:1:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0 
while true
do
  ( sleep 1; echo -e "\x2f\x3f\x21\x0d\x0a" > /dev/ttyUSB0 ) &
  while read -t8 line
  do
    echo $line >> /home/pi/lesekopf/lgread.log
  done < /dev/ttyUSB0

  #Consumption HT
  #the meter was not reset to zero when installed
  BASE=6670
  #the current value
  CURR=`grep -F 1.8.1 /home/pi/lesekopf/lgread.log | awk '{ gsub ("1.8.1\(", "", $0); gsub ("\*kWh\)", "", $0); print }' | sed 's/^0*//' | sed -e 's/\r//g'`
  #the real current value taking non-zero meter into account
  echo "$((CURR - BASE))" > /home/pi/lesekopf/ht.log

  #Consumption NT
  BASE=7832
  CURR=`grep -F 1.8.2 /home/pi/lesekopf/lgread.log | awk '{ gsub ("1.8.2\(", "", $0); gsub ("\*kWh\)", "", $0); print }' | sed 's/^0*//' | sed -e 's/\r//g'`
  echo "$((CURR - BASE))" > /home/pi/lesekopf/nt.log

  #Feed-in
  BASE=12927
  CURR=`grep -F 2.8.0 /home/pi/lesekopf/lgread.log | awk '{ gsub ("2.8.0\(", "", $0); gsub ("\*kWh\)", "", $0); print }' | sed 's/^0*//' | sed -e 's/\r//g'`
  echo "$((CURR - BASE))" > /home/pi/lesekopf/pv.log
  
  rm /home/pi/lesekopf/lgread.log 
  sleep 5m
done
exit

