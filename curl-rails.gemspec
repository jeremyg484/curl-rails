$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "curl-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "curl-rails"
  s.version     = CurlRails::VERSION
  s.authors     = ["Jeremy Grelle"]
  s.email       = ["jeremy.grelle@gmail.com"]
  s.homepage    = "http://cujojs.com"
  s.summary     = "A gem for using Curl with Rails"
  s.description = "A gem for using the Curl AMD loader in a Rails application, integrating with the Rails asset pipeline."

  s.files = Dir["lib/**/*"] + Dir["vendor/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "test-unit"
end
