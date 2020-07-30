#!/bin/bash

setup_soft_app() {

	sudo yum update -y
	sudo setenforce 0

	sudo yum install epel-release -y
	sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
	sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-7.noarch.rpm
	sudo yum --enablerepo=remi-php72 install php php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd \
 php-mcrypt php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd -y

	sudo yum install git httpd -y
	sudo systemctl enable httpd

}

setup_server_app() {

	git clone https://github.com/avvppro/IF-108.git
	sudo mkdir IF-108/task1/dtester/dt-api/application/logs IF-108/task1/dtester/dt-api/application/cache
	sudo chmod 766 IF-108/task1/dtester/dt-api/application/logs
	sudo chmod 766 IF-108/task1/dtester/dt-api/application/cache
	sudo mv IF-108/task1/dtester /var/www
	sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled /var/log/httpd/dtester
	sudo su
	sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf

}

setup_virtual_host() {

sudo cat <<_EOF > /etc/httpd/sites-available/dtester.conf
<VirtualHost *:80>
    #    ServerName www.example.com
    #    ServerAlias example.com
    DocumentRoot /var/www/dtester
    ErrorLog /var/log/httpd/dtester/error.log
    CustomLog /var/log/httpd/dtester/requests.log combined
    <Directory /var/www/dtester/>
            AllowOverride All
    </Directory>
</VirtualHost>
_EOF

sudo ln -s /etc/httpd/sites-available/dtester.conf /etc/httpd/sites-enabled/dtester.conf
systemctl restart httpd

}

change_config_database() {


sudo sed -i -e "s/'type'       => 'MySQL'/'type'       => 'PDO'/g" /var/www/dtester/dt-api/application/config/database.php
sudo sed -i -e "s/'hostname'   => 'localhost'/'hostname'   => '10.164.0.10'/g" /var/www/dtester/dt-api/application/config/database.php
sudo sed -i -e "s/'database'   => 'dtapi2'/'database'   => 'dtesterav'/g" /var/www/dtester/dt-api/application/config/database.php
sudo sed -i -e "s/'username'   => 'dtapi'/'username'   => 'userdt'/g" /var/www/dtester/dt-api/application/config/database.php
sudo sed -i -e "s/'password'   => 'dtapi'/'password'   => '6f+w4PXyboSHaI='/g" /var/www/dtester/dt-api/application/config/database.php

sudo sed -i -e "s/'dsn'        => 'mysql:host=192.168.33.100;dbname=dtapi2;charset=utf8'/'dsn'        => 'mysql:host=10.164.0.10;dbname=dtesterav;charset=utf8'/g" /var/www/dtester/dt-api/application/config/database.php

sudo sed -i -e "s/'username'   => 'username'/'username'   => 'userdt'/g" /var/www/dtester/dt-api/application/config/database.php
sudo sed -i -e "s/'password'   => 'passwordQ1@'/'password'   => '6f+w4PXyboSHaI='/g" /var/www/dtester/dt-api/application/config/database.php

}


setup_environment() {
	
	ext_ip=$(curl ifconfig.me)
	sudo sed -i -e "s/192.168.33.200/$ext_ip/g" /var/www/dtester/main-es2015.822a28925ea35161f6aa.js
	sudo sed -i -e "s/192.168.33.200/$ext_ip/g" /var/www/dtester/main-es5.822a28925ea35161f6aa.js
	sudo chown -R apache:apache -R /var/www/dtester/
	sudo chmod 766 -R /var/www/dtester/
}


setup_soft_app
setup_server_app
setup_virtual_host
change_config_database
setup_environment



