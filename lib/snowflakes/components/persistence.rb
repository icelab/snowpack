require 'dry/system'

Dry::System.register_component(:persistence, provider: :snowflakes) do
  settings do
    key :database_url, Types::String
    key :global_extensions, Types::Array.of(Types::Symbol)
    key :connection_extensions, Types::Array.of(Types::Symbol)
  end

  init do
    require "sequel"
    require "rom"
    require "rom/sql"

    use :settings
    use :monitor

    ROM::SQL.load_extensions(*config.global_extensions)

    Sequel.database_timezone = :utc
    Sequel.application_timezone = :local

    rom_config = ROM::Configuration.new(
      :sql,
      config.database_url,
      extensions: config.connection_extensions
    )

    rom_config.plugin :sql, relations: :instrumentation do |plugin_config|
      plugin_config.notifications = notifications
    end

    rom_config.plugin :sql, relations: :auto_restrictions

    register "config", rom_config
    register "db", rom_config.gateways[:default].connection
  end

  start do
    config = container["persistence.config"]
    config.auto_registration target.root.join("lib/persistence")

    register "rom", ROM.container(config)
  end
end
