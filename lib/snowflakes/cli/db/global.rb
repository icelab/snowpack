require 'snowflakes/cli/abstract'
require 'snowflakes/cli/db/structure'

module Snowflakes
  module CLI
    module Db
      class Global < Abstract
        namespace 'db'

        with_env 'migrate', 'Run database migrations' do
          method_option :target, aliases: '-t', desc: 'Schema version'
          def migrate
            run('db/migrate', options.key?('target') ? options['target'].to_i : nil)
            version
          end
        end

        with_env 'create_migration', 'Create a new migration file' do
          method_option :name, aliases: '-n', desc: 'Name of the migration file'
          def create_migration
            run('db/create_migration', options['name'])
          end
        end

        with_env 'create', 'Create database' do
          def create
            run('db/create')
          end
        end

        with_env 'drop', 'Drop database' do
          def drop
            run('db/drop')
          end
        end

        with_env 'version', 'Print schema version' do
          def version
            run('db/version')
          end
        end

        with_env 'seed', 'Load db seed if it exists' do
          def seed
            run('db/seed')
          end
        end

        with_env 'reset', 'Drop, create and migrate the database' do
          def reset
            drop
            create
            migrate
          end
        end

        register CLI::Db::Structure, 'structure', 'structure SUBCOMMAND', 'Database structure commands'
      end
    end
  end
end
