# Vagrant-ChefConfig

This [Vagrant](http://www.vagrantup.com/) plugin allows you to automatically configure all your Chef client provisioner blocks from your host's knife.rb. Just install the plugin and use the chef-client provisioners in Vagrant. That's it.

## Installation

vagrant plugin install vagrant-chefconfig

## Usage

In your Vagrantfile use the plugin like so:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = "precise64"
  config.vm.provision :chef_client do |chef|
    chef.node_name = 'vagrant-mydummytest'
    chef.run_list = [ 'recipe[dummy::fail]' ]
  end
end
```

The plugin will automatically configure the following Vagrant chef-client provisioner attributes from your knife.rb.

Vagrant chef-client attribute -> knife config attribute
--------------------------------------------------------
* `chef_server_url` - same
* `log_level` - same
* `validation_key_path` - maps to `validation_key`
* `validation_client_name` - same
* `environment` - maps to `vagrant_environment`, this is a non-standard knife config key.
* `client_key_path` - maps to `client_key`
* `encrypted_data_bag_secret_key_path` - maps to `encrypted_data_bag_secret`

Values specified directly in the Vagrantfile override any configured values found in your knife configuration file.

## Optional Configuration

By default the plugin will be enabled and the path to the knife.rb uses the [standard Knife configuration](http://docs.opscode.com/config_rb_knife.html) loading mechanism. You can override this behavior using the following optional plugin configuration options:

* chefconfig.enabled = false
* chefconfig.knife_config_path = '/my/nonstandard/path/knife.rb'

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
