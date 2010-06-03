#!/bin/sh

ROOT_PATH=$(dirname "$(cd "$(dirname "$0")"; pwd)")
apt-get install php5-cli php5-cgi php5-mysql
apt-get install spawn-fcgi
cp ${ROOT_PATH}php-cgi.conf /etc/default/
cp ${ROOT_PATH}php-cgi /etc/init.d/
chmod +x /etc/init.d/php-cgi
update-rc.d php-cgi defaults