require 'log4r'
require 'chef'
require 'chef/knife'

module Vagrant
  module ChefConfig
    class ChefClientConfigurator

      def initialize(env)
        @logger = Log4r::Logger.new("vagrant_chefconfig::chefclientconfigurator") 
        @env = env
      end

      def apply_knife_config()
        load_knife_config()

        chef_provisioners.each do |chef_provisioner|
          chef_config = chef_provisioner.config

          set_if_default(chef_config, :chef_server_url, :chef_server_url)
          set_if_default(chef_config, :log_level, :log_level)
          set_if_default(chef_config, :validation_key_path, :validation_key)
          set_if_default(chef_config, :validation_client_name, :validation_client_name)
          set_if_default(chef_config, :environment, :vagrant_environment)
          set_if_default(chef_config, :client_key_path, :client_key)
          set_if_default(chef_config, :encrypted_data_bag_secret_key_path, :encrypted_data_bag_secret)
        end
      end


      private

      def set_if_default(chef_config, config_prop_sym, chef_prop_sym)
        config_val = chef_config.send(config_prop_sym)

        @logger.debug("Vagrantfile config val #{config_prop_sym} = #{config_val}")
        @logger.debug("Knife config val #{config_prop_sym} = #{Chef::Config[chef_prop_sym]}")

        if is_default_value(config_prop_sym, config_val)
          @logger.debug("Overwriting '#{config_prop_sym}' in Vagrantfile chef-client " +
            "provisioner with '#{Chef::Config[chef_prop_sym]}'")
          chef_config.send("#{config_prop_sym}=", Chef::Config[chef_prop_sym])
        end
      end

      def is_default_value(config_prop_sym, config_val)
        case config_prop_sym
        when :validation_client_name
          return config_val == 'chef-validator'
        when :client_key_path
          return config_val == '/etc/chef/client.pem'
        else
          return config_val.nil?
        end
      end

      def chef_provisioners()
        @env[:machine].config.vm.provisioners.find_all do |p|
          p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
        end
      end

      def load_knife_config()
        knife_config_path = locate_knife_config_file()
        @logger.debug("Using knife config from '#{knife_config_path}'")
        Chef::Config.from_file(knife_config_path)
      end

      def locate_knife_config_file()
        # If the Vagrantfile directly sets the knife.rb path use it, otherwise let
        # knife find its configuration file
        knife_config_path = plugin_config().knife_config_path
        knife_config_path ? knife_config_path : Chef::Knife.locate_config_file()
      end

      def plugin_config()
        @env[:machine].config.chefconfig
      end

    end #ChefClientConfigurator
  end
end