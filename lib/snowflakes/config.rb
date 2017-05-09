require "dry/configurable"
require "pathname"

module Snowflakes
  extend Dry::Configurable

  SUB_PATHS = { 'system' => 'systems', 'app' => 'apps' }.freeze

  setting :env, :development, reader: true
  setting :root, Pathname.pwd, reader: true
  setting :sub_system, false, reader: true
  setting :system, reader: true
  setting :system_dir, "system", reader: true

  def self.configure(options = {}, &block)
    super(&block)

    options.each do |key, value|
      setter = :"#{key}="

      if key == 'system' || key == 'app'
        config.system = value
        config.system_dir = "#{SUB_PATHS[key]}/#{value}"
        config.sub_system = true
      elsif config.respond_to?(setter)
        config.public_send(setter, value)
      end
    end

    unless config.system
      config.system = config.root.to_s.split('/').last.to_sym
    end

    config
  end
end
