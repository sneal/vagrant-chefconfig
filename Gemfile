source 'https://rubygems.org'

# Specify your gem's dependencies in vagrant-chefconfig.gemspec
gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "https://github.com/mitchellh/vagrant.git"
end

# This group is read by Vagrant for plugin development
group :plugins do
  gem "vagrant-chefconfig", path: "."
end
