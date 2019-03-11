require "hanami/cli"
require "snowflakes/cli/command"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module DB
        class Rollback < Command
          desc "Rollback database to a previous migration"

          option :target, desc: "Target migration number", aliases: ["-t"]

          def call(target: nil, **)
            prepare

            target, migration_name = get_migration(target)

            require "byebug"
            byebug

            measure "database #{database_name} rolled back to #{migration_name}" do
              gateway.run_migrations(target: Integer(target))
            end
          end

          private

          def prepare
            application.boot :persistence
          end

          def gateway
            application.container["persistence.config"].gateways[:default]
          end

          def database_name
            gateway.connection.url.split("/").last
          end

          def migrator
            gateway.migrator
          end

          def sequel_migrator
            Sequel::TimestampMigrator.new(migrator.connection, migrator.path, {})
          end

          def applied_migrations
            sequel_migrator.applied_migrations
          end

          def get_migration(target)
            migration =
              if target
                applied_migrations.detect { |m| m.split("_").first == target }
              else
                applied_migrations.last
              end

            target ||= migration.split("_").first
            migration_name = File.basename(migration, ".*")

            [target, migration_name]
          end
        end
      end
    end

    register "db rollback", Commands::DB::Rollback
  end
end
