require 'snowflakes/cli/global'

module Snowflakes
  module CLI
    def self.start(*args)
      Global.start(*args)
    end
  end
end
