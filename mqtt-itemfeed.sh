#!/bin/bash
BROKER=192.168.60.20
ZBXSRV=192.168.60.10

# Start listener for host discoveries

mosquitto_sub -h 192.168.60.20 -v -t zabbix/# | grep --line-buffered -v '^zabbix/clients/' | sed --unbuffered -e 's/^zabbix\///' -e 's/\(.*\)\/\(.*\)/\1\ \2/' | zabbix_sender -r -z $ZBXSRV -i -


