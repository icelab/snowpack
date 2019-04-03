require_relative "../snowflakes"

module Snowflakes
  class Slice < Dry::System::Container
    # TODO: propagate from Snowflakes.application instead
    use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development').to_sym }
    use :logging
    use :notifications
    use :monitoring

    # From dry-web, TODO remove
    setting :logger_class, Dry::Monitor::Logger
    setting :listeners, false # TODO: work out why this is needed

    def self.inherited(klass)
      raise "Snowflakes.application not configured yet" unless Snowflakes.application?

      # TODO: DO MORE TO WIRE THINGS UP

      super
    end
  end
end
