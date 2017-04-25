require 'snowflakes/commands/abstract'

module Snowflakes
  module Commands
    module Assets
      class Precompile < Abstract
        def start
          measure("assets precompiled into #{app.precompiled_assets_path}") do
            `yarn run build-production`
          end
        end
      end
    end
  end
end
