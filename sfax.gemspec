# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sfax/version'

Gem::Specification.new do |spec|
  spec.name          = 'sfax'
  spec.version       = SFax::VERSION
  spec.authors       = ['Derek Schneider']
  spec.email         = ['dschneider.641@gmail.com']
  spec.summary       = %q{Ruby client for SFax API}
  spec.description   = %q{Ruby client for SFax API}
  spec.homepage      = 'https://github.com/schneiderderek/sfax'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday', '~> 0.9'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'webmock', '~> 2.1'
end
