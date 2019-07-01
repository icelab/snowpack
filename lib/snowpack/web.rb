# frozen_string_literal: true

require_relative "../snowpack"
require_relative "web/application"

module Snowpack
  module Web
    def self.routes(&block)
      if block
        @routes = block
      else
        @routes
      end
    end

    def self.application
      @application ||= Application.new(Snowpack.application, &routes)
    end
  end
end
