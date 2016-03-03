# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "20151020.0.0"
    config.vm.provision :shell, path: "provision.sh", privileged: false
end

# TODO : Before packaging up the box, SSH into the VM and run these commands:
# sudo apt-get clean
# sudo dd if=/dev/zero of=/EMPTY bs=1M
# sudo rm -f /EMPTY
# sudo su
# history -c && exit
# cat /dev/null > ~/.bash_history && history -c && exit
