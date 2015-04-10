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

## Vagrant chef-client attribute -> knife config attribute
<table>
  <tr>
    <th>Vagrant attribute name</th>
    <th>Knife attribute name</th>
  </tr>
  <tr>
    <td>chef_server_url</td>
    <td>chef_server_url</td>
  </tr>
  <tr>
    <td>log_level</td>
    <td>log_level</td>
  </tr>
  <tr>
    <td>validation_key_path</td>
    <td>validation_key</td>
  </tr>
  <tr>
    <td>environment</td>
    <td>vagrant_environment</td>
  </tr>
  <tr>
    <td>encrypted_data_bag_secret_key_path</td>
    <td>encrypted_data_bag_secret</td>
  </tr>
</table>

Values specified directly in the Vagrantfile override any configured values found in your knife configuration file.

## Optional Configuration

By default the plugin will be enabled and the path to the knife.rb uses the [standard Knife configuration](http://docs.opscode.com/config_rb_knife.html) loading mechanism. You can override this behavior using the following optional plugin configuration options:

* chefconfig.enabled = false
* chefconfig.knife_config_path = '/my/nonstandard/path/knife.rb'

## Changelog

### 0.1.0

- Added support for Vagrant 1.7+.
- Fixed issue 1. Don't read knife.rb if there are no chef-client provisioner blocks in Vagrantfile.
- Removed dependency upon Chef gem. Handles loading Knife config directly with mixlib-config

### 0.0.1

- Initial release for Vagrant 1.5

# Authors

* Shawn Neal (<sneal@sneal.net>)

## Developing

1. Clone repo
2. `bundle install`
3. `bundle exec vagrant up`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
