require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      module Structure
        class Dump < Database
          def start
            measure("#{db_name} structure dumped to #{output_file}") do
              system(%(pg_dump -h #{hostname} --schema-only --no-owner #{db_name} > #{output_file}))
            end
          end

          private

          def output_file
            "#{app.root}/db/structure.sql"
          end
        end
      end
    end
  end
end
