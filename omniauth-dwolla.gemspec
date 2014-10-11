# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-dwolla/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-dwolla"
  s.version     = Omniauth::Dwolla::VERSION
  s.authors     = ["masukomi"]
  s.email       = ["masukomi@masukomi.org"]
  s.homepage    = "https://github.com/masukomi/omniauth-dwolla"
  s.summary     = %q{OmniAuth strategy for Dwolla.}
  s.description = %q{OmniAuth strategy for Dwolla.}
  s.license     = 'MIT'
  post_install_string =<<END
Remember to specify 
    :provider_ignores_state => true
When you set up your Dwolla OmniAuth provider.
END
  s.post_install_message = post_install_string

  s.rubyforge_project = "omniauth-dwolla"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'omniauth', '~> 1.2'
  s.add_dependency 'omniauth-oauth2', '~> 1.2'
  s.add_dependency 'dwolla-ruby', '~> 2.5'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.13.0'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'simplecov'
#  s.add_development_dependency 'debugger'
  s.add_development_dependency 'coveralls'
end
