require "hanami/cli"
require "snowflakes/cli/command"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module DB
        module Structure
          class Dump < Command
            desc "Dumps database structure to db/structure.sql file"

            def call(*)
              database = application.database

              measure("#{database.name} structure dumped to db/structure.sql") do
                cmd = "pg_dump --schema-only --no-owner #{Shellwords.escape(database.name)} > #{output_file}"
                system(database.cli_env_vars, cmd)
              end
            end

            private

            def output_file
              "#{application.root}/db/structure.sql"
            end
          end
        end
      end

      register "db structure dump", DB::Structure::Dump
    end
  end
end
