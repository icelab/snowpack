require 'snowflakes/cli/abstract'

module Snowflakes
  module CLI
    module Assets
      class Global < Abstract
        namespace 'assets'

        desc 'precompile', 'Precompiles assets for production'
        def precompile
          run('assets/precompile')
        end

        desc 'clobber', 'Removes precompiled assets'
        def clobber
          run('assets/clobber')
        end
      end
    end
  end
end
