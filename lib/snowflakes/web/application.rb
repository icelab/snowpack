require "rack"
require "hanami/controller"
require_relative "router"

module Snowflakes
  module Web
    class Application
      def initialize(application, &routes)
        resolver = application.config.web.routing.endpoint_resolver

        router = Router.new(
          application: application,
          endpoint_resolver: resolver,
          &routes
        )

        @app = Rack::Builder.new do
          use application[:rack_monitor]

          router.middlewares.each do |(*middleware, block)|
            use(*middleware, &block)
          end

          run router
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
