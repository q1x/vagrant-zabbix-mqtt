#!/bin/bash
BROKER=192.168.60.20
ZBXSRV=192.168.60.10
HOST=MQTT_BUS
DISCOVERY=mqtt.discovery

# Start listener for host discoveries

mosquitto_sub -h 192.168.60.20 -v -t zabbix/clients/+ | sed --unbuffered -n "s/\(.*\)\/\(.*\)\/\(.*\)\ 1/$HOST $DISCOVERY {\ \"data\":[\ {\ \"{#MQTTHOST}\":\"\3\"\ }\ ]\ } /p" | zabbix_sender -r -z $ZBXSRV -i -


