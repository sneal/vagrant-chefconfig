module Vagrant
  module ChefConfig
    class Config < ::Vagrant.plugin('2', :config)
      attr_accessor :enabled
      attr_accessor :knife_config_path

      def initialize
        super
        @enabled = UNSET_VALUE
        @knife_config_path = UNSET_VALUE
      end

      def finalize!
        @enabled = true if @enabled == UNSET_VALUE
        @knife_config_path = nil if @knife_config_path == UNSET_VALUE
      end

        def validate(machine)
          errors =[]

          if @enabled
            if @knife_config_path && !File.exists?(@knife_config_path)
              errors << "chefconfig.knife_config_path file '#{@knife_config_path}' not found" 
            end
          end

          { "chefconfig" => errors }
        end
    end
  end
end
