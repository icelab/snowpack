# frozen_string_literal: true

require "hanami/cli"
require "snowflakes/cli/application/command"

module Snowflakes
  module CLI
    module Application
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

        register "assets clobber", Assets::Clobber
      end
    end
  end
end
