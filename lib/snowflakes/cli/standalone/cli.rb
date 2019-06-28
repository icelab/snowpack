require "hanami/cli"
require_relative "commands"

module Snowflakes
  module CLI
    module Standalone
      class CLI < Hanami::CLI
        def initialize(commands = Commands)
          super
        end
      end
    end
  end
end
