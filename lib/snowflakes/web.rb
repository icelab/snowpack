# frozen_string_literal: true

require_relative "../snowflakes"
require_relative "web/application"

module Snowflakes
  module Web
    def self.routes(&block)
      if block
        @routes = block
      else
        @routes
      end
    end

    def self.application
      @application ||= Application.new(Snowflakes.application, &routes)
    end
  end
end
