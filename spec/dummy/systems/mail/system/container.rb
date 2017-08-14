require 'dry/system/container'

module Mail
  class Container < Dry::System::Container
    configure do |config|
      config.root = Pathname(__FILE__).join("../..").realpath.dirname.freeze
    end
  end
end
