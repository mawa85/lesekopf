#!/bin/bash

stty 300 -F /dev/ttyUSB0 1:0:9a7:0:3:1c:7f:15:4:5:1:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0

#MQTT server
ip="192.168.0.10"

#MQTT port
port="1883"

#MQTT user
user=""

#MQTT password
password=""

#MQTT Main Topic
topic="data/energy"

#MQTT Device ID
did="SmartMeter"


declare -A array
#Define Datapoints to send via MQTT
array[Total]="1.8.0("
array[HT]="1.8.1("
array[NT]="1.8.2("
array[kW]="1.25("
array[I1]="31.25("
array[I2]="51.25("
array[I3]="71.25("
array[U1]="32.25("
array[U2]="52.25("
array[U3]="72.25("

#Processing


        ( sleep 1; echo -e "\x2f\x3f\x21\x0d\x0a" > /dev/ttyUSB0 ) &
        while read -t8 line
        do

                for i in "${!array[@]}"
                do
                         key="${array[$i]}"

                        if [[ $line == "$key"* ]] ; then
                                key=${line%'('*}
                                value=${line#*'('}
                                value=${value%'*'*}
                                value=${value%')'*}
                                mosquitto_pub -h $ip -p $port -i $did -u $user -P $password -t "$topic/$key" -m "$value"
                        fi
                done
                #echo $line
        done < /dev/ttyUSB0
exit
