#!/bin/bash
#
# Test to output Zabbix agent data to MQTT.
# The idea is that an MQTT subscriber listening on the MQTT bus can forward
# item data to the Zabbix server.
#

# Set the MQTT Broker to use
BROKER=192.168.60.20

# Program cycle that will be used to update the item values
CYCLE=10		

# Itemskeys to check
CHECKS=agent.ping,system.cpu.load,system.cpu.util

# Get item values from Zabbix Agent running on the localhost
function getval() {
	zabbix_get -s 127.0.0.1 -k "$1"
}

function publish() {
	mosquitto_pub -h $BROKER -t "$1" -m "$2"

}

function publish_r() {
	mosquitto_pub -h $BROKER -r -t "$1" -m "$2"

}

# Get MQTT ID (same as Zabbix hostname)
ID=$(getval system.hostname)

# Put a trap in place in case we exit our loop by signal later on
trap "publish_r zabbix/clients/$ID 0" EXIT


# Loop through publishing item values
while true; do
	echo "Confirming presence with broker ($BROKER)"
	publish_r zabbix/clients/$ID 1
	echo "Sending item values ($CHECKS)"
	for check in $(echo $CHECKS | tr ',' ' '); do
		publish zabbix/$ID/$check $(getval $check)
	done
	echo "Sleep for $CYCLE seconds"
	sleep $CYCLE
done

