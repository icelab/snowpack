# frozen_string_literal: true

require "dry/view/decorator"
require "dry/view/part"
require "inflecto"

module Snowflakes
  module Web
    class Decorator
      attr_reader :parts

      def initialize
        @parts = {}
      end

      def call(name, value, renderer:, context:, **options)
        if paginated_results?(value)
          decorate_paginated_results(name, value, renderer: renderer, context: context, **options)
        elsif value.respond_to?(:to_ary)
          decorate_array(name, value, renderer: renderer, context: context, **options)
        else
          klass = part_class(name, value, **options)
          klass.new(name: name, value: value, renderer: renderer, context: context)
        end
      end

      private

      def decorate_array(name, value, renderer:, context:, **options)
        klass = part_class(name, value, **options)

        singular_name = Inflecto.singularize(name).to_sym
        singular_options = singularize_options(options)

        arr = value.to_ary.map { |obj|
          call(singular_name, obj, renderer: renderer, context: context, **singular_options)
        }

        klass.new(name: name, value: arr, renderer: renderer, context: context)
      end

      def paginated_results?(value)
        value.respond_to?(:to_a) && value.respond_to?(:pager)
      end

      def decorate_paginated_results(name, value, renderer:, context:, **options)
        pager = parts.fetch(:pager).new(
          name: :pager,
          value: value.pager,
          renderer: renderer,
          context: context,
        )

        singular_name = Inflecto.singularize(name).to_sym
        singular_options = singularize_options(options)

        results = value.to_ary.map { |obj|
          call(singular_name, obj, renderer: renderer, context: context, **singular_options)
        }

        results_class = part_class(name, value, fallback: parts.fetch(:paginated_results), **options)

        results_class.new(
          name: name,
          value: results,
          pager: pager,
          renderer: renderer,
          context: context,
        )
      end

      def singularize_options(options)
        if options[:as].is_a?(Symbol)
          options.merge(as: Inflecto.singularize(options[:as]).to_sym)
        else
          options
        end
      end

      def part_class(name, _value, fallback: Dry::View::Part, **options)
        if (custom_name = options[:as])
          custom_name.is_a?(Class) ? options[:as] : resolve_part_class(custom_name, fallback)
        else
          resolve_part_class(name, fallback)
        end
      end

      def resolve_part_class(name, fallback)
        parts.fetch(name) { fallback }
      end
    end
  end
end
