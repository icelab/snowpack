require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      module Structure
        class Dump < Database
          def start
            system(%(pg_dump -h #{hostname} --schema-only --no-owner #{db_name} > #{output_file}))
          end

          private

          def output_file
            'db/structure.sql'
          end
        end
      end
    end
  end
end
