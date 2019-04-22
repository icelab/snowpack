require "hanami/router"

module Snowflakes
  module Web
    class Router < Hanami::Router
      attr_reader :middlewares

      def initialize(**options, &block)
        @options = options
        @middlewares = []
        super
      end

      def use(*args, &block)
        middlewares << (args << block)
      end

      def mount(app, at:, host: nil, &block)
        if app.is_a?(Symbol) && (sliced_resolver = @endpoint_resolver.sliced(app))
          sliced_router = self.class.new(
            **@options,
            endpoint_resolver: sliced_resolver,
            &block
          )

          super(sliced_router, at: at, host: host)
        else
          super(app, at: at, host: host)
        end
      end

      def match?(env)
        match_path?(env)
      end
    end
  end
end