# frozen_string_literal: true

require "dry/view/part"
require "rack/utils"
require "uri"

module Snowflakes
  module View
    module Parts
      class Pager < Dry::View::Part
        attr_reader :part_args
        attr_reader :buffer

        def initialize(buffer: 3, **part_args)
          @part_args = part_args
          @buffer = buffer

          super(**part_args)
        end

        def with(**options)
          new_options = {
            buffer: buffer
          }.merge(options)

          self.class.new(**new_options, **part_args)
        end

        def first_page
          1
        end

        def first_page?
          current_page == first_page
        end

        def last_page
          total_pages
        end

        def last_page?
          current_page == last_page
        end

        def prev_gap?
          current_page - buffer > first_page
        end

        def next_gap?
          current_page + buffer < last_page
        end

        def single_page?
          total_pages <= 1
        end

        def all_page_numbers
          (first_page..last_page).to_a
        end

        def each_entry
          return to_enum(:each_entry) unless block_given?

          entry_numbers.each do |number|
            yield Entry.new(number, current: number == current_page)
          end
        end

        def url_for_page(page)
          uri = URI(_context.fullpath)
          params = Rack::Utils.parse_query(uri.query).merge("page" => page.to_s)
          uri.query = Rack::Utils.build_query(params)
          uri.to_s
        end

        private

        def entry_numbers
          left_edge = current_page - buffer
          left_edge = 1 if left_edge < 1

          right_edge = current_page + buffer
          right_edge = total_pages if right_edge > total_pages

          left_edge.upto(right_edge).to_a
        end

        class Entry
          attr_reader :number

          def initialize(number, current:)
            @number = number
            @current = current
          end

          def to_s
            number.to_s
          end

          def current?
            !!@current
          end
        end
      end
    end
  end
end
