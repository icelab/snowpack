# frozen_string_literal: true

require "hanami/cli"
require "hanami/cli/command"
require "snowflakes/generators/application/generator"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      class New < Hanami::CLI::Command
        argument :path, desc: "Path for new application"
        option :name, desc: "Name for the application"

        def call(path:, name: nil, **)
          name ||= path

          # TODO
          # raise ArgumentError, "invalid name application"

          generator = Generators::Application::Generator.new
          generator.(path, name)

          # TODO: make it so we can use out.puts again
          puts "Done!"
        end
      end
    end

    register "new", Commands::New
  end
end
