# FIXME: This is for the NotCallableEndpointError. It would be good if this
# could be require-able without having to bring in all the routing files
require "hanami/routing"

module Snowflakes
  module Web
    class EndpointResolver
      attr_reader :application
      attr_reader :container
      attr_reader :base_namespace

      def initialize(application:, container: application, namespace: "web.actions")
        @application = application
        @container = container
        @base_namespace = namespace
      end

      def sliced(name)
        slice = application.slices[name]
        return unless slice

        self.class.new(
          application: application,
          container: slice,
          namespace: base_namespace,
        )
      end

      def call(name, namespace = nil, configuration = nil)
        endpoint =
          case name
          when String
            resolve_string_identifier(name, namespace, configuration)
          when Class
            name.respond_to?(:call) ? name : name.new
          else
            name
          end

        unless endpoint.respond_to?(:call)
          raise Hanami::Routing::NotCallableEndpointError.new(endpoint)
        end

        endpoint
      end

      private

      def resolve_string_identifier(name, namespace, configuration)
        identifier = [base_namespace, namespace, name].compact.join(".")

        # byebug

        container[identifier].yield_self { |endpoint|
          if endpoint.class < Hanami::Action
            endpoint.with(configuration: configuration)
          else
            endpoint
          end
        }
      end
    end
  end
end
