lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowpack/version'

Gem::Specification.new do |spec|
  spec.name          = "snowpack"
  spec.version       = Snowpack::VERSION
  spec.authors       = ["Tim Riley", "Piotr Solnica"]
  spec.email         = ["tim@icelab.com.au", "piotr@icelab.com.au"]

  spec.summary       = "Lightweight application framework for Icelab"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/icelab/snowpack"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-inflector", "~> 0.1"
  spec.add_runtime_dependency "dry-monitor", "~> 0.3.1"
  spec.add_runtime_dependency "dry-system", "~> 0.12", ">= 0.12.0"
  spec.add_runtime_dependency "dry-types", "~> 1.0"
  spec.add_runtime_dependency "down", "~> 4.0"
  spec.add_runtime_dependency "hanami-cli"    # requires unstable branch from github in application Gemfile
  spec.add_runtime_dependency "hanami-utils"  # requires unstable branch from github in application Gemfile
  spec.add_runtime_dependency "rack", "~> 2.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
