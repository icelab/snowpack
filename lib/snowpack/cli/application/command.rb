# frozen_string_literal: true

require_relative "../command"

module Snowpack
  module CLI
    module Application
      class Command < Snowpack::CLI::Command
        def self.inherited(klass)
          super

          klass.option :env, aliases: ["-e"], default: nil, desc: "Application environment"
        end

        attr_reader :application

        def initialize(application: nil, **opts)
          super(**opts)
          @application = application
        end

        # TODO: inject application inflector
        def with_application(application)
          self.class.new(
            command_name: @command_name,
            application: application,
            out: out,
            files: files,
          )
        end

        private

        def run_command(klass, *args)
          klass.new(
            command_name: klass.name,
            application: application,
            out: out,
            files: files,
          ).call(*args)
        end

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
