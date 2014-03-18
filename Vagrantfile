# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "opscode_ubuntu-12.04_chef-11.2.0"
  config.vm.provision :chef_client do |chef|
    chef.node_name = 'vagrant_chefconfig_test_vm'
    chef.run_list = [ 'apt' ]
  end
end
