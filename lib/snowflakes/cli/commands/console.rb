require "hanami/cli"
require "snowflakes/cli/command"

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
            application.boot
          end

          start_repl
        end

        private

        def start_repl
          REPL.start(application.context, prompt: [proc { prompt_default }, proc { prompt_indented }])
        end

        def prompt_indented
          "#{prompt_prefix}* "
        end

        def prompt_default
          "#{prompt_prefix}> "
        end

        def prompt_prefix
          "#{inflector.underscore(application.name)}[#{application.env}]"
        end
      end
    end

    register "console", Commands::Console
  end
end
