require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      class CreateMigration < Database
        def start(name)
          version = gateway.migrator.generate_version

          measure("migration #{name}_#{version} created") do
            gateway.migrator.create_file(name, version)
          end
        end
      end
    end
  end
end
