require 'dry/system'

Dry::System.register_component(:persistence, provider: :snowflakes) do
  settings do
    key :database_url, Types::String
    key :global_extensions, Types::Array.of(Types::Symbol)
    key :connection_extensions, Types::Array.of(Types::Symbol)
    key :auto_registration_root, Types::String.optional
    key :auto_registration_namespace, Types::String.optional
  end

  init do
    require "sequel"
    require "rom"
    require "rom/sql"

    use :settings

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
    rom_config = container["persistence.config"]
    rom_config.auto_registration(
      config.auto_registration_root || target.root.join("lib/persistence"),
      namespace: config.auto_registration_namespace || true,
    )

    register "rom", ROM.container(rom_config)
  end
end
