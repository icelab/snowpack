require 'snowflakes/cli/abstract'

module Snowflakes
  module CLI
    module Db
      class Structure < Abstract
        namespace 'structure'

        desc 'dump', 'Dumps schema structure to db/structure.sql'
        def dump
          run('db/structure/dump')
        end
      end
    end
  end
end
