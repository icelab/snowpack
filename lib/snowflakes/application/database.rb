require "hanami/cli"
require "snowflakes/cli/command"

module Snowflakes
  class Application
    class Database
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def name
        gateway.connection.url.split("/").last
      end

      def gateway
        config.gateways[:default]
      end

      def connection
        gateway.connection
      end

      def applied_migrations
        sequel_migrator.applied_migrations
      end

      private

      def migrator
        gateway.migrator
      end

      def sequel_migrator
        Sequel::TimestampMigrator.new(migrator.connection, migrator.path, {})
      end
    end
  end
end
