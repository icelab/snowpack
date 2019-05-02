# frozen_string_literal: true

require "dry/inflector"
require_relative "../../generator"

module Snowflakes
  module Generators
    module Application
      class Generator < Snowflakes::Generator
        # FIXME: need to make templates_dir handling nicer, also support multiple dirs
        def initialize(templates_dir: nil)
          templates_dir ||= File.join(__dir__, "templates")
          super(templates_dir: templates_dir)
        end

        def call(output_dir, application_name)
          super(output_dir, env(application_name))
        end

        private

        def env(application_name)
          {
            underscored_application_name: inflector.underscore(application_name),
            camel_cased_application_name: inflector.camelize(application_name),
          }
        end

        def inflector
          @inflector ||= Dry::Inflector.new
        end
      end
    end
  end
end
