#!/bin/bash
# Give this box a name, boxes love names
sed -i 's/127\.0\.1\.1.*precise64/127.0.1.1\tzbxserver/' /etc/hosts 2>/dev/null
echo "192.168.66.100   ubox1" >> /etc/hosts
echo "192.168.66.101   ubox2" >> /etc/hosts
echo "192.168.66.20   broker" >> /etc/hosts
sed -i 's/precise64/zbxserver/' /etc/hostname 2>/dev/null
hostname -b zbxserver 2>/dev/null
# change to the dutch ubuntu mirror
sed -i 's/us\.archive/nl.archive/' /etc/apt/sources.list 
# Add zbx repo
dpkg -i /vagrant/zabbix-release_2.2-1+wheezy_all.deb
# Add Mosquitto repo
apt-get -y install python-software-properties 
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
# preseed
echo mysql-server mysql-server/root_password select zabbix | debconf-set-selections
echo mysql-server mysql-server/root_password_again select zabbix | debconf-set-selections
echo zabbix-server-mysql zabbix-server-mysql/mysql/app-pass password zabbix | debconf-set-selections
echo zabbix-server-mysql zabbix-server-mysql/password-confirm password zabbix | debconf-set-selections
echo zabbix-server-mysql zabbix-server-mysql/app-password-confirm password zabbix| debconf-set-selections
echo zabbix-server-mysql zabbix-server-mysql/mysql/admin-pass password zabbix | debconf-set-selections
echo zabbix-server-mysql zabbix-server-mysql/dbconfig-install boolean true | debconf-set-selections
echo  zabbix-server-mysql zabbix-server-mysql/dbconfig-upgrade boolean true | debconf-set-selections
# Install packages and configure
apt-get update && apt-get -y install zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-sender zabbix-get vim curl mosquitto-clients
sed -i 's/;date.timezone\ =/date.timezone\ =\ Europe\/Amsterdam/' /etc/php5/apache2/php.ini
cp /vagrant/zabbix.conf.php /etc/zabbix/web/
chown www-data:www-data /etc/zabbix/web/zabbix.conf.php
chmod 644 /etc/zabbix/web/zabbix.conf.php
service apache2 restart
# see if we need to restore a db
/vagrant/restoredb.sh
# Setup the LLD example
#service zabbix-agent restart


