require "dry/configurable"
require "pathname"

module Snowflakes
  extend Dry::Configurable

  setting :root, Pathname.pwd, reader: true
  setting :name
  setting :env, :development
  setting :system_path, "%{root}/system"
end
