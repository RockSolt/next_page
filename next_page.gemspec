# Maintain your gem's version:
require_relative "lib/next_page/version"

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
  spec.required_ruby_version = '>= 3.2'

  spec.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", '>= 7.2'

  spec.add_development_dependency "appraisal", "~> 2.5.0"
  spec.add_development_dependency "sqlite3", "~> 2.1"
  spec.add_development_dependency "rspec-rails", "~> 8.0"
  spec.add_development_dependency "rubocop", "~> 1.75"
  spec.add_development_dependency "simplecov", "~> 0.19"
end
