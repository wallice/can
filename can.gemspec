# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'can'

Gem::Specification.new do |s|
  s.name        = 'can'
  s.version     = Can::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['ptdorf']
  s.email       = ['ptdorf@gmail.com']
  s.homepage    = 'https://rubygems.org/gems/can'
  s.summary     = 'Can stores useful information'
  s.description = 'Can stores useful information and other amazing things.'
  s.license     = 'MIT'

  # s.add_development_dependency 'rspec', '~>2.5.0'
  # s.files         = `git ls-files`.split("\n")
  # s.files         = `find ./lib -type f`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')

  s.files         = ['lib/can.rb', 'lib/can/command.rb']
  s.executables   = ['can']
  s.require_paths = ['lib']
end
