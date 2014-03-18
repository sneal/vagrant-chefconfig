require_relative '../chef_client_configurator'

module Vagrant
  module ChefConfig
    module Action
      class LoadChefConfig

        def initialize(app, env)
          @app = app
        end

        def call(env)
          if @env[:machine].config.chefconfig.enabled
            ChefClientConfigurator.new(env).apply_knife_config()
          end
          @app.call(env)
        end

      end
    end
  end
end
