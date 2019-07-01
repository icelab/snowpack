# frozen_string_literal: true

require "snowpack/cli/application/command"
require "snowpack/generators/slice/generator"

module Snowpack
  module CLI
    module Application
      module Commands
        module Generate
          class Slice < Command
            desc "Generate slice"

            argument :name, desc: "Name for the slice"
            option :web, type: :boolean, default: true, desc: "Include web routing and views support in generated slice"

            def call(name:, web:, **)
              name ||= path

              # TODO raise ArgumentError, "invalid name blah blah"

              generator = Generators::Slice::Generator.new
              generator.(application: application, slice_name: name, web: web)
            end
          end
        end

        register "generate slice", Generate::Slice
      end
    end
  end
end
