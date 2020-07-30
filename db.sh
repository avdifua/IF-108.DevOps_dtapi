#!/bin/bash

get_temporary_password() {

        string_with_passw=$(sudo cat /var/log/mysqld.log | grep "A temporary")
        temp_pass="${string_with_passw#*localhost: }"
}

setup_mysql() {

root_db_pass="3osqiN7NDS!%8dGkE"
user_db_pass="6f+w4PXyboSHaI="
echo -e "[client]\npassword=$temp_pass" > ~/.my.cnf
mysql -u root --connect-expired-password <<SQL_QUERY
SET PASSWORD = PASSWORD("$root_db_pass");
CREATE DATABASE dtesterav;
CREATE USER 'userdt'@'%' IDENTIFIED BY "$user_db_pass";
GRANT ALL PRIVILEGES ON dtesterav.* TO 'userdt'@'%';
FLUSH PRIVILEGES;
SQL_QUERY
echo -e "[client]\npassword=$root_db_pass" > ~/.my.cnf
#rm ~/.my.cnf

}

import_data_in_database() {

        wget https://dtapi.if.ua/~yurkovskiy/dtapi_full.sql
        mysql -u root dtesterav < ./dtapi_full.sql
        sudo systemctl restart mysqld
        rm ~/.my.cnf
}

install_requirements() {

        sudo yum update -y
        sudo yum install wget yum-utils -y
        wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
        sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
        sudo yum-config-manager --enable mysql57-community
        sudo yum install mysql-community-server -y
        sudo service mysqld start

}

install_requirements
get_temporary_password
setup_mysql
import_data_in_database

