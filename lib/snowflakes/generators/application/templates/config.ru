require_relative "config/application"
require_relative "config/routes"

Snowflakes.application.boot!
run Snowflakes::Web.application
