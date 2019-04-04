require_relative "../snowflakes"

module Snowflakes
  class Slice < Dry::System::Container
    use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development').to_sym }

    def self.inherited(klass)
      super

      raise "Snowflakes.application not configured yet" unless Snowflakes.application?

      Snowflakes.application.tap do |app|
        klass.config.env = app.env
        klass.config.auto_register = %w[lib]

        klass.register :logger, app[:logger]
        klass.register :rack_monitor, app[:rack_monitor] # do we need?
      end

      klass.after :configure do
        klass.load_paths! "lib"
      end
    end

    def self.boot!
      finalize!
    end
  end
end
