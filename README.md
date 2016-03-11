# PHP7 Vagrant Box

### The source environment used for my vagrant box on Atlas, server4001/php7.

### NOTE: This is the environment used to build the Vagrant box. If you are looking for a PHP7 environment, just use the box: [server4001/php7](https://atlas.hashicorp.com/server4001/boxes/php7)

#### LEMP stack Vagrant box running on Ubuntu with PHP7

#### Features

* Ubuntu Trusty Tahr 14.04.3 LTS
* Nginx 1.8.1
* MySQL 5.5.47
* PHP 7.0.3
* [PHP7 Data Structures](https://github.com/php-ds/extension)

#### Instructions

* `vagrant up`
* Make any changes you need to the box. Be sure to reflect these changes in the `provision.sh` script.
* Before packaging up the box, ssh in, and run the commands that are in the comments at the end of `Vagrantfile`.
* Package up the box with `vagrant package --output server4001-php7-0.2.0.box`. Replace `0.2.0` with the version number.
* Destroy the vm with `vagrant destroy`.
* Add the new box to vagrant's local list with: `vagrant box add server4001/php7-020 server4001-php7-0.2.0.box`. Again, replace `020` and `0.2.0` with the version number.
* Delete the `.vagrant` folder with `rm -rf .vagrant`.
* Test out the box by going to a different folder, running `vagrant init server4001/php7-020`, and changing the `Vagrantfile` to fit your needs. Next, run `vagrant up`, and ensure everything is working.
* Create a new version on Atlas.
* Add a new provider to the version. The type should be `virtualbox`. Upload the .box file to this provider.

#### MySQL Credentials
* Username: `root`
* Password: `password`
