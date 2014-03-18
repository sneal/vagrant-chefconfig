require_relative '../chef_client_configurator'

module Vagrant
  module ChefConfig
    module Action
      class LoadChefConfig

        def initialize(app, env)
          @app = app
        end

        def call(env)
          ChefClientConfigurator.new(env).apply_knife_config()
          @app.call(env)
        end

      end
    end
  end
end
