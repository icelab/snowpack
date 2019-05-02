lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowflakes/version'

Gem::Specification.new do |spec|
  spec.name          = "snowflakes"
  spec.version       = Snowflakes::VERSION
  spec.authors       = ["Tim Riley", "Piotr Solnica"]
  spec.email         = ["tim@icelab.com.au", "piotr@icelab.com.au"]

  spec.summary       = %{A summary}
  spec.description   = %q{A description}
  spec.homepage      = "https://github.com/icelab/snowflakes"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-inflector"
  spec.add_runtime_dependency "dry-monitor"
  spec.add_runtime_dependency "dry-system", "~> 0.12", ">= 0.12.0"
  spec.add_runtime_dependency "dry-types", "~> 1.0"
  spec.add_runtime_dependency "down"
  spec.add_runtime_dependency "hanami-cli"
  spec.add_runtime_dependency "hanami-utils"
  spec.add_runtime_dependency "rack"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
