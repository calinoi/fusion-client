# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fusion/client/version'

Gem::Specification.new do |spec|
  spec.name          = "fusion-client"
  spec.version       = Fusion::Client::VERSION
  spec.authors       = ["Josh Starcher"]
  spec.email         = ["josh.starcher@gmail.com"]

  spec.summary       = %q{Ruby client for interaction with Callinoi's Fusion API.}
  spec.homepage      = "http://www.calinoi.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency('rest-client', '~> 2.0.2')
  spec.add_dependency('activesupport', '>= 2.2.1')
  spec.add_dependency('retryable-rb', '~> 1.1.0')

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.49.1"
end
