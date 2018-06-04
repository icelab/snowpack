require "shellwords"
require 'snowflakes/commands/database_config'

module Snowflakes
  module Commands
    module Db
      class Create < DatabaseConfig
        def start
          system(postgres_cli_env_vars, "createdb #{Shellwords.escape(db_name)}")
          puts "=> database #{db_name} created" if $?.success?
        end
      end
    end
  end
end
