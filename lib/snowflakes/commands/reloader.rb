require 'snowflakes/commands/abstract'

module Snowflakes
  module Commands
    class Reloader < Abstract
      def start
        puts "Application reloader started"
        `ls #{files} | #{entr_cmd}`
      end

      private

      def files
        @files ||= (file_list(:rb) + file_list(:slim)).join(' ')
      end

      def file_list(ext)
        Dir["#{app.root}/apps/**/*.#{ext}"]
      end

      def entr_cmd
        'entr -r pumactl -P tmp/pids/puma-web.pid restart'
      end
    end
  end
end
