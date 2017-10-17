require 'dry/system'

Dry::System.register_component(:formalist, provider: :snowflakes) do
  settings do
    key :embedded_forms_container, Types::Any
    key :embedded_forms_path, Types::Strict::String
    key :embedded_forms, Types::Strict::Hash
  end

  init do
    require "formalist"
  end

  start do
    embedded_forms = config.embedded_forms_container.new(config.embedded_forms_path)

    config.embedded_forms.each do |name, klass|
      embedded_forms.register(name, klass)
    end

    register "container", embedded_forms
  end
end
