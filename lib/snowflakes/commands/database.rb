require 'snowflakes/commands/database_config'
require 'uri'

module Snowflakes
  module Commands
    class Database < DatabaseConfig
      def prepare
        app.boot(:rom)
      end

      def gateway
        app.container['persistence.config'].gateways[:default]
      end

      def connection
        gateway.connection
      end
    end
  end
end
