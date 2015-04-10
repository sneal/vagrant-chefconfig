# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'chef/ubuntu-14.04'
  config.vm.provision :chef_client do |chef|
    chef.node_name = 'vagrant_chefconfig_test_vm'
    chef.run_list = [ 'apt' ]
  end
end
