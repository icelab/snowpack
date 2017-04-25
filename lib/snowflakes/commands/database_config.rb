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
        URI.parse(app.container.settings[:database_url])
      end
    end
  end
end
