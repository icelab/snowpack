require 'snowflakes/commands/abstract'

module Snowflakes
  module Commands
    module Routes
      class Update < Abstract
        def start
          measure("routes.json updated") do
            `bundle exec roda-parse_routes #{app.route_files} -f #{app.routes_json_file}`
          end
        end
      end
    end
  end
end
