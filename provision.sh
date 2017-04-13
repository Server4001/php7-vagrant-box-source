#!/bin/bash

export ORIGIN_DIR=/home/vagrant


update-rc.d php7.1-fpm enable

# Install Nginx.
apt-get install -y nginx
cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
cp /vagrant/config/nginx/www.conf /etc/nginx/conf.d/www.conf
service nginx restart

# Install MySQL.
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server
sudo mysql_install_db

# mysql_secure_installation
export DATABASE_PASS=password
mysqladmin -u root -proot password "$DATABASE_PASS"
mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root'"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Install Beanstalkd.
sudo apt-get update
sudo apt-get install -y beanstalkd
sudo rm /etc/default/beanstalkd
sudo cp /vagrant/config/beanstalkd.conf /etc/default/beanstalkd
sudo service beanstalkd start
sudo update-rc.d beanstalkd enable

# Install Redis
sudo apt-get install -y redis-server
sudo cp /vagrant/config/redis.conf /etc/redis/redis.conf
sudo service redis-server restart
sudo update-rc.d redis-server enable

# Install Memcached.
sudo apt-get install -y memcached
sudo rm /etc/memcached.conf
sudo cp /vagrant/config/memcached.conf /etc/memcached.conf
sudo service memcached restart
sudo update-rc.d memcached enable
sudo apt-get install -y php-memcached

# Web root.
sudo chown -R vagrant:vagrant /var/www

# Install composer
php /vagrant/config/php/composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

# Composer packages.
composer g require psy/psysh:@stable phpunit/phpunit

# Bash.
cp /vagrant/config/bash/profile /home/vagrant/.profile
