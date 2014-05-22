#!/bin/bash
# Give this box a name, boxes love names
sed -i 's/127\.0\.1\.1.*precise64/127.0.1.1\tbroker/' /etc/hosts 2>/dev/null
echo "192.168.66.100   ubox1" >> /etc/hosts
echo "192.168.66.101   ubox2" >> /etc/hosts
echo "192.168.66.20   broker" >> /etc/hosts
sed -i 's/precise64/broker/' /etc/hostname 2>/dev/null
hostname -b broker 2>/dev/null
# change to the dutch ubuntu mirror
sed -i 's/us\.archive/nl.archive/' /etc/apt/sources.list 
# Add zbx repo
dpkg -i /vagrant/zabbix-release_2.2-1+wheezy_all.deb
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
# Install packages and configure
apt-get update && apt-get -y install zabbix-agent zabbix-sender zabbix-get vim curl mosquitto mosquitto-clients
#service zabbix-agent restart


