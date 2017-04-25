require "bundler/setup"
require "pathname"
require "byebug"
require "open3"

SPEC_ROOT = Pathname(__FILE__).dirname

Dir["#{SPEC_ROOT}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include(Helpers)
end
