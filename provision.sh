#!/bin/bash

export ORIGIN_DIR=/home/vagrant


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
