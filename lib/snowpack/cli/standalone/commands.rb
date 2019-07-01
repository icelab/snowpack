# frozen_string_literal: true

module Snowpack
  module CLI
    module Standalone
      module Commands
        extend Hanami::CLI::Registry

        require_relative "commands/new"
      end
    end
  end
end
