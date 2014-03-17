begin
  require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end

require 'vagrant-chefconfig/version'
require 'vagrant-chefconfig/errors'

module Vagrant
  module ChefConfig
    require_relative 'vagrant-chefconfig/config'
    require_relative 'vagrant-chefconfig/action'
    require_relative 'vagrant-chefconfig/env'
  end
end

require 'vagrant-chefconfig/plugin'
