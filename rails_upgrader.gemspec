# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_upgrader/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_upgrader"
  spec.version       = RailsUpgrader::VERSION
  spec.authors       = ["Mauro Otonelli"]
  spec.email         = ["mauro@ombulabs.com"]

  spec.summary       = %q{Upgrade your Rails 3 app to Rails 4}
  spec.description   = %q{Helps with the process of upgrading your Rails 3 app to Rails 4}
  spec.homepage      = "https://www.fastruby.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]
  spec.executables   = ["rails_upgrader"]

  spec.add_dependency "rails-erd", "~> 1.5"
  spec.add_dependency "rails", "~> 3.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry-byebug", "~> 3.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
