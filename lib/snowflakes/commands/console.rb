require 'snowflakes/commands/abstract'

module Snowflakes
  module Commands
    class Console < Abstract
      REPL = begin
               require 'pry'
               Pry
             rescue LoadError
               require 'irb'
               IRB
             end

      def start
        measure("#{prompt_prefix} booted in") do
          puts "=> starting #{prompt_prefix} console"
          app.boot
        end

        start_repl
      end

      def start_repl
        REPL.start(app.context, prompt: [proc { prompt_default }, proc { prompt_indented }])
      end

      def prompt_indented
        "#{prompt_prefix}* "
      end

      def prompt_default
        "#{prompt_prefix}> "
      end

      def prompt_prefix
        "#{app.name}[#{app.env}]"
      end
    end
  end
end
