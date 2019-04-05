# frozen_string_literal: true

require "snowflakes/application"

module Dummy
  class Application < Snowflakes::Application
    # use :env
    configure do |config|
      config.name = :dummy
      config.root = File.join(__dir__, "../..")
    end
  end
end
