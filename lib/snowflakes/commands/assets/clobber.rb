require 'snowflakes/commands/abstract'

module Snowflakes
  module Commands
    module Assets
      class Clobber < Abstract
        def start
          FileUtils.rm_rf(app.precompiled_assets_path)
          puts "=> assets removed from #{app.precompiled_assets_path}"
        end
      end
    end
  end
end
