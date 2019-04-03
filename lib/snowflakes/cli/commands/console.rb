require "hanami/cli"
require "snowflakes/cli/command"
require "snowflakes/console/context"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      class Console < Command
        REPL = begin
          require 'pry'
          Pry
        rescue LoadError
          require 'irb'
          IRB
        end

        desc "Open interactive console"

        def call(**)
          measure "#{prompt_prefix} booted in" do
            out.puts "=> starting #{prompt_prefix} console"
            application.boot!
          end

          start_repl
        end

        private

        def start_repl
          context = Snowflakes::Console::Context.new(application)
          REPL.start(context, prompt: [proc { default_prompt }, proc { indented_prompt }])
        end

        def default_prompt
          "#{prompt_prefix}> "
        end

        def indented_prompt
          "#{prompt_prefix}* "
        end

        def prompt_prefix
          "#{inflector.underscore(application.config.name)}[#{application.env}]"
        end
      end
    end

    register "console", Commands::Console
  end
end
