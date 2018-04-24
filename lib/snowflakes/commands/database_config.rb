require 'snowflakes/commands/abstract'
require 'uri'

module Snowflakes
  module Commands
    class DatabaseConfig < Abstract
      private

      def hostname
        uri.hostname
      end

      def username
        uri.user || nil
      end

      def port
        uri.port || 5432
      end

      def username_flag
        username ? "-U #{username}" : ""
      end

      def db_name
        @db_name ||= uri.path.gsub(/^\//, '')
      end

      def uri
        URI.parse(app.container.settings[:database_url])
      end
    end
  end
end
