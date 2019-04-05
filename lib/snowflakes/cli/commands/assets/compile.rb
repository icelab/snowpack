# frozen_string_literal: true

require "hanami/cli"
require "snowflakes/cli/command"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module Assets
        class Compile < Command
          desc "Compiles assets"

          def call(**)
            measure "assets compiled into #{compiled_assets_path}" do
              `yarn run build-production` # TODO use shell helper here
            end
          end

          private

          def compiled_assets_path
            File.join(application.root, "public/assets")
          end
        end
      end
    end

    register "assets compile", Commands::Assets::Compile, aliases: ["precompile"]
  end
end
