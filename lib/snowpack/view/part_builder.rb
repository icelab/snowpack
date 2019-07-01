# frozen_string_literal: true

require "dry/view/part_builder"
require "snowpack/view/parts/pager"
require_relative "parts/paginated"

module Snowpack
  module View
    class PartBuilder < Dry::View::PartBuilder
      def call(name, value, **options)
        if paginated_collection?(value)
          build_paginated_collection_part(name, value, **options)
        else
          super
        end
      end

      private

      def paginated_collection?(value)
        value.respond_to?(:to_a) && value.respond_to?(:pager)
      end

      def build_paginated_collection_part(name, value, **options)
        pager_part = build_part(:pager, value.pager, as: Snowpack::View::Parts::Pager)

        collection_as = collection_options(name: name, **options)[:as]
        item_name, item_as = collection_item_options(name: name, **options).values_at(:name, :as)

        arr = value.to_ary.map { |obj|
          call(item_name, obj, **options.merge(as: item_as))
        }

        collection_part_class = part_class(name: name, fallback_class: Parts::Paginated, **options.merge(as: collection_as))

        collection_part_class.new(
          name: name,
          value: arr,
          pager: pager_part,
          render_env: render_env,
        )
      end
    end
  end
end
