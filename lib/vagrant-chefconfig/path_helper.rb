module Vagrant
  module ChefConfig
    # Helper to deal with paths, mainly on Windows
    # Borrowed from Chef 12 PathHelper class
    class PathHelper
      def self.platform_specific_path(path)
        path = cleanpath(path)
        if Gem.win_platform?
          # \etc\chef\client.rb and \var\chef\client.rb -> C:/chef/client.rb
          if env['SYSTEMDRIVE'] && path[0] == '\\' && path.split('\\')[2] == 'chef'
            path = File.join(env['SYSTEMDRIVE'], path.split('\\', 3)[2])
          end
        end
        path
      end

      def self.cleanpath(path)
        path = Pathname.new(path).cleanpath.to_s
        # ensure all forward slashes are backslashes
        if Gem.win_platform?
          path = path.gsub(File::SEPARATOR, path_separator)
        end
        path
      end
    end
  end
end
