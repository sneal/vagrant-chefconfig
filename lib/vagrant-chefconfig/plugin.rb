module Vagrant
  module ChefConfig
    class Plugin < Vagrant.plugin('2')
      name "vagrant-chefconfig"
      description <<-DESC
      Auto-load knife configuration data on Vagrant startup
      DESC

      action_hook(:vagrant_chefconfig_cleanup) do |hook|
        hook.before(
          ::Vagrant::Action::Builtin::ConfigValidate,
          Vagrant::ChefConfig::Action.load_knife_config)
      end

      config("chefconfig") do
        Config
      end

    end
  end
end
