require 'log4r'
require_relative 'knife_config'
require_relative 'knife_config_locator'

module Vagrant
  module ChefConfig
    class ChefClientConfigurator

      def initialize(env)
        @logger = Log4r::Logger.new("vagrant_chefconfig::chefclientconfigurator") 
        @env = env
      end

      def apply_knife_config()
        provisioners = chef_client_provisioners
        return if provisioners.length == 0

        load_knife_config()

        provisioners.each do |provisioner|
          chef_config = provisioner.config

          #                           vagrant config key                   knife config key
          set_if_default(chef_config, :chef_server_url,                    :chef_server_url)
          set_if_default(chef_config, :log_level,                          :log_level)
          set_if_default(chef_config, :validation_key_path,                :validation_key)
          set_if_default(chef_config, :validation_client_name,             :validation_client_name)
          set_if_default(chef_config, :environment,                        :vagrant_environment)
          set_if_default(chef_config, :encrypted_data_bag_secret_key_path, :encrypted_data_bag_secret)
        end
      end


      private

      def set_if_default(chef_config, config_prop_sym, knife_prop_sym)
        config_val = chef_config.send(config_prop_sym)
        knife_val = KnifeConfig[knife_prop_sym]

        @logger.debug("Vagrantfile config val #{config_prop_sym} = #{config_val}")
        @logger.debug("Knife config val #{knife_prop_sym} = #{knife_val}")

        if is_default_vagrant_value(config_prop_sym, config_val)
          @logger.debug("Overwriting '#{config_prop_sym}' in Vagrantfile chef-client " +
            "provisioner with '#{knife_val}'")
          chef_config.send("#{config_prop_sym}=", knife_val)
        end
      end

      def is_default_vagrant_value(config_prop_sym, config_val)
        case config_prop_sym
        when :validation_client_name
          return config_val == 'chef-validator'
        when :log_level
          return config_val == :info
        else
          return config_val.nil?
        end
      end

      def chef_client_provisioners()
        @env[:machine].config.vm.provisioners.select do |prov|
          begin
            prov.type == :chef_client
          rescue NoMethodError
            prov.name == :chef_client # support for Vagrant <= 1.6.5
          end
        end
      end

      def load_knife_config()
        knife_config_path = locate_knife_config_file()
        @logger.debug("Using knife config from '#{knife_config_path}'")
        KnifeConfig.from_file(knife_config_path)
      end

      def locate_knife_config_file()
        # If the Vagrantfile directly sets the knife.rb path use it, otherwise 
        # default to the .chef directory under the user's home dir
        # This could be improved to have the same behavior as Chef for finding
        # the knife.rb relative to the current directory
        knife_config_path = plugin_config().knife_config_path
        knife_config_path ? knife_config_path : KnifeConfigLocator.new().locate_local_config
      end

      def plugin_config()
        @env[:machine].config.chefconfig
      end

    end #ChefClientConfigurator
  end
end
