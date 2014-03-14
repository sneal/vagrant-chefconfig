require "#{Vagrant::source_root}/plugins/provisioners/chef/config/chef_client"

module VagrantPlugins
  module Chef
    module Config
      class ChefClient < Base

        def validate(machine)
          errors = _detected_errors
          errors.concat(validate_base(machine))

          if delete_client || delete_node
            if !Vagrant::Util::Which.which("knife")
              errors << I18n.t("vagrant.chef_config_knife_not_found")
            end
          end

          { "chef client provisioner" => errors }
        end
      end
    end
  end
end
