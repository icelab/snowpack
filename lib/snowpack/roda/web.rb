# frozen_string_literal: true

# TODO wrap in begin/rescue loaderror and raise a meaningful exception
require "roda"
require "roda/plugins/flow"

module Snowpack
  module Roda
    # Mostly copied from Dry::Web::Roda::Application
    class Web < ::Roda
      extend Dry::Configurable

      setting :container, reader: true
      setting :routes

      plugin :flow

      # Disable this so we can better control when it's used
      #
      # def self.configure(&block)
      #   super.tap do
      #     use(container[:rack_monitor]) if container.config.listeners
      #   end
      # end

      def self.resolve(name)
        container[name]
      end

      def self.[](name)
        container[name]
      end

      def self.load_routes!
        Dir[root.join("#{config.routes}/**/*.rb")].each { |f| require f }
      end

      def self.root
        container.config.root
      end

      # def notifications
      #   self.class[:notifications]
      # end
    end
  end
end
