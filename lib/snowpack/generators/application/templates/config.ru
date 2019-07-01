require_relative "config/application"
require_relative "config/routes"

Snowpack.application.boot!
run Snowpack::Web.application
