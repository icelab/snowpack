# frozen_string_literal: true

require "bundler/setup"
require "pathname"
require "open3"

SPEC_ROOT = Pathname(__dir__).realpath

Dir["#{SPEC_ROOT}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include(Helpers)
end
