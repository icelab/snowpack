require 'snowflakes/cli/abstract'

module Snowflakes
  module CLI
    module Routes
      class Global < Abstract
        namespace 'routes'

        desc 'update', 'Update routes.json'
        def update
          run('routes/update')
        end
      end
    end
  end
end
