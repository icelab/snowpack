require 'snowflakes'
require 'snowflakes/commands/abstract'

module Snowflakes
  module Commands
    class Install < Abstract
      def start
        bin_path = "#{app.root}/bin/run"
        FileUtils.cp Snowflakes.cli_exec_file, bin_path
        puts "=> cli executable installed under bin/run"
      end
    end
  end
end
