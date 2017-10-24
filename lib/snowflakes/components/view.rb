require "snowflakes/web/decorator"

Dry::System.register_component(:view, provider: :snowflakes) do
  settings do
    key :decorator_class, Types::Any.default(Snowflakes::Web::Decorator)
    key :part_globs, Types::Strict::Array.of(Types::Coercible::String)
  end

  start do
    require 'dry/core/inflector'
    require 'pathname'

    i = Dry::Core::Inflector

    part_class = -> part_name { i.constantize(i.camelize(part_name)) }

    decorator = config.decorator_class.new

    config.part_globs.each do |pattern|
      Dir["#{pattern}/**/*.rb"].each do |file_path|
        part_path = file_path.gsub(target.root.join("lib/").to_s, "").gsub(".rb", "")
        part_name = File.basename(part_path, ".rb")

        require part_path
        decorator.parts[part_name.to_sym] = part_class.(part_path)
      end
    end

    # Manually register generic parts we share across sub-apps
    # require "readings/view/parts/pager"
    # decorator.parts[:pager] = Readings::View::Parts::Pager

    # require "readings/view/parts/paginated_results"
    # decorator.parts[:paginated_results] = Readings::View::Parts::PaginatedResults

    container.register "decorator", decorator
  end
end
