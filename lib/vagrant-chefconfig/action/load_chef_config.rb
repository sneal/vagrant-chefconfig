require 'chef'

module Vagrant
  module ChefConfig
    module Action
      class LoadChefConfig

        def initialize(app, env)
          @app = app
        end

        def call(env)
          apply_knife_config(env)
          @app.call(env)
        end


        def apply_knife_config(env)
          puts "APPLYING KNIFE CONFIG!!!!"

          return unless chefconfig(env).enabled

          chef = chef_provisioner(env)
          if chef
            load_knife_config()

            chef.chef_server_url = Chef::Config[:chef_server_url]
            chef.log_level = Chef::Config[:log_level]
            chef.validation_key_path = Chef::Config[:validation_key]
            chef.validation_client_name = Chef::Config[:validation_client_name]
            chef.environment = Chef::Config[:vagrant_environment]
          end
        end

        def load_knife_config()
          Chef::Config.from_file(chefconfig(env).knife_config_path)
        end

        def chef_provisioner(env)
          @chef_provisioner ||= vm_config(env).provisioners.find do |p|
            p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
          end.config
        end

        def chefconfig(env)
          env[:machine].config.chefconfig.enabled
        end      

      end
    end
  end
end
