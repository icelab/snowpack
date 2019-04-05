# frozen_string_literal: true

require "hanami/cli"
require_relative "../snowflakes"
require_relative "cli/commands"

module Snowflakes
  class CLI < Hanami::CLI
    attr_reader :application

    def initialize(application: Snowflakes.application, commands: Commands)
      super(commands)
      @application = application
    end

    private

    # TODO: we should make a prepare_command method upstream
    def parse(result, out)
      command, arguments = super

      application.config.env = arguments[:env] if arguments[:env]

      [command.with_application(application), arguments]
    end
  end
end
