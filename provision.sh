#!/usr/bin/env bash

# Install PHP7.
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get -y update
sudo apt-get install -y git build-essential
sudo apt-get install -y php7.0 php7.0-dev php7.0-common php7.0-cli php7.0-fpm php7.0-curl php7.0-gd php7.0-mcrypt php7.0-readline php7.0-pgsql php7.0-xmlrpc php7.0-json php7.0-sqlite3 php7.0-mysql php7.0-opcache php7.0-bz2 php7.0-xml php7.0-mbstring php7.0-soap php7.0-zip
sudo mkdir /var/log/www
sudo chown vagrant:vagrant /var/log/www
sudo chown vagrant:vagrant /var/lib/php/sessions

# Install data structures extension.
git clone https://github.com/php-ds/extension "php-ds"
cd php-ds
phpize
./configure
sudo make install
sudo make clean
sudo phpize --clean
cd $HOME

# Add DS extension to PHP7.
sudo cp /vagrant/config/php/ds.ini /etc/php/7.0/mods-available
sudo ln -s /etc/php/7.0/mods-available/ds.ini /etc/php/7.0/cli/conf.d/30-ds.ini
sudo ln -s /etc/php/7.0/mods-available/ds.ini /etc/php/7.0/fpm/conf.d/30-ds.ini

# Install Xdebug.
wget -O ~/xdebug-2.4.0rc4.tgz https://xdebug.org/files/xdebug-2.4.0rc4.tgz
tar -xvzf xdebug-2.4.0rc4.tgz
rm xdebug-2.4.0rc4.tgz
cd xdebug-2.4.0RC4/
phpize
./configure
make
sudo make install
sudo make clean
sudo phpize --clean
cd $HOME

# Add Xdebug to PHP7.
sudo cp /vagrant/config/php/xdebug.ini /etc/php/7.0/mods-available
sudo ln -s /etc/php/7.0/mods-available/xdebug.ini /etc/php/7.0/cli/conf.d/
sudo ln -s /etc/php/7.0/mods-available/xdebug.ini /etc/php/7.0/fpm/conf.d/

# Add PHP-AST extension to PHP7.
git clone https://github.com/nikic/php-ast.git "php-ast"
cd php-ast
phpize
./configure
make
sudo make install
sudo make clean
sudo phpize --clean
cd $HOME

# Add PHP-AST to PHP7.
sudo cp /vagrant/config/php/ast.ini /etc/php/7.0/mods-available
sudo ln -s /etc/php/7.0/mods-available/ast.ini /etc/php/7.0/cli/conf.d/
sudo ln -s /etc/php/7.0/mods-available/ast.ini /etc/php/7.0/fpm/conf.d/

# PHP config.
sudo cp /vagrant/config/php/php-cli.ini /etc/php/7.0/cli/php.ini
sudo cp /vagrant/config/php/php-fpm.ini /etc/php/7.0/fpm/php.ini
sudo cp /vagrant/config/php/fpm.conf /etc/php/7.0/fpm/pool.d/www.conf
sudo service php7.0-fpm restart

# Install Nginx.
sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get update -y
sudo apt-get install -y nginx
sudo cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp /vagrant/config/nginx/www.conf /etc/nginx/conf.d/www.conf
sudo service nginx restart

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

# Web root.
sudo chown -R vagrant:vagrant /var/www

# Install composer
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === 'fd26ce67e3b237fffd5e5544b45b0d92c41a4afe3e3f778e942e43ce6be197b9cdc7c251dcde6e2a52297ea269370680') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Composer packages.
composer g require psy/psysh:@stable phpunit/phpunit

# Bash.
cp /vagrant/config/bash/profile /home/vagrant/.profile
