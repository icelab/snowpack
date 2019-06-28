# frozen_string_literal: true

require "hanami/cli"
require "hanami/cli/command"
require "snowflakes/cli/command"
require "snowflakes/generators/slice/generator"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module Generate
        # TODO: this doesn't need "-e" environment option
        class Slice < Command
          desc "Generate slice"

          argument :name, desc: "Name for the slice"
          option :web, type: :boolean, default: true, desc: "Include web routing and views support in generated slice"

          def call(name:, web:, **)
            name ||= path

            # TODO
            # raise ArgumentError, "invalid name blah blah"

            # TODO: make it so we can use out.puts again
            puts "Generating slice..."

            generator = Generators::Slice::Generator.new
            generator.(application: application, slice_name: name, web: web)
          end
        end
      end

      register "generate slice", Commands::Generate::Slice
    end
  end
end
