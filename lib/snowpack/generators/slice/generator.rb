# frozen_string_literal: true

require "dry/inflector"
require "securerandom"
require "shellwords"
require_relative "../../generator"

module Snowpack
  module Generators
    module Slice
      class Generator < Snowpack::Generator
        # FIXME: need to make templates_dir handling nicer, also support multiple dirs
        def initialize(templates_dir: nil)
          templates_dir ||= File.join(__dir__, "templates")
          super(templates_dir: templates_dir)
        end

        def call(application:, slice_name:, web:)
          slice_name = inflector.underscore(slice_name)

          output_dir = application.config.root.join("slices", slice_name) # TODO: don't hardcode "slices"

          super(
            output_dir,
            env(application: application, slice_name: slice_name, web: web),
          )
        end

        private

        def templates(web:, **)
          super.then { |tpls|
            if !web
              tpls.reject { |tpl|
                File.fnmatch?("*/web/**", tpl)
              }
            else
              tpls
            end
          }
        end

        def env(application:, slice_name:, **others)
          application_path = inflector.underscore(application.module.to_s)

          {
            application_path: application_path,
            application_module: application.module.to_s,
            slice_name: slice_name,
            slice_path: "#{application_path}/#{slice_name}",
            slice_module: inflector.camelize(slice_name),
          }.merge(**others)
        end

        # TODO: use application's own inflector
        def inflector
          @inflector ||= Dry::Inflector.new
        end
      end
    end
  end
end
