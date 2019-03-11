require "hanami/cli"
require_relative "application"
require_relative "cli/commands"

module Snowflakes
  class CLI < Hanami::CLI
    attr_reader :container

    def initialize(commands: Commands, container:)
      super(commands)
      @container = container
    end

    private

    # TODO: we should make a prepare_command method upstream
    def parse(result, out)
      command, arguments = super

      application = application(arguments[:env])

      [command.with_application(application), arguments]
    end

    def application(env)
      Application.new(container, env: env)
    end
  end
end
