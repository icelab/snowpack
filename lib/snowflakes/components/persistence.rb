# frozen_string_literal: true

require "dry/system"
require "snowflakes/types"

Dry::System.register_component(:persistence, provider: :snowflakes) do
  settings do
    types = Snowflakes::Types

    key :database_url, types::String
    key :global_extensions, types::Array.of(types::Symbol)
    key :connection_extensions, types::Array.of(types::Symbol)
    key :auto_registration_root, types::String.optional.default(nil)
    key :auto_registration_namespace, types::String.optional.default(nil)
    key :max_connections, types::Integer.optional.default(4)
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
      max_connections: config.max_connections,
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
