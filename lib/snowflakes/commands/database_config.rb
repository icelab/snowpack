require 'snowflakes/commands/abstract'
require 'uri'

module Snowflakes
  module Commands
    class DatabaseConfig < Abstract
      private

      def hostname
        uri.hostname
      end

      def db_name
        @db_name ||= uri.path.gsub(/^\//, '')
      end

      def uri
        @uri ||= URI.parse(app.container.settings[:database_url])
      end

      def postgres_cli_env_vars
        @postgres_cli_env_vars ||= {}.tap do |vars|
          vars["PGHOST"] = uri.host.to_s
          vars["PGPORT"] = uri.port.to_s if uri.port
          vars["PGUSER"] = uri.user.to_s if uri.user
          vars["PGPASSWORD"] = uri.password.to_s if uri.password
        end
      end
    end
  end
end
