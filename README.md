# Vagrant-ChefConfig

This [Vagrant](http://www.vagrantup.com/) plugin allows you to automatically bring in the chef gem into Vagrant and configure and access ChefConfig from your Vagrantfile. This plugin will automatically read your knife.rb which you can then access via ChefConfig.

## Installation

vagrant plugin install vagrant-chefconfig

## Usage

In your Vagrantfile use the plugin like so (it'll autoload your knife.rb):
```ruby
require 'chef'

Vagrant.configure('2') do |config|
  config.vm.box = "precise64"
  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = Chef::Config[:chef_server_url]
    chef.log_level = Chef::Config[:log_level]
    chef.validation_key_path = Chef::Config[:validation_key]
    chef.validation_client_name = Chef::Config[:validation_client_name]
    chef.environment = Chef::Config[:vagrant_environment]
  end
end
```

## Changelog

### 0.0.1

Initial release for Vagrant 1.5

# Authors

* Shawn Neal (<sneal@sneal.net>)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
