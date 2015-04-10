require 'mixlib/config'
require_relative 'path_helper'

module Vagrant
  module ChefConfig
    # Subset of Chef Config class functionality
    # Matches Chef 12 default behavior
    class KnifeConfig

      extend Mixlib::Config

      default :chef_server_url, "https://localhost:443"
      default :log_level, :auto
      default(:validation_key) { PathHelper.platform_specific_path("/etc/chef/validation.pem") }
      default :validation_client_name, 'chef-validator'
      default :vagrant_environment, :dev

      default(:encrypted_data_bag_secret) do
        key_path = PathHelper.platform_specific_path("/etc/chef/encrypted_data_bag_secret")
        if File.exist?(key_path)
          key_path
        else
          nil
        end
      end
    end
  end
end
