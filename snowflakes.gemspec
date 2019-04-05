# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowflakes/version'

Gem::Specification.new do |spec|
  spec.name          = "snowflakes"
  spec.version       = Snowflakes::VERSION
  spec.authors       = ["Piotr Solnica"]
  spec.email         = ["piotr@icelab.com.au"]

  spec.summary       = %{A summary}
  spec.description   = %q{A description}
  spec.homepage      = "https://github.com/icelab/snowflakes"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-monitor"
  spec.add_runtime_dependency "dry-system"
  spec.add_runtime_dependency "dry-inflector"
  spec.add_runtime_dependency "hanami-cli"
  spec.add_runtime_dependency "hanami-utils"
  spec.add_runtime_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
