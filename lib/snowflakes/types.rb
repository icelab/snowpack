# frozen_string_literal: true

require "dry/types"

module Snowflakes
  module Types
    include Dry.Types(default: :strict)
  end
end
