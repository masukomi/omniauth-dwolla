# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-dwolla/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-dwolla"
  s.version     = Omniauth::Dwolla::VERSION
  s.authors     = ["Jefferson Girao"]
  s.email       = ["contato@jefferson.eti.br"]
  s.homepage    = "https://github.com/jeffersongirao/omniauth-dwolla"
  s.summary     = %q{OmniAuth strategy for GitHub.}
  s.description = %q{OmniAuth strategy for GitHub.}

  s.rubyforge_project = "omniauth-dwolla"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'omniauth', '~> 1.0'
  s.add_dependency 'omniauth-oauth2', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'simplecov'
end
