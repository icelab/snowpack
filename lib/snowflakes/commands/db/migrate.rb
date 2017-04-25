require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      class Migrate < Database
        def start(target = nil)
          measure("migrations executed") do
            if target
              gateway.run_migrations(target: target)
            else
              gateway.run_migrations
            end
          end
        end
      end
    end
  end
end
