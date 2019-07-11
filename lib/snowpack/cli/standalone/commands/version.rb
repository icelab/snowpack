# frozen_string_literal: true

require "snowpack/version"
require "snowpack/cli/command"

module Snowpack
  module CLI
    module Standalone
      module Commands
        class Version < Command
          def call(*)
            out.puts "Snowpack #{Snowpack::VERSION}"
          end
        end

        register "version", Version, aliases: ["-v", "--version"]
      end
    end
  end
end
