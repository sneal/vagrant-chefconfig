# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-chefconfig/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-chefconfig"
  gem.version       = Vagrant::ChefConfig::VERSION
  gem.authors       = ["Shawn Neal"]
  gem.email         = ["sneal@sneal.net"]
  gem.description   = %q{Load Chef gem client config from knife.rb}
  gem.summary       = %q{Duplicating Chef client configuration is less than ideal, lets reuse our knife.rb configuration data}
  gem.homepage      = "https://github.com/sneal/vagrant-chefconfig"
  gem.license       = 'Apache2'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "mixlib-config", "~> 2"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
