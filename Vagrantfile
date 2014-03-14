# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_plugin "vagrant-chefconfig"

Vagrant.configure('2') do |config|
  config.vm.box = "opscode_ubuntu-12.04_chef-11.2.0"
  config.vm.provision :chef_client do |chef|
    chef.node_name = 'vagrant_chefconfig_test_vm'
    #chef.chef_server_url = Chef::Config[:chef_server_url]
    #chef.log_level = Chef::Config[:log_level]
    #chef.validation_key_path = Chef::Config[:validation_key]
    #chef.validation_client_name = Chef::Config[:validation_client_name]
    #chef.environment = Chef::Config[:vagrant_environment]
    # chef.run_list = [ 'recipe[dummy::fail]' ]
  end
end
