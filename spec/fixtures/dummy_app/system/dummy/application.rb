# frozen_string_literal: true

require "snowpack/application"

module Dummy
  class Application < Snowpack::Application
    # use :env
    configure do |config|
      config.name = :dummy
      config.root = File.join(__dir__, "../..")
    end
  end
end
