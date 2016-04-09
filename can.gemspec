# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "can"

Gem::Specification.new do |spec|
  spec.name          = 'can'
  spec.version       = Can::VERSION
  spec.authors       = ['ptdorf']
  spec.email         = ['ptdorf@gmail.com']
  spec.homepage      = 'https://rubygemspec.org/gems/can'
  spec.summary       = 'Can stores stuff'
  spec.description   = 'Can stores useful information and other amazing thingspec.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split $/
  spec.files         = ['bin/can']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename f }
  # spec.require_paths = ['lib']
end
