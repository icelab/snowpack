require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      class Version < Database
        def start
          version =
            if connection.tables.include?(:schema_migrations)
              connection[:schema_migrations].
                order(:filename).
                reverse.
                limit(1).
                first[:filename]
            else
              "not available"
            end

          puts "=> current schema version is #{version}"
        end
      end
    end
  end
end
