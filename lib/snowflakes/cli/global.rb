require 'snowflakes/cli/abstract'
require 'snowflakes/cli/assets/global'
require 'snowflakes/cli/db/global'
require 'snowflakes/cli/routes/global'

module Snowflakes
  module CLI
    class Global < Abstract
      with_env 'console', 'Start application console' do
        def console
          run(:console)
        end
      end

      desc 'reloader', 'Start application reloader'
      def reloader
        run(:reloader)
      end

      desc 'install', 'Install sf CLI under bin/run'
      def install
        run(:install)
      end

      register CLI::Db::Global, 'db', 'db SUBCOMMAND', 'Database commands'
      register CLI::Assets::Global, 'assets', 'assets SUBCOMMAND', 'Asset commands'
      register CLI::Routes::Global, 'routes', 'routes SUBCOMMAND', 'Route commands'
    end
  end
end
