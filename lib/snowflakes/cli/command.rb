# frozen_string_literal: true

require "hanami/cli"
require "hanami/cli/command"
require "hanami/utils/files"
require "snowflakes/application"
require "snowflakes/config"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      class Command < Hanami::CLI::Command
        def self.inherited(klass)
          super

          klass.option :env, aliases: ["-e"], default: "development", desc: "Application environment"
        end

        attr_reader :application
        attr_reader :out
        attr_reader :files

        # WIP: play with injecting `out, files` from Snowflakes::CLI?
        def initialize(command_name:, application: nil, out: $stdout, files: Hanami::Utils::Files)
          super(command_name: command_name)

          @application = application
          @out = out
          @files = files
        end

        def with_application(application)
          self.class.new(
            command_name: @command_name,
            application: application,
            out: @out,
            files: @files,
          )
        end

        private

        def measure(desc, &block)
          start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          block.call
          stop = Process.clock_gettime(Process::CLOCK_MONOTONIC)

          out.puts "=> #{desc} in #{(stop - start).round(1)}s"
        end
      end
    end
  end
end
