require "hanami/cli"
require "snowflakes/cli/command"
require_relative "structure/dump"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module DB
        class Migrate < Command
          desc "Migrates database"

          option :target, desc: "Target migration number", aliases: ["-t"]

          def call(target: nil, **)
            database = application.database

            measure "database #{database.name} migrated" do
              if target
                database.gateway.run_migrations(target: target)
              else
                database.gateway.run_migrations
              end
            end

            run_command Structure::Dump
          end
        end
      end
    end

    register "db migrate", Commands::DB::Migrate
  end
end
