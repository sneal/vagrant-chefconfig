require 'chef'
require 'chef/knife'
require 'vagrant/plugin/v2/config'

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

            LoadChefConfig.load_knife_config(env)

            chef_client_provisioners = LoadChefConfig.chef_provisioners(env)
            chef_client_provisioners.each do |chef_provisioner|
              chef_config = chef_provisioner.config

              set_if_default(chef_config, :chef_server_url, :chef_server_url)
              set_if_default(chef_config, :log_level, :log_level)
              set_if_default(chef_config, :validation_key_path, :validation_key)
              set_if_default(chef_config, :validation_client_name, :validation_client_name)
              set_if_default(chef_config, :environment, :vagrant_environment)
              set_if_default(chef_config, :client_key_path, :client_key)
            end
          end

          def set_if_default(chef_config, config_prop_sym, chef_prop_sym)
            if chef_config.send(config_prop_sym) != Vagrant::Plugin::V2::Config::UNSET_VALUE
              chef_config.send("#{config_prop_sym}=", Chef::Config[chef_prop_sym])
            end
          end

          def load_knife_config(env)
            Chef::Config.from_file(LoadChefConfig.locate_knife_config_file(env))
          end

          def chef_provisioners(env)
            env[:machine].config.vm.provisioners.find_all do |p|
              p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
            end
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
