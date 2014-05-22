#!/bin/bash
timestamp=$(date +%F_%T)
echo backing up database...
mysqldump -u root -pzabbix --add-drop-table zabbix > /vagrant/db/$timestamp.sql

