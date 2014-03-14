module Vagrant
  module ChefConfig
    class Env
      attr_accessor :ui

      def initialize
        vagrant_version = Gem::Version.new(::Vagrant::VERSION)
        if vagrant_version >= Gem::Version.new("1.5")
          @ui = ::Vagrant::UI::Colored.new
          @ui.opts[:target] = 'ChefConfig'
        elsif vagrant_version >= Gem::Version.new("1.2")
          @ui = ::Vagrant::UI::Colored.new.scope('ChefConfig')
        else
          @ui = ::Vagrant::UI::Colored.new('ChefConfig')
        end
      end
    end
  end
end
