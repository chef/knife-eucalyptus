# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-eucalyptus/version"

Gem::Specification.new do |s|
  s.name        = "knife-eucalyptus"
  s.version     = Knife::Eucalyptus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE" ]
  s.authors     = ["Seth Chisamore"]
  s.email       = ["schisamo@opscode.com"]
  s.homepage    = "https://github.com/opscode/knife-eucalyptus"
  s.summary     = %q{Eucalyptus Cloud Support for Chef's Knife Command}
  s.description = s.summary

  s.rubyforge_project = "knife-eucalyptus"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "fog", "~> 1.3"
end
