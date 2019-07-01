# frozen_string_literal: true

require "dry/types"

module Snowpack
  module Types
    include Dry.Types(default: :strict)
  end
end
