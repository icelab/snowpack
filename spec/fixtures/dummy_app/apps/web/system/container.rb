require 'dry/web/container'

module Web
  class Container < Dry::Web::Container
    configure do |config|
      config.root = Pathname(__FILE__).join("../..").realpath.dirname.freeze
      config.log_dir = config.root.join("../log").realpath.freeze
    end
  end
end
