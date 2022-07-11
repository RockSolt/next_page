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

  spec.add_dependency "rails", "~> 6.0", ">= 6.0.2.2"

  spec.add_development_dependency "appraisal", "~> 2.4.1"
  spec.add_development_dependency "guard", "~> 2.18.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "guard-rubocop", "~> 1.5.0"
  spec.add_development_dependency "pg", "~> 1.2.3"
  spec.add_development_dependency "rspec-rails", "~> 5.1.2"
  spec.add_development_dependency "rubocop", "~> 1.31.2"
  spec.add_development_dependency "simplecov", "~> 0.18"
end
