# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_cache_migrator/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_cache_migrator"
  spec.version       = RailsCacheMigrator::VERSION
  spec.authors       = ["Jeremy Wadsack"]
  spec.email         = ["jeremy.wadsack@gmail.com"]

  spec.summary       = %q{A tool to migrate cache data between Rails 3 and 4.}
  spec.description   = %q{Unless you clear your cache when you migrate to Rails 4 the cache entries
    may not be readable. This resolves the issue by providing a tool migrate your keys.}
  spec.homepage      = "https://github.com/keylimetoolbox/rails_cache_migrator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"

  spec.add_dependency "activesupport", "~> 4"
end

