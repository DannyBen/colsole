lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'colsole/version'

Gem::Specification.new do |s|
  s.name        = 'colsole'
  s.version     = Colsole::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Colorful Console Applications"
  s.description = "Utility functions for making colorful console applications"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.rb']
  s.homepage    = 'https://github.com/DannyBen/colsole'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.0.0"
end
