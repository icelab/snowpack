# frozen_string_literal: true

require "snowpack/cli/application/command"

module Snowpack
  module CLI
    module Application
      module Commands
        module Routes
          class Update < Command
            desc "Update Roda routes.json"

            def call(**)
              measure "routes.json updated" do
                `bundle exec roda-parse_routes #{route_files} -f #{routes_json_file}`
              end
            end

            private

            def route_files
              Dir["#{application.root}/apps/**/web/routes/**/*.rb"].join(" ")
            end

            def routes_json_file
              "#{application.root}/config/routes.json"
            end
          end
        end

        register "routes update", Routes::Update
      end
    end
  end
end
