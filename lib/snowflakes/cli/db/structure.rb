require 'snowflakes/cli/abstract'

module Snowflakes
  module CLI
    module Db
      class Structure < Abstract
        namespace 'structure'

        with_env('dump', 'Dumps schema structure to db/structure.sql') do
          def dump
            run('db/structure/dump')
          end
        end
      end
    end
  end
end
