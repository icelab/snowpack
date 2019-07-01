# frozen_string_literal: true

require "dry/inflector"
require "securerandom"
require "shellwords"
require "snowpack/version"
require_relative "../../generator"

module Snowpack
  module Generators
    module Application
      class Generator < Snowpack::Generator
        # FIXME: need to make templates_dir handling nicer, also support multiple dirs
        def initialize(templates_dir: nil)
          templates_dir ||= File.join(__dir__, "templates")
          super(templates_dir: templates_dir)
        end

        def call(output_dir, application_name)
          super(output_dir, env(application_name))
          generate_tool_versions output_dir
        end

        private

        def env(application_name)
          {
            application_path: inflector.underscore(application_name),
            application_module: inflector.camelize(application_name),
            random: -> name, *args { SecureRandom.public_send(name, *args) },
            snowpack_version: Snowpack::VERSION,
          }
        end

        def generate_tool_versions(output_dir)
          if `which asdf` && $?.success?
            versions = %w[nodejs postgres ruby]
              .map { |tool|
                version = asdf_current_version(tool)
                "#{tool} #{version}" if version
              }
              .compact

            if versions.any?
              files.write(
                File.join(output_dir, ".tool-versions"),
                versions.join("\n") + "\n",
              )
            end
          end
        end

        def asdf_current_version(tool)
          output = `asdf current #{Shellwords.shellescape(tool)}`

          # Handle this output:
          # 2.6.2    (set by /path/to/.tool-versions)
          output.split(" ").first if $?.success?
        end

        def inflector
          @inflector ||= Dry::Inflector.new
        end
      end
    end
  end
end
