require 'rspec/core'

module Snowflakes
  module Test
    module Helpers
      module_function

      def suite
        @__suite__ ||= RSpec.configuration.suite
      end
    end

    class Suite
      DB_CLEANUP_PATH_REGEX = /(features|integration)/

      def self.inherited(klass)
        super
        Suite.current = klass
      end

      class << self
        attr_accessor :current

        def root
          @__root__ ||= Pathname(Dir.pwd).join("spec").freeze
        end
      end

      def self.configure(&block)
        RSpec.configure do |config|
          config.add_setting :suite

          config.suite = self.new

          config.include Helpers

          config.disable_monkey_patching!

          config.expect_with :rspec do |expectations|
            expectations.include_chain_clauses_in_custom_matcher_descriptions = true
          end

          config.mock_with :rspec do |mocks|
            mocks.verify_partial_doubles = true
          end

          config.filter_run :focus
          config.run_all_when_everything_filtered = true

          config.example_status_persistence_file_path = root.join("../tmp").realpath.join("spec/examples.txt").to_s

          if config.files_to_run.one?
            config.default_formatter = "doc"
          end

          config.profile_examples = 10

          config.order = :random

          Kernel.srand config.seed

          yield(config) if block_given?
        end
      end

      attr_reader :root

      def initialize(root = self.class.root.join("suite"))
        @root = root
      end

      def file_group(idx = nil)
        case idx
        when -1 then files
        when 0 then chdir(:integration).files + chdir(:main).files
        when 1 then chdir(:admin).files
        else
          files
        end
      end

      def chdir(name)
        self.class.new(root.join(name.to_s))
      end

      def files
        dirs.map { |dir| dir.join("**/*_spec.rb") }.flat_map { |path| Dir[path] }.sort
      end

      def groups
        dirs.map(&:basename).map(&:to_s).map(&:to_sym).sort
      end

      def dirs
        Dir[root.join("*")].map(&Kernel.method(:Pathname)).select(&:directory?)
      end

      def capybara_server_port
        3001
      end

      def clean_db?(example)
        DB_CLEANUP_PATH_REGEX.match?(example.metadata[:file_path])
      end
    end
  end
end
