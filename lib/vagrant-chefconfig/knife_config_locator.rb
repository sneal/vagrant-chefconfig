require_relative 'path_helper'

module Vagrant
  module ChefConfig
    # Locates the local knife config using the same behavior as Chef 12
    # Borrowed from Chef WorkstationConfigLoader
    # Author:: Daniel DeLeo (<dan@getchef.com>)
    class KnifeConfigLocator

      def initialize()
        @logger = Log4r::Logger.new("vagrant_chefconfig::knifeconfiglocator") 
      end

      def locate_local_config
        candidate_configs = []

        # Look for $KNIFE_HOME/knife.rb (allow multiple knives config on same machine)
        if ENV['KNIFE_HOME']
          candidate_configs << File.join(ENV['KNIFE_HOME'], 'config.rb')
          candidate_configs << File.join(ENV['KNIFE_HOME'], 'knife.rb')
        end
        # Look for $PWD/knife.rb
        if Dir.pwd
          candidate_configs << File.join(Dir.pwd, 'config.rb')
          candidate_configs << File.join(Dir.pwd, 'knife.rb')
        end
        # Look for $UPWARD/.chef/knife.rb
        if chef_config_dir
          candidate_configs << File.join(chef_config_dir, 'config.rb')
          candidate_configs << File.join(chef_config_dir, 'knife.rb')
        end
        # Look for $HOME/.chef/knife.rb
        candidate_configs << File.join(home_dot_chef_dir, 'config.rb')
        candidate_configs << File.join(home_dot_chef_dir, 'knife.rb')

        candidate_configs.find do | candidate_config |
          have_config?(candidate_config)
        end
      end

      private

      def chef_config_dir
        if @chef_config_dir.nil?
          @chef_config_dir = false
          full_path = Dir.pwd.split(File::SEPARATOR)
          (full_path.length - 1).downto(0) do |i|
            candidate_directory = File.join(full_path[0..i] + [".chef" ])
            if File.exist?(candidate_directory) && File.directory?(candidate_directory)
              @chef_config_dir = candidate_directory
              break
            end
          end
        end
        @chef_config_dir
      end

      def home_dot_chef_dir
        File.join(Dir.home, '.chef')
      end

      def have_config?(path)
        if File.exist?(path)
          @logger.info("Using config at #{path}")
          true
        else
          @logger.debug("Config not found at #{path}, trying next option")
          false
        end
      end
    end
  end
end