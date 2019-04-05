# frozen_string_literal: true

require "hanami/cli"
require "snowflakes/cli/command"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module Assets
        class Clobber < Command
          desc "Delete compiled assets"

          def call(**)
            FileUtils.rm_rf(compiled_assets_path)
            out.puts "=> assets removed from #{compiled_assets_path}"
          end

          private

          def compiled_assets_path
            File.join(application.root, "public/assets")
          end
        end
      end
    end

    register "assets clobber", Commands::Assets::Clobber
  end
end
