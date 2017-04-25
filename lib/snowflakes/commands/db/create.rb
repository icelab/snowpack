require 'snowflakes/commands/database_config'

module Snowflakes
  module Commands
    module Db
      class Create < DatabaseConfig
        def start
          `createdb #{db_name}`
          puts "=> database #{db_name} created"
        end
      end
    end
  end
end
