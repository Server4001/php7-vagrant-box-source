# PHP7.1 Ubuntu Vagrant Box

### The source environment used for my vagrant box on Atlas, server4001/php71-ubuntu.

### NOTE: This is the environment used to build the Vagrant box. If you are looking for a PHP7.1 environment, just use the box: [server4001/php71-ubuntu](https://atlas.hashicorp.com/server4001/boxes/php71-ubuntu)

### LEMP stack Vagrant box running on Ubuntu with PHP7.1

### Features

# TODO : THIS:
* Ubuntu Trusty Tahr 14.04.3 LTS
* Nginx 1.10.1
* MySQL 5.5.53
* PHP 7.0.14
* [PHP7 Data Structures](https://github.com/php-ds/extension)

### Instructions

* `vagrant up`
* Make any changes you need to the box by changing the provisioner.
* Before packaging up the box, ssh in, and run the commands at the end of this readme, under "Pre-Packaging Commands".
* Package up the box with `vagrant package --output server4001-php71-ubuntu-0.1.0.box`. Replace `0.1.0` with the version number.
* Destroy the vm with `vagrant destroy -f`.
* Add the new box to vagrant's local list with: `vagrant box add server4001/php71-ubuntu-010 server4001-php71-ubuntu-0.1.0.box`. Again, replace `010` and `0.1.0` with the version number.
* Delete the `.vagrant` folder with `rm -rf .vagrant`.
* Test out the box by going to a different folder, running `vagrant init server4001/php71-ubuntu-010`, and changing the `Vagrantfile` to fit your needs. Next, run `vagrant up`, and ensure everything is working.
* Create a new version on Atlas.
* Add a new provider to the version. The type should be `virtualbox`. Upload the .box file to this provider.
* Commit your changes via git.
* Add a new git tag: `git tag php71-0.1.0 && git push origin php71-0.1.0`.

### MySQL Credentials
* Username: `root`
* Password: `password`

### Pre-Packaging Commands

        sudo apt-get clean
        sudo dd if=/dev/zero of=/EMPTY bs=1M
        sudo rm -f /EMPTY
        sudo su
        history -c && exit
        cat /dev/null > ~/.bash_history && history -c && exit

### TODO:
