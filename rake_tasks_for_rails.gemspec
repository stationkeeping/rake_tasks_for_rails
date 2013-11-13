# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake_tasks_for_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "rake_tasks_for_rails"
  spec.version       = RakeTasksForRails::VERSION
  spec.authors       = ["Pedr Browne"]
  spec.email         = ["pedr.browne@gmail.com"]
  spec.description   = %q{Rake tasks to help with Rails development}
  spec.summary       = %q{Useful Rake tasks used in Rails development, specifically using Postgres and Heroku}
  spec.homepage      = "https://github.com/stationkeeping/rake_tasks_for_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency "dropbox-sdk", "~> 1.5"
  spec.add_development_dependency "bundler", "~> 1.3"
end
