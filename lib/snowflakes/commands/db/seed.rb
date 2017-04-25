require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      class Seed < Database
        def prepare
          app.boot
        end

        def start
          if app.has_db_seed?
            app.load_db_seed
            puts "=> db seed loaded"
          else
            puts "=> app has no db seed"
          end
        end
      end
    end
  end
end
