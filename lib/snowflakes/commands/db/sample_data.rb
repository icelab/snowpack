require 'snowflakes/commands/database'

module Snowflakes
  module Commands
    module Db
      class SampleData < Database
        def prepare
          app.boot
        end

        def start
          if app.has_db_sample_data?
            app.load_db_sample_data
            puts "=> db sample data loaded"
          else
            puts "=> app has no db sample data"
          end
        end
      end
    end
  end
end
