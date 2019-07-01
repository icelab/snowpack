# frozen_string_literal: true

module Snowpack
  module Console
    module Plugins
      class RelationReaders < Module
        def initialize(ctx)
          ctx.rom.relations.each do |name, relation|
            define_method(name) do
              relation
            end
          end
        end
      end
    end
  end
end
