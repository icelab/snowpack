# frozen_string_literal: true

require "snowpack/cli/application/command"
require_relative "structure/dump"
require_relative "utils/database"

module Snowpack
  module CLI
    module Application
      module Commands
        module DB
          class CreateMigration < Command
            desc "Create new migration file"

            argument :name, desc: "Migration file name"

            def call(name:, **)
              migrator = database.migrator
              version = migrator.generate_version

              measure "migration #{version}_#{name} created" do
                migrator.create_file(name, version)
              end
            end

            private

            def database
              @database ||= Utils::Database.for_application(application)
            end
          end
        end

        register "db create_migration", DB::CreateMigration
      end
    end
  end
end
