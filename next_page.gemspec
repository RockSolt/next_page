$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "next_page/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "next_page"
  spec.version     = NextPage::VERSION
  spec.authors     = ["Todd Kummer"]
  spec.email       = ["todd@rockridgesolutions.com"]
  spec.homepage    = "https://github.com/RockSolt/next_page"
  spec.summary     = "Pagination for Rails Controllers"
  spec.description = "Provide basic pagination, including page size and number as well as helpers for generating links."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.2"

  spec.add_development_dependency "guard", "~> 2.16"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "guard-rubocop", "~> 1.3.0"
  spec.add_development_dependency "pg", "~> 1.2.3"
  spec.add_development_dependency "rspec-rails", "~> 3.9"
  spec.add_development_dependency "rubocop", "~> 0.82.0"
  spec.add_development_dependency "simplecov", "~> 0.18"
end
