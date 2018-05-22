require "shellwords"
require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      module Structure
        class Dump < Database
          def start
            measure("#{db_name} structure dumped to #{output_file}") do
              # To avoid version incompatibility errors we want to run pg_dump
              # on the same system as the actual running database.
              cmd =
                if docker_compose_postgres?
                  "docker-compose exec postgres 'pg_dump --schema-only --no-owner #{Shellwords.escape(db_name)}' > #{output_file}"
                else
                  "pg_dump --schema-only --no-owner #{Shellwords.escape(db_name)} > #{output_file}"
                end

              system(postgres_cli_env_vars, cmd)
            end
          end

          private

          def docker_compose_postgres?
            services = `docker-compose ps --services`
            $?.success? && services.split("\n").include?("postgres")
          end

          def output_file
            "#{app.root}/db/structure.sql"
          end
        end
      end
    end
  end
end
