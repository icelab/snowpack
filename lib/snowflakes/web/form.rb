require "json"

require "formalist"
require "formalist/elements/standard"

module Snowflakes
  module Web
    class Form < ::Formalist::Form
      setting :prefix

      def self.prefix(value)
        config.prefix = value
      end

      def prefix
        self.class.config.prefix
      end

      def fill(input: {}, errors: {}, **args)
        super(input: Hash(input), errors: errors, **args)
      end

      def to_h(config = {})
        if config.any?
          {ast: to_ast, prefix: prefix, config: {global: config}}
        else
          {ast: to_ast, prefix: prefix}
        end
      end

      def to_s
        JSON.generate(to_h)
      end
    end
  end
end
