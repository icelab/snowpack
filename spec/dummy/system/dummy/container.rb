require 'dry/system/container'

module Dummy
  class Container < Dry::System::Container
    configure do |c|
      c.root = Pathname(__FILE__).join('../../..').freeze
    end

    def self.settings
      { database_url: "postgres://localhost/dummy_test"}
    end
  end
end
