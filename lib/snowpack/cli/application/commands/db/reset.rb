# frozen_string_literal: true

require "snowpack/cli/application/command"
require_relative "drop"
require_relative "create"
require_relative "migrate"

module Snowpack
  module CLI
    module Application
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

        register "db reset", Commands::DB::Reset
      end
    end
  end
end
