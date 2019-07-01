# frozen_string_literal: true

require_relative "plugins/relation_readers"
require_relative "plugins/slice_readers"

module Snowpack
  module Console
    class Context < SimpleDelegator
      attr_reader :application

      def self.new(*args)
        ctx = super

        if ctx.rom
          ctx.extend(Snowpack::Console::Plugins::RelationReaders.new(ctx))
          ctx.extend(Snowpack::Console::Plugins::SliceReaders.new(ctx))
        end

        ctx
      end

      def initialize(application)
        super(application)
        @application = application
      end

      def rom
        application["persistence.rom"] if application.key?("persistence.rom")
      end
    end
  end
end
