require 'chef'
require 'chef/knife'

module Vagrant
  module ChefConfig
    module Action
      class LoadChefConfig

        @@chef_config_dir = nil

        def initialize(app, env)
          @app = app
        end

        def call(env)
          LoadChefConfig.apply_knife_config(env)
          @app.call(env)
        end


        class << self

          def apply_knife_config(env)
            return unless LoadChefConfig.chefconfig(env).enabled

            chef = LoadChefConfig.chef_provisioner(env)
            if chef
              LoadChefConfig.load_knife_config(env)

              chef.chef_server_url = Chef::Config[:chef_server_url]
              chef.log_level = Chef::Config[:log_level]
              chef.validation_key_path = Chef::Config[:validation_key]
              chef.validation_client_name = Chef::Config[:validation_client_name]
              chef.environment = Chef::Config[:vagrant_environment]
            end
          end

          def load_knife_config(env)
            Chef::Config.from_file(LoadChefConfig.locate_knife_config_file(env))
          end

          def chef_provisioner(env)
            @chef_provisioner ||= env[:machine].config.vm.provisioners.find do |p|
              p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
            end.config
          end

          def chefconfig(env)
            env[:machine].config.chefconfig
          end

          def locate_knife_config_file(env)
            # If the Vagrantfile directly sets the knife.rb path, use that
            vagrantfile_knife_config_path = LoadChefConfig.chefconfig(env).knife_config_path
            if !vagrantfile_knife_config_path
              vagrantfile_knife_config_path = Chef::Knife.locate_config_file()
            end
            vagrantfile_knife_config_path
          end

        end # end self

      end
    end
  end
end
