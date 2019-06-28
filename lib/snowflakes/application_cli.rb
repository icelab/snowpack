# frozen_string_literal: true

require "hanami/cli"
require_relative "../snowflakes"
require_relative "cli/command"
require_relative "cli/commands"

module Snowflakes
  class ApplicationCLI < Hanami::CLI
    def self.application
      if Snowflakes.application?
        Snowflakes.application
      else
        nil
      end
    end

    attr_reader :application

    def initialize(application: self.class.application, commands: Commands)
      super(commands)
      @application = application
    end

    private

    # TODO: we should make a prepare_command method upstream
    def parse(result, out)
      command, arguments = super

      if command.respond_to?(:with_application)
        application.config.env = arguments[:env] if arguments[:env]
        [command.with_application(application), arguments]
      else
        [command, arguments]
      end
    end
  end
end
