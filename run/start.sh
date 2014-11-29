#!/bin/bash

__mysql_config() {
if [ ! -f /var/lib/mysql/mysql/user.MYD ]; then
    echo 'configuring mysql'
    chown -R mysql:mysql /var/lib/mysql
    chown -R mysql:mysql /var/run/mysql
    #mysql_install_db
    chown -R mysql:mysql /var/lib/mysql
    service mysqld start
    MYSQL_PASSWORD='dockermysql'
    mysqladmin -u root password 'dockermysql'
    service mysqld stop
    echo mysql root password: dockermysql
    echo dockermysql > /mysql-root-pw.txt
    sleep 2
fi
}

__mysql_passwd() {

if [ ! -f /mysql-root-pw.txt ]; then
    MYSQL_PASSWORD='dockermysql'
    mysqladmin -u root password 'dockermysql'
    echo mysql root password: dockermysql
    echo dockermysql > /mysql-root-pw.txt
fi
}

__samba () {
    /etc/init.d/smb start
}

__run_supervisor() {
supervisord -n -c /etc/supervisord.conf
}

# Call all functions
__mysql_config
__samba
__run_supervisor
