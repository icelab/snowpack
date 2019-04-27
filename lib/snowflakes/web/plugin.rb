require "dry/system/plugins"
require_relative "rack_logger"

module Snowflakes
  module Web
    module Plugin
      def self.extended(system)
        super

        system.setting :web do
          setting :logging do
            setting :filter_params, %w[_csrf password password_confirmation]
          end
        end

        system.after :configure do
          register_rack_monitor
          attach_rack_logger
        end
      end

      def register_rack_monitor
        return self if key?(:rack_monitor)
        register :rack_monitor, Dry::Monitor::Rack::Middleware.new(self[:notifications])
        self
      end

      def attach_rack_logger
        RackLogger.new(self[:logger], filter_params: config.web.logging.filter_params).attach(self[:rack_monitor])
        self
      end
    end

    Dry::System::Plugins.register :web, Plugin
  end
end
