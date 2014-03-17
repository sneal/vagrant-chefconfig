module Vagrant
  module ChefConfig
    module Action
      require_relative 'action/load_chef_config'

      def self.load_chef_config
        ::Vagrant::Action::Builder.new.tap do |b|
          b.use Vagrant::ChefConfig::Action::LoadChefConfig
        end
      end

    end
  end
end
