require "hanami/cli"
require "snowflakes/cli/command"
require_relative "drop"
require_relative "create"
require_relative "migrate"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module DB
        class Reset < Command
          desc "Drop, create, and migrate database"

          def call(**)
            run_command Drop
            run_command Create
            run_command Migrate
          end
        end
      end
    end

    register "db reset", Commands::DB::Reset
  end
end
