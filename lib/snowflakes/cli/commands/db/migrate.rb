# frozen_string_literal: true

require "hanami/cli"
require "snowflakes/cli/command"
require_relative "structure/dump"
require_relative "utils/database"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module DB
        class Migrate < Command
          desc "Migrates database"

          option :target, desc: "Target migration number", aliases: ["-t"]

          def call(target: nil, **)
            measure "database #{database.name} migrated" do
              if target
                run_migrations(target: target)
              else
                run_migrations
              end
            end

            run_command Structure::Dump
          end

          private

          def run_migrations(**options  )
            ROM::SQL.with_gateway(database.gateway) do
              database.migrator.run(options)
            end
          end

          def database
            @database ||= Utils::Database.for_application(application)
          end
        end
      end
    end

    register "db migrate", Commands::DB::Migrate
  end
end
