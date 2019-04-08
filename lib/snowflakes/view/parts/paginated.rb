# frozen_string_literal: true

require "dry/view/part"

module Snowflakes
  module View
    module Parts
      class Paginated < Dry::View::Part
        attr_reader :pager

        def initialize(pager:, **part_args)
          @pager = pager
          super(**part_args)
        end

        def pagination(locals: {}, **options)
          pager.with(**options).render(:pagination, **locals)
        end
      end
    end
  end
end
