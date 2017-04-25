module Snowflakes
  module Commands
    class Abstract
      attr_reader :app

      def self.run(app, *args)
        cmd = new(app)
        cmd.prepare
        cmd.start(*args)
      end

      def initialize(app)
        @app = app
      end

      def measure(info, &block)
        start = Time.now
        block.call
        stop = Time.now

        puts "=> #{info} in #{stop - start}s"
      end

      def prepare
        # no-op
      end
    end
  end
end
