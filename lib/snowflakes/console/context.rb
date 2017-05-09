require 'delegate'

require 'snowflakes/console/plugins/relation_readers'
require 'snowflakes/console/plugins/repo_readers'

module Snowflakes
  module Console
    class Context < SimpleDelegator
      attr_reader :container, :apps

      def self.new(*args)
        ctx = super

        if ctx.rom
          ctx.extend(Snowflakes::Console::Plugins::RelationReaders.new(ctx))
          ctx.extend(Snowflakes::Console::Plugins::RepoReaders.new(ctx))
        end

        ctx
      end

      def initialize(container, apps = [])
        super(container)
        @container = container
        @apps = apps
      end

      def rom
        container['persistence.rom'] if container.key?('persistence.rom')
      end
    end
  end
end
