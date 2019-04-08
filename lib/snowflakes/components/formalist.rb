# frozen_string_literal: true

require "dry/system"
require "snowflakes/types"

Dry::System.register_component(:formalist, provider: :snowflakes) do
  settings do
    key :embedded_forms_container, Snowflakes::Types::Any
    key :embedded_forms, Snowflakes::Types::Hash
  end

  init do
    require "formalist"
  end

  start do
    embedded_forms_container = config.embedded_forms_container

    if embedded_forms_container
      config.embedded_forms.each do |name, klass|
        embedded_forms_container.register(name, klass)
      end

      register "container", embedded_forms_container
    end
  end
end
