require "rack"
require "hanami/controller"
require_relative "endpoint_resolver"
require_relative "router"

module Snowflakes
  module Web
    class Application
      def initialize(application)
        # TODO: support passing config from application?
        resolver = EndpointResolver.new(application: application)

        # TODO: can we make this cleaner somehow? via application settings?
        configuration = application.key?(key = "web.action.configuration") ? application[key] : Hanami::Controller::Configuration.new

        router = Router.new(
          endpoint_resolver: resolver,
          configuration: configuration,
          &application.routes
        )

        @app = Rack::Builder.new do
          # TODO: load middleware, from application config

          run router
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
