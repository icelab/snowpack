# frozen_string_literal: true

require "snowflakes/cli/command"
require "snowflakes/generators/application/generator"

module Snowflakes
  module CLI
    module Standalone
      module Commands
        class New < Command
          argument :path, desc: "Path for new application"
          option :name, desc: "Name for the application"

          def call(path:, name: nil, **)
            name ||= path

            # TODO raise ArgumentError, "invalid name application"

            out.puts "Generating into #{path}..."

            generator = Generators::Application::Generator.new
            generator.(path, name)

            out.puts "Bootstrapping..."
            system "#{path}/script/bootstrap"
          end
        end

        register "new", New
      end
    end
  end
end
