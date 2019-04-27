require "rack"
require "hanami/controller"
require_relative "endpoint_resolver"
require_relative "router"

module Snowflakes
  module Web
    class Application
      def initialize(application, &routes)
        # TODO: support passing config from application?
        resolver = EndpointResolver.new(application: application)

        router = Router.new(
          application: application,
          endpoint_resolver: resolver,
          configuration: resolve_configuration(application),
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

      private

      def resolve_configuration(application)
        # TODO: can we make this cleaner somehow? via application settings?
        if application.key?(key = "web.action.configuration")
          application[key]
        else
          Hanami::Controller::Configuration.new
        end
      end
    end
  end
end
