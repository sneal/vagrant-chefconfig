module Vagrant
  module ChefConfig
    class Plugin < Vagrant.plugin('2')
      name "vagrant-chefconfig"
      description <<-DESC
      Auto-load knife configuration data on Vagrant startup
      DESC


      action_hook(:vagrant_chefconfig_validate) do |hook|
        hook.before(
          ::Vagrant::Action::Builtin::ConfigValidate,
          Vagrant::ChefConfig::Action.load_chef_config)
      end

      action_hook(:vagrant_chefconfig_provision) do |hook|
        hook.before(
          ::Vagrant::Action::Builtin::Provision,
          Vagrant::ChefConfig::Action.load_chef_config)
      end

      config("chefconfig") do
        Config
      end

    end
  end
end
