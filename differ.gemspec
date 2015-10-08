# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'differ/version'

Gem::Specification.new do |spec|
  spec.name          = 'differ'
  spec.version       = Differ::VERSION
  spec.authors       = ['Pieter van de Bruggen', 
                        'Jonas Schubert Erlandsson', 
                        'Jakob Rath', 'Emin Tham',
                        'masukomi']
  spec.date          = %q{2011-02-17}
  spec.email         = ['pvande@gmail.com', 
                        'jonas.schubert.erlandsson@my-codeworks.com',
                        'masukomi@masukomi.org']
  spec.description   = 'A simple gem for generating string diffs'
  spec.summary       = 'A simple gem for generating string diffs'
  spec.homepage      = 'http://github.com/Jeremygeros/differ'
  spec.license       = 'GIFT v1'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rspec'
  #spec.add_development_dependency 'byebug'
end
