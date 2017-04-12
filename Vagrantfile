# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_version = "20170404.0.0"

  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.provisioning_path = "/vagrant/provision"
    ansible.install = true
    ansible.verbose = true
  end
end
