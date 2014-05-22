#!/bin/bash
# Give this box a name, boxes love names
sed -i "s/127\.0\.1\.1.*precise64/127.0.1.1\t$1/" /etc/hosts 2>/dev/null
sed -i "s/precise64/$1/" /etc/hostname 2>/dev/null
echo "192.168.66.10   zbxserver" >> /etc/hosts
echo "192.168.66.20   broker" >> /etc/hosts
hostname -b $1 2>/dev/null
# install zabbix repo
dpkg -i /vagrant/zabbix-release_2.2-1+wheezy_all.deb
# Add Mosquitto repo
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
# change to the dutch ubuntu mirror
sed -i 's/us\.archive/nl.archive/' /etc/apt/sources.list
# install needed packages
apt-get update && apt-get -y install vim zabbix-agent zabbix-get zabbix-sender apache2 facter facter-customfacts-plugin mosquitto-clients
# configure
fact-add webserver apache2
cp /vagrant/zabbix-agent/facter.conf /etc/zabbix/zabbix_agentd.d/
cp /vagrant/zabbix-agent/zabbix_agentd.conf /etc/zabbix
chown zabbix:zabbix /etc/zabbix/zabbix_agentd.d/*
service zabbix-agent restart
