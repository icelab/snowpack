require "dry/system/container"
require "dry/system/components"

module Dummy
  class Container < Dry::System::Container
    use :env

    configure do |c|
      c.root = Pathname(__FILE__).join('../../..').freeze
    end
  end
end
