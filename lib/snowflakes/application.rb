require "pathname"
require_relative "console/context"

module Snowflakes
  class Application
    attr_reader :container

    def initialize(container, env: default_env)
      @container = container
    end

    def with_env(env)
      container.config.env = env
      self
    end

    def root
      container.config.root
    end

    def context
      Console::Context.new(container, subapps)
    end

    def boot(component = nil)
      if component
        boot_component(component)
      else
        boot_container
      end
    end

    private

    def default_env
      ENV.fetch("RACK_ENV") { "development" }
    end

    def boot_container
      require boot_file_path
      load_sub_apps
    end

    def boot_component(name)
      container.init(name)
    end

    def boot_file_path
      path = Dir["#{system_path}/**/*.rb"].detect { |f| f.include?("boot.rb") }

      path or raise "Couldn't find boot.rb for #{container}"
    end

    def load_sub_apps
      @subapps ||=
        begin
          sub_app_names.map do |path|
            begin
              constantize("#{name}/#{Pathname(path).basename}")
            rescue NameError
              constantize(Pathname(path).basename.to_s)
            end
          end
        end
    end

    def sub_app_names
      Dir["#{root}/apps/*"].map { |path| Pathname(path).basename }
    end

    def system_path
      File.join(root, container.config.system_dir)
    end
  end
end
