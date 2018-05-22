require "shellwords"
require 'snowflakes/commands/database_config'

module Snowflakes
  module Commands
    module Db
      class Drop < DatabaseConfig
        def start
          system(postgres_cli_env_vars, "dropdb #{Shellwords.escape(db_name)}")
          puts "=> database #{db_name} dropped" if $?.success?
        end
      end
    end
  end
end
