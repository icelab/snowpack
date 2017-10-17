require "formalist"
require "formalist/elements/standard"
require "json"
require "dry-configurable"

module Snowflakes
  module Components
    module Formalist
      class Form < ::Formalist::Form
        setting :prefix

        class Result
          attr_reader :output, :prefix

          def initialize(output, prefix)
            @output = output
            @prefix = prefix
          end

          def to_h(config = {})
            if config.any?
              {ast: output.to_ast, prefix: prefix, config: {global: config}}
            else
              {ast: output.to_ast, prefix: prefix}
            end
          end

          def to_ast
            output.to_ast
          end

          def to_s
            JSON.generate(to_h)
          end
        end

        def self.prefix(value)
          config.prefix = value
        end

        def build(*args)
          output =
            if args.any?
              super(*args.map(&Kernel.method(:Hash)))
            else
              super
            end

          Result.new(output, prefix)
        end

        def prefix
          self.class.config.prefix
        end
      end
    end
  end
end
