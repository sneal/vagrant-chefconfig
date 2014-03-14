require 'vagrant/errors'

module Vagrant
  module ChefConfig
    module Errors
      class KnifeConfigNotFound < ::Vagrant::Errors::VagrantError
      end
    end
  end
end
