# frozen_string_literal: true

require "dry/system"
require "snowpack/types"

Dry::System.register_component(:formalist, provider: :snowpack) do
  settings do
    key :embedded_forms_container, Snowpack::Types::Any
    key :embedded_forms, Snowpack::Types::Hash
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
