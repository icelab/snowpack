require "hanami/cli"
require "snowflakes/cli/command"

module Snowflakes
  class Application
    class Database
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def url
        gateway.connection.url
      end

      def uri
        @uri ||= URI.parse(url)
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

      def applied_migrations
        sequel_migrator.applied_migrations
      end

      def cli_env_vars
        @postgres_cli_env_vars ||= {}.tap do |vars|
          vars["PGHOST"] = uri.host.to_s
          vars["PGPORT"] = uri.port.to_s if uri.port
          vars["PGUSER"] = uri.user.to_s if uri.user
          vars["PGPASSWORD"] = uri.password.to_s if uri.password
        end
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
