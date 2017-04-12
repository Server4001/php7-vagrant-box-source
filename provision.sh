#!/bin/bash

# export DEBIAN_FRONTEND=noninteractive # TODO : REMOVE.
export ORIGIN_DIR=/home/vagrant

# Add APT repos.
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:nginx/stable
apt-get -y update

# Install pre-reqs.
apt-get install -y git build-essential

# Install PHP 7.1.
apt-get install -y php7.1 php7.1-dev php7.1-common php7.1-cli php7.1-fpm php7.1-curl php7.1-gd php7.1-mcrypt php7.1-readline php7.1-pgsql php7.1-xmlrpc php7.1-json php7.1-sqlite3 php7.1-mysql php7.1-opcache php7.1-bz2 php7.1-xml php7.1-mbstring php7.1-soap php7.1-zip php7.1-intl
mkdir /var/log/www
chown vagrant:vagrant /var/log/www
chown vagrant:vagrant /var/lib/php/sessions

# Install data structures extension.
git clone https://github.com/php-ds/extension /usr/src/php-ds
cd /usr/src/php-ds
phpize
./configure
make install
phpize --clean
cd ${ORIGIN_DIR}

# Add DS extension to PHP7.1.
cp /vagrant/config/php/ds.ini /etc/php/7.1/mods-available
ln -s /etc/php/7.1/mods-available/ds.ini /etc/php/7.1/cli/conf.d/30-ds.ini
ln -s /etc/php/7.1/mods-available/ds.ini /etc/php/7.1/fpm/conf.d/30-ds.ini

# Install Xdebug.
wget -O /usr/src/xdebug-2.4.0rc4.tgz https://xdebug.org/files/xdebug-2.4.0rc4.tgz
cd /usr/src
tar -xvzf xdebug-2.4.0rc4.tgz
rm xdebug-2.4.0rc4.tgz
cd xdebug-2.4.0RC4/
phpize
./configure
make
make install
phpize --clean
cd ${ORIGIN_DIR}

# Add Xdebug to PHP7.1.
cp /vagrant/config/php/xdebug.ini /etc/php/7.1/mods-available # TODO : CHECK THIS.
ln -s /etc/php/7.1/mods-available/xdebug.ini /etc/php/7.1/cli/conf.d/
ln -s /etc/php/7.1/mods-available/xdebug.ini /etc/php/7.1/fpm/conf.d/

# Add PHP-AST extension to PHP7.1.
git clone https://github.com/nikic/php-ast.git /usr/src/php-ast
cd /usr/src/php-ast
phpize
./configure
make
make install
phpize --clean
cd ${ORIGIN_DIR}

# Add PHP-AST to PHP7.1.
cp /vagrant/config/php/ast.ini /etc/php/7.1/mods-available
ln -s /etc/php/7.1/mods-available/ast.ini /etc/php/7.1/cli/conf.d/
ln -s /etc/php/7.1/mods-available/ast.ini /etc/php/7.1/fpm/conf.d/

# PHP config.
# TODO : CHECK THESE
cp /vagrant/config/php/php-cli.ini /etc/php/7.1/cli/php.ini
cp /vagrant/config/php/php-fpm.ini /etc/php/7.1/fpm/php.ini
cp /vagrant/config/php/fpm.conf /etc/php/7.1/fpm/pool.d/www.conf
service php7.1-fpm restart
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
