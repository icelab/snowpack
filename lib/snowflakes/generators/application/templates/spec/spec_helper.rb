# frozen_string_literal: true

ENV["RACK_ENV"] = "test"

require_relative "../config/application"
require_relative "support/suite"

SPEC_ROOT = Pathname(__dir__).freeze
FIXTURES_PATH = SPEC_ROOT.join("fixtures").freeze

suite = Test::Suite.instance

suite.start_coverage
