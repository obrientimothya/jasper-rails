# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jasper-rails/version"

Gem::Specification.new do |s|
  s.name        = "obrientimothya-jasper-rails"
  s.version     = JasperRails::VERSION
  s.authors     = ["Marlus Saraiva", "Rodrigo Maia", "Timothy OBrien"]
  s.summary     = %q{Custom Rails-Jaspersoft Tool}
  s.description = %q{A FORK of the fortesinformatica/jasper-rails project for a particular project. NOT intended for wide use.}
  s.email       = "obrien.timothy.a@gmail.com"
  s.homepage    = "https://github.com/obrientimothya/jasper-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rjb', '1.4.3')
  s.add_development_dependency 'combustion', '~> 0.3.2'
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "jasper-rails-rspec"
end
