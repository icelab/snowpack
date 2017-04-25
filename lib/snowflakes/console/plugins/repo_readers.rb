module Snowflakes
  module Console
    module Plugins
      class RepoReaders < Module
        def initialize(ctx)
          ctx.apps.map { |a| a::Container }.each_with_object({}) do |app_container, memo|
            app_container.keys.grep(/repositories/).each do |key|
              name = :"#{Inflecto.singularize(key.split('.').last)}_repo"
              repo = app_container[key]

              define_method(name) do
                repo
              end
            end
          end
        end
      end
    end
  end
end
