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
              if docker_compose_postgres?
                env_args = postgres_cli_env_vars
                  .select { |k, _| %w[PGUSER PGPASSWORD].include?(k) }
                  .map { |k,v| "-e #{k}=#{Shellwords.escape(v)}" }
                  .join(" ")
                cmd = "docker-compose exec -T #{env_args} postgres pg_dump --schema-only --no-owner #{Shellwords.escape(db_name)} > #{output_file}"
                system(cmd)
              else
                cmd = "pg_dump --schema-only --no-owner #{Shellwords.escape(db_name)} > #{output_file}"
                system(postgres_cli_env_vars, cmd)
              end
            end
          end

          private

          def docker_compose_postgres?
            services = `docker-compose ps --services 2>/dev/null`
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
