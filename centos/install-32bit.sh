#!/bin/sh
ROOT_PATH=$(cd "$(dirname "$0")"; pwd)

rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
yum -y update

#Install and start Nginx

yum -y remove httpd

yum -y install nginx

cp -rf ${ROOT_PATH}/nginx-conf/* /etc/nginx/
chkconfig --add nginx
chkconfig nginx on

#Install php

yum --enablerepo=remi -y install php-cli php php-mcrypt php-devel php-mbstring spawn-fcgi sudo patch libtool libmcrypt-devel libxml2-devel make automake gcc gcc-c++ sudo flex bison wget zlib-devel openssl-devel pcre pcre-devel pcre-devel gd-devel bzip2* libc-client-devel.i386 

#Add script to start-stop-restart fastcgi

cp ${ROOT_PATH}/php-fastcgi/php-fastcgi-exec /usr/bin/php-fastcgi
chmod +x /usr/bin/php-fastcgi

cp ${ROOT_PATH}/php-fastcgi/php-fastcgi-init /etc/init.d/php-fastcgi
chmod +x /etc/init.d/php-fastcgi

chown root:nginx /var/lib/php/session/

chkconfig --add php-fastcgi
chkconfig php-fastcgi on

#Install zend-optimizer
sh ${ROOT_PATH}/atomic.sh
yum -y install php-zend-optimizer

#Install mysql

yum --enablerepo=remi -y install mysql-server php-mysql
chkconfig --add mysqld
chkconfig mysqld on

#Config msyql
mysql_secure_installation

#Install phpmyadmin
yum --enablerepo=remi -y install phpmyadmin

#Run
/etc/init.d/nginx start
/etc/init.d/php-fastcgi start
/etc/init.d/mysqld start
