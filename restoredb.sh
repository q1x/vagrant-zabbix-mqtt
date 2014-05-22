if [ -d "/vagrant/db" ]; then
 latest=$(ls -tx -w 1 /vagrant/db/*.sql | head -n 1);
 if [ -n "$latest" ]; then
    service zabbix-server stop
    service apache2 stop
    echo "Restoring db $latest"
    mysql -u root -pzabbix zabbix < "$latest"
    service zabbix-server start
    service apache2 start
 fi
fi

