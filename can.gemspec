# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require 'can'

Gem::Specification.new do |s|
  s.name          = 'can'
  s.version       = Can::VERSION
  s.authors       = ['ptdorf']
  s.email         = ['ptdorf@gmail.com']
  s.homepage      = 'https://rubygems.org/gems/can'
  s.summary       = 'Can stores stuff'
  s.description   = 'Can stores useful information and other amazing things.'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split $/
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename f }
  s.require_paths = ['lib']
end
