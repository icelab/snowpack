module Snowflakes
  module Console
    module Plugins
      class RepoReaders < Module
        def initialize(ctx)
          ctx.application.slices.values.each_with_object({}) do |slice, memo|
            slice.keys.grep(/repositories/).each do |key|
              name = :"#{Inflecto.singularize(key.split('.').last)}_repo"
              repo = slice[key]

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
