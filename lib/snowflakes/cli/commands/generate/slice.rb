# frozen_string_literal: true

require "hanami/cli"
require "hanami/cli/command"
require "snowflakes/cli/command"
require "snowflakes/generators/slice/generator"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module Generate
        class Slice < Command
          argument :name, desc: "Name for the slice"

          def call(name:, **)
            name ||= path

            # TODO
            # raise ArgumentError, "invalid name blah blah"

            # TODO: make it so we can use out.puts again
            puts "Generating slice..."

            generator = Generators::Slice::Generator.new
            generator.(application: application, slice_name: name)
          end
        end
      end

      register "generate slice", Commands::Generate::Slice
    end
  end
end
