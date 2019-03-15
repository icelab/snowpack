require "snowflakes/config"

Snowflakes.configure do |c|
  c.root = Pathname(__FILE__).join('../..')
end
