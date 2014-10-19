# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jsstrings-templates/version"

Gem::Specification.new do |s|
  s.name        = "jsstrings-templates"
  s.version     = JsStringsTemplates::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jay Hudson"]
  s.email       = ["jkh30003@gmail.com@gmail.com"]
  s.homepage    = "https://github.com/jay-hudson/jsstrings-templates"
  s.summary     = "Turns your HTML templates into JavaScript string variables"

  s.files = %w(README.md LICENSE) + Dir["lib/**/*", "vendor/**/*"]
  s.license = 'MIT'

  s.require_paths = ["lib"]

  s.add_dependency "railties", ">= 3.1"
  s.add_dependency "sprockets"
  s.add_dependency "tilt"

  s.add_development_dependency "minitest"
  s.add_development_dependency "capybara"
  s.add_development_dependency "uglifier"
end