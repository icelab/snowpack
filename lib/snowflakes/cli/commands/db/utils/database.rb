require "hanami/cli"
require "snowflakes/cli/command"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module DB
        module Utils
          class Database
            def self.for_application(application)
              application.boot :persistence
              new(application.container["persistence.config"])
            end

            attr_reader :config

            def initialize(config)
              @config = config
            end

            def url
              gateway.connection.url
            end

            def name
              url.split("/").last
            end

            def applied_migrations
              sequel_migrator.applied_migrations
            end

            def gateway
              config.gateways[:default]
            end

            def connection
              gateway.connection
            end

            def migrator
              gateway.migrator
            end

            def applied_migrations
              sequel_migrator.applied_migrations
            end

            private

            def sequel_migrator
              Sequel::TimestampMigrator.new(migrator.connection, migrator.path, {})
            end
          end
        end
      end
    end
  end
end
