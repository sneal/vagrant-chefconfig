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

      # This sets up our log level to be whatever VAGRANT_LOG is.
      def self.setup_logging
        require 'log4r'

        level = nil
        begin
          level = Log4r.const_get(ENV["VAGRANT_LOG"].upcase)
        rescue NameError
          # This means that the logging constant wasn't found,
          # which is fine. We just keep `level` as `nil`. But
          # we tell the user.
          level = nil
        end

        # Some constants, such as "true" resolve to booleans, so the
        # above error checking doesn't catch it. This will check to make
        # sure that the log level is an integer, as Log4r requires.
        level = nil if !level.is_a?(Integer)

        # Set the logging level on all "vagrant" namespaced
        # logs as long as we have a valid level.
        if level
          logger = Log4r::Logger.new("vagrant_chefconfig")
          logger.outputters = Log4r::Outputter.stderr
          logger.level = level
          logger = nil
        end
      end

    end
  end
end

Vagrant::ChefConfig::Plugin.setup_logging()
